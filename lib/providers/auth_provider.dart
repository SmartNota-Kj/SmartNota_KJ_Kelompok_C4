import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _repo;

  AuthProvider(this._repo);

  UserModel? _currentUser;
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> init() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final authUser = _repo.currentAuthUser;
      if (authUser != null) {
        final profile = await _repo.getProfile(authUser.id);
        if (profile == null || !profile.isActive) {
          await _repo.logout();
          _currentUser = null;
          _status = AuthStatus.unauthenticated;
        } else {
          _currentUser = profile;
          _status = AuthStatus.authenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading();
    try {
      _currentUser = await _repo.login(email: email, password: password);
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _parseError(e.toString());
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _status = _currentUser != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    notifyListeners();
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  String _parseError(String raw) {
    print('Auth Error Raw: $raw'); // Debug: print raw error
    if (raw.contains('Invalid login credentials'))
      return 'Email atau password salah';
    if (raw.contains('Email not confirmed')) return 'Email belum dikonfirmasi';
    if (raw.contains('Password should be'))
      return 'Password minimal 6 karakter';
    if (raw.contains('Akun tidak aktif')) return 'Akun Anda dinonaktifkan';
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}
