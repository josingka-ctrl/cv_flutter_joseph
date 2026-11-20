import 'package:cv_flutter_joseph/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('la connexion vide reste sur le formulaire', (tester) async {
    await tester.pumpWidget(const CvApp());

    await tapVisible(tester, find.text('Se connecter'));

    expect(find.text('Identifiant'), findsOneWidget);
    expect(
      find.text('Veuillez remplir l’identifiant et le mot de passe.'),
      findsOneWidget,
    );
  });

  testWidgets('un identifiant ouvre le CV, la famille et le contact', (
    tester,
  ) async {
    await tester.pumpWidget(const CvApp());

    await tester.enterText(find.byType(TextField).at(0), 'joseph');
    await tester.enterText(find.byType(TextField).at(1), 'siringi');
    await tapVisible(tester, find.text('Se connecter'));

    expect(find.text('Économe général'), findsWidgets);
    await tester.scrollUntilVisible(find.text('Formation'), 200);
    expect(find.text('Formation'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Compétences linguistiques'),
      300,
    );
    expect(find.text('Compétences linguistiques'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Famille'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Siringi'), findsOneWidget);
    expect(find.text('Père'), findsOneWidget);
    expect(find.text('Antoinette Kasidika'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Aisha Siringi'), 200);
    expect(find.text('Aisha Siringi'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Michael Siringi'), 200);
    expect(find.text('Michael Siringi'), findsOneWidget);

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
