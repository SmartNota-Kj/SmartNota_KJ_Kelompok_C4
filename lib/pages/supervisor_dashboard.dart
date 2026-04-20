import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../themes/app_theme.dart';
import '../utils/format_utils.dart';
import '../providers/auth_provider.dart';
import '../providers/nota_provider.dart';
import '../models/nota_model.dart';
import '../pages/nota_form_page.dart';

// ── Color Palette ─────────────────────────────────────────
class _CP {
  static const bg = Color(0xFFF5F0EC);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1A1210);
  static const inkMid = Color(0xFF3D2B2B);
  static const muted = Color(0xFF8A7A7A);
  static const border = Color(0xFFE8E0D8);
  static const success = Color(0xFF2D6A4F);
  static const secondary = Color(0xFF4A6741);
}

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({super.key});

  @override
  State<SupervisorDashboard> createState() => _SupervisorDashboardState();
}

class _SupervisorDashboardState extends State<SupervisorDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotaProvider>().loadAllNota();
    });
  }

  Future<void> _tambahNota() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotaFormPage()),
    );
    context.read<NotaProvider>().loadAllNota();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final nota = context.watch<NotaProvider>();
    final user = auth.currentUser;
    final all = nota.activeNotes;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () => nota.loadAllNota(),
        child: CustomScrollView(
          slivers: [
            // ── AppBar ─────────────────────────────────────
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppTheme.secondary,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppTheme.primary, AppTheme.primaryDark],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 64, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Brand
                      Text(
                        'SmartNota KJ',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 2.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Greeting
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Halo, ',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                height: 1.15,
                              ),
                            ),
                            TextSpan(
                              text: user?.fullName.split(' ').first ??
                                  'Supervisor',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Selamat datang kembali.',
                        style: GoogleFonts.dmSans(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Simpan nota Anda dengan aman dan pantau secara mandiri.',
                        style: GoogleFonts.dmSans(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Tanggal
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            FormatUtils.date(DateTime.now()),
                            style: GoogleFonts.dmSans(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Tombol Upload Nota
                      Material(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: _tambahNota,
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 9,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Upload Nota',
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Ringkasan Hari Ini ─────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionLabel(title: 'Ringkasan Hari Ini'),
                      const SizedBox(height: 4),
                      Text(
                        'Pantau aktivitas nota hari ini',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Stat Cards ────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showEditedNotasFilter(context, nota),
                          child: _StatCard(
                            label: 'Nota Di Edit',
                            value: '${nota.notaEditedToday}',
                            icon: Icons.edit_outlined,
                            accent: AppTheme.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showDeletedNotasInfo(context, nota),
                          child: _StatCard(
                            label: 'Nota Di Hapus',
                            value: '${nota.notaDeletedToday}',
                            icon: Icons.delete_outline_rounded,
                            accent: AppTheme.danger,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Nota Hari Ini ─────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark,
                    borderRadius: BorderRadius.circular(18),
                    border:
                        Border.all(color: AppTheme.primary.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.receipt_long_outlined,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nota Hari Ini',
                              style: GoogleFonts.dmSans(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${nota.notaAddedToday}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'nota',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 13,
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Section Header Nota Terbaru + Filter Tanggal ───────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _SectionLabel(title: 'Nota Terbaru'),
                  ],
                ),
              ),
            ),

            // ── List Nota (max 5) + Lihat Semua ──────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (nota.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: AppTheme.primary)),
                    )
                  else if (all.isEmpty)
                    const _EmptyState()
                  else ...[
                    ...all.take(5).map((n) => _RecentNotaItem(
                          nota: n,
                          onEdit: () => _editNota(n),
                          onDelete: () => _deleteNota(n),
                        )),
                    if (all.length > 5)
                      _LihatSemuaButton(
                        onTap: () {
                          // Hubungkan ke navigasi tab Nota kamu
                        },
                      ),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editNota(NotaModel nota) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NotaFormPage(existingNota: nota)),
    );
    context.read<NotaProvider>().loadAllNota();
  }

  Future<void> _deleteNota(NotaModel nota) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _CP.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Hapus Nota',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w700,
            color: _CP.ink,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Nota yang dihapus tidak dapat dikembalikan. Lanjutkan?',
          style: TextStyle(color: _CP.inkMid, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: _CP.muted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              minimumSize: const Size(80, 40),
            ),
            child: const Text('Hapus',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final ok = await context.read<NotaProvider>().deleteNota(nota.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        ok ? 'Nota berhasil dihapus' : 'Gagal menghapus nota',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: ok ? _CP.success : AppTheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
    if (ok) {
      context.read<NotaProvider>().incrementDeletionCount();
      context.read<NotaProvider>().trackDeletedNota(nota.id);
      context.read<NotaProvider>().loadAllNota();
    }
  }

  void _showEditedNotasFilter(BuildContext context, NotaProvider notaProvider) {
    final editedNotas = notaProvider.notasEditedToday;
    if (editedNotas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada nota yang diedit hari ini'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: _CP.muted,
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Container(
        color: _CP.bg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _CP.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Text(
                    'Nota Diedit Hari Ini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _CP.ink,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _CP.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${editedNotas.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _CP.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: editedNotas.map((nota) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _CP.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _CP.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nota.namaPelanggan,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: _CP.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nota.nomorNota,
                          style:
                              const TextStyle(fontSize: 11, color: _CP.muted),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDeletedNotasInfo(BuildContext context, NotaProvider notaProvider) {
    final deletedCount = notaProvider.notaDeletedToday;
    if (deletedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada nota yang dihapus hari ini'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: _CP.muted,
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Container(
        color: _CP.bg,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: AppTheme.primary, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              '$deletedCount Nota Dihapus',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _CP.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nota yang sudah dihapus tidak dapat ditampilkan atau dipulihkan.',
              style: TextStyle(fontSize: 12, color: _CP.muted, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Mengerti',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accent, size: 16),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: _CP.ink,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: _CP.muted,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined,
              color: AppTheme.primary.withOpacity(0.3), size: 44),
          const SizedBox(height: 12),
          Text(
            'Belum ada nota',
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _CP.muted,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Nota yang dibuat akan muncul di sini',
            style: TextStyle(fontSize: 13, color: _CP.muted),
          ),
        ],
      ),
    );
  }
}

// ── Recent Nota Item ──────────────────────────────────────
class _RecentNotaItem extends StatelessWidget {
  final NotaModel nota;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _RecentNotaItem({required this.nota, this.onEdit, this.onDelete});

  String _formatTanggal(DateTime dt) {
    const bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${dt.day} ${bulan[dt.month]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _CP.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E0D8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: nota.imageUrl != null && nota.imageUrl!.isNotEmpty
                ? Image.network(
                    nota.imageUrl!,
                    width: 62,
                    height: 62,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderImage(),
                  )
                : _placeholderImage(),
          ),
          const SizedBox(width: 10),

          // Garis aksen vertikal DIHILANGKAN
          // const SizedBox(width: 12),

          // Nama + tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nota.namaPelanggan,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: const Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTanggal(nota.createdAt),
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tombol aksi
          if (onEdit != null || onDelete != null) ...[
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onEdit != null)
                  _ActionBtn(
                    icon: Icons.edit_outlined,
                    color: _CP.inkMid,
                    onTap: onEdit!,
                  ),
                if (onDelete != null) ...[
                  const SizedBox(width: 6),
                  _ActionBtn(
                    icon: Icons.delete_outline_rounded,
                    color: AppTheme.primary,
                    onTap: onDelete!,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: const Color(0xFFF0EBE5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.receipt_long_outlined,
        color: Color(0xFFBBAA9E),
        size: 28,
      ),
    );
  }
}

// ── Lihat Semua Button ────────────────────────────────────
class _LihatSemuaButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LihatSemuaButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 4, bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.4),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lihat Semua Nota',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_rounded,
                size: 16, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }
}

// ── Action Button ─────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
