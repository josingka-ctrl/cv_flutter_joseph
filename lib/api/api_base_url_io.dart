import 'dart:io';

String get defaultApiBaseUrl {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2/api-test/public';
  }
  return 'http://127.0.0.1/api-test/public';
}
