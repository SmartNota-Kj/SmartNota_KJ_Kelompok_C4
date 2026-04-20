import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import '../models/nota_model.dart';
import '../services/nota_service.dart';

class NotaProvider extends ChangeNotifier {
  final NotaService _repo;

  NotaProvider(this._repo);

  List<NotaModel> _notaList = [];
  bool _isLoading = false;
  String? _error;

  String _filterAdminId = '';
  DateTime? _filterStart;
  DateTime? _filterEnd;
  String _sortBy = 'created_at';
  bool _sortAscending = false;

  List<Map<String, dynamic>> _rekapBulanan = [];

  // ── Activity tracking ────────────────────────────────────────
  int _deletedTodayCount = 0;
  final Set<String> _editedNotaIds = {}; // Track nota IDs edited today
  final Set<String> _deletedNotaIds = {}; // Track nota IDs deleted today

  List<NotaModel> get notaList => _notaList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get filterAdminId => _filterAdminId;
  DateTime? get filterStart => _filterStart;
  DateTime? get filterEnd => _filterEnd;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;
  List<Map<String, dynamic>> get rekapBulanan => _rekapBulanan;
  Set<String> get editedNotaIds => _editedNotaIds;
  Set<String> get deletedNotaIds => _deletedNotaIds;

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isArchived(NotaModel nota) => nota.createdAt
      .isBefore(DateTime.now().subtract(const Duration(days: 30)));

  bool isActive(NotaModel nota) => !isArchived(nota);

  String getNotaType(NotaModel nota) {
    return 'Nota Penjualan';
  }

  List<NotaModel> get activeNotes =>
      _notaList.where((n) => !isArchived(n)).toList();

  List<NotaModel> get archiveNotes =>
      _notaList.where((n) => isArchived(n)).toList();

  int get notaPenjualanToday =>
      _notaList.where((n) => _isToday(n.createdAt)).length;

  int get notaAddedToday =>
      _notaList.where((n) => _isToday(n.createdAt)).length;

  int get totalNota => _notaList.length;

  List<NotaModel> get notasEditedToday => _notaList
      .where((n) =>
          n.updatedAt != null &&
          _isToday(n.updatedAt!) &&
          n.updatedAt!.difference(n.createdAt).inSeconds > 0)
      .toList();

  int get notaEditedToday => notasEditedToday.length;

  int get notaDeletedToday => _deletedTodayCount;

  int get totalArchive => _notaList.where((n) => isArchived(n)).length;

  void incrementDeletionCount() {
    _deletedTodayCount++;
    notifyListeners();
  }

  void trackEditedNota(String notaId) {
    _editedNotaIds.add(notaId);
    notifyListeners();
  }

  void trackDeletedNota(String notaId) {
    _deletedNotaIds.add(notaId);
    notifyListeners();
  }

  void resetDailyCounters() {
    _deletedTodayCount = 0;
    _editedNotaIds.clear();
    _deletedNotaIds.clear();
    notifyListeners();
  }

  Future<void> loadAllNota() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _notaList = await _repo.getAllNota(
        adminId: _filterAdminId.isEmpty ? null : _filterAdminId,
        startDate: _filterStart,
        endDate: _filterEnd,
        sortBy: _sortBy,
        ascending: _sortAscending,
      );
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadNotaByAdmin(String adminId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _notaList = await _repo.getNotaByAdmin(adminId);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createNota(NotaModel nota) async {
    _isLoading = true;
    notifyListeners();
    try {
      final created = await _repo.createNota(nota);
      _notaList.insert(0, created); // tambah ke awal list
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String> uploadNotaImage({
    required Uint8List bytes,
    required String fileName,
    required String nomorNota,
  }) async {
    return _repo.uploadNotaImage(
      bytes: bytes,
      fileName: fileName,
      nomorNota: nomorNota,
    );
  }

  Future<bool> updateNota(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateNota(id: id, data: data);
      // Update local list so UI reflects changes immediately
      final idx = _notaList.indexWhere((n) => n.id == id);
      if (idx != -1) {
        final old = _notaList[idx];
        _notaList[idx] = old.copyWith(
          namaPelanggan: data['nama_pelanggan'] as String? ?? old.namaPelanggan,
          tanggal: data['tanggal'] != null
              ? DateTime.parse(data['tanggal'] as String)
              : old.tanggal,
          kategori: data['kategori'] as String? ?? old.kategori,
          keterangan: data.containsKey('keterangan')
              ? data['keterangan'] as String?
              : old.keterangan,
          fileFoto: data.containsKey('file_foto')
              ? data['file_foto'] as String?
              : old.fileFoto,
          updatedAt: DateTime.now(),
        );
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<NotaModel?> fetchNotaById(String id) async {
    try {
      final nota = await _repo.getNotaById(id);
      if (nota != null) {
        final idx = _notaList.indexWhere((n) => n.id == id);
        if (idx != -1) {
          _notaList[idx] = nota;
        }
        notifyListeners();
      }
      return nota;
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteNota(String id) async {
    try {
      await _repo.deleteNota(id);
      _notaList.removeWhere((n) => n.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<String> generateNomorNota() => _repo.generateNomorNota();

  Future<void> loadRekap() async {
    _isLoading = true;
    notifyListeners();
    try {
      _rekapBulanan = await _repo.getRekapBulanan();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  void setFilter({
    String? adminId,
    DateTime? start,
    DateTime? end,
  }) {
    _filterAdminId = adminId ?? _filterAdminId;
    _filterStart = start;
    _filterEnd = end;
    loadAllNota();
  }

  void setSort(String sortBy, bool ascending) {
    _sortBy = sortBy;
    _sortAscending = ascending;
    loadAllNota();
  }

  void clearFilter() {
    _filterAdminId = '';
    _filterStart = null;
    _filterEnd = null;
    _sortBy = 'created_at';
    _sortAscending = false;
    loadAllNota();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
