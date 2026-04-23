import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          surface: AppColors.surface,
          primary: AppColors.accent,
          onPrimary: AppColors.primaryText,
          secondary: AppColors.muted,
          onSecondary: AppColors.background,
          error: Color(0xFFCF6679),
        ),
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: AppColors.muted,
          displayColor: AppColors.primaryText,
        ),
        dividerColor: AppColors.divider,
        cardColor: AppColors.surface,
        useMaterial3: true,
      );
}
