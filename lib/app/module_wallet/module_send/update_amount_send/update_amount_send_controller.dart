import 'dart:math';

import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/module_send/send_confirm/send_confirm_controller.dart';
import 'package:base_source/app/module_wallet/module_send/send_confirm/send_confirm_page.dart';
import 'package:base_source/app/module_wallet/module_send/send_controller.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:base_source/app/widget_global/select_coin_of_address/select_coin_of_address_controller.dart';
import 'package:base_source/app/widget_global/select_coin_of_address/select_coin_of_address_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum EnumUpdateSendInputAmount { BUTTON, COIN }

class UpdateAmountSendController extends GetxController {
  final List<String> calculatorsStr = ['25%', '50%', '75%', 'use_max'.tr];

  final status = Status();
  final amountController = TextEditingController();
  final FocusNode focusNode =
      FocusNode(debugLabel: AppRoutes.UPDATE_AMOUNT_SEND);
  final Rx<double> valueCompare = 0.0.obs;
  bool isActiveButton = false;
  bool isFullScreen = true;

  late final Worker woker;

  final sendController = Get.find<SendController>();

  @override
  void onInit() {
    if (sendController.coinModelSelect.id.isEmpty) {
      sendController.coinModelSelect =
          sendController.addressSender.coinAvalible();
    }

    amountController.addListener(() {
      final inputValue = double.parse(amountController.text.isEmpty
          ? '0.0'
          : amountController.text.replaceAll(',', '.'));
      valueCompare.value = inputValue;
      sendController.amount = inputValue;
      sendController.amountString = amountController.text.isEmpty
          ? '0.0'
          : amountController.text.replaceAll(',', '.');
      if (inputValue > 0 &&
          sendController.isAvalibleValueInput &&
          !isActiveButton) {
        isActiveButton = true;
        update([EnumUpdateSendInputAmount.BUTTON]);
      } else if ((inputValue <= 0 || !sendController.isAvalibleValueInput) &&
          isActiveButton) {
        isActiveButton = false;
        update([EnumUpdateSendInputAmount.BUTTON]);
      } else {
        update([EnumUpdateSendInputAmount.BUTTON]);
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

  String get currencyCompare => CoinModel.currentcyFormat(
      valueCompare.value * sendController.coinModelSelect.price);

  void handleTextSetAmountOnTap(String title) async {
    focusNode.unfocus();
    try {
      await status.updateStatus(StateStatus.LOADING);
      if (sendController.coinModelSelect.isValueZero) {
        await status.updateStatus(
          StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'error_balance_not_enough'.tr,
        );
        return;
      }
      final fee = await sendController.calculatorFee();
      sendController.fee = fee;
      if (!sendController
          .addressSender.coinOfBlockChain.isValueAvalibleForFee) {
        await status.updateStatus(StateStatus.FAILURE,
            showDialogError: true,
            title: 'global_error'.tr,
            desc: 'error_balance_not_enough'.tr);
        return;
      } else {
        var totalAmount = BigInt.from(0);
        if (sendController.coinModelSelect.isToken) {
          totalAmount = sendController.coinModelSelect.value;
        } else {
          totalAmount = sendController.coinModelSelect.value - Crypto().fee;
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
                bigIntString: amount.toString(),
                decimal: sendController.coinModelSelect.decimals)
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
    try {
      if (double.parse(amountController.text.replaceAll(',', '.')) <
          pow(10, -sendController.coinModelSelect.decimals)) {
        throw Exception();
      }
    } catch (exp) {
      await status.updateStatus(StateStatus.FAILURE,
          showDialogError: true,
          title: 'global_error'.tr,
          desc: 'amount_not_format'.tr);
      return;
    }
    try {
      focusNode.unfocus();
      final fee = await sendController.calculatorFee();
      sendController.fee = fee;
      if (sendController.coinModelSelect.isToken) {
        if (!sendController
            .addressSender.coinOfBlockChain.isValueAvalibleForFee) {
          await status.updateStatus(StateStatus.FAILURE,
              showDialogError: true,
              title: 'global_error'.tr,
              desc: 'error_balance_not_enough'.tr);
          return;
        }
      } else {
        if (!sendController.addressSender.coinOfBlockChain
            .isValueAvaliblePlusFee(sendController.amountString)) {
          await status.updateStatus(StateStatus.FAILURE,
              showDialogError: true,
              title: 'global_error'.tr,
              desc: 'error_balance_not_enough'.tr);
          return;
        }
      }
      await status.updateStatus(StateStatus.SUCCESS);
      Get.put(SendConfirmController()).isFullScreen = isFullScreen;
      await Get.bottomSheet(
          SendConfirmPage(
            height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
          ),
          isScrollControlled: true);
      await Get.delete<SendConfirmController>();
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

  void handleCoinBoxOnTap() async {
    Get.put(SelectCoinOfAddressController());
    final coinResult = await Get.bottomSheet(
        SelectCoinOfAddressPage(
          addressModel: sendController.addressSender,
          height: isFullScreen ? Get.height * 0.85 : Get.height * 0.8,
        ),
        isScrollControlled: true);
    if (coinResult != null &&
        coinResult.id != sendController.coinModelSelect.id) {
      sendController.coinModelSelect = coinResult;
      amountController.clear();
      update([
        EnumUpdateSendInputAmount.COIN,
        EnumUpdateSendInputAmount.BUTTON,
      ]);
    }
    await Get.delete<SelectCoinOfAddressController>();
  }

  void handleIcbackOnTap() {
    focusNode.unfocus();
    amountController.clear();
    sendController.handleResetData();
    Get.back(id: AppPages.NAVIGATOR_KEY_SEND);
  }

  bool get isErrorInputAmount => !sendController.coinModelSelect
      .isValueAvalible(sendController.amountString);
}
