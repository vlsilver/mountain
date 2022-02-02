import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'add_token_repository.dart';
import 'pages/add_token_review_page.dart';

enum EnumAddToken { INPUT_ADDRESS, BUTTON, SEARCH, BLOCK_CHAIN }

class AddTokenController extends GetxController {
  final walletController = Get.find<WalletController>();
  final addressController = TextEditingController();
  final _repo = AddTokenRepository();

  final focusNode = FocusNode();
  final status = Status();
  bool enableScan = true;
  bool isActiveButton = false;
  final searchText = ''.obs;

  late final Worker worker;

  late BlockChainModel blockChainModelActive;
  late CoinModel coinModelResult;

  late List<BlockChainModel> blockChains;

  var _listSearchInitialActive = <CoinModel>[];
  var _listSearchInitialDisable = <CoinModel>[];
  var listSearchInitial = <CoinModel>[];
  var listSearchResult = <CoinModel>[];

  void handleIcCloseOnTap() {
    addressController.text = '';
  }

  @override
  void onInit() {
    for (var blockChain in walletController.blockChains) {
      for (var coin in blockChain.coins) {
        coin.isActive
            ? _listSearchInitialActive.add(coin)
            : _listSearchInitialDisable.add(coin);
      }
    }
    listSearchInitial = _listSearchInitialActive + _listSearchInitialDisable;
    listSearchResult = List.from(listSearchInitial);
    blockChainModelActive = walletController.wallet.blockChains
        .firstWhere((blockChain) => blockChain.id == BlockChainModel.ethereum);
    blockChains = walletController.wallet.blockChains
        .where(
          (blockChain) =>
              blockChain.id == BlockChainModel.ethereum ||
              blockChain.id == BlockChainModel.binanceSmart ||
              blockChain.id == BlockChainModel.polygon ||
              blockChain.id == BlockChainModel.kardiaChain,
        )
        .toList();

    super.onInit();
  }

  @override
  void onReady() async {
    await Future.delayed(Duration(milliseconds: 500));
    addressController.addListener(() {
      if (addressController.text.isEmpty && isActiveButton) {
        isActiveButton = false;
        update([EnumAddToken.BUTTON, EnumAddToken.INPUT_ADDRESS]);
      } else if (addressController.text.isNotEmpty && !isActiveButton) {
        isActiveButton = true;
        update([EnumAddToken.BUTTON, EnumAddToken.INPUT_ADDRESS]);
      }
    });
    worker = debounce(searchText, (value) {
      if (searchText.isEmpty) {
        listSearchResult = listSearchInitial;
        update([EnumAddToken.SEARCH]);
      } else {
        final searhValue = searchText.toLowerCase();
        listSearchResult = listSearchInitial.where((coin) {
          return coin.name.toLowerCase().contains(searhValue) ||
              coin.symbol.toLowerCase().contains(searhValue) ||
              coin.type.toLowerCase().contains(searhValue);
        }).toList();
        update([EnumAddToken.SEARCH]);
      }
    }, time: Duration(milliseconds: 300));
    super.onReady();
  }

  @override
  void onClose() {
    addressController.removeListener(() {});
    worker.dispose();
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
      addressController.text = barcodeScanRes;
      update([EnumAddToken.INPUT_ADDRESS]);
    }
  }

  void handleBlockChainBoxOnTap() {
    Get.toNamed(
      AppRoutes.ADD_TOKEN_SELECT_BLOCK_CHAIN,
      id: AppPages.NAVIGATOR_KEY_ADD_TOKEN,
    );
  }

  void handleIconBackOnTap() {
    Get.back(id: AppPages.NAVIGATOR_KEY_ADD_TOKEN);
  }

  void handleSwitchOnTap({
    required index,
    required CoinModel coinModel,
  }) {
    if (coinModel.isActive) {
      listSearchResult[index].isActive = false;
      final indexInList = _listSearchInitialActive.indexWhere((coin) =>
          coin.blockchainId == coinModel.blockchainId &&
          coin.contractAddress == coinModel.contractAddress);
      _listSearchInitialActive.removeAt(indexInList);
      _listSearchInitialDisable.insert(0, coinModel.copyWith(isActive: false));
      listSearchInitial = _listSearchInitialActive + _listSearchInitialDisable;
      update([index]);
    } else {
      listSearchResult[index].isActive = true;
      final indexInList = _listSearchInitialDisable.indexWhere((coin) =>
          coin.blockchainId == coinModel.blockchainId &&
          coin.contractAddress == coinModel.contractAddress);
      _listSearchInitialDisable.removeAt(indexInList);
      _listSearchInitialActive.add(coinModel.copyWith(isActive: true));
      listSearchInitial = _listSearchInitialActive + _listSearchInitialDisable;
      update([index]);
    }
  }

  void handleTextActionDoneOnTap() async {
    focusNode.unfocus();
    await status.updateStatus(StateStatus.LOADING);
    for (var blockChain in walletController.blockChains) {
      blockChain.idOfCoinActives = [];
      for (var coin in blockChain.coinsAddLocalDatabase) {
        coin.isActive = false;
      }
      for (var coinModel in _listSearchInitialActive) {
        if (coinModel.blockchainId == blockChain.id) {
          if (coinModel.contractAddress.isNotEmpty) {
            final index = blockChain.coinsAddLocalDatabase
                .indexWhere((coin) => coin.id == coinModel.id);
            if (index != -1) {
              blockChain.coinsAddLocalDatabase[index].isActive = true;
            }
            blockChain.idOfCoinActives.add(coinModel.id);
            final key = coinModel.blockchainId + '+' + coinModel.id;
            final checkInCoinSorts = walletController.wallet.coinSorts
                .indexWhere((element) => element == key);
            if (checkInCoinSorts == -1) {
              walletController.wallet.coinSorts
                  .insert(0, '${coinModel.blockchainId}+${coinModel.id}');
            }
          } else {
            blockChain.idOfCoinActives.add(coinModel.id);
            final key = coinModel.blockchainId + '+' + coinModel.id;
            final checkInCoinSorts = walletController.wallet.coinSorts
                .indexWhere((element) => element == key);
            if (checkInCoinSorts == -1) {
              walletController.wallet.coinSorts
                  .insert(0, '${coinModel.blockchainId}+${coinModel.id}');
            }
          }
        }
      }
    }
    for (var i = 0; i < walletController.wallet.coinSorts.length; i++) {
      final index = _listSearchInitialActive.indexWhere((element) =>
          element.blockchainId + '+' + element.id ==
          walletController.wallet.coinSorts[i]);
      if (index == -1) {
        walletController.wallet.coinSorts.removeAt(i);
      }
    }

    await walletController.updateWallet();
    walletController.updateCoinModel();
    walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
    await status.updateStatus(StateStatus.SUCCESS);
    Get.back();
  }

  void handleIcBackOnTap() {
    Get.back();
  }

  void handleIcBackLocalOnTap() {
    addressController.clear();
    Get.back(id: AppPages.NAVIGATOR_KEY_ADD_TOKEN);
  }

  void handleTextActionNewToken() {
    Get.toNamed(AppRoutes.ADD_TOKEN_INPUT,
        id: AppPages.NAVIGATOR_KEY_ADD_TOKEN);
  }

  void handleBlockChainItemOnTap(BlockChainModel blockChain) {
    if (blockChain.id == BlockChainModel.bitcoin) {
      Get.snackbar('global_failure'.tr, 'network_not_availiable'.tr,
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING,
          colorText: AppColorTheme.error,
          backgroundColor: AppColorTheme.backGround,
          duration: Duration(milliseconds: 1500));
    } else {
      blockChainModelActive = blockChain;
      update([EnumAddToken.BLOCK_CHAIN]);
      Get.back(id: AppPages.NAVIGATOR_KEY_ADD_TOKEN);
    }
  }

  void handleButtonAddOnTap() async {
    try {
      focusNode.unfocus();
      await status.updateStatus(StateStatus.LOADING);
      var contract = '';
      if (addressController.text.substring(0, 2) != '0x') {
        contract = '0x' + addressController.text;
      } else {
        contract = addressController.text;
      }
      coinModelResult = await _repo.addNewToken(
        blockChainId: blockChainModelActive.id,
        addressContract: contract,
      );

      if (coinModelResult.id.isEmpty) {
        coinModelResult = coinModelResult.copyWith(
            id: coinModelResult.name.toLowerCase() +
                blockChainModelActive.id +
                (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString());
      }
      Get.back();
      await Get.dialog(
        AddTokenReviewPage(),
        barrierDismissible: false,
      );
    } catch (exp) {
      await status.updateStatus(StateStatus.FAILURE,
          showSnackbarError: true, desc: 'global_not_found'.tr);
      AppError.handleError(exception: exp);
    }
  }

  void handleButtonAddToMenu() async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      final indexExit = listSearchInitial.indexWhere((element) =>
          coinModelResult.contractAddress.toLowerCase() ==
          element.contractAddress.toLowerCase());
      if (indexExit == -1) {
        _listSearchInitialActive.insert(0, coinModelResult);
        listSearchInitial =
            _listSearchInitialActive + _listSearchInitialDisable;
        listSearchResult.insert(0, coinModelResult);
        final index = walletController.blockChains.indexWhere(
            (blockChain) => blockChain.id == blockChainModelActive.id);
        walletController.blockChains[index].coinsAddLocalDatabase
            .add(coinModelResult.copyWith());
        for (var address in walletController.blockChains[index].addresss) {
          final balance = await _repo.getBalanceOfToken(
              address: address.address, coinModel: coinModelResult);
          address.coins.add(coinModelResult.copyWith(value: balance));
        }
        walletController.blockChains[index].coins
            .add(coinModelResult.copyWith(isActive: true));
        walletController.blockChains[index].idOfCoinActives
            .insert(0, coinModelResult.id);
        walletController.wallet.coinSorts
            .insert(0, coinModelResult.blockchainId + '+' + coinModelResult.id);
        await walletController.updateWallet();
        update([EnumAddToken.SEARCH]);
        await status.updateStatus(StateStatus.SUCCESS);
        Get.back(id: AppPages.NAVIGATOR_KEY_ADD_TOKEN);
      } else {
        await status.updateStatus(StateStatus.FAILURE,
            showDialogError: true,
            desc: 'token_already_exists'.tr,
            title: 'global_failure'.tr);
      }
    } catch (exp) {
      await status.updateStatus(StateStatus.FAILURE,
          showDialogError: true,
          desc: 'add_token_failure'.tr,
          title: 'global_error'.tr);
      AppError.handleError(exception: exp);
    }
  }
}
