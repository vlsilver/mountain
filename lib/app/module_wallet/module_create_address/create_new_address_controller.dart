import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

import '../wallet_controller.dart';

enum EnumUpdateAddAcount {
  BUTTON_ACCOUNT_NAME,
  BUTTON_INPUT_KEY,
  IMPORT_KEY,
  NAME_ADDRESS
}

class CreateNewAddressController extends GetxController {
  final focusNode = FocusNode();

  bool isActiveButtonNew = false;
  bool isActiveButtonInput = false;
  bool isErrorImportAddress = false;
  String accountName = '';
  String? isErrorName;
  String key = '';

  late final WalletController walletController;
  final privateKeyController = TextEditingController();
  var privateKeyState = EnumPrivateKeyStatus.SUCCESS;
  String? blockChainId;

  final status = Status();

  @override
  void onInit() {
    walletController = Get.find<WalletController>();
    super.onInit();
  }

  void handleScreenOnTap() {
    focusNode.unfocus();
    if (isErrorImportAddress) {
      isErrorImportAddress = false;
      privateKeyState = EnumPrivateKeyStatus.SUCCESS;
      update([EnumUpdateAddAcount.IMPORT_KEY]);
    }
    if (isErrorName != null) {
      isErrorName = null;
      update([EnumUpdateAddAcount.NAME_ADDRESS]);
    }
  }

  void handleIconQRScanOnTap() async {
    var barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '',
      'global_cancel'.tr,
      false,
      ScanMode.QR,
    );
    if (barcodeScanRes != '-1') {
      privateKeyController.text = barcodeScanRes;
      handleTextFormFieldInputKeyOnChange(input: barcodeScanRes);
    }
  }

  void handleTextFormFieldAccountNameOnChange({required String input}) {
    accountName = input;
    if (input.isEmpty && isActiveButtonNew) {
      isActiveButtonNew = false;
      update([EnumUpdateAddAcount.BUTTON_ACCOUNT_NAME]);
    } else if (input.isNotEmpty && !isActiveButtonNew) {
      isActiveButtonNew = true;
      update([EnumUpdateAddAcount.BUTTON_ACCOUNT_NAME]);
    }
  }

  void handleOnTapName() {
    if (isErrorName != null) {
      isErrorName = null;
      update([EnumUpdateAddAcount.NAME_ADDRESS]);
    }
  }

  void handleOnTapImportKey() {
    if (isErrorImportAddress) {
      isErrorImportAddress = false;
      privateKeyState = EnumPrivateKeyStatus.SUCCESS;
      update([EnumUpdateAddAcount.IMPORT_KEY]);
    }
  }

  void handleTextFormFieldInputKeyOnChange({required String input}) {
    key = input;
    if (input.isEmpty && isActiveButtonInput) {
      isActiveButtonInput = false;
      update([EnumUpdateAddAcount.BUTTON_INPUT_KEY]);
    } else if (input.isNotEmpty && !isActiveButtonInput) {
      isActiveButtonInput = true;
      update([EnumUpdateAddAcount.BUTTON_INPUT_KEY]);
    }
  }

  void handleIcBackOntap() {
    Get.back(id: AppPages.NAVIGATOR_KEY_ADD_ACCOUNT);
  }

  void handleButtonCreateOntap(bool isBack) async {
    try {
      focusNode.unfocus();
      isErrorName = Validators.validateNameAddress(accountName);
      if (isErrorName == null) {
        await status.updateStatus(StateStatus.LOADING);
        await walletController.createNewAddress(
            name: accountName, blockChainId: blockChainId!);
        await status.updateStatus(StateStatus.SUCCESS);
        if (isBack) {
          Get.back(id: AppPages.NAVIGATOR_KEY_ADD_ACCOUNT);
        } else {
          Get.back();
        }
      } else {
        update([EnumUpdateAddAcount.NAME_ADDRESS]);
      }
    } catch (exp) {
      await status.updateStatus(StateStatus.FAILURE);
      Get.back();
      AppError.handleError(exception: exp);
    }
  }

  void handleButtonCreateFromPrivateKeyOnTap(bool isBack) async {
    try {
      focusNode.unfocus();
      if (isErrorImportAddress) {
        isErrorImportAddress = false;
        update([EnumUpdateAddAcount.IMPORT_KEY]);
      }
      await status.updateStatus(StateStatus.LOADING);
      final privateKeyStateResult = await walletController.createAddress(
        key: key,
        blockChainId: blockChainId!,
      );
      privateKeyState = privateKeyStateResult;
      if (privateKeyState == EnumPrivateKeyStatus.SUCCESS) {
        await status.updateStatus(StateStatus.SUCCESS);
        if (isBack) {
          Get.back(id: AppPages.NAVIGATOR_KEY_ADD_ACCOUNT);
        } else {
          Get.back();
        }
      } else {
        await status.updateStatus(StateStatus.FAILURE);
        isErrorImportAddress = true;
        update([EnumUpdateAddAcount.IMPORT_KEY]);
      }
    } catch (exp) {
      await status.updateStatus(StateStatus.FAILURE);
      isErrorImportAddress = true;
      update([EnumUpdateAddAcount.IMPORT_KEY]);
      AppError.handleError(exception: exp);
    }
  }

  void handleTabarOnTap({required int index}) {
    if (index == 0) {
      if (isActiveButtonInput) {
        isActiveButtonInput = false;
      }
    } else if (index == 1) {
      if (isActiveButtonInput) {
        isActiveButtonInput = false;
      }
    }
  }
}
