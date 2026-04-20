import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _client;

  AuthService(this._client);

  User? get currentAuthUser => _client.auth.currentUser;

  Future<UserModel?> getProfile(String userId) async {
    final res = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (res == null) return null;
    return UserModel.fromJson(res);
  }

  Future<UserModel?> getProfileByEmail(String email) async {
    final res = await _client
        .from('profiles')
        .select()
        .eq('email', email.trim())
        .maybeSingle();
    if (res == null) return null;
    return UserModel.fromJson(res);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final existingProfile = await getProfileByEmail(email);
      if (existingProfile != null && !existingProfile.isActive) {
        throw Exception('Akun tidak aktif');
      }

      final res = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (res.user == null) throw Exception('Login gagal');

      final profile = await getProfile(res.user!.id);
      if (profile == null) {
        await _client.auth.signOut();
        throw Exception('Profil tidak ditemukan');
      }

      if (!profile.isActive) {
        await _client.auth.signOut();
        throw Exception('Akun tidak aktif');
      }

      return profile;
    } catch (e) {
      if (e.toString().contains('Akun tidak aktif')) {
        await _client.auth.signOut();
      }
      rethrow;
    }
  }
  Future<void> logout() => _client.auth.signOut();

  Future<List<UserModel>> getAllUsers() async {
    final res = await _client
        .from('profiles')
        .select()
        .order('created_at', ascending: false);
    return (res as List).map((e) => UserModel.fromJson(e)).toList();
  }

  Future<void> updateUser({
    required String userId,
    required String fullName,
    required String role,
    required bool isActive,
  }) async {
    await _client.from('profiles').update({
      'full_name': fullName.trim(),
      'role': role,
      'is_active': isActive,
    }).eq('id', userId);
  }

  Future<void> deleteUser(String userId) async {
    await _client.from('profiles').update({'is_active': false}).eq('id', userId);
  }
}
