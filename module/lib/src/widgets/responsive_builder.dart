import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return switch (ResponsiveUtils.deviceType(context)) {
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet ?? desktop,
      DeviceType.desktop => desktop,
    };
  }
}

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, DeviceType device) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, ResponsiveUtils.deviceType(context));
  }
}
