import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/save_address_widget/save_addres_favourite_controller.dart';
import 'package:base_source/app/widget_global/save_address_widget/save_address_favourite_page.dart';
import 'package:base_source/app/widget_global/select_address/select_address_widget.dart';
import 'package:base_source/app/widget_global/update_address/update_address_repo.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

enum EnumUpdateAddress {
  INPUT_RECEIVE_ADDRESS,
  BUTTON_CONTINUE,
  GROUP_ERROR,
  MY_LIST_ADDRESS,
  ADDRESS_SENDER,
}
enum EnumUpdateAddressError {
  VALID,
  NO_COIN,
  INVALID_ADDRESS,
}

class UpdateAddressController1 extends GetxController {
  EnumUpdateAddressError errorType = EnumUpdateAddressError.VALID;

  final status = Status();
  final receiveController = TextEditingController();
  bool enableScan = true;
  bool isActiveButtonContinue = false;
  final FocusNode focusNode = FocusNode();
  final addressRecievieInput = ''.obs;
  late final Worker worker;
  final _walletController = Get.find<WalletController>();
  final _repo = UpdateAddressRepository();

  late bool isFullScreen;
  late AddressModel addressSend;
  late AddressModel addressRecieve;
  late BlockChainModel blockChainModel;

  @override
  void onInit() {
    worker = debounce(
      addressRecievieInput,
      (value) {
        final address = addressRecievieInput.value;
        final indexInAddresss = blockChainModel.addresss.indexWhere(
            (element) => element.address == address || element.name == address);
        final indexInAddresssFavourite = blockChainModel.addresssFavourite
            .indexWhere((element) =>
                element.address == address || element.name == address);
        if (indexInAddresss != -1) {
          final addressRecievieModel =
              blockChainModel.addresss[indexInAddresss];
          addressRecieve = blockChainModel.addresss[indexInAddresss];
          receiveController.text =
              '${addressRecievieModel.name}\n( ${addressRecievieModel.address} )';
        } else if (indexInAddresssFavourite != -1) {
          final addressRecievieModel =
              blockChainModel.addresssFavourite[indexInAddresssFavourite];
          addressRecieve = addressRecievieModel;
          receiveController.text =
              '${addressRecievieModel.name}\n( ${addressRecievieModel.address} )';
        } else {
          if (!receiveAddressIsMyAddress) {
            addressRecieve = AddressModel.empty().copyWith(address: address);
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

  void handleInitData({
    required AddressModel addressSendInit,
    required AddressModel addressRecieveInit,
    required bool isFullScreenInit,
  }) {
    addressSend = addressSendInit;
    addressRecieve = addressRecieveInit;
    isFullScreen = isFullScreenInit;
    blockChainModel =
        _walletController.blockChainById(addressSend.blockChainId);
    isFullScreen = isFullScreen;
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
          .trParams({'value': addressSend.currecyString}) ??
      '';

  void handleIcCloseOnTap() {
    receiveController.text = '';
    addressRecieve = AddressModel.empty();
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
      if (addressSend.coinOfBlockChain.value == BigInt.from(0)) {
        errorType = EnumUpdateAddressError.NO_COIN;
        update([EnumUpdateAddress.GROUP_ERROR]);
        return;
      }
      final isValid = await _repo.checkValidAddress(
        address: addressRecieve.address,
        coinType: addressSend.coinType,
      );
      if (!isValid) {
        errorType = EnumUpdateAddressError.INVALID_ADDRESS;
        update([EnumUpdateAddress.GROUP_ERROR]);
        return;
      }
      focusNode.unfocus();
      if (!receiveAddressIsMyAddress) {
        Get.put(SaveAddressFavouriteController()).handleInitData(
          receiveController.text,
          addressSend.blockChainId,
        );
        await Get.bottomSheet(SaveAddressFavouriteWidget(),
            isScrollControlled: true);
        await Get.delete<SaveAddressFavouriteController>();
      }
      await status.updateStatus(StateStatus.LOADING);
      // if (swapController.coinModelFrom.id.isEmpty ||
      //     swapController.coinModelFrom.blockchainId !=
      //         swapController.addressSender.blockChainId) {
      //   swapController.coinModelFrom =
      //       swapController.addressSender.coinAvalible();
      // }
      // if (swapController.coinModelTo.id.isEmpty ||
      //     swapController.coinModelTo.blockchainId !=
      //         swapController.addressSender.blockChainId) {
      //   if (swapController.addressSender.coins[1].value > 0.0) {
      //     swapController.coinModelTo = swapController.addressSender.coins[2];
      //   } else {
      //     swapController.coinModelTo = swapController.addressSender.coins[1];
      //   }
      // }
      // await swapController.getRateCoinSwap();
      // await status.updateStatus(StateStatus.SUCCESS);
      // swapController.isAutoGetAmount = true;
      // await Get.toNamed(AppRoutes.UPDATE_AMOUNT_SWAP,
      //     id: AppPages.NAVIGATOR_KEY_SWAP);
    } catch (exp) {
      await status.updateStatus(StateStatus.FAILURE,
          showSnackbarError: true,
          title: 'global_failure'.tr,
          desc: 'unable_to_calculate'.tr);
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

  void handleInputAddressSendOnTap() async {
    if (errorType != EnumUpdateAddressError.VALID) {
      errorType = EnumUpdateAddressError.VALID;
      update([EnumUpdateAddress.GROUP_ERROR]);
    }
    final oldBlockChainId = blockChainModel.id;
    final result = await Get.bottomSheet<AddressModel>(
        SelectAddressWidget(
          blockChains: _walletController.blockChainSupportSwap,
          addressModel: addressSend,
          height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
        ),
        isScrollControlled: true);
    if (result != null) {
      if (oldBlockChainId != result.blockChainId) {
        receiveController.clear();
        blockChainModel = _walletController.blockChainById(result.blockChainId);
        addressRecieve = AddressModel.empty();
        // swapController.coinModelFrom = CoinModel.empty();
      }
      if (addressSend.address != result.address ||
          oldBlockChainId != result.blockChainId) {
        addressSend = result;
        // swapController.coinModelFrom =
        // swapController.addressSender.coinAvalible();
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
          blockChains: [blockChainModel],
          addressModel: addressRecieve,
        ),
        isScrollControlled: true);
    if (result != null) {
      if (!receiveController.text.contains(result.address)) {
        addressRecieve = result;
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
          blockChains: [blockChainModel],
          addressModel: addressRecieve,
        ),
        isScrollControlled: true);
    if (result != null) {
      if (!receiveController.text.contains(result.address)) {
        addressRecieve = result;
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
