class ApiException implements Exception {
  final String message;

  /// null berarti gagal terhubung ke server (tidak ada respons).
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  bool get isNetwork => statusCode == null;

  @override
  String toString() => message;
}
