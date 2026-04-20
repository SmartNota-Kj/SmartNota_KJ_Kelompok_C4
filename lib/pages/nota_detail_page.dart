import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../utils/web_download_stub.dart'
    if (dart.library.html) '../utils/web_download_web.dart';

import '../themes/app_theme.dart';
import '../utils/format_utils.dart';
import '../models/nota_model.dart';
import '../providers/auth_provider.dart';
import '../providers/nota_provider.dart';
import '../widgets/app_widgets.dart';
import 'nota_form_page.dart';

class NotaDetailPage extends StatefulWidget {
  final String notaId;

  const NotaDetailPage({super.key, required this.notaId});

  @override
  State<NotaDetailPage> createState() => _NotaDetailPageState();
}

class _NotaDetailPageState extends State<NotaDetailPage> {
  NotaModel? _nota;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNota();
  }

  Future<void> _loadNota({bool forceRemote = false}) async {
    setState(() => _loading = true);
    final prov = context.read<NotaProvider>();
    if (forceRemote) {
      final fresh = await prov.fetchNotaById(widget.notaId);
      if (!mounted) return;
      setState(() {
        _nota = fresh;
        _loading = false;
      });
      return;
    }
    final found = prov.notaList.where((n) => n.id == widget.notaId).toList();
    if (found.isNotEmpty) {
      setState(() {
        _nota = found.first;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteNota() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Nota'),
        content: const Text(
            'Nota yang dihapus tidak dapat dikembalikan. Lanjutkan?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
              minimumSize: const Size(80, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    final ok = await context.read<NotaProvider>().deleteNota(widget.notaId);
    if (!mounted) return;
    if (ok) {
      context.read<NotaProvider>().incrementDeletionCount();
      context.read<NotaProvider>().trackDeletedNota(widget.notaId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Nota berhasil dihapus'),
        backgroundColor: AppTheme.success,
      ));
      Navigator.pop(context);
    }
  }

  bool _isArchived(NotaModel nota) {
    return nota.createdAt
        .isBefore(DateTime.now().subtract(const Duration(days: 30)));
  }

  String _getNotaType(NotaModel nota) {
    return 'Nota Penjualan';
  }

  // ── Download: tampilkan pilihan format ───────────────────────────────────
  void _downloadNota() {
    if (_nota?.imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Foto nota tidak tersedia untuk diunduh.'),
        backgroundColor: AppTheme.danger,
      ));
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _DownloadBottomSheet(
        onPdf: () {
          Navigator.pop(context);
          _downloadAsPdf();
        },
        onJpg: () {
          Navigator.pop(context);
          _downloadAsJpg();
        },
      ),
    );
  }

  // ── Download PDF ─────────────────────────────────────────────────────────
  Future<void> _downloadAsPdf() async {
    try {
      final response = await http.get(Uri.parse(_nota!.imageUrl!));
      if (response.statusCode != 200) throw Exception();
      final bytes = response.bodyBytes;

      final pdf = pw.Document();
      final image = pw.MemoryImage(bytes);
      pdf.addPage(pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Detail Nota',
                style: pw.TextStyle(
                    fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Text('Jenis Nota: ${_getNotaType(_nota!)}'),
            pw.Text('Nama Toko: ${_nota!.namaPelanggan}'),
            pw.Text('Tanggal: ${FormatUtils.date(_nota!.tanggal)}'),
            if (_nota!.keteranganTeks != null &&
                _nota!.keteranganTeks!.trim().isNotEmpty)
              pw.Text('Keterangan: ${_nota!.keteranganTeks}'),
            pw.SizedBox(height: 12),
            pw.Expanded(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            ),
          ],
        ),
      ));

      await Printing.layoutPdf(
        onLayout: (_) async => pdf.save(),
        name: 'Nota_${_nota!.nomorNota}.pdf',
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Gagal mengunduh PDF. Silakan coba lagi.'),
        backgroundColor: AppTheme.danger,
      ));
    }
  }

  // ── Download JPG → simpan ke galeri / browser download ───────────────────
  Future<void> _downloadAsJpg() async {
    try {
      final response = await http.get(Uri.parse(_nota!.imageUrl!));
      if (response.statusCode != 200) throw Exception();

      if (kIsWeb) {
        downloadBytesOnWeb(response.bodyBytes, 'Nota_${_nota!.nomorNota}.jpg');
      } else {
        if (!await Gal.hasAccess()) {
          final granted = await Gal.requestAccess();
          if (!granted) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Izin penyimpanan ditolak.'),
              backgroundColor: AppTheme.danger,
            ));
            return;
          }
        }
        await Gal.putImageBytes(response.bodyBytes);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Gambar berhasil disimpan!'),
        backgroundColor: AppTheme.success,
      ));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Gagal menyimpan gambar. Silakan coba lagi.'),
        backgroundColor: AppTheme.danger,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;
    final isSupervisor = user?.isSupervisor ?? false;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_nota == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Nota')),
        body: const EmptyState(
          icon: Icons.error_outline,
          title: 'Nota tidak ditemukan',
        ),
      );
    }

    final n = _nota!;
    final archived = _isArchived(n);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Nota'),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: 'Informasi Nota',
              child: Column(
                children: [
                  InfoTile(label: 'Jenis Nota', value: _getNotaType(n)),
                  InfoTile(label: 'Nama Toko', value: n.namaPelanggan),
                  InfoTile(
                      label: 'Tanggal',
                      value: FormatUtils.date(n.tanggal)),
                  if (n.adminName != null)
                    InfoTile(label: 'Admin', value: n.adminName!),
                  if (n.keteranganTeks != null &&
                      n.keteranganTeks!.trim().isNotEmpty)
                    InfoTile(label: 'Keterangan', value: n.keteranganTeks!),
                ],
              ),
            ),

            // ── Tombol Edit & Hapus ──────────────────────────────────────
            if (isSupervisor && !archived) ...[
              const SizedBox(height: 18),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => NotaFormPage(existingNota: n)),
                      ).then((_) => _loadNota(forceRemote: true)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text(
                        'Edit Nota',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: AppTheme.border,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    TextButton.icon(
                      onPressed: _deleteNota,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.danger,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text(
                        'Hapus Nota',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // ── Foto Nota ────────────────────────────────────────────────
            if (n.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  n.imageUrl!,
                  width: double.infinity,
                  height: 360,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 360,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Center(
                  child: Icon(Icons.receipt_long_outlined,
                      size: 60, color: AppTheme.textSecondary),
                ),
              ),

            const SizedBox(height: 24),

            // ── Tombol Download ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton(
                label: 'Download Nota',
                icon: Icons.download_rounded,
                onPressed: _downloadNota,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Section wrapper ────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── Download Bottom Sheet ──────────────────────────────────────────────────

class _DownloadBottomSheet extends StatelessWidget {
  final VoidCallback onPdf;
  final VoidCallback onJpg;

  const _DownloadBottomSheet({required this.onPdf, required this.onJpg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Unduh Nota',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Pilih format file yang ingin diunduh',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          _DownloadOption(
            icon: Icons.picture_as_pdf_rounded,
            iconColor: const Color(0xFFE53935),
            iconBg: const Color(0xFFFFEBEE),
            title: 'Download PDF',
            subtitle: 'Simpan sebagai file PDF',
            onTap: onPdf,
          ),
          const SizedBox(height: 12),
          _DownloadOption(
            icon: Icons.image_rounded,
            iconColor: const Color(0xFF1E88E5),
            iconBg: const Color(0xFFE3F2FD),
            title: 'Simpan ke Galeri',
            subtitle: 'Simpan gambar nota ke galeri HP',
            onTap: onJpg,
          ),
        ],
      ),
    );
  }
}

// ── Download Option Tile ───────────────────────────────────────────────────

class _DownloadOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DownloadOption({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}