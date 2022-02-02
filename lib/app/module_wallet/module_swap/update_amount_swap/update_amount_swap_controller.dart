import 'dart:math';

import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_approve_confirm/swap_approve_confirm_controller.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_approve_confirm/swap_approve_confirm_page.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_confirm/swap_confirm_controller.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_confirm/swap_confirm_page.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_controller.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:base_source/app/widget_global/select_coin_of_address/select_coin_of_address_controller.dart';
import 'package:base_source/app/widget_global/select_coin_of_address/select_coin_of_address_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum EnumUpdateInputAmountSwap { BUTTON }

class UpdateAmountSwapController extends GetxController {
  final List<String> calculatorsStr = ['25%', '50%', '75%', 'use_max'.tr];
  final status = Status();
  final amountInController = TextEditingController();
  final amountOutController = TextEditingController();
  bool isEditAmountIn = true;
  bool isEditAmountOut = false;
  bool isFullScreen = true;
  final FocusNode focusNode =
      FocusNode(debugLabel: AppRoutes.UPDATE_AMOUNT_SWAP);
  final Rx<double> valueCompareIn = 0.0.obs;
  final Rx<double> valueCompareOut = 0.0.obs;
  bool isActiveButton = false;
  bool isApprove = false;
  bool isApproveSuccess = false;
  BigInt amountApproveSuccess = BigInt.from(0);
  String idOfCoinApprroveSucess = '';

  late final Worker woker;
  final swapController = Get.find<SwapController>();

  @override
  void onInit() {
    if (swapController.coinModelFrom.isToken) {
      isApprove = true;
    }
    amountInController.addListener(() {
      final inputValue = double.parse(amountInController.text.isEmpty
          ? '0.0'
          : amountInController.text.replaceAll(',', '.'));
      swapController.amountStringIn = amountInController.text.isEmpty
          ? '0.0'
          : amountInController.text.replaceAll(',', '.');
      valueCompareIn.value = inputValue;
      swapController.amountIn = inputValue;
      if (!isEditAmountOut) {
        amountOutController.text =
            (inputValue * swapController.rate).toString();
      }
      if (swapController.coinModelFrom.id == idOfCoinApprroveSucess) {
        if (swapController.getBigIntAmountCoinFrom > amountApproveSuccess) {
          isApproveSuccess = false;
        } else {
          isApproveSuccess = true;
        }
        update([EnumUpdateInputAmountSwap.BUTTON]);
      }
      if (inputValue > 0 && !isErrorInputAmount && !isActiveButton) {
        isActiveButton = true;
        update([EnumUpdateInputAmountSwap.BUTTON]);
      } else if ((inputValue <= 0 || isErrorInputAmount) && isActiveButton) {
        isActiveButton = false;
        update([EnumUpdateInputAmountSwap.BUTTON]);
      } else {
        update([EnumUpdateInputAmountSwap.BUTTON]);
      }
    });

    amountOutController.addListener(() {
      final outPutValue = double.parse(amountOutController.text.isEmpty
          ? '0.0'
          : amountOutController.text.replaceAll(',', '.'));
      valueCompareOut.value = outPutValue;
      if (!isEditAmountIn) {
        if (swapController.rate == 0.0) {
          amountInController.text = '0.0';
        } else {
          amountInController.text =
              (outPutValue / swapController.rate).toString();
        }
      }
      if (swapController.coinModelFrom.id == idOfCoinApprroveSucess) {
        if (swapController.getBigIntAmountCoinFrom > amountApproveSuccess) {
          isApproveSuccess = false;
        } else {
          isApproveSuccess = true;
        }
        update([EnumUpdateInputAmountSwap.BUTTON]);
      }
      if (outPutValue > 0 &&
          swapController.amountIn > 0 &&
          !isErrorInputAmount &&
          !isActiveButton) {
        isActiveButton = true;
        update([EnumUpdateInputAmountSwap.BUTTON]);
      } else if ((outPutValue <= 0 ||
              isErrorInputAmount ||
              swapController.amountIn <= 0) &&
          isActiveButton) {
        isActiveButton = false;
        update([EnumUpdateInputAmountSwap.BUTTON]);
      } else {
        update([EnumUpdateInputAmountSwap.BUTTON]);
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    handleGetAutoAmountsOut();
    super.onReady();
  }

  @override
  void dispose() {
    amountInController.removeListener(() {});
    amountInController.dispose();
    amountOutController.removeListener(() {});
    amountOutController.dispose();
    super.dispose();
  }

  Future<void> handleGetAutoAmountsOut() async {
    while (swapController.isAutoGetAmount) {
      await swapController.getRateCoinSwap();
      if (isEditAmountIn) {
        amountOutController.text =
            (valueCompareIn.value * swapController.rate).toString();
      } else {
        final outPutValue = double.parse(amountOutController.text.isEmpty
            ? '0.0'
            : amountOutController.text.replaceAll(',', '.'));
        if (swapController.rate == 0.0) {
          amountInController.text = '0.0';
        } else {
          amountInController.text =
              (outPutValue / swapController.rate).toString();
        }
      }
      swapController.update([EnumSwap.RATE]);
    }
  }

  String get currencyFromCompare => CoinModel.currentcyFormat(
      valueCompareIn.value * swapController.coinModelFrom.price);

  String get currencyToCompare => CoinModel.currentcyFormat(
      valueCompareOut * swapController.coinModelTo.price);

  void handleTextSetAmountOnTap(String title) async {
    focusNode.unfocus();
    try {
      await status.updateStatus(StateStatus.LOADING);
      if (swapController.addressSender.coinOfBlockChain.isValueZero) {
        await status.updateStatus(
          StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'error_balance_not_enough'.tr,
        );
        return;
      }
      if (swapController.isErroRate) {
        await status.updateStatus(
          StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'coin_pair_failure'.tr,
        );
        return;
      }
      await swapController.calculatorFee(
          isApprove: isApprove,
          isApproveSuccess: isApproveSuccess,
          isCalculator: true);
      if (!swapController
          .addressSender.coinOfBlockChain.isValueAvalibleForFee) {
        await status.updateStatus(StateStatus.FAILURE,
            showDialogError: true,
            title: 'global_error'.tr,
            desc: 'error_balance_not_enough'.tr);
        return;
      } else {
        var totalAmount = BigInt.from(0);
        if (swapController.coinModelFrom.isToken) {
          totalAmount = swapController.coinModelFrom.value;
        } else {
          totalAmount = swapController.coinModelFrom.value - Crypto().fee;
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
        isEditAmountIn = true;
        isEditAmountOut = false;
        amountInController.text = Crypto.bigIntToStringWithDevide(
                bigIntString: amount.toString(),
                decimal: swapController.coinModelFrom.decimals)
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

    if (double.parse(amountInController.text.replaceAll(',', '.')) <
            pow(10, -swapController.coinModelFrom.decimals) ||
        double.parse(amountOutController.text.replaceAll(',', '.')) <
            pow(10, -swapController.coinModelTo.decimals)) {
      await status.updateStatus(StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'amount_not_format'.tr);
      return;
    }
    try {
      focusNode.unfocus();
      if (swapController.isErroRate) {
        await status.updateStatus(
          StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'coin_pair_failure'.tr,
        );
        return;
      }
      if (isApprove && !isApproveSuccess) {
        amountApproveSuccess = await swapController.checkAllowance();
        idOfCoinApprroveSucess = swapController.coinModelFrom.id;
        if (amountApproveSuccess >= swapController.getBigIntAmountCoinFrom) {
          isApproveSuccess = true;
          await status.updateStatus(
            StateStatus.SUCCESS,
            showDialogSuccess: true,
            title: 'success_transaction'.tr,
            desc: 'success_approve_detail'.trParams({
              'symbol': swapController.coinModelFrom.symbol,
            }),
          );
          update([EnumUpdateInputAmountSwap.BUTTON]);
          return;
        }
      }
      await swapController.calculatorFee(
          isApprove: isApprove,
          isApproveSuccess: isApproveSuccess,
          isCalculator: false);
      if (swapController.coinModelFrom.isToken) {
        if (!swapController
            .addressSender.coinOfBlockChain.isValueAvalibleForFee) {
          await status.updateStatus(StateStatus.FAILURE,
              showDialogError: true,
              title: 'global_error'.tr,
              desc: 'error_balance_not_enough'.tr);
          return;
        }
      } else {
        if (!swapController.addressSender.coinOfBlockChain
            .isValueAvaliblePlusFee(swapController.amountStringIn)) {
          await status.updateStatus(StateStatus.FAILURE,
              showDialogError: true,
              title: 'global_error'.tr,
              desc: 'error_balance_not_enough'.tr);
          return;
        }
      }

      if (!isApprove || isApproveSuccess) {
        await status.updateStatus(StateStatus.SUCCESS);
        Get.put(SwapConfirmController()).isFullScreen = isFullScreen;
        await Get.bottomSheet(
            SwapConfirmPage(
              height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
            ),
            isScrollControlled: true);
        await Get.delete<SwapConfirmController>();
      } else if (isApprove && !isApproveSuccess) {
        await status.updateStatus(StateStatus.SUCCESS);
        Get.put(SwapApproveConfirmController());
        await Get.bottomSheet(
            SwapApproveConfirmPage(
              height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
            ),
            isScrollControlled: true);
        await Get.delete<SwapApproveConfirmController>();
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

  void handleCoinBoxOnTap(bool isFrom) async {
    focusNode.unfocus();
    Get.put(SelectCoinOfAddressController());
    final coinResult = await Get.bottomSheet(
        SelectCoinOfAddressPage(
          addressModel: swapController.addressSender,
          height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
        ),
        isScrollControlled: true);
    await Get.delete<SelectCoinOfAddressController>();
    var isResetData = false;
    if (coinResult != null) {
      if (swapController.coinModelFrom.id != coinResult.id && isFrom) {
        swapController.coinModelFrom = coinResult;
        amountInController.clear();
        isResetData = true;
      }
      if (swapController.coinModelTo.id != coinResult.id && !isFrom) {
        swapController.coinModelTo = coinResult;
        amountOutController.clear();
        isResetData = true;
      }
      if (isResetData) {
        if (swapController.coinModelFrom.isToken && !isApprove) {
          isApprove = true;
        } else if (!swapController.coinModelFrom.isToken && isApprove) {
          isApprove = false;
        }
        if (swapController.coinModelFrom.id != idOfCoinApprroveSucess) {
          isApproveSuccess = false;
        } else {
          isApproveSuccess = true;
        }
        swapController.update([EnumSwap.RATE]);
        update([
          EnumUpdateInputAmountSwap.BUTTON,
        ]);
      }
    }
  }

  void handleChangePositionCoinModel() async {
    focusNode.unfocus();
    final idOldCoinFrom = swapController.coinModelFrom.id;
    final idOldCoinTo = swapController.coinModelTo.id;
    if (idOldCoinFrom.isNotEmpty || idOldCoinTo.isNotEmpty) {
      if (idOldCoinFrom.isEmpty) {
        swapController.coinModelTo = CoinModel.empty();
      } else {
        swapController.coinModelTo = swapController.addressSender.coins
            .firstWhere((element) => element.id == idOldCoinFrom,
                orElse: () => CoinModel.empty());
      }
      if (idOldCoinTo.isEmpty) {
        swapController.coinModelFrom = CoinModel.empty();
      } else {
        swapController.coinModelFrom = swapController.addressSender.coins
            .firstWhere((element) => element.id == idOldCoinTo,
                orElse: () => CoinModel.empty());
      }
      if (isEditAmountIn) {
        isEditAmountIn = false;
        isEditAmountOut = true;
        amountOutController.text = amountInController.text;
      } else {
        isEditAmountIn = true;
        isEditAmountOut = false;
        amountInController.text = amountOutController.text;
      }
      update([EnumUpdateInputAmountSwap.BUTTON]);
      swapController.update([EnumSwap.RATE]);
    }
  }

  void handleIconBackOnTap() async {
    focusNode.unfocus();
    amountInController.clear();
    amountOutController.clear();
    swapController.handleResetData();
    Get.back(id: AppPages.NAVIGATOR_KEY_SWAP);
  }

  bool get isErrorInputAmount => !swapController.isAvalibleValueInput;
}
