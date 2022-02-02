import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../import_wallet_controller.dart';

class PrivacyWidget extends GetView<ImportWalletController> {
  const PrivacyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'agree_req'.tr,
        recognizer: TapGestureRecognizer()..onTap = () {},
        style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black50),
        children: [
          TextSpan(
            text: 'term_req'.tr,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await launch(
                  'https://moonwallet.net/term',
                  forceSafariVC: true,
                  forceWebView: true,
                  enableJavaScript: true,
                );
              },
            style: AppTextTheme.bodyText2.copyWith(
                color: AppColorTheme.textAccent80,
                decoration: TextDecoration.underline),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
