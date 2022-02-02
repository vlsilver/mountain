import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_theme.dart';

class AppTextTheme {
  static const String fontFamily = 'SF Pro';

  static final TextStyle appName = GoogleFonts.fredokaOne(
    fontSize: 20.0,
    color: AppColorTheme.appName,
  );

  static final TextStyle title = TextStyle(
      fontFamily: fontFamily,
      fontSize: 20.0,
      color: AppColorTheme.appName,
      fontWeight: FontWeight.bold);

  static final TextStyle number = TextStyle(
      fontFamily: fontFamily,
      fontSize: 48.0,
      letterSpacing: -0.3,
      fontWeight: FontWeight.normal,
      color: AppColorTheme.black60);
  static final TextStyle number1 = TextStyle(
      fontFamily: fontFamily,
      fontSize: 30.0,
      letterSpacing: -0.3,
      fontWeight: FontWeight.normal,
      color: AppColorTheme.black60);
  static final TextStyle number2 = TextStyle(
      fontFamily: fontFamily,
      fontSize: 20.0,
      letterSpacing: -0.3,
      fontWeight: FontWeight.normal,
      color: AppColorTheme.black60);
  static final TextStyle headline = TextStyle(
      fontFamily: fontFamily,
      fontSize: 36.0,
      letterSpacing: -0.3,
      color: AppColorTheme.white,
      fontWeight: FontWeight.w600);
  static final TextStyle headline1 = TextStyle(
      fontFamily: fontFamily,
      fontSize: 24.0,
      letterSpacing: -0.3,
      fontWeight: FontWeight.bold,
      color: AppColorTheme.white);

  static final TextStyle headline2 = TextStyle(
      fontFamily: fontFamily,
      fontSize: 18.0,
      letterSpacing: -0.3,
      fontWeight: FontWeight.bold,
      color: AppColorTheme.white);

  static final TextStyle titleAppbar = TextStyle(
      fontFamily: fontFamily,
      fontSize: 18.0,
      letterSpacing: -0.3,
      fontWeight: FontWeight.w600,
      color: AppColorTheme.white);

  static final TextStyle body = TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.0,
      letterSpacing: -0.3,
      color: AppColorTheme.white,
      fontWeight: FontWeight.normal);
  static final TextStyle bodyText1 = TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.0,
      letterSpacing: -0.3,
      fontWeight: FontWeight.normal,
      color: AppColorTheme.white);
  static final TextStyle bodyText2 = TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.0,
      letterSpacing: -0.3,
      fontWeight: FontWeight.normal,
      color: AppColorTheme.white);
  static final TextStyle caption = TextStyle(
      fontFamily: fontFamily,
      fontSize: 10.0,
      letterSpacing: -0.3,
      fontWeight: FontWeight.normal,
      color: AppColorTheme.white);

  static final TextStyle balance = TextStyle(
      fontFamily: fontFamily,
      fontSize: 15.0,
      letterSpacing: -0.3,
      fontWeight: FontWeight.bold,
      color: AppColorTheme.white);
}
