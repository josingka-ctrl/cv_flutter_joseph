import 'dart:convert';

import 'package:cv_flutter_joseph/api/api_exception.dart';
import 'package:cv_flutter_joseph/api/http_cv_api.dart';
import 'package:cv_flutter_joseph/models/family_member.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const base = 'http://localhost/api-test/public';

  test('la connexion refusée remonte le message du serveur', () async {
    final api = HttpCvApi(
      baseUrl: base,
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api-test/public/accounts/login');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['email'], 'joseph.siringi@cv.test');
        return http.Response(
          jsonEncode({
            'success': false,
            'message': 'Email ou mot de passe incorrect',
          }),
          401,
        );
      }),
    );

    expect(
      api.login(email: 'joseph.siringi@cv.test', password: 'mauvais'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          'Email ou mot de passe incorrect',
        ),
      ),
    );
  });

  test('la liste et la création passent par l’API', () async {
    final calls = <String>[];
    final api = HttpCvApi(
      baseUrl: base,
      client: MockClient((request) async {
        calls.add('${request.method} ${request.url.path}');
        if (request.method == 'GET') {
          return http.Response(
            jsonEncode({
              'success': true,
              'data': [
                {
                  'id': 3,
                  'nom': 'Siringi',
                  'postnom': 'Wa',
                  'prenom': 'Michael',
                  'lieu_naissance': 'Goma',
                  'date_naissance': '1998-04-12',
                  'parente': 'Frère',
                  'image': null,
                  'image_url': null,
                },
              ],
            }),
            200,
          );
        }
        if (request.method == 'POST') {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['prenom'], 'Antoinette');
          return http.Response(
            jsonEncode({
              'success': true,
              'message': 'Membre créé',
              'data': {
                'id': 4,
                'nom': body['nom'],
                'postnom': body['postnom'],
                'prenom': body['prenom'],
                'lieu_naissance': body['lieu_naissance'],
                'date_naissance': body['date_naissance'],
                'parente': body['parente'],
                'image': null,
                'image_url': null,
              },
            }),
            201,
          );
        }
        if (request.method == 'PUT') {
          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'id': 4,
                'nom': 'Kasidika',
                'postnom': 'Maman',
                'prenom': 'Antoinette',
                'lieu_naissance': 'Goma',
                'date_naissance': '1975-02-14',
                'parente': 'Mère',
                'image_url': null,
              },
            }),
            200,
          );
        }
        expect(request.method, 'DELETE');
        return http.Response(
          jsonEncode({'success': true, 'message': 'Membre supprimé'}),
          200,
        );
      }),
    );

    final listed = await api.listMembers();
    expect(listed.single.fullName, 'Michael Siringi Wa');

    final created = await api.createMember(
      const FamilyInput(
        nom: 'Kasidika',
        postnom: 'Maman',
        prenom: 'Antoinette',
        lieuNaissance: 'Goma',
        dateNaissance: '1975-02-14',
        parente: 'Mère',
      ),
    );
    expect(created.id, 4);

    await api.updateMember(
      4,
      const FamilyInput(
        nom: 'Kasidika',
        postnom: 'Maman',
        prenom: 'Antoinette',
        lieuNaissance: 'Goma',
        dateNaissance: '1975-02-14',
        parente: 'Mère',
      ),
    );
    await api.deleteMember(4);

    expect(calls, [
      'GET /api-test/public/famille-membres',
      'POST /api-test/public/famille-membres',
      'PUT /api-test/public/famille-membres/4',
      'DELETE /api-test/public/famille-membres/4',
    ]);
  });
}
