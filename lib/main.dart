import 'package:flutter/semantics.dart';
import 'package:material_ui/material_ui.dart';

import 'pages/login_page.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();
  runApp(const CvApp());
}

class CvApp extends StatelessWidget {
  const CvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV Joseph Siringi',
      theme: buildAppTheme(),
      home: const LoginPage(),
    );
  }
}
