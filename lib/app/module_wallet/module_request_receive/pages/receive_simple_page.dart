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

class RecieveSimplePage extends GetView<RequestRecieveController> {
  const RecieveSimplePage({Key? key}) : super(key: key);
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
                isBack: controller.isBackSimple,
                title: 'titleSimpleStr'.tr,
                onTap: controller.handleIcBackOnTap),
          ),
          SizedBox(height: AppSizes.spaceVeryLarge),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
              child: GetBuilder<RequestRecieveController>(
                  id: EnumRequestReceive.QRCODE,
                  builder: (_) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'descSimpleStr'.tr,
                          textAlign: TextAlign.center,
                          style: AppTextTheme.bodyText1.copyWith(
                            color: AppColorTheme.highlight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppSizes.spaceVeryLarge),
                        QrImage(
                          size: Get.width * 4 / 7,
                          data: _.qrData.toString(),
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
                        CupertinoButton(
                          onPressed: _.handleAddressBoxOnTap,
                          padding: EdgeInsets.zero,
                          child: Container(
                            padding: EdgeInsets.all(AppSizes.spaceSmall),
                            decoration: BoxDecoration(
                                color: AppColorTheme.backGround,
                                borderRadius:
                                    BorderRadius.circular(AppSizes.spaceSmall)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    _.addressRequest.address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextTheme.bodyText2.copyWith(
                                      color: AppColorTheme.accent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppSizes.spaceSmall),
                                Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: AppColorTheme.accent,
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                splashRadius: AppSizes.spaceMedium,
                                onPressed: controller.handleIconCopyOntap,
                                icon: Icon(
                                  Icons.file_copy_outlined,
                                  color: AppColorTheme.accent,
                                )),
                            IconButton(
                                splashRadius: AppSizes.spaceMedium,
                                onPressed: controller.hanldeIconShareButton,
                                icon: Icon(
                                  Icons.share,
                                  color: AppColorTheme.accent,
                                ))
                          ],
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: AppSizes.spaceSmall),
                          ),
                        ),
                        GlobalButtonWidget(
                            name: 'btnAddmoreStr'.tr,
                            type: ButtonType.ACTIVE,
                            onTap: controller.handleButtonAddMoreOntap),
                        SizedBox(height: AppSizes.spaceVeryLarge),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
