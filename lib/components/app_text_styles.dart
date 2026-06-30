import 'package:flutter/material.dart';

class AppTextStyles {
  static const double sizeSmall = 14.0;
  static const double sizeMedium = 16.0;
  static const double sizeLarge = 18.0;

  static const TextStyle small = TextStyle(
    fontSize: sizeSmall,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle medium = TextStyle(
    fontSize: sizeMedium,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle large = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: sizeLarge,
    fontWeight: FontWeight.bold,
  );
}
