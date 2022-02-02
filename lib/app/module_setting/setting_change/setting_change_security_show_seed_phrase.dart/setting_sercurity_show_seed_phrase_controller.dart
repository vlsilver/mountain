import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum EnumUpdateSettingSecurityShowSeedPhrase { INPUT_TEXT, BUTTON, FORM }

class SettingSecurityShowSeedPhraseController extends GetxController {
  final FocusNode focusNode = FocusNode();
  final status = Status();
  bool isDisableValidator = false;
  bool isActiveButton = false;
  bool isErrorAuthen = false;
  bool security = true;
  int step = 1;

  final TextEditingController passwordController = TextEditingController();
  final walletController = Get.find<WalletController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(
      debugLabel: 'SettingSecurityShowSeedPhraseController');
  String? validatorPassword(String? password) {
    if (isErrorAuthen) {
      return 'pass_error'.tr;
    }
    if (isDisableValidator) {
      return null;
    }
    return Validators.validatePassword(password);
  }

  String get menemonic => walletController.wallet.mnemonic;

  void handleScreenOnTap() {
    focusNode.unfocus();
    isDisableValidator = true;
    formKey.currentState!.validate();
  }

  void handleInputOnTap() {
    isDisableValidator = false;
  }

  void handleButtonConitnueOnTap() async {
    if (step == 1) {
      focusNode.unfocus();
      var success = walletController.wallet.password == passwordController.text;
      if (!success) {
        isErrorAuthen = true;
        formKey.currentState!.build(Get.context!);
        isErrorAuthen = false;
      } else {
        step = 2;
        update([
          EnumUpdateSettingSecurityShowSeedPhrase.FORM,
          EnumUpdateSettingSecurityShowSeedPhrase.BUTTON,
        ]);
      }
    } else {
      Get.back();
    }
  }

  void handleIconEyeOnTap() {
    security = !security;
    update([EnumUpdateSettingSecurityShowSeedPhrase.INPUT_TEXT]);
  }

  void handleOnChangeInput() {
    if (formKey.currentState!.validate()) {
      if (!isActiveButton) {
        isActiveButton = true;
        update([EnumUpdateSettingSecurityShowSeedPhrase.BUTTON]);
      }
    } else {
      if (isActiveButton) {
        isActiveButton = false;
        update([EnumUpdateSettingSecurityShowSeedPhrase.BUTTON]);
      }
    }
  }

  void handleIconCopyOntap() async {
    await Clipboard.setData(ClipboardData(text: menemonic));
    await status.updateStatus(StateStatus.SUCCESS,
        showSnackbarSuccess: true,
        isBack: false,
        desc: 'copy_success_recovery_seed_phrase'.tr);
  }
}
