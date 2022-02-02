import 'dart:io';

import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/module_home/home_controller.dart';
import 'package:base_source/app/module_wallet/module_create_token/create_token_repository.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/select_address/select_address_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';

import 'widget/information_token_widget.dart';

enum EnumUpdateCreateToken {
  BUTTON,
  AVATAR,
  TOKEN_NAME,
  SYMBOL,
  TOTAL,
  CREATOR,
  NETWORK,
}

class CreateTokenController extends GetxController {
  final FocusNode focusNode = FocusNode();
  final _status = Status();

  final List<String> calculatorsStr = [
    '1000,000',
    '10,000,000',
    '100,000,000',
    '1000,000,000',
  ];

  bool isActiveButton = false;
  String name = '';
  String symbol = '';
  final total = ''.obs;
  AddressModel? addressModelActiveInitial;
  late BlockChainModel blockChainModelActive;

  final totalController = TextEditingController();
  final _repo = CreateTokenRepository();
  final walletController = Get.find<WalletController>();
  final homeController = Get.find<HomeController>();
  double fee = 0.0;

  String? errorName;
  String? errorSymbol;
  String? errorTotal;

  File? file;

  late final Worker _woker;

  AddressModel get addressModelActive =>
      addressModelActiveInitial ??
      blockChainModelActive.addresss.firstWhere(
          (address) => address.coinOfBlockChain.value > BigInt.from(0),
          orElse: () => blockChainModelActive.addressModelActive);

  @override
  void onInit() {
    blockChainModelActive = walletController.blockChains.firstWhere(
        (blockChain) => blockChain.id == BlockChainModel.binanceSmart);

    totalController.addListener(() {
      total.value = totalController.text.replaceAll(',', '');
      errorTotal = Validators.validateAmount(total.value);
      if (errorSymbol == null &&
          symbol.isNotEmpty &&
          errorName == null &&
          name.isNotEmpty &&
          errorTotal == null &&
          total.value != '0' &&
          file != null &&
          !isActiveButton) {
        isActiveButton = true;
        update([
          EnumUpdateCreateToken.BUTTON,
        ]);
      } else if (errorTotal != null ||
          total.value == '0' ||
          total.value.isEmpty && isActiveButton) {
        isActiveButton = false;
        update([
          EnumUpdateCreateToken.BUTTON,
        ]);
      }
      update([
        EnumUpdateCreateToken.TOTAL,
      ]);
    });
    _woker = debounce(total, (value) {
      if (errorTotal == null) {
        var len = total.value.length;
        var num = (len / 3 + 0.4).round();
        if (num > 1) {
          var string = total.value;
          var list = <String>[];
          for (var i = 1; i <= num; i++) {
            var str = '';
            if (i == num) {
              str = string.substring(0, len - (i - 1) * 3);
            } else {
              str = string.substring(len - i * 3, len - (i - 1) * 3);
            }
            list.insert(0, str);
          }
          totalController.text = list.join(',');
          totalController.selection = TextSelection.fromPosition(
              TextPosition(offset: totalController.text.length));
        } else {
          totalController.text = total.value;
          totalController.selection = TextSelection.fromPosition(
              TextPosition(offset: totalController.text.length));
        }
      }
    }, time: const Duration(milliseconds: 500));

    super.onInit();
  }

  @override
  void onClose() {
    _woker.dispose();
    totalController.removeListener(() {});
    super.onClose();
  }

  String feeCurrency() {
    return TransactionData.feeFormatWithSymbolByData(
            fees: fee, blockChainId: blockChainModelActive.id) +
        ' - ' +
        CoinModel.currentcyFormat(
            TransactionData.feePrice(blockChainModelActive.id) * fee);
  }

  void handleInputNameOnChange(String value) {
    name = value;
    errorName = Validators.validateNameAddress(name);
    if (errorSymbol == null &&
        symbol.isNotEmpty &&
        errorName == null &&
        name.isNotEmpty &&
        errorTotal == null &&
        total.value != '0' &&
        file != null &&
        !isActiveButton) {
      isActiveButton = true;
      update([EnumUpdateCreateToken.BUTTON]);
    } else if (errorName != null && isActiveButton) {
      isActiveButton = false;
      update([EnumUpdateCreateToken.BUTTON]);
    }
    update([EnumUpdateCreateToken.TOKEN_NAME]);
  }

  void handleInputSymbolOnChange(String value) {
    symbol = value;
    errorSymbol = Validators.validateSymbol(symbol);
    if (errorSymbol == null &&
        symbol.isNotEmpty &&
        errorName == null &&
        name.isNotEmpty &&
        errorTotal == null &&
        total.value != '0' &&
        file != null &&
        !isActiveButton) {
      isActiveButton = true;
      update([EnumUpdateCreateToken.BUTTON]);
    } else if (errorSymbol != null && isActiveButton) {
      isActiveButton = false;
      update([EnumUpdateCreateToken.BUTTON]);
    }
    update([EnumUpdateCreateToken.SYMBOL]);
  }

  void handleCalculatorFeeCreateToken() async {
    try {
      focusNode.unfocus();
      await _status.updateStatus(StateStatus.LOADING);
      fee = await _repo.calculatorFeeToCreateToken(
        name: name,
        symbol: symbol,
        totalSuply: BigInt.parse(totalController.text.replaceAll(',', '')),
        addressModel: addressModelActive,
      );
      await _status.updateStatus(StateStatus.SUCCESS);
      await Get.bottomSheet(const CompleteCreateTokenPage(),
          isScrollControlled: true);
    } catch (exp) {
      await _status.updateStatus(StateStatus.FAILURE,
          showSnackbarError: true, desc: 'calculator_fee_failure'.tr);
      AppError.handleError(exception: exp);
    }
  }

  void handleButtonOnTap() async {
    try {
      await _status.updateStatus(StateStatus.LOADING);
      if (addressModelActive.coinOfBlockChain.value < Crypto().fee) {
        await _status.updateStatus(
          StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'error_balance_not_enough'.tr,
        );
      } else {
        final tokenAddress = await _repo.callCreateToken(
          name: name,
          symbol: symbol,
          totalSuply: BigInt.parse(totalController.text.replaceAll(',', '')),
          addressModel: addressModelActive,
        );
        final indexOfToken = addressModelActive.coins.indexWhere((element) =>
            element.contractAddress.toLowerCase() ==
            tokenAddress.toLowerCase());
        if (indexOfToken != -1) {
          await _status.updateStatus(StateStatus.FAILURE,
              showDialogError: true,
              title: 'global_error'.tr,
              desc: 'failure_create_token_exited'.tr);
          Status.hideSnackBarDialogBottomsheet();
          return;
        }

        await _repo.createNewToken(
          name: name,
          symbol: symbol,
          addressModel: addressModelActive,
          gasLimit: Crypto().gasLimit,
          gasPrice: Crypto().gasPrice,
          totalSuply: BigInt.parse(totalController.text.replaceAll(',', '')),
        );
        var coinModelResult = CoinModel(
            id: name.toLowerCase() +
                blockChainModelActive.id +
                (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
            symbol: symbol,
            name: name,
            decimals: 18,
            blockchainId: blockChainModelActive.id,
            contractAddress: tokenAddress,
            type: blockChainModelActive.id == BlockChainModel.binanceSmart
                ? 'TOKEN Binance Smart Chain'
                : 'TOKEN KardiaChain',
            image: '',
            isActive: true,
            value: BigInt.from(0));
        final index = walletController.blockChains.indexWhere(
            (blockChain) => blockChain.id == addressModelActive.blockChainId);
        try {
          final imageLink = await _repo.createTokenMoonApi(
              coinModel: coinModelResult,
              file: file!,
              addressCreator: addressModelActive.address);
          coinModelResult = coinModelResult.copyWith(image: imageLink);
        } catch (exp) {
          final basePath = await getApplicationDocumentsDirectory();
          final imageType = file!.path.split('.')[1];
          final newPath =
              '${basePath.path}/${coinModelResult.symbol}-${DateTime.now().microsecondsSinceEpoch.toString()}.$imageType';
          await file!.copy(newPath);
          coinModelResult = coinModelResult.copyWith(image: newPath);
          walletController.blockChains[index].coinsAddLocalDatabase
              .add(coinModelResult);
        }
        walletController.blockChains[index].idOfCoinActives
            .insert(0, coinModelResult.id);
        walletController.wallet.coinSorts
            .insert(0, coinModelResult.blockchainId + '+' + coinModelResult.id);
        walletController.blockChains[index].coins.add(coinModelResult);
        await for (var address in Stream.fromIterable(
            walletController.blockChains[index].addresss)) {
          if (address.address.toLowerCase() ==
              addressModelActive.address.toLowerCase()) {
            final balance = await _repo.getBalanceToken(
              coin: coinModelResult,
              address: address.address,
              blockChainId: addressModelActive.blockChainId,
            );
            address.coins.add(coinModelResult.copyWith(value: balance));
          } else {
            address.coins.add(coinModelResult.copyWith());
          }
        }
        await walletController.updateWallet();
        walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
        await _status.updateStatus(
          StateStatus.SUCCESS,
          showDialogSuccess: true,
          title: 'success_create_token'.tr,
          desc: 'success_create_token_detail'.tr,
        );
        Status.hideSnackBarDialogBottomsheet();
        Status.hideSnackBarDialogBottomsheet();
      }
    } catch (exp) {
      await _status.updateStatus(StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: exp.toString());
      AppError.handleError(exception: exp);
      Status.hideSnackBarDialogBottomsheet();
    }
  }

  void handleScreenOnTap() {
    focusNode.unfocus();
  }

  void handleAvatarOnTap() async {
    try {
      focusNode.unfocus();
      await _status.updateStatus(StateStatus.LOADING);
      var _filePicker = await FilePicker.platform
          .pickFiles(type: FileType.image, withData: true);
      if (_filePicker != null) {
        file = File(_filePicker.files.single.path!);
        if (symbol.isNotEmpty &&
            name.isNotEmpty &&
            total.value.isNotEmpty & !isActiveButton) {
          isActiveButton = true;
          update([EnumUpdateCreateToken.BUTTON]);
        }
        await _status.updateStatus(StateStatus.SUCCESS);
        update([EnumUpdateCreateToken.AVATAR]);
      } else {
        await _status.updateStatus(StateStatus.FAILURE, showDialogError: false);
      }
    } catch (exp) {
      await _status.updateStatus(StateStatus.FAILURE,
          desc: AppError.handleError(exception: exp));
    }
  }

  void handleInputAddressSendOnTap() async {
    final result = await Get.bottomSheet<AddressModel>(
        SelectAddressWidget(
          blockChains: walletController.blockChainSupportCreateToken,
          addressModel: addressModelActive,
          height: Get.height * 0.8,
        ),
        isScrollControlled: true);
    if (result != null) {
      if (addressModelActive.address != result.address ||
          addressModelActive.blockChainId != result.blockChainId) {
        if (addressModelActive.blockChainId != result.blockChainId) {
          blockChainModelActive = walletController.blockChains
              .firstWhere((element) => element.id == result.blockChainId);
          update([EnumUpdateCreateToken.NETWORK]);
        }
        addressModelActiveInitial = result;
        update([EnumUpdateCreateToken.CREATOR]);
      }
    }
  }

  void handleTextSetTotalOnTap(String total) {
    totalController.text = total.replaceAll(',', '');
  }
}
