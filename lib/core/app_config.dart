import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  /// Bisa diganti tanpa mengubah kode:
  /// flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000/api/v1
  static const String _override = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    // Emulator Android memakai 10.0.2.2 untuk mengakses localhost komputer.
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8000/api/v1';
    return 'http://127.0.0.1:8000/api/v1';
  }

  static const Duration timeout = Duration(seconds: 15);
}
