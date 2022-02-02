import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

enum EnumUpdateSettingChangePassword { BUTTON, INPUT_TEXT }

class SettingChangePasswordController extends GetxController {
  final FocusNode focusNode = FocusNode();
  final status = Status();
  bool isDisableValidator = false;
  bool isActiveButton = false;
  bool isErrorAuthen = false;
  bool security = true;

  final TextEditingController passwordOldController = TextEditingController();
  final TextEditingController passwordNewController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final walletController = Get.find<WalletController>();
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: 'SettingChangePasswordController');
  String? validatorPasswordOld(String? password) {
    if (isErrorAuthen) {
      return 'incorrectPass'.tr;
    }
    if (isDisableValidator) {
      return null;
    }
    return Validators.validatePassword(password);
  }

  String? validatorPasswordNew(String? password) =>
      isDisableValidator ? null : Validators.validatePassword(password);

  String? validatorConfirmPassword(String? confirmPassword) =>
      isDisableValidator
          ? null
          : Validators.validateConfirmPassword(
              passwordNewController.text, confirmPassword);

  String get menemonic => walletController.wallet.mnemonic;

  void handleScreenOnTap() {
    focusNode.unfocus();
    isDisableValidator = true;
    formKey.currentState!.validate();
  }

  void handleInputOnTap() {
    isDisableValidator = false;
  }

  void handleOnChangeInput() {
    if (formKey.currentState!.validate()) {
      if (!isActiveButton) {
        isActiveButton = true;
        update([EnumUpdateSettingChangePassword.BUTTON]);
      }
    } else {
      if (isActiveButton) {
        isActiveButton = false;
        update([EnumUpdateSettingChangePassword.BUTTON]);
      }
    }
  }

  void handleIconEyeOnTap() {
    security = !security;
    update([EnumUpdateSettingChangePassword.INPUT_TEXT]);
  }

  void handleButtonOnTap() async {
    focusNode.unfocus();
    try {
      await status.updateStatus(StateStatus.LOADING);
      var success =
          walletController.wallet.password == passwordOldController.text;
      if (!success) {
        isErrorAuthen = true;
        Get.back();
        formKey.currentState!.validate();
        isErrorAuthen = false;
      } else {
        walletController.wallet.password = passwordNewController.text;
        await walletController.changePassword();
        await status.updateStatus(
          StateStatus.SUCCESS,
          showSnackbarSuccess: true,
          desc: 'passUpdate'.tr,
        );
        Get.back();
        Get.back();
        Get.snackbar(
          'success_'.tr,
          'request_succ'.tr,
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColorTheme.toggleableActiveColor,
          backgroundColor: AppColorTheme.backGround,
          duration: Duration(milliseconds: 1000),
        );
      }
    } catch (exp) {
      await status.updateStatus(
        StateStatus.FAILURE,
        showSnackbarError: true,
        desc: 'passUpdateFail'.tr,
      );
      AppError.handleError(exception: exp);
    }
  }
}
