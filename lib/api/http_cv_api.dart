import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/account.dart';
import '../models/family_member.dart';
import 'api_config.dart';
import 'api_exception.dart';
import 'cv_api.dart';

class HttpCvApi implements CvApi {
  HttpCvApi({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _client;
  final String baseUrl;

  static const _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<Account> login({
    required String email,
    required String password,
  }) async {
    final body = await _send(
      () => _client.post(
        _uri('/accounts/login'),
        headers: _jsonHeaders,
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      ),
    );
    return Account.fromJson(_asMap(body['data']));
  }

  @override
  Future<Account> register({
    required String email,
    required String password,
  }) async {
    final body = await _send(
      () => _client.post(
        _uri('/accounts/register'),
        headers: _jsonHeaders,
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      ),
    );
    return Account.fromJson(_asMap(body['data']));
  }

  @override
  Future<List<FamilyMember>> listMembers() async {
    final body = await _send(() => _client.get(_uri('/famille-membres')));
    final data = body['data'];
    if (data is! List) {
      throw ApiException('La liste des membres est illisible.');
    }
    return data
        .map(
          (item) => FamilyMember.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  @override
  Future<FamilyMember> createMember(FamilyInput input) {
    if (input.imageBytes == null) {
      return _saveJson('POST', '/famille-membres', input);
    }
    return _saveMultipart('POST', '/famille-membres', input);
  }

  @override
  Future<FamilyMember> updateMember(int id, FamilyInput input) {
    if (input.imageBytes == null) {
      return _saveJson('PUT', '/famille-membres/$id', input);
    }
    return _saveMultipart('POST', '/famille-membres/$id', input);
  }

  @override
  Future<void> deleteMember(int id) async {
    await _send(() => _client.delete(_uri('/famille-membres/$id')));
  }

  Future<FamilyMember> _saveJson(
    String method,
    String path,
    FamilyInput input,
  ) async {
    final uri = _uri(path);
    final encoded = jsonEncode(input.toJson());
    final body = await _send(() {
      if (method == 'PUT') {
        return _client.put(uri, headers: _jsonHeaders, body: encoded);
      }
      return _client.post(uri, headers: _jsonHeaders, body: encoded);
    });
    return FamilyMember.fromJson(_asMap(body['data']));
  }

  Future<FamilyMember> _saveMultipart(
    String method,
    String path,
    FamilyInput input,
  ) async {
    final request = http.MultipartRequest(method, _uri(path));
    request.fields.addAll(input.toJson());
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        input.imageBytes!,
        filename: input.imageFilename ?? 'photo.jpg',
      ),
    );
    final response = await _sendResponse(() async {
      final streamed = await _client.send(request);
      return http.Response.fromStream(streamed);
    });
    return FamilyMember.fromJson(_asMap(response['data']));
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() call,
  ) {
    return _sendResponse(call);
  }

  Future<Map<String, dynamic>> _sendResponse(
    Future<http.Response> Function() call,
  ) async {
    final http.Response response;
    try {
      response = await call().timeout(const Duration(seconds: 20));
    } on TimeoutException {
      throw ApiException('Le serveur met trop de temps à répondre.');
    } on http.ClientException {
      throw ApiException(
        'Impossible de joindre l’API. Démarrez Apache et MySQL, puis réessayez.',
      );
    }

    Map<String, dynamic> body;
    try {
      final decoded = jsonDecode(response.body);
      body = decoded is Map<String, dynamic>
          ? decoded
          : Map<String, dynamic>.from(decoded as Map);
    } catch (_) {
      throw ApiException(
        'Réponse illisible du serveur (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }

    if (body['success'] == true) return body;

    final errors = <String, String>{};
    final rawErrors = body['errors'];
    if (rawErrors is Map) {
      rawErrors.forEach((key, value) {
        errors['$key'] = '$value';
      });
    }
    throw ApiException(
      body['message']?.toString() ?? 'La requête a échoué.',
      statusCode: response.statusCode,
      errors: errors,
    );
  }

  Map<String, dynamic> _asMap(Object? data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    throw ApiException('Réponse inattendue du serveur.');
  }
}
