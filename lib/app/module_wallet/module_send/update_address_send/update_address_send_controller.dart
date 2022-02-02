import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/module_wallet/module_send/send_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:base_source/app/widget_global/save_address_widget/save_addres_favourite_controller.dart';
import 'package:base_source/app/widget_global/save_address_widget/save_address_favourite_page.dart';
import 'package:base_source/app/widget_global/select_address/select_address_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

enum EnumUpdateAddress {
  INPUT_RECEIVE_ADDRESS,
  BUTTON_CONTINUE,
  BUTTON_SAVE,
  GROUP_ERROR,
  MY_LIST_ADDRESS,
  ADDRESS_SENDER,
  ADDRESS_SAVE
}
enum EnumUpdateAddressError {
  VALID,
  NO_COIN,
  INVALID_ADDRESS,
}

class UpdateAddressSendController extends GetxController {
  EnumUpdateAddressError errorType = EnumUpdateAddressError.VALID;

  final status = Status();
  final receiveController = TextEditingController();
  bool enableScan = true;
  bool isActiveButtonContinue = false;
  final FocusNode focusNode = FocusNode();
  final addressRecievieInput = ''.obs;
  final sendController = Get.find<SendController>();
  String? isErrorAddressSave;
  bool isFullScreen = true;
  late final Worker worker;
  final _walletController = Get.find<WalletController>();

  @override
  void onInit() {
    worker = debounce(
      addressRecievieInput,
      (value) {
        final address = addressRecievieInput.value;
        final indexInAddresss = sendController.blockChainModel.addresss
            .indexWhere((element) =>
                element.address == address || element.name == address);
        final indexInAddresssFavourite = sendController
            .blockChainModel.addresssFavourite
            .indexWhere((element) =>
                element.address == address || element.name == address);
        if (indexInAddresss != -1) {
          final addressRecievieModel =
              sendController.blockChainModel.addresss[indexInAddresss];
          sendController.addressRecieve =
              sendController.blockChainModel.addresss[indexInAddresss];
          receiveController.text =
              '${addressRecievieModel.name}\n( ${addressRecievieModel.address} )';
        } else if (indexInAddresssFavourite != -1) {
          final addressRecievieModel = sendController
              .blockChainModel.addresssFavourite[indexInAddresssFavourite];
          sendController.addressRecieve = addressRecievieModel;
          receiveController.text =
              '${addressRecievieModel.name}\n( ${addressRecievieModel.address} )';
        } else {
          if (!receiveAddressIsMyAddress) {
            sendController.addressRecieve =
                sendController.addressRecieve.copyWith(address: address);
          }
        }
      },
      time: 500.milliseconds,
    );
    handleListenRecieveTextEditControler();
    super.onInit();
  }

  @override
  void onClose() {
    receiveController.removeListener(() {});
    receiveController.dispose();
    worker.dispose();
    super.onClose();
  }

  void handleListenRecieveTextEditControler() {
    receiveController.addListener(() {
      addressRecievieInput.value = receiveController.text;
      if (errorType != EnumUpdateAddressError.VALID) {
        errorType = EnumUpdateAddressError.VALID;
        update([EnumUpdateAddress.GROUP_ERROR]);
      }
      if (receiveController.text.isNotEmpty &&
          enableScan &&
          !isActiveButtonContinue) {
        enableScan = false;
        isActiveButtonContinue = true;
        update([
          EnumUpdateAddress.INPUT_RECEIVE_ADDRESS,
          EnumUpdateAddress.BUTTON_CONTINUE,
        ]);
      } else if (receiveController.text.isEmpty &&
          !enableScan &&
          isActiveButtonContinue) {
        enableScan = true;
        isActiveButtonContinue = false;
        update([
          EnumUpdateAddress.INPUT_RECEIVE_ADDRESS,
          EnumUpdateAddress.BUTTON_CONTINUE,
        ]);
      }
    });
  }

  bool get noCoin => errorType == EnumUpdateAddressError.NO_COIN;
  bool get valid => errorType == EnumUpdateAddressError.VALID;
  bool get inValidAddress =>
      errorType == EnumUpdateAddressError.INVALID_ADDRESS;
  String errorNoCoinStr() =>
      'error_balance_not_enough_address'
          .trParams({'value': sendController.addressSender.currecyString}) ??
      '';

  void handleIcCloseOnTap() {
    receiveController.text = '';
    sendController.addressRecieve = AddressModel.empty();
  }

  void handleIconQRScanOnTap() async {
    if (errorType != EnumUpdateAddressError.VALID) {
      errorType = EnumUpdateAddressError.VALID;
      update([EnumUpdateAddress.GROUP_ERROR]);
    }
    var barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '',
      'Cancel',
      false,
      ScanMode.QR,
    );
    if (barcodeScanRes != '-1') {
      receiveController.text = barcodeScanRes;
      update([EnumUpdateAddress.INPUT_RECEIVE_ADDRESS]);
    }
  }

  bool get receiveAddressIsMyAddress => receiveController.text.contains('(');

  void handleButtonContinueOnTap() async {
    focusNode.unfocus();
    try {
      if (sendController.addressSender.coinOfBlockChain.value ==
          BigInt.from(0)) {
        errorType = EnumUpdateAddressError.NO_COIN;
        update([EnumUpdateAddress.GROUP_ERROR]);
        return;
      }
      final isValid = await sendController.checkValidAddress(
          address: sendController.addressRecieve.address);
      if (!isValid) {
        errorType = EnumUpdateAddressError.INVALID_ADDRESS;
        update([EnumUpdateAddress.GROUP_ERROR]);
        return;
      }
      focusNode.unfocus();
      if (!receiveAddressIsMyAddress) {
        Get.put(SaveAddressFavouriteController()).handleInitData(
          receiveController.text,
          sendController.addressSender.blockChainId,
        );
        await Get.bottomSheet(SaveAddressFavouriteWidget(),
            isScrollControlled: true);
        await Get.delete<SaveAddressFavouriteController>();
        final indexInAddresssFavourite = sendController
            .blockChainModel.addresssFavourite
            .indexWhere((element) => element.address == receiveController.text);
        if (indexInAddresssFavourite != -1) {
          final addressResult = sendController
              .blockChainModel.addresssFavourite[indexInAddresssFavourite];
          receiveController.text =
              '${addressResult.name}\n( ${addressResult.address} )';
        }
      }
      await Get.toNamed(AppRoutes.UPDATE_AMOUNT_SEND,
          id: AppPages.NAVIGATOR_KEY_SEND);
    } catch (exp) {
      AppError.handleError(exception: exp);
    }
  }

  void handleScreenOnTap() {
    focusNode.unfocus();
  }

  void handleInputReceiveAddressOnTap() {
    if (errorType != EnumUpdateAddressError.VALID) {
      errorType = EnumUpdateAddressError.VALID;
      update([EnumUpdateAddress.GROUP_ERROR]);
    }
  }

  void handleButtonCancelOnTap() {
    Get.back();
    Get.toNamed(AppRoutes.UPDATE_AMOUNT_SEND, id: AppPages.NAVIGATOR_KEY_SEND);
  }

  void handleInputAddressSendOnTap() async {
    if (errorType != EnumUpdateAddressError.VALID) {
      errorType = EnumUpdateAddressError.VALID;
      update([EnumUpdateAddress.GROUP_ERROR]);
    }
    final oldBlockChainId = sendController.blockChainModel.id;
    final result = await Get.bottomSheet<AddressModel>(
        SelectAddressWidget(
          blockChains: _walletController.blockChains,
          addressModel: sendController.addressSender,
          height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
        ),
        isScrollControlled: true);
    if (result != null) {
      if (oldBlockChainId != result.blockChainId) {
        receiveController.clear();
        sendController.blockChainModel =
            _walletController.blockChainById(result.blockChainId);
        sendController.addressRecieve = AddressModel.empty();
      }
      if (sendController.addressSender.address != result.address ||
          oldBlockChainId != result.blockChainId) {
        sendController.addressSender = result;
        sendController.coinModelSelect =
            sendController.addressSender.coinAvalible();
        update([EnumUpdateAddress.ADDRESS_SENDER]);
      }
    }
  }

  void handleTextShowAddresssActive() async {
    if (errorType != EnumUpdateAddressError.VALID) {
      errorType = EnumUpdateAddressError.VALID;
      update([EnumUpdateAddress.GROUP_ERROR]);
    }
    final result = await Get.bottomSheet<AddressModel>(
        SelectAddressWidget(
          height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
          blockChains: [sendController.blockChainModel],
          addressModel: sendController.addressRecieve,
        ),
        isScrollControlled: true);
    if (result != null) {
      if (!receiveController.text.contains(result.address)) {
        sendController.addressRecieve = result;
        receiveController.text = '${result.name}\n( ${result.address} )';
      }
    }
  }

  void handleTextShowAddresssFavouriteOnTap() async {
    if (errorType != EnumUpdateAddressError.VALID) {
      errorType = EnumUpdateAddressError.VALID;
      update([EnumUpdateAddress.GROUP_ERROR]);
    }
    final result = await Get.bottomSheet<AddressModel>(
        SelectAddressWidget(
          isFavourite: true,
          add: false,
          height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
          blockChains: [sendController.blockChainModel],
          addressModel: sendController.addressRecieve,
        ),
        isScrollControlled: true);
    if (result != null) {
      if (!receiveController.text.contains(result.address)) {
        sendController.addressRecieve = result;
        receiveController.text = '${result.name}\n( ${result.address} )';
      }
    }
  }

  void handlePaseteData() async {
    var data = await Clipboard.getData('text/plain');
    if (data != null) {
      receiveController.text = data.text ?? '';
    } else {}
  }
}
