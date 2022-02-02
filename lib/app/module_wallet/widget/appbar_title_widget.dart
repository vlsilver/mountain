import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    Key? key,
    required this.title,
    required this.onTap,
    this.isBack = true,
  }) : super(key: key);

  final String title;
  final Function onTap;
  final bool isBack;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            height: 24.0,
            width: 24.0,
            child: isBack
                ? IconButton(
                    padding: EdgeInsets.all(0),
                    splashRadius: 24.0,
                    onPressed: () {
                      onTap();
                    },
                    icon: Icon(Icons.arrow_back_ios),
                    color: AppColorTheme.accent,
                  )
                : null),
        Expanded(
          child: Text(title,
              style:
                  AppTextTheme.headline2.copyWith(color: AppColorTheme.black),
              textAlign: TextAlign.center),
        ),
        SizedBox(width: 24.0),
      ],
    );
  }
}
