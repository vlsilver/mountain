import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_setting/setting_change/setting_security_show_password/setting_security_show_privatrekey_repo.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum EnumUpdateSettingSecurityShowPrivateKey { INPUT_TEXT, BUTTON, FORM, TITLE }

class SettingSecurityShowPrivateKeyController extends GetxController {
  final FocusNode focusNode = FocusNode();
  final status = Status();
  bool isDisableValidator = false;
  bool isActiveButton = false;
  bool isErrorAuthen = false;
  bool security = true;
  String privateKey = '';
  int step = 1;

  final _repo = SettingSecurityShowPrivateKeyRepository();
  final TextEditingController passwordController = TextEditingController();
  final walletController = Get.find<WalletController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(
      debugLabel: 'SettingSecurityShowPrivateKeyController');
  String? validatorPassword(String? password) {
    if (isErrorAuthen) {
      return 'keyPass'.tr;
    }
    if (isDisableValidator) {
      return null;
    }
    return Validators.validatePassword(password);
  }

  List<BlockChainModel> get blockChains => walletController.blockChains;

  void handleScreenOnTap() {
    focusNode.unfocus();
    isDisableValidator = true;
    formKey.currentState!.validate();
  }

  void handleInputOnTap() {
    isDisableValidator = false;
  }

  void handleButtonConitnueOnTap({AddressModel? addressModel}) async {
    if (step == 1) {
      focusNode.unfocus();
      var success = walletController.wallet.password == passwordController.text;
      if (!success) {
        isErrorAuthen = true;
        formKey.currentState!.build(Get.context!);
        isErrorAuthen = false;
      } else {
        step += 1;
        update([
          EnumUpdateSettingSecurityShowPrivateKey.FORM,
          EnumUpdateSettingSecurityShowPrivateKey.TITLE,
        ]);
      }
    } else if (step == 2) {
      try {
        if (addressModel == null) {
          return;
        }
        if (addressModel.privatekey.isNotEmpty) {
          await status.updateStatus(StateStatus.LOADING);
          privateKey = addressModel.privatekey;
        } else {
          await status.updateStatus(StateStatus.LOADING);
          if (addressModel.privatekey.isNotEmpty) {
            privateKey = addressModel.privatekey;
          } else {
            privateKey = await _repo.getPrivateKey(
                derivationPath: addressModel.derivationPath,
                coinType: addressModel.coinType);
          }
        }
        step += 1;
        await status.updateStatus(StateStatus.SUCCESS);
        update([
          EnumUpdateSettingSecurityShowPrivateKey.FORM,
          EnumUpdateSettingSecurityShowPrivateKey.BUTTON,
          EnumUpdateSettingSecurityShowPrivateKey.TITLE,
        ]);
      } catch (exp) {
        await status.updateStatus(StateStatus.FAILURE,
            showSnackbarError: true, desc: 'copy_fail'.tr);
        AppError.handleError(exception: exp);
      }
    } else {
      Get.back();
    }
  }

  void handleIconEyeOnTap() {
    security = !security;
    update([EnumUpdateSettingSecurityShowPrivateKey.INPUT_TEXT]);
  }

  void handleOnChangeInput() {
    if (formKey.currentState!.validate()) {
      if (!isActiveButton) {
        isActiveButton = true;
        update([EnumUpdateSettingSecurityShowPrivateKey.BUTTON]);
      }
    } else {
      if (isActiveButton) {
        isActiveButton = false;
        update([EnumUpdateSettingSecurityShowPrivateKey.BUTTON]);
      }
    }
  }

  void handleIconCopyOntap() async {
    await Clipboard.setData(ClipboardData(text: privateKey));
    await status.updateStatus(StateStatus.SUCCESS,
        showSnackbarSuccess: true, isBack: false, desc: 'copy_key'.tr);
  }
}
