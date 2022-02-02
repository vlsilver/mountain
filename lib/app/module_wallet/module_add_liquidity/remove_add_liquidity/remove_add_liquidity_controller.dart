import 'dart:math';

import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/data/models/local_model/address_add_liquidity_list.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/providers/crypto_provider/binance_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/ethereum_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/kardiachain_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/polygon_provider.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_controller.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/remove_add_liquidity/remove_add_liquidity_approve_page.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/remove_add_liquidity/remove_add_liquidity_confirm_page.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/remove_add_liquidity/remove_add_liquidity_repo.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum EnumRemoveAddLiquidity { BUTTON }

class RemoveAddLiquidityController extends GetxController {
  final List<String> calculatorsStr = ['25%', '50%', '75%', 'use_max'.tr];
  final status = Status();
  late final AddLiquidityModel addLiquidityModel;
  late final AddressModel addressSender;
  final amountController = TextEditingController();
  final FocusNode focusNode =
      FocusNode(debugLabel: AppRoutes.UPDATE_AMOUNT_ADD_LIQUIDITY);
  final _repo = RemoveAddLiquidityRepository();
  bool isActiveButton = false;
  bool isApproveSuccess = false;
  BigInt amountApproveSuccess = BigInt.from(0);
  double fee = 0.0;
  bool isFullScreen = true;
  // final addLiquidityController = Get.find<AddLiquidityController>();
  String amountString = '0.0';

  @override
  void onInit() {
    amountController.addListener(() {
      final inputDouble = double.parse(amountController.text.isEmpty
          ? '0.0'
          : amountController.text.replaceAll(',', '.'));
      amountString = amountController.text.isEmpty
          ? '0.0'
          : amountController.text.replaceAll(',', '.');
      if (!isAvalibleAmountApprove && isApproveSuccess) {
        isApproveSuccess = false;
      } else if (isAvalibleAmountApprove && !isApproveSuccess) {
        isApproveSuccess = true;
      }
      update([EnumRemoveAddLiquidity.BUTTON]);
      if (inputDouble > 0 && !isErrorInputAmount && !isActiveButton) {
        isActiveButton = true;
        update([EnumRemoveAddLiquidity.BUTTON]);
      } else if ((inputDouble <= 0 || isErrorInputAmount) && isActiveButton) {
        isActiveButton = false;
        update([EnumRemoveAddLiquidity.BUTTON]);
      } else {
        update([EnumRemoveAddLiquidity.BUTTON]);
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

  void handleTextSetAmountOnTap(String title) async {
    focusNode.unfocus();
    var totalAmount = addLiquidityModel.tokenLP.value;
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
            bigIntString: amount.toString(),
            decimal: addLiquidityModel.tokenLP.decimals)
        .replaceAll('.', ',');
  }

  void handleButtonContinueOnTap() async {
    await status.updateStatus(StateStatus.LOADING);
    if (double.parse(amountController.text.replaceAll(',', '.')) <
        pow(10, -addLiquidityModel.tokenLP.decimals)) {
      await status.updateStatus(StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'amount_not_format'.tr);
      return;
    }
    try {
      focusNode.unfocus();
      if (!isApproveSuccess) {
        amountApproveSuccess =
            await checkAllowance(coinModel: addLiquidityModel.tokenLP);
        if (isAvalibleAmountApprove) {
          isApproveSuccess = true;
          update([EnumRemoveAddLiquidity.BUTTON]);
          await status.updateStatus(
            StateStatus.SUCCESS,
            showDialogSuccess: true,
            title: 'success_transaction'.tr,
            desc: 'success_approve_detail_addLiquidity'
                .trParams({'symbol': addLiquidityModel.tokenLP.symbol}),
          );
          return;
        } else {
          fee = await calculatorFeeApprove();

          if (addressSender.coinOfBlockChain.isValueAvalibleForFee) {
            await status.updateStatus(StateStatus.SUCCESS);
            await Get.bottomSheet(
                RemoveAddLiquidityApproveConfirmPage(
                  height: Get.height * 0.85,
                ),
                isScrollControlled: true);
          } else {
            await status.updateStatus(StateStatus.FAILURE,
                showDialogError: true,
                title: 'global_error'.tr,
                desc: 'error_balance_not_enough'.tr);
            return;
          }
        }
      } else {
        fee = await calculatorFeeRemoveAddLiquidity(
          tokenA: addLiquidityModel.tokenA.contractAddress,
          tokenB: addLiquidityModel.tokenB.contractAddress,
          amountTokenLP: getAmountBigInt,
          blocChainId: addLiquidityModel.blockChainId,
          addressSender: addressSender.address,
          addrsassRecieve: addressSender.address,
        );
        if (addressSender.coinOfBlockChain.isValueAvalibleForFee) {
          await status.updateStatus(StateStatus.SUCCESS);
          await Get.bottomSheet(
              RemoveAddLiquidityConfirmPage(
                height: Get.height * 0.85,
              ),
              isScrollControlled: true);
        } else {
          await status.updateStatus(StateStatus.FAILURE,
              showDialogError: true,
              title: 'global_error'.tr,
              desc: 'error_balance_not_enough'.tr);
          return;
        }
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

  void handleButtonApproveOnTap() async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      await createApproveTransaction();
      await status.updateStatus(
        StateStatus.SUCCESS,
        showDialogSuccess: true,
        title: 'success_transaction'.tr,
        desc: 'success_approve_detail'.trParams({
          'symbol': addLiquidityModel.tokenLP.symbol,
        }),
      );
      isApproveSuccess = true;
      amountApproveSuccess = addLiquidityModel.tokenLP.value * BigInt.from(2);
      update([EnumRemoveAddLiquidity.BUTTON]);
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

  void handleButtonRemoveOnTap() async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      await removeAddliquidityTransaction(
        tokenA: addLiquidityModel.tokenA.contractAddress,
        tokenB: addLiquidityModel.tokenB.contractAddress,
        amountTokenLP: getAmountBigInt,
        addressSender: addressSender,
        addrsassRecieve: addressSender.address,
      );
      await status.updateStatus(
        StateStatus.SUCCESS,
        showDialogSuccess: true,
        title: 'success_transaction'.tr,
        desc: 'success_remove_add_liquidity_detail'.trParams({
          'symbolLP': addLiquidityModel.tokenLP.symbol,
          'symbolA': addLiquidityModel.tokenA.symbol,
          'symbolB': addLiquidityModel.tokenB.symbol,
        }),
      );

      if (getAmountBigInt == addLiquidityModel.tokenLP.value) {
        addressSender.addLiquidityList!.data.removeWhere((element) =>
            element.addressRecive == addLiquidityModel.addressRecive &&
            element.tokenLP.contractAddress ==
                addLiquidityModel.tokenLP.contractAddress);

        await _repo.saveDataToLocal(
            key: addressSender.keyOfAddLiquidityList,
            data: addressSender.addLiquidityList!.toJson());
        Get.find<AddLiquidityController>()
          ..update([EnumAddLiquidity.LIST_DATA])
          ..handleResetDatList();
      }
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
      Get.back(id: AppPages.NAVIGATOR_KEY_ADD_LIQUIDITY);
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

  void handleIconBackOnTap() async {
    focusNode.unfocus();
    amountController.clear();
    Get.back(id: AppPages.NAVIGATOR_KEY_ADD_LIQUIDITY);
  }

  Future<BigInt> checkAllowance({required CoinModel coinModel}) async {
    switch (addressSender.blockChainId) {
      case BlockChainModel.ethereum:
        return await _repo.getAllowanceEthereum(
            addressOwner: addressSender.address,
            addressSender: EthereumProvider.contractSwapAbi,
            addressContract: coinModel.contractAddress);
      case BlockChainModel.binanceSmart:
        return await _repo.getAllowanceBinance(
            addressOwner: addressSender.address,
            addressSender: BinanceSmartProvider.contractSwapAbi,
            addressContract: coinModel.contractAddress);
      case BlockChainModel.polygon:
        return await _repo.getAllowancePolygon(
            addressOwner: addressSender.address,
            addressSender: PolygonProvider.contractSwapAbi,
            addressContract: coinModel.contractAddress);
      case BlockChainModel.kardiaChain:
        return await _repo.getAllowanceKardiaChain(
            addressOwner: addressSender.address,
            addressSender: KardiaChainProvider.contractSwapAbi,
            addressContract: coinModel.contractAddress);

      default:
        return BigInt.from(0);
    }
  }

  Future<double> calculatorFeeApprove() async {
    switch (addressSender.blockChainId) {
      case BlockChainModel.ethereum:
        return await _repo.calculatorFeeApproveEthereum(
            tokenContract: addLiquidityModel.tokenLP.contractAddress,
            addressOwner: addressSender.address,
            addressSender: EthereumProvider.contractSwapAbi,
            amount: getAmountBigInt);
      case BlockChainModel.binanceSmart:
        return await _repo.calculatorFeeApproveBinanceSmart(
            tokenContract: addLiquidityModel.tokenLP.contractAddress,
            addressOwner: addressSender.address,
            addressSender: BinanceSmartProvider.contractSwapAbi,
            amount: getAmountBigInt);
      case BlockChainModel.polygon:
        return await _repo.calculatorFeeApprovePolygon(
            tokenContract: addLiquidityModel.tokenLP.contractAddress,
            addressOwner: addressSender.address,
            addressSender: PolygonProvider.contractSwapAbi,
            amount: getAmountBigInt);
      case BlockChainModel.kardiaChain:
        return await _repo.calculatorFeeApproveKardiaChain(
            tokenContract: addLiquidityModel.tokenLP.contractAddress,
            addressOwner: addressSender.address,
            addressSender: KardiaChainProvider.contractSwapAbi,
            amount: getAmountBigInt);
      default:
        return 0.0;
    }
  }

  Future<double> calculatorFeeRemoveAddLiquidity({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
    required String blocChainId,
  }) async {
    switch (blocChainId) {
      case BlockChainModel.ethereum:
        final fee = await _repo.calculatorFeeRemoveAddLiquidityEthereum(
            tokenA: tokenA,
            tokenB: tokenB,
            addressSender: addressSender,
            addrsassRecieve: addrsassRecieve,
            amountTokenLP: amountTokenLP);
        return fee;
      case BlockChainModel.binanceSmart:
        final fee = await _repo.calculatorFeeRemoveAddLiquidityBinance(
            tokenA: tokenA,
            tokenB: tokenB,
            addressSender: addressSender,
            addrsassRecieve: addrsassRecieve,
            amountTokenLP: amountTokenLP);
        return fee;
      case BlockChainModel.polygon:
        final fee = await _repo.calculatorFeeRemoveAddLiquidityPolygon(
            tokenA: tokenA,
            tokenB: tokenB,
            addressSender: addressSender,
            addrsassRecieve: addrsassRecieve,
            amountTokenLP: amountTokenLP);
        return fee;
      case BlockChainModel.kardiaChain:
        final fee = await _repo.calculatorFeeRemoveAddLiquidityKardiaChain(
            tokenA: tokenA,
            tokenB: tokenB,
            addressSender: addressSender,
            addrsassRecieve: addrsassRecieve,
            amountTokenLP: amountTokenLP);
        return fee;
      default:
        return 0.0;
    }
  }

  Future<void> createApproveTransaction() async {
    var privateKey = '';
    if (addressSender.privatekey.isNotEmpty) {
      privateKey = addressSender.privatekey;
    } else {
      privateKey = await _repo.getPrivateKey(
          derivationPath: addressSender.derivationPath,
          coinType: addressSender.coinType);
    }
    switch (addressSender.blockChainId) {
      case BlockChainModel.ethereum:
        await _repo.createApproveTransactionEthereum(
            tokenContract: addLiquidityModel.tokenLP.contractAddress,
            addressOwner: addressSender.address,
            addressSender: EthereumProvider.contractSwapAbi,
            privateKey: privateKey,
            amount: addLiquidityModel.tokenLP.value * BigInt.from(2));
        break;
      case BlockChainModel.binanceSmart:
        await _repo.createApproveTransactionBinanceSmart(
            tokenContract: addLiquidityModel.tokenLP.contractAddress,
            addressOwner: addressSender.address,
            addressSender: BinanceSmartProvider.contractSwapAbi,
            privateKey: privateKey,
            amount: addLiquidityModel.tokenLP.value * BigInt.from(2));
        break;
      case BlockChainModel.polygon:
        await _repo.createApproveTransactionPolygon(
            tokenContract: addLiquidityModel.tokenLP.contractAddress,
            addressOwner: addressSender.address,
            addressSender: PolygonProvider.contractSwapAbi,
            privateKey: privateKey,
            amount: addLiquidityModel.tokenLP.value * BigInt.from(2));
        break;
      case BlockChainModel.kardiaChain:
        await _repo.createApproveTransactionKardiaChain(
            tokenContract: addLiquidityModel.tokenLP.contractAddress,
            addressOwner: addressSender.address,
            addressSender: KardiaChainProvider.contractSwapAbi,
            privateKey: privateKey,
            amount: addLiquidityModel.tokenLP.value * BigInt.from(2));
        break;
      default:
        break;
    }
  }

  Future<void> removeAddliquidityTransaction({
    required String tokenA,
    required String tokenB,
    required AddressModel addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
  }) async {
    var privateKey = '';
    if (addressSender.privatekey.isNotEmpty) {
      privateKey = addressSender.privatekey;
    } else {
      privateKey = await _repo.getPrivateKey(
          derivationPath: addressSender.derivationPath,
          coinType: addressSender.coinType);
    }
    switch (addressSender.blockChainId) {
      case BlockChainModel.ethereum:
        await _repo.createRemoveAddLiquidityTransactionEthereum(
            tokenA: tokenA,
            tokenB: tokenB,
            addressSender: addressSender.address,
            addrsassRecieve: addrsassRecieve,
            privateKey: privateKey,
            amountTokenLP: amountTokenLP);
        break;
      case BlockChainModel.binanceSmart:
        await _repo.createRemoveAddLiquidityTransactionBinance(
            tokenA: tokenA,
            tokenB: tokenB,
            addressSender: addressSender.address,
            addrsassRecieve: addrsassRecieve,
            privateKey: privateKey,
            amountTokenLP: amountTokenLP);
        break;
      case BlockChainModel.polygon:
        await _repo.createRemoveAddLiquidityTransactionPolygon(
            tokenA: tokenA,
            tokenB: tokenB,
            addressSender: addressSender.address,
            addrsassRecieve: addrsassRecieve,
            privateKey: privateKey,
            amountTokenLP: amountTokenLP);
        break;
      case BlockChainModel.kardiaChain:
        await _repo.createRemoveAddLiquidityTransactionKardiaChain(
            tokenA: tokenA,
            tokenB: tokenB,
            addressSender: addressSender.address,
            addrsassRecieve: addrsassRecieve,
            privateKey: privateKey,
            amountTokenLP: amountTokenLP);
        break;
      default:
        break;
    }
  }

  String getNameAddressRouter() {
    switch (addressSender.blockChainId) {
      case BlockChainModel.ethereum:
        return AppFormat.formatRoundBrackets(
            value: AppFormat.addressString(EthereumProvider.contractSwapAbi));
      case BlockChainModel.binanceSmart:
        return AppFormat.formatRoundBrackets(
            value:
                AppFormat.addressString(BinanceSmartProvider.contractSwapAbi));
      case BlockChainModel.polygon:
        return AppFormat.formatRoundBrackets(
            value: AppFormat.addressString(PolygonProvider.contractSwapAbi));
      case BlockChainModel.kardiaChain:
        return AppFormat.formatRoundBrackets(
            value:
                AppFormat.addressString(KardiaChainProvider.contractSwapAbi));
      default:
        return '';
    }
  }

  double get amountDouble =>
      double.parse(amountController.text.replaceAll(',', '.'));

  BigInt get getAmountBigInt => Crypto.parseStringToBigIntMultiply(
      valueString: amountString, decimal: addLiquidityModel.tokenLP.decimals);

  bool get isAvalibleAmountApprove => (amountApproveSuccess >= getAmountBigInt);

  bool get isErrorInputAmount =>
      !addLiquidityModel.tokenLP.isValueAvalible(amountString);
}
