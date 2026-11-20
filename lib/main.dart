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
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth <= 520) {
              return child ?? const SizedBox.shrink();
            }
            return ColoredBox(
              color: AppColors.ink,
              child: Center(
                child: SizedBox(
                  width: 420,
                  height: constraints.maxHeight,
                  child: child,
                ),
              ),
            );
          },
        );
      },
      home: const LoginPage(),
    );
  }
}
