class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.errors = const {}});

  final String message;
  final int? statusCode;
  final Map<String, String> errors;

  String get details {
    if (errors.isEmpty) return message;
    return '$message\n${errors.values.join('\n')}';
  }

  @override
  String toString() => details;
}
