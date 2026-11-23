import 'api_base_url.dart';

class ApiConfig {
  static String get baseUrl {
    const defined = String.fromEnvironment('API_BASE_URL');
    if (defined.isNotEmpty) {
      return defined.replaceAll(RegExp(r'/+$'), '');
    }
    return defaultApiBaseUrl;
  }
}
