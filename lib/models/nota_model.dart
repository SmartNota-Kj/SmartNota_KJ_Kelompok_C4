class NotaModel {
  final String id;
  final String nomorNota;
  final DateTime tanggal;
  final String namaPelanggan;
  final String adminId;
  final String? adminName;
  final String? adminEmail;
  final String status;
  final String? keterangan;
  final String? fileFoto;
  final String kategori;
  final DateTime createdAt;
  final DateTime? updatedAt;

  String? get imageUrl =>
      fileFoto ??
      (keterangan != null && keterangan!.startsWith('http')
          ? keterangan
          : null);

  String? get keteranganTeks =>
      (keterangan != null && !keterangan!.startsWith('http'))
          ? keterangan
          : null;

  const NotaModel({
    required this.id,
    required this.nomorNota,
    required this.tanggal,
    required this.namaPelanggan,
    required this.adminId,
    this.adminName,
    this.adminEmail,
    required this.status,
    this.keterangan,
    this.fileFoto,
    required this.kategori,
    required this.createdAt,
    this.updatedAt,
  });

  NotaModel copyWith({
    String? id,
    String? nomorNota,
    DateTime? tanggal,
    String? namaPelanggan,
    String? adminId,
    String? adminName,
    String? adminEmail,
    String? status,
    String? keterangan,
    Object? fileFoto = _sentinel,
    String? kategori,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotaModel(
      id: id ?? this.id,
      nomorNota: nomorNota ?? this.nomorNota,
      tanggal: tanggal ?? this.tanggal,
      namaPelanggan: namaPelanggan ?? this.namaPelanggan,
      adminId: adminId ?? this.adminId,
      adminName: adminName ?? this.adminName,
      adminEmail: adminEmail ?? this.adminEmail,
      status: status ?? this.status,
      keterangan: keterangan ?? this.keterangan,
      fileFoto: fileFoto == _sentinel ? this.fileFoto : fileFoto as String?,
      kategori: kategori ?? this.kategori,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory NotaModel.fromJson(Map<String, dynamic> json) {
    return NotaModel(
      id: json['id'] as String,
      nomorNota: json['nomor_nota'] as String,
      tanggal: DateTime.parse(json['tanggal'] as String),
      namaPelanggan: json['nama_pelanggan'] as String,
      adminId: json['admin_id'] as String,
      adminName: json['admin_name'] as String?,
      adminEmail: json['admin_email'] as String?,
      status: json['status'] as String? ?? 'tercatat',
      keterangan: json['keterangan'] as String?,
      fileFoto: json['file_foto'] as String?,
      kategori: json['kategori'] as String? ??
          json['category'] as String? ??
          'penjualan',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toInsertJson() => {
        'nomor_nota': nomorNota,
        'tanggal': tanggal.toIso8601String(),
        'nama_pelanggan': namaPelanggan,
        'admin_id': adminId,
        'status': status,
        'keterangan': keterangan,
        'file_foto': fileFoto,
        'kategori': kategori,
      };
}

const Object _sentinel = Object();
