import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/data/services/authen_services.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_repo.dart';
import 'widget/dialog_reset_wallet_widget.dart';

enum EnumUpdateLogin { BUTTON, INPUT_TEXT, SWITCH_TOUCH_ID, CHECK_BOX }

class LoginController extends GetxController {
  final String bg = AppAssets.loginBg;
  final String icTouchId = AppAssets.loginIcTouchId;
  final String icFaceId = AppAssets.loginIcFaceId;

  bool security = true;
  bool biometricState = true;
  late bool acceptedBiometric;
  bool isDisableValidator = false;
  bool isActiveButton = false;
  bool isErrorAuthen = false;

  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: AppRoutes.LOGIN);
  final TextEditingController passwordController = TextEditingController();

  final status = Status();

  final LoginRepository _repo = LoginRepository();
  final walletController = Get.find<WalletController>();
  final authenService = Get.find<AuthenService>();

  String? validatorPassword(String? password) {
    if (isErrorAuthen) {
      return 'error_pass'.tr;
    }
    if (isDisableValidator) {
      return null;
    }
    return Validators.validatePassword(password);
  }

  @override
  void onInit() async {
    acceptedBiometric = _repo.checkIsAcceptBiometric();
    biometricState = acceptedBiometric;
    super.onInit();
  }

  @override
  void onReady() async {
    await Future.delayed(Duration(milliseconds: 500));

    if (acceptedBiometric) {
      await handleBiometricIconOnTap();
    }
    super.onReady();
  }

  @override
  void onClose() {
    passwordController.dispose();
    formKey.reactive.dispose();
    super.onClose();
  }

  Future<void> handleBiometricIconOnTap() async {
    try {
      final success =
          await _repo.loginWithBiometric(biometricState: biometricState);
      if (success) {
        await walletController.initWallet();
        await Get.offAllNamed(AppRoutes.HOME);
      } else {}
    } catch (exp) {
      AppError.handleError(exception: exp);
    }
  }

  void handleButtonLoginOnTap() async {
    try {
      focusNode.unfocus();
      await status.updateStatus(StateStatus.LOADING);
      bool? success = await walletController.loginWithPassword(
          passsowrd: passwordController.text);
      if (!success) {
        await status.updateStatus(StateStatus.FAILURE);
        isErrorAuthen = true;
        formKey.currentState!.build(Get.context!);
        isErrorAuthen = false;
        return;
      }
      success = await _repo.confirmBiometric(
        acceptedBiometric: acceptedBiometric,
        biometricState: biometricState,
      );
      if (success) {
        await status.updateStatus(StateStatus.SUCCESS);
        await Get.offAllNamed(AppRoutes.HOME);
      } else {
        await status.updateStatus(StateStatus.FAILURE);
      }
    } catch (exp) {
      if (exp == 'Error Biometric') {
        await status.updateStatus(StateStatus.FAILURE,
            showDialogError: true,
            title: 'global_failure'.tr,
            desc: 'global_error_enable_touchId'.tr);
      } else {
        await status.updateStatus(StateStatus.FAILURE);
        AppError.handleError(exception: exp);
      }
    }
  }

  void handleButtonDeleteWalletOnTap() async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      await walletController.deletedAllWallet();
      await _repo.deleteAcceptedBiometric();
      await _repo.deteleFavouriteCoinPair(
          walletController.wallet.keyForFavouritePairCoin);
      await status.updateStatus(StateStatus.SUCCESS);
      await Get.offAllNamed(AppRoutes.CHOICE_SETUP_WALLET);
    } catch (exp) {
      await status.updateStatus(StateStatus.FAILURE);
      AppError.handleError(exception: exp);
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
    update([EnumUpdateLogin.INPUT_TEXT]);
  }

  void handleSwitchTouchIdOnChange() {
    biometricState = !biometricState;
    update([EnumUpdateLogin.SWITCH_TOUCH_ID]);
  }

  void handleResetTextOnTap() {
    Get.dialog(
      DialogResetWalletWidget(),
      barrierDismissible: false,
    );
  }

  void handleOnChangeInput() {
    if (formKey.currentState!.validate()) {
      if (!isActiveButton) {
        isActiveButton = true;
        update([EnumUpdateLogin.BUTTON]);
      }
    } else {
      if (isActiveButton) {
        isActiveButton = false;
        update([EnumUpdateLogin.BUTTON]);
      }
    }
  }

  void handleResetTextOnLongPress() async {
    await walletController.deletedAllWallet();
    await _repo.deleteAcceptedBiometric();
    await Get.offAllNamed(AppRoutes.CHOICE_SETUP_WALLET);
  }
}
