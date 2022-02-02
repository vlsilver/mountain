import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../global_bottomsheet_layout_widget.dart';
import 'save_addres_favourite_controller.dart';

class SaveAddressFavouriteWidget
    extends GetView<SaveAddressFavouriteController> {
  const SaveAddressFavouriteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      height: Get.height * 0.8,
      child: InkWell(
        focusNode: controller.focusNodeSave,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: controller.handleOnTapScreenAddressSave,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
          child: GlobalLayoutBuilderWidget(
            child: Column(
              children: [
                SizedBox(height: AppSizes.spaceNormal),
                Text('titleSaveAddressStr'.tr,
                    style: AppTextTheme.headline2.copyWith(
                      color: AppColorTheme.black,
                    )),
                SizedBox(height: AppSizes.spaceLarge),
                GetBuilder<SaveAddressFavouriteController>(
                  id: EnumUpdateAddressSaveFavourite.ADDRESS_SAVE,
                  builder: (_) {
                    return GlobalInputWidget(
                      controller: controller.saveController,
                      onTap: _.handleOnTapAddressSave,
                      hintText: 'hintSaveStr'.tr,
                      errorText: _.isErrorAddressSave,
                      maxLength: 30,
                    );
                  },
                ),
                Expanded(
                    child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: AppSizes.spaceMedium),
                )),
                GlobalButtonWidget(
                    name: 'global_cancel'.tr,
                    type: ButtonType.ERROR,
                    onTap: controller.handleButtonCancelOnTap),
                SizedBox(height: AppSizes.spaceSmall),
                GetBuilder<SaveAddressFavouriteController>(
                  id: EnumUpdateAddressSaveFavourite.BUTTON_SAVE,
                  builder: (_) {
                    return GlobalButtonWidget(
                        name: 'global_save'.tr,
                        type: _.isActiveButtonSave
                            ? ButtonType.ACTIVE
                            : ButtonType.DISABLE,
                        onTap: _.handleButtonSaveOnTap);
                  },
                ),
                SizedBox(height: AppSizes.spaceVeryLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
