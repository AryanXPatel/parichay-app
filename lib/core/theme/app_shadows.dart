import 'package:flutter/material.dart';

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x1F0F172A),
      blurRadius: 30,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}
