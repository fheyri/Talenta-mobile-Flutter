import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/app_config.dart';
import '../models/app_user.dart';
import 'api_exception.dart';

class LoginResult {
  final String token;
  final AppUser user;
  const LoginResult({required this.token, required this.user});
}

class AuthService {
  // Accept: application/json wajib, kalau tidak Laravel mengarahkan (redirect)
  // saat validasi gagal, bukan mengirim JSON.
  Map<String, String> _headers({String? token}) => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Uri _uri(String path) => Uri.parse('${AppConfig.baseUrl}$path');

  Future<LoginResult> login({
    required String email,
    required String password,
    String deviceName = 'mobile',
  }) async {
    final res = await _send(
      () => http.post(
        _uri('/auth/login'),
        headers: _headers(),
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_name': deviceName,
        }),
      ),
    );

    final body = _decode(res);
    if (res.statusCode == 200 && body['token'] != null && body['user'] != null) {
      return LoginResult(
        token: body['token'].toString(),
        user: AppUser.fromJson(Map<String, dynamic>.from(body['user'] as Map)),
      );
    }
    throw _errorFrom(res.statusCode, body);
  }

  Future<AppUser> me(String token) async {
    final res = await _send(
      () => http.get(_uri('/me'), headers: _headers(token: token)),
    );

    final body = _decode(res);
    if (res.statusCode == 200 && body['user'] != null) {
      return AppUser.fromJson(Map<String, dynamic>.from(body['user'] as Map));
    }
    throw _errorFrom(res.statusCode, body);
  }

  Future<void> logout(String token) async {
    await _send(
      () => http.post(_uri('/auth/logout'), headers: _headers(token: token)),
    );
  }

  // ---------------------------------------------------------------- helpers

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(AppConfig.timeout);
    } on TimeoutException {
      throw const ApiException('Server tidak merespons. Coba lagi sebentar.');
    } catch (_) {
      throw const ApiException(
        'Tidak bisa terhubung ke server. Periksa koneksi internet kamu.',
      );
    }
  }

  Map<String, dynamic> _decode(http.Response res) {
    try {
      final data = jsonDecode(res.body);
      if (data is Map) return Map<String, dynamic>.from(data);
    } catch (_) {}
    return <String, dynamic>{};
  }

  ApiException _errorFrom(int status, Map<String, dynamic> body) {
    // Validasi Laravel: {"message": "...", "errors": {"email": ["..."]}}
    final errors = body['errors'];
    if (status == 422 && errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) {
        return ApiException(first.first.toString(), status);
      }
    }

    final message = body['message'];
    if (message is String && message.isNotEmpty) {
      return ApiException(message, status);
    }

    if (status == 401) {
      return ApiException('Sesi berakhir. Silakan masuk lagi.', status);
    }
    return ApiException('Terjadi kesalahan di server ($status).', status);
  }
}
