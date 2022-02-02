import 'dart:math';

import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_approve_confirm/add_liquidity_approve_confirm_controller.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_approve_confirm/add_liquidity_approve_confirm_page.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_confirm/add_liquidity_confirm_controller.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_confirm/add_liquidity_confirm_page.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_controller.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:base_source/app/widget_global/select_coin_of_address/select_coin_of_address_controller.dart';
import 'package:base_source/app/widget_global/select_coin_of_address/select_coin_of_address_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum EnumUpdateInputAmountAddLiquidity { BUTTON }

class UpdateAmountAddLiquidityController extends GetxController {
  final List<String> calculatorsStr = ['25%', '50%', '75%', 'use_max'.tr];
  final status = Status();
  final amountInAController = TextEditingController();
  final amountInBController = TextEditingController();
  bool isEditAmountA = true;
  bool isEditAmountB = false;
  bool isFullScreen = true;
  final FocusNode focusNode =
      FocusNode(debugLabel: AppRoutes.UPDATE_AMOUNT_ADD_LIQUIDITY);
  final Rx<double> valueCompareA = 0.0.obs;
  final Rx<double> valueCompareB = 0.0.obs;
  bool isActiveButton = false;
  bool isApprove = false;
  bool isApproveSuccess = false;
  BigInt amountAApproveSuccess = BigInt.from(0);
  BigInt amountBApproveSuccess = BigInt.from(0);
  String idOfCoinApprroveSucessA = '';
  String idOfCoinApprroveSucessB = '';

  late final Worker woker;
  final addLiquidityController = Get.find<AddLiquidityController>();

  @override
  void onInit() {
    if (addLiquidityController.coinModelA.contractAddress.isNotEmpty ||
        addLiquidityController.coinModelB.contractAddress.isNotEmpty) {
      isApprove = true;
    }
    amountInAController.addListener(() {
      final inputDoubleA = double.parse(amountInAController.text.isEmpty
          ? '0.0'
          : amountInAController.text.replaceAll(',', '.'));
      addLiquidityController.amountStringInA = amountInAController.text.isEmpty
          ? '0.0'
          : amountInAController.text.replaceAll(',', '.');
      valueCompareA.value = inputDoubleA;
      addLiquidityController.amountDoubleA = inputDoubleA;

      if (!isEditAmountB) {
        amountInBController.text =
            (inputDoubleA * addLiquidityController.rate).toString();
      }
      if ((!isApproveSuccessA || !isApproveSuccessB) && isApproveSuccess) {
        isApproveSuccess = false;
      } else if (isApproveSuccessA && isApproveSuccessB && !isApproveSuccess) {
        isApproveSuccess = true;
      }
      update([EnumUpdateInputAmountAddLiquidity.BUTTON]);
      if (inputDoubleA > 0 &&
          !isErrorInputAAmount &&
          !isErrorInputBAmount &&
          !isActiveButton &&
          addLiquidityController.amountDoubleB > 0) {
        isActiveButton = true;
        update([EnumUpdateInputAmountAddLiquidity.BUTTON]);
      } else if ((inputDoubleA <= 0 ||
              addLiquidityController.amountDoubleB <= 0 ||
              isErrorInputBAmount ||
              isErrorInputAAmount) &&
          isActiveButton) {
        isActiveButton = false;
        update([EnumUpdateInputAmountAddLiquidity.BUTTON]);
      } else {
        update([EnumUpdateInputAmountAddLiquidity.BUTTON]);
      }
    });

    amountInBController.addListener(() {
      final inputDoubleB = double.parse(amountInBController.text.isEmpty
          ? '0.0'
          : amountInBController.text.replaceAll(',', '.'));
      addLiquidityController.amountStringInB = amountInBController.text.isEmpty
          ? '0.0'
          : amountInBController.text.replaceAll(',', '.');
      addLiquidityController.amountDoubleB = inputDoubleB;
      valueCompareB.value = inputDoubleB;
      if (!isEditAmountA) {
        if (addLiquidityController.rate == 0.0) {
          amountInAController.text = '0.0';
        } else {
          amountInAController.text =
              (inputDoubleB / addLiquidityController.rate).toString();
        }
      }
      if ((!isApproveSuccessA || !isApproveSuccessB) && isApproveSuccess) {
        isApproveSuccess = false;
      } else if (isApproveSuccessA && isApproveSuccessB && !isApproveSuccess) {
        isApproveSuccess = true;
      }
      update([EnumUpdateInputAmountAddLiquidity.BUTTON]);
      if (inputDoubleB > 0 &&
          !isErrorInputAAmount &&
          !isErrorInputBAmount &&
          !isActiveButton &&
          addLiquidityController.amountDoubleA > 0) {
        isActiveButton = true;
        update([EnumUpdateInputAmountAddLiquidity.BUTTON]);
      } else if ((inputDoubleB <= 0 ||
              addLiquidityController.amountDoubleA <= 0 ||
              isErrorInputBAmount ||
              isErrorInputAAmount) &&
          isActiveButton) {
        isActiveButton = false;
        update([EnumUpdateInputAmountAddLiquidity.BUTTON]);
      } else {
        update([EnumUpdateInputAmountAddLiquidity.BUTTON]);
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
    amountInAController.removeListener(() {});
    amountInAController.dispose();
    amountInBController.removeListener(() {});
    amountInBController.dispose();
    super.dispose();
  }

  Future<void> handleGetAutoAmountsOut() async {
    while (addLiquidityController.isAutoGetAmount) {
      await addLiquidityController.getRateCoinAddLiquidity();
      if (isEditAmountA) {
        amountInBController.text =
            (valueCompareA.value * addLiquidityController.rate).toString();
      } else {
        final inputDoubleB = double.parse(amountInBController.text.isEmpty
            ? '0.0'
            : amountInBController.text.replaceAll(',', '.'));
        if (addLiquidityController.rate == 0.0) {
          amountInAController.text = '0.0';
        } else {
          amountInAController.text =
              (inputDoubleB / addLiquidityController.rate).toString();
        }
      }
      addLiquidityController.update([EnumAddLiquidity.RATE]);
    }
  }

  String get currencyACompare => CoinModel.currentcyFormat(
      valueCompareA.value * addLiquidityController.coinModelA.price);

  String get currencyBCompare => CoinModel.currentcyFormat(
      valueCompareB.value * addLiquidityController.coinModelB.price);

  void handleTextSetAmountOnTap(String title, bool isFrom) async {
    focusNode.unfocus();
    try {
      await status.updateStatus(StateStatus.LOADING);

      if (addLiquidityController.addressSender.coinOfBlockChain.isValueZero) {
        await status.updateStatus(
          StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'error_balance_not_enough'.tr,
        );
        return;
      }

      if (addLiquidityController.isErroRate) {
        await status.updateStatus(
          StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'coin_pair_failure'.tr,
        );
        return;
      }
      await addLiquidityController.calculatorFee(
          isApprove: isApprove,
          isApproveSuccess: isApproveSuccess,
          isNeedApproveA: isNeedApproveA,
          isNeedApproveB: isNeedApproveB,
          isCalculator: true);
      if (!addLiquidityController
          .addressSender.coinOfBlockChain.isValueAvalibleForFee) {
        await status.updateStatus(StateStatus.FAILURE,
            showDialogError: true,
            title: 'global_error'.tr,
            desc: 'error_balance_not_enough'.tr);
        return;
      } else {
        var totalAmount = BigInt.from(0);
        if (isFrom) {
          if (addLiquidityController.coinModelA.isToken) {
            totalAmount = addLiquidityController.coinModelA.value;
          } else {
            totalAmount =
                addLiquidityController.coinModelA.value - Crypto().fee;
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
              amount =
                  BigInt.from(totalAmount * BigInt.from(3) / BigInt.from(4));
              break;
            default:
              break;
          }
          isEditAmountA = true;
          isEditAmountB = false;
          amountInAController.text = Crypto.bigIntToStringWithDevide(
                  bigIntString: amount.toString(),
                  decimal: addLiquidityController.coinModelA.decimals)
              .replaceAll('.', ',');
        } else {
          if (addLiquidityController.coinModelB.isToken) {
            totalAmount = addLiquidityController.coinModelB.value;
          } else {
            totalAmount =
                addLiquidityController.coinModelB.value - Crypto().fee;
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
              amount =
                  BigInt.from(totalAmount * BigInt.from(3) / BigInt.from(4));
              break;
            default:
              break;
          }
          isEditAmountA = false;
          isEditAmountB = true;
          amountInBController.text = Crypto.bigIntToStringWithDevide(
                  bigIntString: amount.toString(),
                  decimal: addLiquidityController.coinModelB.decimals)
              .replaceAll('.', ',');
        }
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

    if (double.parse(amountInAController.text.replaceAll(',', '.')) <
            pow(10, -addLiquidityController.coinModelA.decimals) ||
        double.parse(amountInBController.text.replaceAll(',', '.')) <
            pow(10, -addLiquidityController.coinModelB.decimals)) {
      await status.updateStatus(StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'amount_not_format'.tr);
      return;
    }
    try {
      focusNode.unfocus();
      if (addLiquidityController.isErroRate) {
        await status.updateStatus(
          StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'coin_pair_failure'.tr,
        );
        return;
      }
      if (isApprove && !isApproveSuccess) {
        if (addLiquidityController.coinModelA.isToken) {
          amountAApproveSuccess = await addLiquidityController.checkAllowance(
              coinModel: addLiquidityController.coinModelA);
        } else {
          amountAApproveSuccess = BigInt.from(0);
        }
        if (addLiquidityController.coinModelB.isToken) {
          amountBApproveSuccess = await addLiquidityController.checkAllowance(
              coinModel: addLiquidityController.coinModelB);
        } else {
          amountBApproveSuccess = BigInt.from(0);
        }
        idOfCoinApprroveSucessA = addLiquidityController.coinModelA.id;
        idOfCoinApprroveSucessB = addLiquidityController.coinModelB.id;
        if (isApproveSuccessA && isApproveSuccessB) {
          isApproveSuccess = true;
          final symbol = addLiquidityController.coinModelA.isToken &&
                  addLiquidityController.coinModelB.isToken
              ? addLiquidityController.coinModelA.symbol +
                  ',' +
                  addLiquidityController.coinModelB.symbol
              : addLiquidityController.coinModelA.isToken
                  ? addLiquidityController.coinModelA.symbol
                  : addLiquidityController.coinModelB.symbol;

          update([EnumUpdateInputAmountAddLiquidity.BUTTON]);
          await status.updateStatus(
            StateStatus.SUCCESS,
            showDialogSuccess: true,
            title: 'success_transaction'.tr,
            desc: 'success_approve_detail_addLiquidity'
                .trParams({'symbol': symbol}),
          );

          return;
        }
      }
      await addLiquidityController.calculatorFee(
          isApprove: isApprove,
          isApproveSuccess: isApproveSuccess,
          isNeedApproveA: isNeedApproveA,
          isNeedApproveB: isNeedApproveB,
          isCalculator: false);
      if (addLiquidityController.coinModelA.isToken &&
          addLiquidityController.coinModelB.isToken) {
        if (!addLiquidityController
            .addressSender.coinOfBlockChain.isValueAvalibleForFee) {
          await status.updateStatus(StateStatus.FAILURE,
              showDialogError: true,
              title: 'global_error'.tr,
              desc: 'error_balance_not_enough'.tr);
          return;
        }
      } else if (!addLiquidityController.coinModelA.isToken) {
        if (!addLiquidityController.addressSender.coinOfBlockChain
            .isValueAvaliblePlusFee(addLiquidityController.amountStringInA)) {
          await status.updateStatus(StateStatus.FAILURE,
              showDialogError: true,
              title: 'global_error'.tr,
              desc: 'error_balance_not_enough'.tr);
          return;
        }
      } else if (!addLiquidityController.coinModelB.isToken) {
        if (!addLiquidityController.addressSender.coinOfBlockChain
            .isValueAvaliblePlusFee(addLiquidityController.amountStringInB)) {
          await status.updateStatus(StateStatus.FAILURE,
              showDialogError: true,
              title: 'global_error'.tr,
              desc: 'error_balance_not_enough'.tr);
          return;
        }
      }

      if (!isApprove || isApproveSuccess) {
        await status.updateStatus(StateStatus.SUCCESS);
        Get.put(AddLiquidityConfirmController()).isFullScreen = isFullScreen;
        await Get.bottomSheet(
            AddLiquidityConfirmPage(
              height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
            ),
            isScrollControlled: true);
        await Get.delete<AddLiquidityConfirmController>();
      } else if (isApprove && !isApproveSuccess) {
        await status.updateStatus(StateStatus.SUCCESS);
        Get.put(AddLiquidityApproveConfirmController());
        await Get.bottomSheet(
            AddLiquidityApproveConfirmPage(
              height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
            ),
            isScrollControlled: true);
        await Get.delete<AddLiquidityApproveConfirmController>();
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
          addressModel: addLiquidityController.addressSender,
          height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
        ),
        isScrollControlled: true);
    await Get.delete<SelectCoinOfAddressController>();
    var isResetData = false;
    if (coinResult != null) {
      if (addLiquidityController.coinModelA.id != coinResult.id && isFrom) {
        addLiquidityController.coinModelA = coinResult;
        amountInAController.clear();
        isResetData = true;
      }
      if (addLiquidityController.coinModelB.id != coinResult.id && !isFrom) {
        addLiquidityController.coinModelB = coinResult;
        amountInBController.clear();
        isResetData = true;
      }
      if (isResetData) {
        if ((addLiquidityController.coinModelA.isToken ||
                addLiquidityController.coinModelB.isToken) &&
            !isApprove) {
          isApprove = true;
        } else if (!addLiquidityController.coinModelA.isToken &&
            !addLiquidityController.coinModelB.isToken &&
            isApprove) {
          isApprove = false;
        }
        if ((!isApproveSuccessA || !isApproveSuccessB) && isApproveSuccess) {
          isApproveSuccess = false;
        } else if (isApproveSuccessA &&
            isApproveSuccessB &&
            !isApproveSuccess) {
          isApproveSuccess = true;
        }
        addLiquidityController.update([EnumAddLiquidity.RATE]);
        update([
          EnumUpdateInputAmountAddLiquidity.BUTTON,
        ]);
      }
    }
  }

  void handleIconBackOnTap() async {
    focusNode.unfocus();
    amountInAController.clear();
    amountInBController.clear();
    addLiquidityController.handleResetData();
    Get.back(id: AppPages.NAVIGATOR_KEY_ADD_LIQUIDITY);
  }

  bool get isErrorInputAAmount => !addLiquidityController.isAvalibleValueInputA;

  bool get isErrorInputBAmount => !addLiquidityController.isAvalibleValueInputB;

  bool get isApproveSuccessA =>
      (amountAApproveSuccess >= addLiquidityController.getBigIntAmountCoinA &&
          addLiquidityController.coinModelA.isToken &&
          idOfCoinApprroveSucessA == addLiquidityController.coinModelA.id) ||
      !addLiquidityController.coinModelA.isToken;
  bool get isApproveSuccessB =>
      (amountBApproveSuccess >= addLiquidityController.getBigIntAmountCoinB &&
          addLiquidityController.coinModelB.isToken &&
          idOfCoinApprroveSucessB == addLiquidityController.coinModelB.id) ||
      !addLiquidityController.coinModelB.isToken;
  bool get isNeedApproveA =>
      amountAApproveSuccess < addLiquidityController.getBigIntAmountCoinA &&
      addLiquidityController.coinModelA.isToken;
  bool get isNeedApproveB =>
      amountBApproveSuccess < addLiquidityController.getBigIntAmountCoinB &&
      addLiquidityController.coinModelB.isToken;
}
