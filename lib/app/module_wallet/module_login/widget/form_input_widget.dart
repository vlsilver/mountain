import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_controller.dart';

class LoginFormInputWidget extends GetView<LoginController> {
  const LoginFormInputWidget({
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
      child: GetBuilder<LoginController>(
        id: EnumUpdateLogin.INPUT_TEXT,
        builder: (_) {
          return GlobalInputSecurityWidget(
              controller: _.passwordController,
              validator: _.validatorPassword,
              onTap: _.handleInputOnTap,
              security: _.security,
              hintText: 'global_inputPass'.tr,
              onTapIcEye: _.handleIconEyeOnTap);
        },
      ),
    );
  }
}
