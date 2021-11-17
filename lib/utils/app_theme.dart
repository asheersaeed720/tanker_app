import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color nearBlack = Color(0xFF213333);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gradientStart = Color(0xFF184A45);
  static const Color gradientEnd = Color(0xFF23635c);

  static const String fontName = 'Poppins';

  static const TextTheme textTheme = TextTheme(
    headline1: headTxt1,
    headline2: headTxt2,
    bodyText1: bodyTxt1,
    subtitle1: subtitleTxt1,
  );

  static const TextStyle headTxt1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
    color: nearBlack,
  );
  static const TextStyle headTxt2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
    color: nearBlack,
  );

  static const TextStyle bodyTxt1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
    color: nearBlack,
  );
  static const TextStyle subtitleTxt1 = TextStyle(
    fontFamily: fontName,
    fontSize: 13.5,
    color: Colors.black87,
  );
}
