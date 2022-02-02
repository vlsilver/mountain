import 'dart:math';

import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_request_receive/request_receive_controller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RecieveCompletePage extends GetView<RequestRecieveController> {
  const RecieveCompletePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      child: Column(
        children: [
          SizedBox(height: AppSizes.spaceNormal),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
            child: AppBarWidget(
                title: 'titleSimpleStr'.tr,
                onTap: controller.handleIcBackOnTap),
          ),
          SizedBox(height: AppSizes.spaceNormal),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      controller.amountString,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.headline1.copyWith(
                        color: AppColorTheme.highlight,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                        angle: pi / 2,
                        child: Icon(
                          Icons.compare_arrows_outlined,
                          color: AppColorTheme.accent,
                        ),
                      ),
                      Obx(
                        () => Flexible(
                          child: Text(
                            controller.currencyCompare,
                            textAlign: TextAlign.right,
                            style: AppTextTheme.bodyText1
                                .copyWith(color: AppColorTheme.black),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceNormal),
                  QrImage(
                    size: Get.width * 2 / 3,
                    data: controller.qrData.toString(),
                    gapless: false,
                    errorStateBuilder: (cxt, err) {
                      return Container(
                        child: Center(
                          child: Text(
                            'Uh oh! Something went wrong...',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppSizes.spaceMedium),
                  Text(
                    'descComplete1Str'.tr,
                    style: AppTextTheme.bodyText2
                        .copyWith(color: AppColorTheme.black),
                  ),
                  Expanded(child: SizedBox(height: AppSizes.spaceSmall)),
                  CupertinoButton(
                    onPressed: controller.handleIconCopyOntap,
                    padding: EdgeInsets.zero,
                    child: Text(
                      'descInformationInputStr'.tr,
                      style: AppTextTheme.headline2
                          .copyWith(color: AppColorTheme.accent),
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceMedium),
                  GlobalButtonWidget(
                      name: 'btnSendStr'.tr,
                      type: ButtonType.ACTIVE,
                      onTap: controller.hanldeIconShareButton),
                  SizedBox(height: AppSizes.spaceVeryLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
