import 'package:flutter/semantics.dart';
import 'package:material_ui/material_ui.dart';

import 'api/cv_api.dart';
import 'api/http_cv_api.dart';
import 'pages/login_page.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();
  runApp(const CvApp());
}

class CvApp extends StatefulWidget {
  const CvApp({super.key, this.api});

  final CvApi? api;

  @override
  State<CvApp> createState() => _CvAppState();
}

class _CvAppState extends State<CvApp> {
  late final CvApi _api = widget.api ?? HttpCvApi();

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
      home: LoginPage(api: _api),
    );
  }
}
