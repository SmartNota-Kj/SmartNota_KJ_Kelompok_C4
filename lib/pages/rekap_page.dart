import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../themes/app_theme.dart';
import '../models/nota_model.dart';
import '../providers/nota_provider.dart';
import 'nota_detail_page.dart';

class RekapPage extends StatefulWidget {
  const RekapPage({super.key});

  @override
  State<RekapPage> createState() => _RekapPageState();
}

class _RekapPageState extends State<RekapPage>
    with SingleTickerProviderStateMixin {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDate;
  late AnimationController _sheetController;
  late Animation<double> _sheetAnimation;

  @override
  void initState() {
    super.initState();
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _sheetAnimation = CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeOutCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotaProvider>().loadAllNota();
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _selectDate(DateTime date, List<NotaModel> notesOnDate) {
    setState(() {
      if (_selectedDate != null &&
          _selectedDate!.year == date.year &&
          _selectedDate!.month == date.month &&
          _selectedDate!.day == date.day) {
        _selectedDate = null;
        _sheetController.reverse();
      } else {
        _selectedDate = date;
        if (notesOnDate.isNotEmpty) {
          _sheetController.forward(from: 0);
        }
      }
    });
  }

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
      _selectedDate = null;
    });
    _sheetController.reverse();
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
      _selectedDate = null;
    });
    _sheetController.reverse();
  }

  void _openMonthPicker() {
    int pickerYear = _focusedMonth.year;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.75,
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Pilih Periode',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C1A1A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _NavButton(
                          icon: Icons.chevron_left_rounded,
                          onTap: () => setModal(() => pickerYear--),
                        ),
                        Text(
                          '$pickerYear',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C1A1A),
                          ),
                        ),
                        _NavButton(
                          icon: Icons.chevron_right_rounded,
                          onTap: () => setModal(() => pickerYear++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.0,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                      ),
                      itemCount: 12,
                      itemBuilder: (_, i) {
                        final isActive = pickerYear == _focusedMonth.year &&
                            i + 1 == _focusedMonth.month;
                        final monthName = DateFormat('MMM')
                            .format(DateTime(pickerYear, i + 1));
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(ctx);
                            setState(() {
                              _focusedMonth = DateTime(pickerYear, i + 1);
                              _selectedDate = null;
                            });
                            _sheetController.reverse();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppTheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive
                                    ? AppTheme.primary
                                    : const Color(0xFFEDE8E3),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              monthName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? Colors.white
                                    : const Color(0xFF2C1A1A),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Map<DateTime, List<NotaModel>> _groupByDate(List<NotaModel> notes) {
    final map = <DateTime, List<NotaModel>>{};
    for (final nota in notes) {
      final key =
          DateTime(nota.tanggal.year, nota.tanggal.month, nota.tanggal.day);
      map.putIfAbsent(key, () => []).add(nota);
    }
    return map;
  }

  NotaModel? _lastNota(List<NotaModel> notes) {
    if (notes.isEmpty) return null;
    return notes.reduce((a, b) => a.tanggal.isAfter(b.tanggal) ? a : b);
  }

  void _showAllArchiveSheet(List<NotaModel> notes) {
    if (notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada nota arsip')),
      );
      return;
    }

    final sorted = [...notes]..sort((a, b) => b.tanggal.compareTo(a.tanggal));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        builder: (context, controller) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8D2CC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'Semua Arsip',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    '${sorted.length} arsip',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9A8A8A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  controller: controller,
                  itemCount: sorted.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final nota = sorted[i];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFEDE8E3)),
                      ),
                      tileColor: Colors.white,
                      title: Text(
                        nota.namaPelanggan,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${nota.nomorNota} • ${DateFormat('dd MMM yyyy').format(nota.tanggal)}',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          this.context,
                          MaterialPageRoute(
                            builder: (_) => NotaDetailPage(notaId: nota.id),
                          ),
                        ).then((_) =>
                            this.context.read<NotaProvider>().loadAllNota());
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLastArchive(NotaModel? lastNota) {
    if (lastNota == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada nota arsip terbaru')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NotaDetailPage(notaId: lastNota.id)),
    ).then((_) => context.read<NotaProvider>().loadAllNota());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<NotaProvider>();
    final archiveNotes = prov.archiveNotes;
    final grouped = _groupByDate(archiveNotes);
    final monthNotes = archiveNotes
        .where((n) =>
            n.tanggal.year == _focusedMonth.year &&
            n.tanggal.month == _focusedMonth.month)
        .toList();
    final lastNota = _lastNota(archiveNotes);

    final selectedNotes = _selectedDate != null
        ? (grouped[DateTime(
              _selectedDate!.year,
              _selectedDate!.month,
              _selectedDate!.day,
            )] ??
            [])
        : <NotaModel>[];

    return Scaffold(
      // ── Disesuaikan: background putih ──
      backgroundColor: Colors.white,
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => prov.loadAllNota(),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 0,
                    backgroundColor: AppTheme.primaryDark,
                    foregroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    title: const Text(
                      'Rekap Arsip',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _MonthBadge(total: monthNotes.length),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded,
                              size: 14, color: AppTheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Periode ${DateFormat('MMMM yyyy').format(_focusedMonth)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8A6A6A),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _openMonthPicker,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      DateFormat('MMMM yyyy')
                                          .format(_focusedMonth),
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2C1A1A),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF8A6A6A),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 44,
                                  height: 3,
                                  margin: const EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.calendar_month_outlined,
                              color: AppTheme.primary, size: 26),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
                      child: _CalendarCard(
                        focusedMonth: _focusedMonth,
                        selectedDate: _selectedDate,
                        grouped: grouped,
                        onPrev: _prevMonth,
                        onNext: _nextMonth,
                        onDateSelected: _selectDate,
                        onHeaderTap: _openMonthPicker,
                      ),
                    ),
                  ),
                  if (_selectedDate != null && selectedNotes.isNotEmpty)
                    SliverToBoxAdapter(
                      child: AnimatedBuilder(
                        animation: _sheetAnimation,
                        builder: (context, child) => Opacity(
                          opacity: _sheetAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - _sheetAnimation.value)),
                            child: child,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
                          child: _NotaSheet(
                            date: _selectedDate!,
                            notes: selectedNotes,
                            onNotaTap: (nota) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      NotaDetailPage(notaId: nota.id),
                                ),
                              ).then((_) =>
                                  context.read<NotaProvider>().loadAllNota());
                            },
                          ),
                        ),
                      ),
                    ),
                  if (_selectedDate != null && selectedNotes.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
                        child: _EmptyDateCard(date: _selectedDate!),
                      ),
                    ),
                  if (_selectedDate == null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
                        child: _HintCard(hasNotes: monthNotes.isNotEmpty),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 6, 14, 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              dark: true,
                              label: 'Total Arsip',
                              value: '${archiveNotes.length}',
                              sub: 'Lebih dari 30 hari',
                              subIcon: Icons.archive_rounded,
                              onTap: () => _showAllArchiveSheet(archiveNotes),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              dark: false,
                              label: 'Terakhir',
                              value: lastNota != null
                                  ? DateFormat("dd MMM ''yy")
                                      .format(lastNota.tanggal)
                                  : '—',
                              sub: 'Lihat Nota →',
                              onTap: () => _openLastArchive(lastNota),
                            ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Month Badge (AppBar)
// ─────────────────────────────────────────────────────────────────────────────
class _MonthBadge extends StatelessWidget {
  final int total;
  const _MonthBadge({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$total arsip',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar Card
// ─────────────────────────────────────────────────────────────────────────────
class _CalendarCard extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime? selectedDate;
  final Map<DateTime, List<NotaModel>> grouped;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final void Function(DateTime, List<NotaModel>) onDateSelected;
  final VoidCallback onHeaderTap;

  const _CalendarCard({
    required this.focusedMonth,
    required this.selectedDate,
    required this.grouped,
    required this.onPrev,
    required this.onNext,
    required this.onDateSelected,
    required this.onHeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE8E3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            _CalendarHeader(
              focusedMonth: focusedMonth,
              onPrev: onPrev,
              onNext: onNext,
              onTap: onHeaderTap,
            ),
            _CalendarGrid(
              focusedMonth: focusedMonth,
              selectedDate: selectedDate,
              grouped: grouped,
              onDateSelected: onDateSelected,
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar Header
// ─────────────────────────────────────────────────────────────────────────────
class _CalendarHeader extends StatelessWidget {
  final DateTime focusedMonth;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onTap;

  const _CalendarHeader({
    required this.focusedMonth,
    required this.onPrev,
    required this.onNext,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
      child: Row(
        children: [
          _NavButton(icon: Icons.chevron_left_rounded, onTap: onPrev),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('MMM yyyy').format(focusedMonth),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C1A1A),
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 16, color: Color(0xFF8A6A6A)),
                  ],
                ),
              ),
            ),
          ),
          _NavButton(icon: Icons.chevron_right_rounded, onTap: onNext),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7F4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE8E4E0)),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF5A3A3A)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar Grid
// ─────────────────────────────────────────────────────────────────────────────
class _CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime? selectedDate;
  final Map<DateTime, List<NotaModel>> grouped;
  final void Function(DateTime, List<NotaModel>) onDateSelected;

  const _CalendarGrid({
    required this.focusedMonth,
    required this.selectedDate,
    required this.grouped,
    required this.onDateSelected,
  });

  static const _dayLabels = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final daysInMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    final startOffset = firstDay.weekday % 7;
    final today = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            children: _dayLabels
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9A8A8A),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.95,
            ),
            itemCount: startOffset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startOffset) return const SizedBox();
              final day = index - startOffset + 1;
              final date = DateTime(focusedMonth.year, focusedMonth.month, day);
              final notesOnDate = grouped[date] ?? [];
              final isToday = date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;
              final isSelected = selectedDate != null &&
                  date.year == selectedDate!.year &&
                  date.month == selectedDate!.month &&
                  date.day == selectedDate!.day;
              final hasNotes = notesOnDate.isNotEmpty;
              final isFuture = date.isAfter(today);

              return _DayCell(
                day: day,
                isToday: isToday,
                isSelected: isSelected,
                hasNotes: hasNotes,
                noteCount: notesOnDate.length,
                isFuture: isFuture,
                onTap: () => onDateSelected(date, notesOnDate),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Day Cell
// ─────────────────────────────────────────────────────────────────────────────
class _DayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final bool hasNotes;
  final int noteCount;
  final bool isFuture;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.hasNotes,
    required this.noteCount,
    required this.isFuture,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color textColor =
        isFuture ? const Color(0xFFC4B8B8) : const Color(0xFF2C1A1A);
    Color? borderColor;

    if (isSelected) {
      bgColor = AppTheme.primary;
      textColor = Colors.white;
    } else if (isToday) {
      borderColor = AppTheme.primary;
    }

    return GestureDetector(
      onTap: isFuture ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1.2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    hasNotes || isToday ? FontWeight.w700 : FontWeight.w400,
                color: textColor,
              ),
            ),
            if (hasNotes) ...[
              const SizedBox(height: 2),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.28)
                      : AppTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$noteCount',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppTheme.primary,
                  ),
                ),
              ),
            ] else if (isToday && !isSelected) ...[
              const SizedBox(height: 2),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nota Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _NotaSheet extends StatelessWidget {
  final DateTime date;
  final List<NotaModel> notes;
  final void Function(NotaModel) onNotaTap;

  const _NotaSheet({
    required this.date,
    required this.notes,
    required this.onNotaTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEEE, d MMMM yyyy').format(date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                dayName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C1A1A),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${notes.length} nota',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...notes.asMap().entries.map((entry) {
          final i = entry.key;
          final nota = entry.value;
          return TweenAnimationBuilder<double>(
            key: ValueKey(nota.id),
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 200 + i * 55),
            curve: Curves.easeOut,
            builder: (context, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(
                offset: Offset(0, 16 * (1 - v)),
                child: child,
              ),
            ),
            child: _NotaCard(nota: nota, onTap: () => onNotaTap(nota)),
          );
        }),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual Nota Card
// ─────────────────────────────────────────────────────────────────────────────
class _NotaCard extends StatelessWidget {
  final NotaModel nota;
  final VoidCallback onTap;
  const _NotaCard({required this.nota, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEDE8E3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.receipt_rounded,
                  color: AppTheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nota.namaPelanggan,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy').format(nota.tanggal),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9A8A8A),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 22, color: Color(0xFF9A8A8A)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty date card
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyDateCard extends StatelessWidget {
  final DateTime date;
  const _EmptyDateCard({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE8E3)),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_rounded,
              size: 38, color: const Color(0xFF9A8A8A).withOpacity(0.4)),
          const SizedBox(height: 8),
          Text(
            'Tidak ada nota pada ${DateFormat('d MMMM').format(date)}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9A8A8A),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hint card
// ─────────────────────────────────────────────────────────────────────────────
class _HintCard extends StatelessWidget {
  final bool hasNotes;
  const _HintCard({required this.hasNotes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withOpacity(0.13)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 6,
                    offset: const Offset(0, 1)),
              ],
            ),
            child: Icon(
              hasNotes ? Icons.touch_app_rounded : Icons.calendar_today_rounded,
              color: AppTheme.primary.withOpacity(0.7),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasNotes
                  ? 'Pilih tanggal untuk melihat nota yang diarsipkan'
                  : 'Belum ada arsip pada bulan ini',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8A6A6A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Card
// ─────────────────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final bool dark;
  final String label;
  final String value;
  final String sub;
  final IconData? subIcon;
  final VoidCallback? onTap;

  const _StatCard({
    required this.dark,
    required this.label,
    required this.value,
    required this.sub,
    this.subIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: dark ? AppTheme.primaryDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: dark ? null : Border.all(color: const Color(0xFFEDE8E3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: dark
                      ? Colors.white.withOpacity(0.6)
                      : const Color(0xFF9A8A8A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: dark ? 28 : 18,
                  fontWeight: FontWeight.w700,
                  color: dark ? Colors.white : const Color(0xFF2C1A1A),
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  if (subIcon != null) ...[
                    Icon(
                      subIcon,
                      size: 12,
                      color: dark
                          ? Colors.white.withOpacity(0.65)
                          : AppTheme.primary,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: dark
                          ? Colors.white.withOpacity(0.65)
                          : AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}