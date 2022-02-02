import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../create_wallet_controller.dart';

class PrivacyWidget extends GetView<CreateWalletController> {
  const PrivacyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 18.0,
            width: 18.0,
            child: GetBuilder<CreateWalletController>(
              id: EnumUpdateCreateWallet.CHECK_BOX,
              builder: (_) {
                return Checkbox(
                  value: controller.isChecked,
                  onChanged: (_) {
                    controller.handleCheckBoxOnTap();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  checkColor: Colors.white,
                  activeColor: AppColorTheme.textAccent80,
                );
              },
            )),
        SizedBox(
          width: AppSizes.spaceSmall,
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'create_password_pravicy_desc'.tr,
              recognizer: TapGestureRecognizer()..onTap = () {},
              style:
                  AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black50),
              children: [
                TextSpan(
                  text: 'create_password_pravicy_link'.tr,
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
                      color: AppColorTheme.textAccent,
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
