import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonDefineWidget extends StatelessWidget {
  final Function onFunction;
  final String title;

  const ButtonDefineWidget({
    required this.onFunction,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        onFunction();
      },
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceVeryLarge,
          vertical: AppSizes.spaceNormal,
        ),
        decoration: const ShapeDecoration(
            shape: StadiumBorder(),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff5FB2FF),
                  Color(0xff3BA0FF),
                  Color(0xff3887FE),
                ])),
        child: Text(
          title,
          style: AppTextTheme.bodyText1,
        ),
      ),
    );
  }
}
