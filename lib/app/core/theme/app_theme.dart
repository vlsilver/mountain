import 'package:flutter/material.dart';

import 'color_theme.dart';
import 'text_theme.dart';

class AppTheme {
  static ThemeData get lightMode => ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppColorTheme.backGround,
      accentColor: AppColorTheme.accent,
      splashColor: AppColorTheme.accent80,
      toggleableActiveColor: AppColorTheme.toggleableActiveColor,
      textTheme: TextTheme(
        headline1: AppTextTheme.headline1,
        headline2: AppTextTheme.headline2,
        bodyText1: AppTextTheme.bodyText1,
        bodyText2: AppTextTheme.bodyText2,
        caption: AppTextTheme.caption,
      ),
      buttonTheme: ButtonThemeData());
  static ThemeData get darkMode => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColorTheme.backGround,
        accentColor: AppColorTheme.accent,
        textTheme: TextTheme(
          headline1: AppTextTheme.headline1,
          headline2: AppTextTheme.headline2,
          bodyText1: AppTextTheme.bodyText1,
          bodyText2: AppTextTheme.bodyText2,
          caption: AppTextTheme.caption,
        ),
      );
}
