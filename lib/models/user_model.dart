class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String role; // 'supervisor' | 'admin'
  final bool isActive;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  bool get isSupervisor => role == 'supervisor';
  bool get isAdmin => role == 'admin';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final isActiveRaw = json['is_active'];
    bool isActiveValue;
    if (isActiveRaw is bool) {
      isActiveValue = isActiveRaw;
    } else if (isActiveRaw is int) {
      isActiveValue = isActiveRaw == 1;
    } else if (isActiveRaw is String) {
      isActiveValue = isActiveRaw.toLowerCase() == 'true';
    } else {
      isActiveValue = true;
    }

    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: isActiveValue,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'role': role,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
      };

  UserModel copyWith({
    String? fullName,
    String? email,
    String? role,
    bool? isActive,
  }) =>
      UserModel(
        id: id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        role: role ?? this.role,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt,
      );
}
