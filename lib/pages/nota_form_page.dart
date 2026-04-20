import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../constants/store_options.dart';
import '../themes/app_theme.dart';
import '../utils/format_utils.dart';
import '../models/nota_model.dart';
import '../providers/auth_provider.dart';
import '../providers/nota_provider.dart';
import '../widgets/app_widgets.dart';

class NotaFormPage extends StatefulWidget {
  final NotaModel? existingNota;
  const NotaFormPage({super.key, this.existingNota});

  @override
  State<NotaFormPage> createState() => _NotaFormPageState();
}

class _NotaFormPageState extends State<NotaFormPage> {
  final _formKey = GlobalKey<FormState>();

  // FIX: Controller dijadikan field state — tidak boleh dibuat di build()
  final _captionCtrl   = TextEditingController();
  final _nomorNotaCtrl = TextEditingController();
  final _tanggalCtrl   = TextEditingController();

  DateTime _tanggal = DateTime.now();
  String   _nomorNota = '';
  String   _kategori  = 'penjualan';
  String?  _namaToko;
  bool     _generating = true;
  final    _picker = ImagePicker();

  XFile?     _selectedImage;
  Uint8List? _imageBytes;

  bool get isEditing => widget.existingNota != null;

  @override
  void initState() {
    super.initState();
    _tanggalCtrl.text = FormatUtils.dateTime(_tanggal);

    if (isEditing) {
      final n = widget.existingNota!;
      _nomorNota = n.nomorNota;
      _tanggal   = n.tanggal;
      _kategori  = n.kategori;
      _namaToko  = kAllowedStores.contains(n.namaPelanggan)
          ? n.namaPelanggan
          : kAllowedStores.first;
      _captionCtrl.text   = n.keteranganTeks ?? '';
      _nomorNotaCtrl.text = _nomorNota;
      _tanggalCtrl.text   = FormatUtils.dateTime(_tanggal);
      _generating         = false;
    } else {
      _namaToko = kAllowedStores.first;
      _loadNomorNota();
    }
  }

  @override
  void dispose() {
    _captionCtrl.dispose();
    _nomorNotaCtrl.dispose();
    _tanggalCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadNomorNota() async {
    setState(() {
      _generating         = true;
      _nomorNotaCtrl.text = 'Membuat nomor...';
    });
    _nomorNota          = await context.read<NotaProvider>().generateNomorNota();
    _nomorNotaCtrl.text = _nomorNota;
    if (mounted) setState(() => _generating = false);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source, maxWidth: 1200, imageQuality: 80,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() {
      _selectedImage = picked;
      _imageBytes    = bytes;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_namaToko == null || _namaToko!.trim().isEmpty) {
      _snack('Pilih nama toko terlebih dahulu', AppTheme.danger);
      return;
    }
    if (!kAllowedStores.contains(_namaToko)) {
      _snack('Nama toko tidak valid', AppTheme.danger);
      return;
    }
    if (!isEditing && _selectedImage == null) {
      _snack('Unggah foto nota terlebih dahulu', AppTheme.danger);
      return;
    }

    final user = context.read<AuthProvider>().currentUser!;
    final prov = context.read<NotaProvider>();

    // ── Upload foto → hasilkan URL untuk kolom file_foto ──
    String? fileFotoUrl;
    if (_selectedImage != null && _imageBytes != null) {
      try {
        fileFotoUrl = await prov.uploadNotaImage(
          bytes:     _imageBytes!,
          fileName:  _selectedImage!.name,
          nomorNota: _nomorNota,
        );
      } catch (e) {
        if (!mounted) return;
        _snack('Gagal mengunggah foto: $e', AppTheme.danger);
        return;
      }
    }

    final nota = NotaModel(
      id:            isEditing ? widget.existingNota!.id : const Uuid().v4(),
      nomorNota:     _nomorNota,
      tanggal:       _tanggal,
      namaPelanggan: _namaToko!,
      adminId:       user.id,
      adminName:     user.fullName,
      adminEmail:    user.email,
      status:        'aktif',
      // keterangan hanya untuk teks catatan (bukan URL gambar)
      keterangan: _captionCtrl.text.trim().isEmpty
          ? null
          : _captionCtrl.text.trim(),
      // file_foto adalah URL gambar dari storage
      fileFoto: fileFotoUrl ??
          (isEditing ? widget.existingNota!.fileFoto : null),
      kategori:  _kategori,
      createdAt: isEditing ? widget.existingNota!.createdAt : DateTime.now(),
      updatedAt: isEditing ? DateTime.now() : null,
    );

    bool ok;
    if (isEditing) {
      final existing = widget.existingNota!;
      final data = <String, dynamic>{
        'nama_pelanggan': _namaToko,
        'tanggal':        _tanggal.toIso8601String(),
        'kategori':       _kategori,
        'updated_at':     DateTime.now().toIso8601String(),
        // Selalu update keterangan teks
        'keterangan': _captionCtrl.text.trim().isEmpty
            ? null
            : _captionCtrl.text.trim(),
      };

      if (fileFotoUrl != null) {
        // Foto baru diunggah → simpan ke file_foto
        data['file_foto'] = fileFotoUrl;
        // Jika data lama menyimpan URL di keterangan (migrasi lama),
        // bersihkan supaya tidak dobel
        if (existing.fileFoto == null &&
            existing.keterangan != null &&
            existing.keterangan!.startsWith('http')) {
          data['keterangan'] = null;
        }
      }

      ok = await prov.updateNota(nota.id, data);
      if (ok) prov.trackEditedNota(nota.id);
    } else {
      ok = await prov.createNota(nota);
    }

    if (!mounted) return;
    if (ok) {
      _snack(isEditing ? 'Nota berhasil diperbarui' : 'Nota berhasil dibuat',
          AppTheme.success);
      Navigator.pop(context);
    } else {
      _snack(prov.error ?? 'Gagal menyimpan nota', AppTheme.danger);
    }
  }

  void _snack(String msg, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: bg),
    );
  }

  Widget _buildPreview() {
    // Preview gambar yang baru dipilih
    if (_imageBytes != null) {
      return _previewStack(
        child: Image.memory(_imageBytes!,
            width: double.infinity, height: 240, fit: BoxFit.cover),
      );
    }

    // Preview gambar existing dari kolom file_foto (atau fallback keterangan)
    final existingUrl = widget.existingNota?.imageUrl;
    if (isEditing && existingUrl != null) {
      return _previewStack(
        child: Image.network(
          existingUrl,
          width: double.infinity,
          height: 240,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.broken_image_outlined,
                size: 48, color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.photo_camera_outlined, size: 48, color: AppTheme.textSecondary),
          SizedBox(height: 8),
          Text('Ketuk untuk memilih foto',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _previewStack({required Widget child}) {
    return Stack(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(15), child: child),
        Positioned(
          bottom: 10, right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color:        Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text('Ganti Foto', style: TextStyle(color: Colors.white, fontSize: 11)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: AppTheme.border, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppTheme.primary),
              title:   const Text('Ambil Foto'),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppTheme.primary),
              title:   const Text('Pilih dari Galeri'),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<NotaProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(isEditing ? 'Edit Nota' : 'Buat Nota Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _FormSection(
              title: 'Informasi Nota',
              child: Column(
                children: [
                  // FIX: Pakai controller persisten, bukan inline ctor
                  AppTextField(
                    label:      'Nomor Nota',
                    controller: _nomorNotaCtrl,
                    readOnly:   true,
                    prefix:     const Icon(Icons.tag_rounded, size: 18),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label:      'Waktu Pembuatan',
                    controller: _tanggalCtrl,
                    readOnly:   true,
                    prefix:     const Icon(Icons.access_time_filled_outlined, size: 18),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _namaToko,
                    decoration: InputDecoration(
                      labelText: 'Nama Toko',
                      prefixIcon: const Icon(Icons.store_rounded, size: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primary, width: 2),
                      ),
                      filled:    true,
                      fillColor: AppTheme.surface,
                    ),
                    dropdownColor: AppTheme.surface,
                    style: const TextStyle(color: AppTheme.onSurface, fontSize: 14),
                    items: kAllowedStores
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged:  (v) => setState(() => _namaToko = v),
                    validator:  (v) => (v == null || v.isEmpty) ? 'Nama toko harus dipilih' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _FormSection(
              title: 'Foto Nota',
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showPickerOptions,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width:  double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                        color: _imageBytes != null ? Colors.transparent : AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _imageBytes != null ? AppTheme.primary : AppTheme.border,
                          width: _imageBytes != null ? 2 : 1,
                        ),
                      ),
                      child: _buildPreview(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon:  const Icon(Icons.camera_alt_outlined, size: 18),
                          label: const Text('Kamera'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon:  const Icon(Icons.photo_library_outlined, size: 18),
                          label: const Text('Galeri'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _FormSection(
              title: 'Keterangan (Opsional)',
              child: AppTextField(
                label:      'Catatan singkat',
                hint:       'Tambahkan deskripsi singkat',
                controller: _captionCtrl,
                maxLines:   3,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label:     isEditing ? 'Perbarui Nota' : 'Simpan Nota',
              icon:      Icons.save_rounded,
              onPressed: _submit,
              isLoading: prov.isLoading,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _FormSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border:       Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
