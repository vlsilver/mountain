import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../wallet_controller.dart';

enum EnumUpdateCreateWallet {
  BUTTON,
  INPUT_TEXT,
  SWITCH_TOUCH_ID,
  CHECK_BOX,
  APPBAR,
  STEP
}

class CreateWalletController extends GetxController {
  final String tagHeroIndicator = 'tag_hero_indicator';
  final String tagHeroButton = 'tag_hero_button';
  final String tagHeroTitleText = 'tag_shero_title_text';

  bool security = true;
  bool isValidator = false;
  bool isEnableTouchId = false;
  bool isChecked = false;
  bool isActiveButton = false;
  bool isDisableValidator = false;
  List<String> seedPhrase = <String>[];
  int step = 1;
  late final password;

  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: AppRoutes.CREATE_WALLET);
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  final _status = Status();

  late final WalletController _walletController;

  double get widthIndicatorSetupLoading =>
      AppSizes.sizeGroupIndicatorStepSetupWallet.width / 2 * (step - 1);
  bool stepIsLoading(int index) => step == index;
  bool stepSucessed(int index) => step == 3 ? step >= index : step > index;

  String? validatorPassword(String? password) =>
      isDisableValidator ? null : Validators.validatePassword(password);

  String? validatorConfirmPassword(String? confirmPassword) =>
      isDisableValidator
          ? null
          : Validators.validateConfirmPassword(
              passwordController.text, confirmPassword);

  @override
  void onInit() async {
    _walletController = Get.find<WalletController>();
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }

  void handleButtonOnTap() async {
    step = 2;
    try {
      await _status.updateStatus(StateStatus.LOADING);
      final seedPhraseResult = await _walletController.createNewWallet(
          password: passwordController.text, biometricState: isEnableTouchId);
      step = 2;
      seedPhrase = seedPhraseResult;
      await _status.updateStatus(StateStatus.SUCCESS);
      await Get.offAllNamed(AppRoutes.GUIDE_SAVE_SEEDPHRASE_STEP1);
    } catch (exp) {
      if (exp == 'Error Biometric') {
        await _status.updateStatus(StateStatus.FAILURE,
            showDialogError: true,
            title: 'global_failure'.tr,
            desc: 'global_error_enable_touchId'.tr);
      } else {
        await _status.updateStatus(StateStatus.FAILURE);
        AppError.handleError(exception: exp);
      }
    }
  }

  void handleButtonBackAppBarOnTap() {
    Get.back();
  }

  void handleInputOnTap() {
    isDisableValidator = false;
  }

  void handleScreenOnTap() {
    focusNode.unfocus();
    isDisableValidator = true;
    formKey.currentState!.validate();
  }

  void handleIconEyeOnTap() {
    security = !security;
    update([EnumUpdateCreateWallet.INPUT_TEXT]);
  }

  void handleSwitchTouchIdOnChange() {
    isEnableTouchId = !isEnableTouchId;
    update([EnumUpdateCreateWallet.SWITCH_TOUCH_ID]);
  }

  void handleOnChangeInput() {
    if (formKey.currentState!.validate()) {
      isValidator = true;
      if (!isActiveButton && isChecked) {
        isActiveButton = true;
        update([EnumUpdateCreateWallet.BUTTON]);
      }
    } else {
      isValidator = false;
      if (isActiveButton) {
        isActiveButton = false;
        update([EnumUpdateCreateWallet.BUTTON]);
      }
    }
  }

  void handleCheckBoxOnTap() {
    isChecked = !isChecked;
    update([EnumUpdateCreateWallet.CHECK_BOX]);
    if (isValidator && isChecked) {
      isActiveButton = true;
      update([EnumUpdateCreateWallet.BUTTON]);
    } else if (!isChecked && isActiveButton) {
      isActiveButton = false;
      update([EnumUpdateCreateWallet.BUTTON]);
    }
  }
}
