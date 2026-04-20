import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/nota_model.dart';

class NotaService {
  final SupabaseClient _client;

  NotaService(this._client);

  Future<String> uploadNotaImage({
    required Uint8List bytes,
    required String fileName,
    required String nomorNota,
  }) async {
    final fileExt  = fileName.split('.').last.toLowerCase();
    final safeName = nomorNota.replaceAll('/', '_');
    final uniqueName =
        '${safeName}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final path = 'nota_images/$uniqueName';

    await _client.storage.from('nota-bucket').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: 'image/$fileExt',
            upsert: false,
          ),
        );

    return _client.storage.from('nota-bucket').getPublicUrl(path);
  }

  Future<List<NotaModel>> getAllNota({
    String? adminId,
    DateTime? startDate,
    DateTime? endDate,
    String sortBy = 'created_at',
    bool ascending = false,
  }) async {
    final res = await _client
        .from('nota_with_admin')
        .select()
        .order(sortBy, ascending: ascending);

    var list = (res as List).map((e) => NotaModel.fromJson(e)).toList();

    if (adminId != null && adminId.isNotEmpty) {
      list = list.where((n) => n.adminId == adminId).toList();
    }
    if (startDate != null) {
      list = list.where((n) => !n.tanggal.isBefore(startDate)).toList();
    }
    if (endDate != null) {
      list = list.where((n) => !n.tanggal.isAfter(endDate)).toList();
    }
    if (sortBy == 'tanggal') {
      list.sort((a, b) => ascending
          ? a.tanggal.compareTo(b.tanggal)
          : b.tanggal.compareTo(a.tanggal));
    }
    return list;
  }

  Future<List<NotaModel>> getNotaByAdmin(String adminId) async {
    final res = await _client
        .from('nota_with_admin')
        .select()
        .eq('admin_id', adminId)
        .order('created_at', ascending: false);
    return (res as List).map((e) => NotaModel.fromJson(e)).toList();
  }

  Future<NotaModel?> getNotaById(String id) async {
    final res = await _client
        .from('nota_with_admin')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return NotaModel.fromJson(res);
  }

  Future<NotaModel> createNota(NotaModel nota) async {
    var currentNota = nota;
    const maxAttempts = 5;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final res = await _client
            .from('nota')
            .insert(currentNota.toInsertJson())
            .select()
            .single();
        return NotaModel.fromJson(res);
      } catch (e) {
        if (e is PostgrestException &&
            e.code == '23505' &&
            e.message.contains('nota_nomor_nota_key')) {
          final newNomor = await generateNomorNota();
          currentNota = currentNota.copyWith(nomorNota: newNomor);
          continue;
        }
        rethrow;
      }
    }
    throw Exception(
        'Gagal membuat nota: nomor nota duplikat berulang kali. Silakan coba lagi.');
  }

  Future<void> updateNota({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await _client.from('nota').update(data).eq('id', id);
  }

  Future<void> deleteNota(String id) async {
    await _client.from('nota').delete().eq('id', id);
  }

  Future<String> generateNomorNota() async {
    final now    = DateTime.now();
    final prefix =
        'NTA/${now.year}${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';

    final res = await _client
        .from('nota')
        .select('nomor_nota')
        .like('nomor_nota', '$prefix%')
        .order('nomor_nota', ascending: false)
        .limit(1);

    final list = res as List;
    if (list.isEmpty) return '$prefix/001';

    final last   = list.first['nomor_nota'] as String;
    final seqStr = last.split('/').last;
    final seq    = int.tryParse(seqStr) ?? 0;
    return '$prefix/${(seq + 1).toString().padLeft(3, '0')}';
  }

  Future<List<Map<String, dynamic>>> getRekapBulanan() async {
    final now          = DateTime.now();
    final twoMonthsAgo = DateTime(now.year, now.month - 2);
    final oneMonthAgo  = DateTime(now.year, now.month - 1);

    String _key(DateTime dt) =>
        '${dt.year}-${dt.month.toString().padLeft(2, '0')}';

    try {
      final res = await _client
          .from('nota')
          .select('tanggal')
          .order('tanggal', ascending: true);

      final Map<String, int> monthly = {};
      for (final r in res as List) {
        final dt  = DateTime.parse(r['tanggal'] as String);
        final key = _key(dt);
        monthly[key] = (monthly[key] ?? 0) + 1;
      }

      if (monthly.isEmpty) {
        return [
          {'bulan': _key(twoMonthsAgo), 'jumlah': 0},
          {'bulan': _key(oneMonthAgo),  'jumlah': 0},
          {'bulan': _key(now),          'jumlah': 0},
        ];
      }

      return monthly.entries
          .map((e) => {'bulan': e.key, 'jumlah': e.value})
          .toList();
    } catch (e) {
      // Kembalikan 3 bulan terakhir sebagai fallback (tanpa crash)
      return [
        {'bulan': _key(twoMonthsAgo), 'jumlah': 0},
        {'bulan': _key(oneMonthAgo),  'jumlah': 0},
        {'bulan': _key(now),          'jumlah': 0},
      ];
    }
  }
}
