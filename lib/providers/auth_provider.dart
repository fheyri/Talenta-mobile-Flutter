import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/api_exception.dart';
import '../services/auth_service.dart';
import '../services/token_storage.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, offline }

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._service, this._storage);

  final AuthService _service;
  final TokenStorage _storage;

  AuthStatus status = AuthStatus.unknown;
  AppUser? user;
  String? _token;

  /// Dipanggil saat aplikasi dibuka: kalau ada token tersimpan, cek ke server.
  Future<void> bootstrap() async {
    status = AuthStatus.unknown;
    notifyListeners();

    _token = await _storage.read();
    if (_token == null) {
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    try {
      user = await _service.me(_token!);
      status = AuthStatus.authenticated;
    } on ApiException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) {
        // token tidak berlaku lagi / akun dinonaktifkan
        await _clearSession();
      } else {
        // server mati atau tidak ada internet: token dipertahankan
        status = AuthStatus.offline;
      }
    }
    notifyListeners();
  }

  /// Error (ApiException) dilempar ke pemanggil supaya bisa tampil di form.
  Future<void> login(String email, String password) async {
    final result = await _service.login(email: email, password: password);
    await _storage.write(result.token);
    _token = result.token;
    user = result.user;
    status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final result = await _service.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
    await _storage.write(result.token);
    _token = result.token;
    user = result.user;
    status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> completeProfile(Map<String, dynamic> data) async {
    final token = _token;
    if (token == null) return;
    final updated = await _service.completeProfile(token: token, data: data);
    user = updated;
    notifyListeners();
  }

  Future<void> logout() async {
    final token = _token;
    if (token != null) {
      try {
        await _service.logout(token);
      } catch (_) {
        // tetap keluar di perangkat walau server tidak terjangkau
      }
    }
    await _clearSession();
    notifyListeners();
  }

  Future<void> _clearSession() async {
    await _storage.clear();
    _token = null;
    user = null;
    status = AuthStatus.unauthenticated;
  }
}
