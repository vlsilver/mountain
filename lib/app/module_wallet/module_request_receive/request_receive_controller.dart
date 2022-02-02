import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/widget_global/select_address/select_address_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';

import '../wallet_controller.dart';

enum EnumRequestReceive { SEARCH, QRCODE, AMOUNT }

class RequestRecieveController extends GetxController {
  final walletController = Get.find<WalletController>();

  final status = Status();

  final searchText = ''.obs;

  late final Worker worker;

  bool isBackSimple = true;
  bool isErrorAmount = false;

  AddressModel addressRequest = AddressModel.empty();
  final amountController = TextEditingController();

  QrData get qrData => QrData(
        toAddress: addressRequest.address,
        amount: amountController.text,
        contractAddress: coinModel.contractAddress,
        symbol: coinModel.symbol,
        type: coinModel.type,
        blockChain: network(addressRequest.blockChainId),
      );

  final FocusNode focusNode =
      FocusNode(debugLabel: AppRoutes.REQUEST_RECIEVE_SELECT);

  final Rx<double> valueCompare = 0.0.obs;

  late CoinModel coinModel;

  List<BlockChainModel> get blockChains => walletController.blockChains;

  String network(String id) =>
      walletController.wallet.getNetworkByBlockChainId(id);

  late List<CoinModel> coinsInitial;

  late List<CoinModel> coinsSearch;

  String get amountString =>
      (amountController.text.isEmpty
          ? '0'
          : amountController.text.replaceAll(',', '.')) +
      ' ' +
      coinModel.symbol;

  @override
  void onInit() {
    coinsInitial = walletController.wallet.allCoins();
    coinsSearch = List.from(coinsInitial);

    super.onInit();
  }

  @override
  void onReady() async {
    await Future.delayed(Duration(milliseconds: 500));
    amountController.addListener(() {
      final inputValue = double.parse(amountController.text.isEmpty
          ? '0'
          : amountController.text.replaceAll(',', '.'));
      valueCompare.value = inputValue;
    });
    worker = debounce(searchText, (value) {
      if (searchText.isEmpty) {
        coinsSearch = coinsInitial;
        update([EnumRequestReceive.SEARCH]);
      } else {
        final searhValue = searchText.toLowerCase();
        coinsSearch = coinsInitial.where((coin) {
          return coin.name.toLowerCase().contains(searhValue) ||
              coin.symbol.toLowerCase().contains(searhValue) ||
              coin.type.toLowerCase().contains(searhValue);
        }).toList();
        update([EnumRequestReceive.SEARCH]);
      }
    }, time: Duration(milliseconds: 300));
    super.onReady();
  }

  @override
  void onClose() {
    worker.dispose();
    super.onClose();
  }

  void handleIcBackOnTap() {
    amountController.clear();
    Get.back(id: AppPages.NAVIGATOR_KEY_REQUEST_RECEIVE);
  }

  void setData({
    required CoinModel coin,
    required AddressModel address,
    required bool isBack,
  }) {
    coinModel = coin.copyWith();
    addressRequest = address.copyWith();
    isBackSimple = isBack;
  }

  void handleScreenOnTap() {
    focusNode.unfocus();
    if (isErrorAmount) {
      isErrorAmount = false;
      update([EnumRequestReceive.AMOUNT]);
    }
  }

  void handleAmountInputOntap() {
    if (isErrorAmount) {
      isErrorAmount = false;
      update([EnumRequestReceive.AMOUNT]);
    }
  }

  void handleCoinItemOnTap(CoinModel coin, bool isBack, int? idBack) {
    if (isBack) {
      Get.back<CoinModel>(id: idBack, result: coin);
    } else {
      coinModel = coin.copyWith();
      addressRequest = coin.blockChainOfCoin().addressModelActive.copyWith();
      Get.toNamed(AppRoutes.REQUEST_RECIEVE_SIMPLE,
          id: AppPages.NAVIGATOR_KEY_REQUEST_RECEIVE);
    }
  }

  void handleIconCopyOntap() async {
    await Clipboard.setData(ClipboardData(text: qrData.toAddress));
    await status.updateStatus(StateStatus.SUCCESS,
        showSnackbarSuccess: true, isBack: false, desc: addressRequest.address);
  }

  void hanldeIconShareButton() async {
    await Share.share(qrData.toAddress);
  }

  void handleButtonAddMoreOntap() async {
    await Get.toNamed(AppRoutes.REQUEST_RECIEVE_AMOUNT,
        id: AppPages.NAVIGATOR_KEY_REQUEST_RECEIVE);
  }

  void handleButtonContinueOnTap() async {
    focusNode.unfocus();
    isErrorAmount = Validators.validateAmount(amountController.text) != null;
    if (isErrorAmount) {
      update([EnumRequestReceive.AMOUNT]);
    } else {
      await Get.toNamed(AppRoutes.REQUEST_RECIEVE_COMPLETE,
          id: AppPages.NAVIGATOR_KEY_REQUEST_RECEIVE);
    }
  }

  void handleAddressBoxOnTap() async {
    final result = await Get.bottomSheet<AddressModel>(
        SelectAddressWidget(
          blockChains: [coinModel.blockChainOfCoin()],
          addressModel: addressRequest,
          height: Get.height * 0.8,
        ),
        isScrollControlled: true);

    if (result != null && addressRequest.address != result.address) {
      addressRequest = result.copyWith();
      update([EnumRequestReceive.QRCODE]);
    }
  }

  String get currencyCompare =>
      CoinModel.currentcyFormat(valueCompare.value * coinModel.price);
}

class QrData {
  final String toAddress;
  final String amount;
  final String blockChain;
  final String symbol;
  final String type;
  final String contractAddress;
  QrData({
    required this.toAddress,
    required this.amount,
    required this.blockChain,
    required this.symbol,
    required this.type,
    required this.contractAddress,
  });

  @override
  String toString() {
    return 'QrData(toAddress: $toAddress, amount: $amount, blockChain: $blockChain, symbol: $symbol, type: $type, contractAddress: $contractAddress)';
  }
}
