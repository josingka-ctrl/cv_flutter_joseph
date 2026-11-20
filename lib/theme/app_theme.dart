import 'package:material_ui/material_ui.dart';

class AppColors {
  static const ink = Color(0xFF1B2430);
  static const forest = Color(0xFF1E4D3A);
  static const forestDeep = Color(0xFF143528);
  static const gold = Color(0xFFB8893A);
  static const goldSoft = Color(0xFFE7D3A1);
  static const ivory = Color(0xFFF4EFE4);
  static const paper = Color(0xFFFFFBF5);
  static const clay = Color(0xFF8E3D32);
  static const muted = Color(0xFF5C6570);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.forest,
    primary: AppColors.forest,
    onPrimary: AppColors.ivory,
    secondary: AppColors.gold,
    onSecondary: AppColors.ink,
    surface: AppColors.paper,
    error: AppColors.clay,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.ivory,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        height: 1.15,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        height: 1.45,
        color: AppColors.ink,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        height: 1.4,
        color: AppColors.muted,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.forest,
      foregroundColor: AppColors.ivory,
      centerTitle: true,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.paper,
      indicatorColor: AppColors.goldSoft,
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.forest : AppColors.muted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? AppColors.forestDeep : AppColors.muted,
        );
      }),
    ),
    cardTheme: CardThemeData(
      color: AppColors.paper,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE6DCC8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF8F4EC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE0D4C0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE0D4C0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.forest, width: 1.6),
      ),
      labelStyle: const TextStyle(color: AppColors.muted),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
  );
}
