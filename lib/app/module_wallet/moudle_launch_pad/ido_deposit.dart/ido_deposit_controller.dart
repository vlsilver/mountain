import 'dart:math';

import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_pendding.dart';
import 'package:base_source/app/data/providers/crypto_provider/binance_provider.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_deposit.dart/ido_deposit_confirm_page.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_project/ido_project_controller.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/launchpad_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/select_address/select_address_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'ido_approve_confirm_page.dart';
import 'ido_deposit_repo.dart';

enum EnumIDODeposit { BUTTON, COIN, ADDRESS_SENDER }

class IDODepositController extends GetxController {
  final List<String> calculatorsStr = ['25%', '50%', '75%', 'use_max'.tr];
  final status = Status();
  final FocusNode focusNode = FocusNode(debugLabel: 'IDO_Deposit');
  final amountController = TextEditingController();
  double amount = 0.0;
  double fee = 0.0;
  String amountString = '0.0';
  bool isApprove = false;
  bool isApproveSuccess = false;
  BigInt amountApproveSuccess = BigInt.from(0);
  final Rx<double> valueCompare = 0.0.obs;
  bool isActiveButton = false;
  late CoinModel coinBase;
  late AddressModel addressModel;

  late final Worker woker;

  final launchPadController = Get.find<LaunchPadController>();
  final idoProjectController = Get.find<IDOProjectController>();
  final _walletController = Get.find<WalletController>();
  final _repo = IDODepositRepository();

  @override
  void onInit() {
    addressModel = _walletController.blockChains
        .firstWhere((element) => element.id == BlockChainModel.binanceSmart)
        .addressAvalible;
    coinBase = addressModel.coins.firstWhere(
        (element) =>
            element.contractAddress ==
            idoProjectController.idoModel.addressBaseToken,
        orElse: () => CoinModel.empty());

    if (coinBase.isToken) {
      isApprove = true;
    }
    amountController.addListener(() {
      final inputValue = double.parse(amountController.text.isEmpty
          ? '0.0'
          : amountController.text.replaceAll(',', '.'));
      valueCompare.value = inputValue;
      amount = inputValue;
      amountString = amountController.text.isEmpty
          ? '0.0'
          : amountController.text.replaceAll(',', '.');
      if (coinBase.stringDoubleToBigInt(amountString) > amountApproveSuccess) {
        isApproveSuccess = false;
        update([EnumIDODeposit.BUTTON]);
      } else {
        isApproveSuccess = true;
        update([EnumIDODeposit.BUTTON]);
      }
      if (inputValue > 0 &&
          coinBase.isValueAvalible(amountString) &&
          !isActiveButton) {
        isActiveButton = true;
        update([EnumIDODeposit.BUTTON]);
      } else if ((inputValue <= 0 || !coinBase.isValueAvalible(amountString)) &&
          isActiveButton) {
        isActiveButton = false;
        update([EnumIDODeposit.BUTTON]);
      } else {
        update([EnumIDODeposit.BUTTON]);
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    amountController.removeListener(() {});
    amountController.dispose();
    super.dispose();
  }

  String get currencyCompare =>
      CoinModel.currentcyFormat(valueCompare.value * coinBase.price);

  void handleTextSetAmountOnTap(String title) async {
    focusNode.unfocus();
    try {
      await status.updateStatus(StateStatus.LOADING);
      if (coinBase.isValueZero) {
        await status.updateStatus(
          StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'error_balance_not_enough'.tr,
        );
        return;
      }
      fee = await _repo.calculatorFee(
        isApprove: isApprove,
        isApproveSuccess: isApproveSuccess,
        amount: coinBase.value,
        adddressOwner: addressModel.address,
        contractBaseToken: coinBase.contractAddress,
        index: idoProjectController.idoModel.index,
      );
      if (!addressModel.coinOfBlockChain.isValueAvalibleForFee) {
        await status.updateStatus(StateStatus.FAILURE,
            showDialogError: true,
            title: 'global_error'.tr,
            desc: 'error_balance_not_enough'.tr);
        return;
      } else {
        var totalAmount = BigInt.from(0);
        if (coinBase.isToken) {
          totalAmount = coinBase.value;
        } else {
          totalAmount = coinBase.value - Crypto().fee;
        }
        var amount = totalAmount;
        switch (title) {
          case '25%':
            amount = BigInt.from(totalAmount / BigInt.from(4));
            break;
          case '50%':
            amount = BigInt.from(totalAmount / BigInt.from(2));
            break;
          case '75%':
            amount = BigInt.from(totalAmount * BigInt.from(3) / BigInt.from(4));
            break;
          default:
            break;
        }
        amountController.text = Crypto.bigIntToStringWithDevide(
                bigIntString: amount.toString(), decimal: coinBase.decimals)
            .replaceAll('.', ',');
      }
      await status.updateStatus(StateStatus.SUCCESS);
    } catch (exp) {
      await status.updateStatus(
        StateStatus.FAILURE,
        showDialogError: true,
        title: 'global_error'.tr,
        desc: exp.toString(),
      );
      AppError.handleError(exception: exp);
    }
  }

  void handleButtonContinueOnTap() async {
    await status.updateStatus(StateStatus.LOADING);
    if (double.parse(amountController.text.replaceAll(',', '.')) <
        pow(10, -coinBase.decimals)) {
      await status.updateStatus(StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'amount_not_format'.tr);
      return;
    }
    try {
      focusNode.unfocus();
      if (isApprove && !isApproveSuccess) {
        amountApproveSuccess = await _repo.getAllowanceBinance(
          addressOwner: addressModel.address,
          addressSender: BinanceSmartProvider.contractLaunchPad,
          addressContract: coinBase.contractAddress,
        );
        if (amountApproveSuccess >=
            coinBase.stringDoubleToBigInt(amountString)) {
          isApproveSuccess = true;
          await status.updateStatus(
            StateStatus.SUCCESS,
            showDialogSuccess: true,
            title: 'success_transaction'.tr,
            desc: 'success_approve_detail'.trParams({
              'symbol': coinBase.symbol,
            }),
          );
          update([EnumIDODeposit.BUTTON]);
          return;
        }
      }
      await _repo.calculatorFee(
        isApprove: isApprove,
        isApproveSuccess: isApproveSuccess,
        amount: coinBase.stringDoubleToBigInt(amountString),
        adddressOwner: addressModel.address,
        contractBaseToken: coinBase.contractAddress,
        index: idoProjectController.idoModel.index,
      );
      if (coinBase.isToken) {
        if (!addressModel.coinOfBlockChain.isValueAvalibleForFee) {
          await status.updateStatus(StateStatus.FAILURE,
              showDialogError: true,
              title: 'global_error'.tr,
              desc: 'error_balance_not_enough'.tr);
          return;
        }
      } else {
        if (!addressModel.coinOfBlockChain
            .isValueAvaliblePlusFee(amountString)) {
          await status.updateStatus(StateStatus.FAILURE,
              showDialogError: true,
              title: 'global_error'.tr,
              desc: 'error_balance_not_enough'.tr);
          return;
        }
      }

      if (!isApprove || isApproveSuccess) {
        await status.updateStatus(StateStatus.SUCCESS);
        await Get.bottomSheet(
            IDODepositConfirmPage(
              height: Get.height * 0.8,
            ),
            isScrollControlled: true);
      } else if (isApprove && !isApproveSuccess) {
        await status.updateStatus(StateStatus.SUCCESS);
        await Get.bottomSheet(
            IDOApproveConfirmPage(
              height: Get.height * 0.8,
            ),
            isScrollControlled: true);
      }
    } catch (exp) {
      await status.updateStatus(
        StateStatus.FAILURE,
        showDialogError: true,
        title: 'global_error'.tr,
        desc: exp.toString(),
      );
      AppError.handleError(exception: exp);
    }
  }

  void handleInputAddressSendOnTap() async {
    final result = await Get.bottomSheet<AddressModel>(
        SelectAddressWidget(
          blockChains: [_walletController.blockChainSupportLaunchPad],
          addressModel: addressModel,
          height: Get.height * 0.8,
        ),
        isScrollControlled: true);
    if (result != null) {
      if (addressModel.address != result.address) {
        addressModel = result;
        coinBase = addressModel.coins.firstWhere(
            (element) =>
                element.contractAddress ==
                idoProjectController.idoModel.addressBaseToken,
            orElse: () => CoinModel.empty());
        isApproveSuccess = false;
        amountApproveSuccess = BigInt.from(0);
        amountController.clear();
        if (coinBase.isToken) {
          isApprove = true;
        } else {
          isApprove = false;
        }
        update([
          EnumIDODeposit.ADDRESS_SENDER,
          EnumIDODeposit.BUTTON,
          EnumIDODeposit.COIN,
        ]);
      }
    }
  }

  void handleButtonApproveOnTap() async {
    try {
      var privateKey = '';
      if (addressModel.privatekey.isNotEmpty) {
        privateKey = addressModel.privatekey;
      } else {
        privateKey = await _repo.getPrivateKey(
            derivationPath: addressModel.derivationPath,
            coinType: addressModel.coinType);
      }
      await status.updateStatus(StateStatus.LOADING);
      await Future.delayed(Duration(milliseconds: 1000));
      // await _repo.createApproveTransactionBinanceSmart(
      //     tokenContract: coinBase.contractAddress,
      //     addressOwner: addressModel.address,
      //     addressSender: BinanceSmartProvider.contractLaunchPad,
      //     privateKey: privateKey,
      //     amount: coinBase.value * BigInt.from(2));
      await status.updateStatus(
        StateStatus.SUCCESS,
        showDialogSuccess: true,
        title: 'success_transaction'.tr,
        desc: 'success_approve_detail'.trParams({
          'symbol': coinBase.symbol,
        }),
      );
      isApproveSuccess = true;
      amountApproveSuccess = coinBase.value * BigInt.from(2);
      update([EnumIDODeposit.BUTTON]);
      try {
        if (Get.isDialogOpen!) {
          Get.back();
        }
      } catch (exp) {}
      try {
        if (Get.isSnackbarOpen!) {
          Get.back();
        }
      } catch (exp) {}
      try {
        if (Get.isBottomSheetOpen!) {
          Get.back();
        }
      } catch (exp) {}
    } catch (exp) {
      await status.updateStatus(
        StateStatus.FAILURE,
        showDialogError: true,
        desc: exp.toString(),
        title: 'global_error'.tr,
      );
      AppError.handleError(exception: exp);
    }
  }

  void handleButtonDepositOnTap() async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      var privateKey = '';
      if (addressModel.privatekey.isNotEmpty) {
        privateKey = addressModel.privatekey;
      } else {
        privateKey = await _repo.getPrivateKey(
            derivationPath: addressModel.derivationPath,
            coinType: addressModel.coinType);
      }
      final transaction = await _repo.createDepositTransactionBinanceSmart(
          addressSender: addressModel.address,
          privateKey: privateKey,
          amount: coinBase.stringDoubleToBigInt(amountString),
          index: BigInt.from(idoProjectController.idoModel.index),
          contractCoinBase: coinBase.contractAddress);
      if (transaction != null) {
        addressModel.transactionPending.insert(0, transaction);
        _walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
        await _repo.saveDataToLocal(
            key: addressModel.keyOfTransactionPending,
            data: TransactionPenddingData(data: addressModel.transactionPending)
                .toJson());
      }
      final coinModelResult = CoinModel.empty().copyWith(
        id: idoProjectController.idoModel.name.toLowerCase() +
            addressModel.blockChainId,
        contractAddress: idoProjectController.idoModel.address,
        symbol: idoProjectController.idoModel.symbol,
        name: idoProjectController.idoModel.name,
        type: 'Token Binance Smart Chain',
        blockchainId: addressModel.blockChainId,
        image: idoProjectController.idoModel.icon,
        decimals: idoProjectController.idoModel.decimal,
        isActive: true,
      );
      final indexExit = addressModel.coins.indexWhere((element) =>
          coinModelResult.contractAddress.toLowerCase() ==
          element.contractAddress.toLowerCase());
      if (indexExit == -1) {
        final index = _walletController.blockChains.indexWhere(
            (blockChain) => blockChain.id == addressModel.blockChainId);
        _walletController.blockChains[index].coinsAddLocalDatabase
            .add(coinModelResult.copyWith());
        _walletController.blockChains[index].coins
            .add(coinModelResult.copyWith());
        _walletController.blockChains[index].idOfCoinActives
            .insert(0, coinModelResult.id);
        _walletController.wallet.coinSorts
            .insert(0, coinModelResult.blockchainId + '+' + coinModelResult.id);
        for (var address in _walletController.blockChains[index].addresss) {
          address.coins.add(coinModelResult.copyWith());
        }
        await _walletController.updateWallet();
        await status.updateStatus(StateStatus.SUCCESS);
      } else {}
      await status.updateStatus(
        StateStatus.SUCCESS,
        showDialogSuccess: true,
        title: 'success_transaction'.tr,
        desc: 'success_deposit_detail'.trParams(
            {'symbolFrom': coinBase.symbol, 'symbolTo': coinBase.symbol}),
      );

      try {
        if (Get.isDialogOpen!) {
          Get.back();
        }
      } catch (exp) {}
      try {
        if (Get.isSnackbarOpen!) {
          Get.back();
        }
      } catch (exp) {}
      try {
        if (Get.isBottomSheetOpen!) {
          Get.back();
        }
      } catch (exp) {}
      Get.back();
    } catch (exp) {
      await status.updateStatus(
        StateStatus.FAILURE,
        showDialogError: true,
        desc: exp.toString(),
        title: 'global_error'.tr,
      );
      AppError.handleError(exception: exp);
    }
  }

  bool get isErrorInput =>
      !coinBase.isValueAvalible(amountString) ||
      (amount < idoProjectController.idoModel.minBuyBaseDouble &&
          amount > 0.0) ||
      amount > idoProjectController.idoModel.maxBuyBaseDouble;
}
