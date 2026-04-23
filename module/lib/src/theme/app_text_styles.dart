import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.spaceGrotesk(
        fontSize: 72,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
        height: 1.05,
        letterSpacing: -2,
      );

  static TextStyle get displayMedium => GoogleFonts.spaceGrotesk(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
        height: 1.1,
        letterSpacing: -1.5,
      );

  static TextStyle get displaySmall => GoogleFonts.spaceGrotesk(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.15,
        letterSpacing: -1,
      );

  static TextStyle get headlineLarge => GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineMedium => GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.25,
      );

  static TextStyle get titleLarge => GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryText,
        height: 1.3,
      );

  static TextStyle get titleMedium => GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryText,
        height: 1.4,
      );

  static TextStyle get bodyLarge => GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
        height: 1.6,
      );

  static TextStyle get bodyMedium => GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
        height: 1.6,
      );

  static TextStyle get labelLarge => GoogleFonts.spaceGrotesk(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.muted,
        height: 1.4,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.muted,
        height: 1.4,
        letterSpacing: 1,
      );

  static TextStyle get sectionNumber => GoogleFonts.spaceGrotesk(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.accent,
        letterSpacing: 2,
      );

  static TextStyle get accent => GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.accent,
        height: 1.4,
      );
}
