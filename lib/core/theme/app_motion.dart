import 'package:flutter/animation.dart';

class AppMotion {
  const AppMotion._();

  static const Duration fast = Duration(milliseconds: 160);
  static const Duration medium = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 320);

  static const Curve standardCurve = Curves.easeOutCubic;
}
