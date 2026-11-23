import 'package:cv_flutter_joseph/api/api_exception.dart';
import 'package:cv_flutter_joseph/api/cv_api.dart';
import 'package:cv_flutter_joseph/main.dart';
import 'package:cv_flutter_joseph/models/account.dart';
import 'package:cv_flutter_joseph/models/family_member.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> enterField(WidgetTester tester, Key key, String value) async {
  final finder = find.byKey(key);
  final scrollable = find
      .descendant(
        of: find.byKey(const Key('family-form-list')),
        matching: find.byType(Scrollable),
      )
      .first;
  await tester.scrollUntilVisible(finder, 120, scrollable: scrollable);
  await tester.ensureVisible(finder);
  await tester.enterText(finder, value);
}

class MemoryApi implements CvApi {
  final members = <FamilyMember>[
    const FamilyMember(
      id: 1,
      nom: 'Siringi',
      postnom: 'Wa',
      prenom: 'Michael',
      lieuNaissance: 'Goma',
      dateNaissance: '1998-04-12',
      parente: 'Frère',
    ),
  ];

  @override
  Future<Account> login({
    required String email,
    required String password,
  }) async {
    if (email == 'joseph.siringi@cv.test' && password == 'siringi') {
      return Account(id: 1, email: email);
    }
    throw ApiException('Email ou mot de passe incorrect');
  }

  @override
  Future<Account> register({
    required String email,
    required String password,
  }) async {
    return Account(id: 2, email: email);
  }

  @override
  Future<List<FamilyMember>> listMembers() async => List<FamilyMember>.of(members);

  @override
  Future<FamilyMember> createMember(FamilyInput input) async {
    final created = FamilyMember(
      id: members.length + 1,
      nom: input.nom,
      postnom: input.postnom,
      prenom: input.prenom,
      lieuNaissance: input.lieuNaissance,
      dateNaissance: input.dateNaissance,
      parente: input.parente,
    );
    members.add(created);
    return created;
  }

  @override
  Future<FamilyMember> updateMember(int id, FamilyInput input) async {
    return FamilyMember(
      id: id,
      nom: input.nom,
      postnom: input.postnom,
      prenom: input.prenom,
      lieuNaissance: input.lieuNaissance,
      dateNaissance: input.dateNaissance,
      parente: input.parente,
    );
  }

  @override
  Future<void> deleteMember(int id) async {
    members.removeWhere((member) => member.id == id);
  }
}

void main() {
  testWidgets('la connexion vide reste sur le formulaire', (tester) async {
    await tester.pumpWidget(CvApp(api: MemoryApi()));

    await tapVisible(tester, find.text('Se connecter'));

    expect(find.text('Email'), findsOneWidget);
    expect(
      find.text('Veuillez remplir l’email et le mot de passe.'),
      findsOneWidget,
    );
    expect(find.text('Économe général'), findsNothing);
  });

  testWidgets('un mot de passe incorrect n’ouvre pas le CV', (tester) async {
    await tester.pumpWidget(CvApp(api: MemoryApi()));

    await tester.enterText(find.byType(TextField).at(0), 'joseph.siringi@cv.test');
    await tester.enterText(find.byType(TextField).at(1), 'mauvais');
    await tapVisible(tester, find.text('Se connecter'));

    expect(find.text('Email ou mot de passe incorrect'), findsOneWidget);
    expect(find.text('Économe général'), findsNothing);
  });

  testWidgets('la connexion réelle ouvre le CV, la famille et le contact', (
    tester,
  ) async {
    final api = MemoryApi();
    await tester.pumpWidget(CvApp(api: api));

    await tester.enterText(
      find.byType(TextField).at(0),
      'joseph.siringi@cv.test',
    );
    await tester.enterText(find.byType(TextField).at(1), 'siringi');
    await tapVisible(tester, find.text('Se connecter'));

    expect(find.text('Économe général'), findsWidgets);
    await tester.scrollUntilVisible(find.text('Formation'), 200);
    expect(find.text('Formation'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Famille'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Michael Siringi Wa'), findsOneWidget);
    expect(find.text('Frère'), findsOneWidget);

    await tapVisible(tester, find.byKey(const Key('add-member')));
    expect(find.text('Nouveau membre'), findsOneWidget);
    await enterField(tester, const Key('family-nom'), 'Kasidika');
    await enterField(tester, const Key('family-postnom'), 'Maman');
    await enterField(tester, const Key('family-prenom'), 'Antoinette');
    await enterField(tester, const Key('family-lieu'), 'Goma');
    await enterField(tester, const Key('family-date'), '1975-02-14');
    await enterField(tester, const Key('family-parente'), 'Mère');
    await tapVisible(tester, find.text('Enregistrer'));

    expect(find.text('Antoinette Kasidika Maman'), findsOneWidget);
    expect(api.members, hasLength(2));

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Contact'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('josingka@gmail.com'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('GitHub'), 200);
    expect(find.text('GitHub'), findsOneWidget);
  });
}
