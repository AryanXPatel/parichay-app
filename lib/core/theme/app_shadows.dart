import 'package:flutter/material.dart';

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0F1D2231), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(color: Color(0x1A1D2231), blurRadius: 22, offset: Offset(0, 10)),
  ];
}
