import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../themes/app_theme.dart';
import '../models/nota_model.dart';
import '../providers/auth_provider.dart';
import '../providers/nota_provider.dart';
import 'nota_detail_page.dart';
import 'nota_form_page.dart';
import '../widgets/app_widgets.dart';

class AdminNotaPage extends StatefulWidget {
  const AdminNotaPage({super.key});

  @override
  State<AdminNotaPage> createState() => _AdminNotaPageState();
}

class _AdminNotaPageState extends State<AdminNotaPage> {
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        context.read<NotaProvider>().loadNotaByAdmin(user.id);
      }
    });
  }

  Future<void> _pickDateFrom() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: _dateTo ?? now,
      initialDate: _dateFrom ?? (_dateTo ?? now),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF8B4D4D),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dateFrom = picked;
        if (_dateTo != null && _dateTo!.isBefore(picked)) _dateTo = picked;
      });
    }
  }

  Future<void> _pickDateTo() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: _dateFrom ?? DateTime(2020),
      lastDate: now,
      initialDate: _dateTo ?? (_dateFrom ?? now),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF8B4D4D),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dateTo = picked;
        if (_dateFrom != null && _dateFrom!.isAfter(picked)) _dateFrom = picked;
      });
    }
  }

  List<NotaModel> _applyFilterAndSort(List<NotaModel> notes) {
    var result = List<NotaModel>.from(notes);

    if (_dateFrom != null && _dateTo != null) {
      final endOfDay =
          _dateTo!.add(const Duration(hours: 23, minutes: 59, seconds: 59));
      result = result
          .where((n) =>
              n.tanggal
                  .isAfter(_dateFrom!.subtract(const Duration(seconds: 1))) &&
              n.tanggal.isBefore(endOfDay))
          .toList();
    }

    result.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return result;
  }

  Map<String, List<NotaModel>> _groupByDate(List<NotaModel> notes) {
    final grouped = <String, List<NotaModel>>{};
    for (final nota in notes) {
      final key = DateFormat('yyyy-MM-dd').format(nota.tanggal);
      grouped.putIfAbsent(key, () => []).add(nota);
    }
    return grouped;
  }

  String _humanDate(String key) {
    final date = DateTime.parse(key);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return 'Hari Ini';
    if (d == yesterday) return 'Kemarin';
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;
    final prov = context.watch<NotaProvider>();
    final filtered = _applyFilterAndSort(prov.notaList);
    final grouped = _groupByDate(filtered);
    final dateKeys = grouped.keys.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotaFormPage()),
        ).then((_) => prov.loadNotaByAdmin(user?.id ?? '')),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text(
          'Tambah Nota',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.primaryDark,
            automaticallyImplyLeading: false,
            toolbarHeight: 56,
            expandedHeight: 56,
            title: const Text(
              'Menu Nota',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _DateChip(
                      label: 'Dari',
                      value: _dateFrom != null
                          ? DateFormat('d MMM yyyy').format(_dateFrom!)
                          : 'Pilih tanggal',
                      isActive: _dateFrom != null,
                      onTap: _pickDateFrom,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward_rounded,
                        size: 16, color: AppTheme.textSecondary),
                  ),
                  Expanded(
                    child: _DateChip(
                      label: 'Sampai',
                      value: _dateTo != null
                          ? DateFormat('d MMM yyyy').format(_dateTo!)
                          : 'Pilih tanggal',
                      isActive: _dateTo != null,
                      onTap: _pickDateTo,
                    ),
                  ),
                  if (_dateFrom != null || _dateTo != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () =>
                          setState(() { _dateFrom = null; _dateTo = null; }),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.danger.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppTheme.danger.withOpacity(0.2)),
                        ),
                        child: Icon(Icons.close_rounded,
                            size: 16, color: AppTheme.danger),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          if (prov.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (filtered.isEmpty)
            const SliverFillRemaining(
              child: EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Belum ada nota',
                subtitle: 'Tekan tombol + untuk membuat nota baru',
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, sectionIndex) {
                  final key = dateKeys[sectionIndex];
                  final notes = grouped[key]!;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 3,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _humanDate(key),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Divider(
                                  indent: 8,
                                  thickness: 0.5,
                                  color: AppTheme.border,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.82,
                          ),
                          itemCount: notes.length,
                          itemBuilder: (context, i) {
                            final nota = notes[i];
                            return _AdminNotaGridCard(
                              nota: nota,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      NotaDetailPage(notaId: nota.id),
                                ),
                              ).then(
                                  (_) => prov.loadNotaByAdmin(user?.id ?? '')),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
                childCount: dateKeys.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 90)),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isActive;
  final VoidCallback onTap;

  const _DateChip({
    required this.label,
    required this.value,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isActive ? AppTheme.primary : AppTheme.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 14,
              color: isActive ? Colors.white : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color:
                          isActive ? Colors.white60 : AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminNotaGridCard extends StatelessWidget {
  final NotaModel nota;
  final VoidCallback onTap;

  const _AdminNotaGridCard({required this.nota, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border.withOpacity(0.75)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  nota.imageUrl != null
                      ? Image.network(
                          nota.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _ImagePlaceholder(nota: nota),
                        )
                      : _ImagePlaceholder(nota: nota),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.15),
                            Colors.transparent
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nota.namaPelanggan,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    Text(
                      nota.nomorNota,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 10,
                            color: AppTheme.textSecondary.withOpacity(0.8)),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('d MMM yyyy', 'id_ID')
                              .format(nota.tanggal),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Ketuk untuk lihat detail',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.primary.withOpacity(0.75),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.arrow_forward_rounded,
                            size: 10,
                            color: AppTheme.primary.withOpacity(0.75)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final NotaModel nota;
  const _ImagePlaceholder({required this.nota});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primary.withOpacity(0.07),
      child: Center(
        child: Icon(Icons.receipt_long_rounded,
            size: 32, color: AppTheme.primary.withOpacity(0.35)),
      ),
    );
  }
}