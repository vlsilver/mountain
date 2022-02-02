import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/module_wallet/module_create/create_wallet/create_wallet_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

enum EnumUpdateImportWallet {
  BUTTON,
  INPUT_TEXT_PASSWORD,
  SWITCH_TOUCH_ID,
  INPUT_TEXT_MNEMONIC
}

class ImportWalletController extends GetxController {
  final String icScan = AppAssets.globalIcScan;

  bool security = true;
  bool securityMnemonic = false;
  bool isValidMnemonic = true;
  bool isEnableTouchId = false;
  bool isActiveButton = false;
  bool isDisableValidator = false;

  final RxString mnemonic = ''.obs;

  late final Worker worker;
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: AppRoutes.IMPORT_WALLET);
  final TextEditingController passwordController = TextEditingController();
  TextEditingController mnemonicController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  final _status = Status();

  // final AuthenService _authenService = Get.find<AuthenService>();
  final WalletController _walletController = Get.find<WalletController>();

  String? validatorPassword(String? password) {
    if (isDisableValidator) {
      return null;
    }
    return Validators.validatePassword(password);
  }

  String? validatorConfirmPassword(String? confirmPassword) {
    if (isDisableValidator) {
      return null;
    }
    return Validators.validateConfirmPassword(
        passwordController.text, confirmPassword);
  }

  String? validatorMnemonic() {
    if (!isValidMnemonic) {
      return 'restore_'.tr;
    }
    if (isDisableValidator) {
      return null;
    }
    return Validators.validateMnemonic(mnemonic.value);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    await Future.delayed(Duration(milliseconds: 500));
    worker = debounce(
      mnemonic,
      (value) {
        if (securityMnemonic) {
          mnemonicController.text = mnemonicController.text
              .substring(0, mnemonicController.text.length)
              .replaceAll(RegExp(r'[^-\s]'), '•');
          mnemonicController.selection = TextSelection.fromPosition(
              TextPosition(offset: mnemonicController.text.length));
        }
      },
      time: 1.seconds,
    );
    super.onReady();
  }

  @override
  void onClose() {
    worker.dispose();
    mnemonicController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }

  void handleIconQRScanOnTap() async {
    var barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '',
      'global_cancel'.tr,
      false,
      ScanMode.QR,
    );
    if (barcodeScanRes != '-1') {
      mnemonicController.text = barcodeScanRes;
      mnemonic.value = barcodeScanRes;
    }
  }

  void handleInputMnemonicText() {
    if (securityMnemonic) {
      if (mnemonicController.text.isNotEmpty && mnemonic.value.isNotEmpty) {
        final _valueLength = mnemonicController.text.length;
        final _mnemonicLength = mnemonic.value.length;
        if (_valueLength > _mnemonicLength) {
          final _currentChar = mnemonicController.text[_valueLength - 1];
          mnemonic.value += _currentChar;
        } else if (_valueLength == _mnemonicLength) {
          final _currentChar = mnemonicController.text[_valueLength - 1];
          mnemonic.value =
              mnemonic.substring(0, _mnemonicLength - 1) + _currentChar;
        } else {
          mnemonic.value = mnemonic.substring(0, _mnemonicLength - 1);
        }
        mnemonicController.text = mnemonicController.text
                .substring(0, mnemonicController.text.length - 1)
                .replaceAll(RegExp(r'[^-\s]'), '•') +
            mnemonicController.text[mnemonicController.text.length - 1];
        mnemonicController.selection = TextSelection.fromPosition(
            TextPosition(offset: mnemonicController.text.length));
      } else {
        mnemonic.value = mnemonicController.text;
      }
    } else {
      mnemonic.value = mnemonicController.text;
    }
  }

  void handleButtonOnTap() async {
    try {
      await _status.updateStatus(StateStatus.LOADING);
      isValidMnemonic = await _walletController.importWallet(
        mnemonic: mnemonic.value,
        password: passwordController.text,
        biometricState: isEnableTouchId,
      );

      if (isValidMnemonic) {
        await Get.delete<CreateWalletController>(force: true);
        Get.back();
        await Get.offAllNamed(AppRoutes.HOME);
      } else {
        isValidMnemonic = false;
        await _status.updateStatus(StateStatus.FAILURE);
        isValidMnemonic = true;
        formKey.currentState!.build(Get.context!);
      }
    } catch (exp) {
      if (exp == 'Error Biometric') {
        await _status.updateStatus(StateStatus.FAILURE,
            showDialogError: true,
            title: 'global_failure'.tr,
            desc: 'global_error_enable_touchId'.tr);
      } else {
        await _status.updateStatus(StateStatus.FAILURE);
        isValidMnemonic = false;
        formKey.currentState!.build(Get.context!);
        AppError.handleError(exception: exp);
        isValidMnemonic = true;
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

  void handleIconEyePasswordOnTap() {
    security = !security;
    update([EnumUpdateImportWallet.INPUT_TEXT_PASSWORD]);
  }

  void handleIconEyeMnemonicOnTap() {
    securityMnemonic = !securityMnemonic;
    if (!securityMnemonic) {
      mnemonicController.text = mnemonic.value;
      mnemonicController.selection = TextSelection.fromPosition(
          TextPosition(offset: mnemonicController.text.length));
    } else {
      mnemonicController.text = mnemonicController.text
          .substring(0, mnemonicController.text.length)
          .replaceAll(RegExp(r'[^-\s]'), '•');
      mnemonicController.selection = TextSelection.fromPosition(
          TextPosition(offset: mnemonicController.text.length));
    }
    update([EnumUpdateImportWallet.INPUT_TEXT_MNEMONIC]);
  }

  void handleSwitchTouchIdOnChange() {
    isEnableTouchId = !isEnableTouchId;
    update([EnumUpdateImportWallet.SWITCH_TOUCH_ID]);
  }

  void handleOnChangeInput() {
    if (formKey.currentState!.validate()) {
      if (!isActiveButton) {
        isActiveButton = true;
        update([EnumUpdateImportWallet.BUTTON]);
      }
    } else {
      if (isActiveButton) {
        isActiveButton = false;
        update([EnumUpdateImportWallet.BUTTON]);
      }
    }
  }
}
