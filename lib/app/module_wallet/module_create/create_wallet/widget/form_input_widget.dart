import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../create_wallet_controller.dart';

class CreateWalletFormInputWidget extends GetView<CreateWalletController> {
  const CreateWalletFormInputWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        controller.handleOnChangeInput();
      },
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GetBuilder<CreateWalletController>(
            id: EnumUpdateCreateWallet.INPUT_TEXT,
            builder: (_) {
              return GlobalInputSecurityWidget(
                  controller: _.passwordController,
                  validator: _.validatorPassword,
                  onTap: _.handleInputOnTap,
                  security: _.security,
                  hintText: 'create_password_hint_text'.tr,
                  onTapIcEye: _.handleIconEyeOnTap);
            },
          ),
          SizedBox(
            height: AppSizes.spaceVeryLarge,
          ),
          GetBuilder<CreateWalletController>(
            id: EnumUpdateCreateWallet.INPUT_TEXT,
            builder: (_) {
              return GlobalInputSecurityWidget(
                  controller: _.passwordConfirmController,
                  validator: _.validatorConfirmPassword,
                  onTap: _.handleInputOnTap,
                  security: _.security,
                  hintText: 'create_confirm_password_hint_text'.tr,
                  onTapIcEye: _.handleIconEyeOnTap);
            },
          ),
        ],
      ),
    );
  }
}
