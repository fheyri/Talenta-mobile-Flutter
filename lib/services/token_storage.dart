import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Token login disimpan di penyimpanan aman perangkat,
/// sehingga user tetap login sampai menekan logout.
class TokenStorage {
  static const _key = 'auth_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> read() => _storage.read(key: _key);

  Future<void> write(String token) => _storage.write(key: _key, value: token);

  Future<void> clear() => _storage.delete(key: _key);
}
