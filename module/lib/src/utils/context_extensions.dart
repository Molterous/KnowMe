import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'responsive_utils.dart';

extension BuildContextX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  T responsive<T>({required T mobile, T? tablet, required T desktop}) =>
      ResponsiveUtils.value(this, mobile: mobile, tablet: tablet, desktop: desktop);
}

extension AppColorsX on BuildContext {
  Color get backgroundColor => AppColors.background;
  Color get surfaceColor => AppColors.surface;
  Color get mutedColor => AppColors.muted;
  Color get primaryTextColor => AppColors.primaryText;
  Color get accentColor => AppColors.accent;
}
