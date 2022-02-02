import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/theme/color_theme.dart';
import '../core/theme/text_theme.dart';
import '../core/utils/enum_utils.dart';
import '../core/values/size_values.dart';

class GlobalButtonWidget extends StatelessWidget {
  const GlobalButtonWidget({
    required this.name,
    required this.type,
    required this.onTap,
    this.borderRadius = AppSizes.borderRadiusVeryLarge,
  });

  final String name;
  final ButtonType type;
  final Function onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    late final Color _colorButton;
    late final Color _coloText;

    var _isActive = true;
    switch (type) {
      case ButtonType.ACTIVE:
        _colorButton = AppColorTheme.accent;
        _coloText = AppColorTheme.focus;
        _isActive = true;
        break;
      case ButtonType.ERROR:
        _colorButton = AppColorTheme.error;
        _coloText = AppColorTheme.focus;
        _isActive = true;
        break;
      case ButtonType.DISABLE:
        _colorButton = AppColorTheme.card;
        _coloText = AppColorTheme.focus;
        _isActive = false;
        break;
      case ButtonType.FOCUS:
        _colorButton = AppColorTheme.highlight;
        _coloText = AppColorTheme.focus;
        _isActive = true;
        break;
      default:
        _colorButton = AppColorTheme.white;
        _coloText = AppColorTheme.textAccent;
        _isActive = true;
        break;
    }

    return CupertinoButton(
      onPressed: () {
        _isActive ? onTap() : null;
      },
      padding: EdgeInsets.zero,
      child: Container(
        height: AppSizes.sizeButtonWidget.height,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceSmall),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _colorButton,
          gradient: type == ButtonType.ACTIVE
              ? LinearGradient(
                  colors: [
                    Color(0xFF5FB2FF),
                    Color(0xFF3BA0FF),
                    Color(0xFF3887FE),
                  ],
                  stops: [0.0, 0.5, 1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          name,
          style: AppTextTheme.headline2.copyWith(
            color: _coloText,
            decoration: TextDecoration.none,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
