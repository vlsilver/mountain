import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/providers/crypto_provider/binance_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/ethereum_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/kardiachain_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/polygon_provider.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/update_amount_add_liquidity/update_amount_add_liquidity_controller.dart';
import 'package:get/get.dart';

import '../add_liquidity_controller.dart';

class AddLiquidityApproveConfirmController extends GetxController {
  final status = Status();

  final addLiquidityController = Get.find<AddLiquidityController>();
  final updateAmountController = Get.find<UpdateAmountAddLiquidityController>();

  @override
  void onInit() {
    super.onInit();
  }

  String getNameAddressRouter() {
    switch (addLiquidityController.addressSender.blockChainId) {
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

  void handleButtonApproveOnTap() async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      if (updateAmountController.isNeedApproveA) {
        await addLiquidityController.createApproveTransaction(
            coinModel: addLiquidityController.coinModelA);
        updateAmountController
          ..amountAApproveSuccess =
              addLiquidityController.coinModelA.value * BigInt.from(2)
          ..idOfCoinApprroveSucessA = addLiquidityController.coinModelA.id;
      }

      if (updateAmountController.isNeedApproveB) {
        await addLiquidityController.createApproveTransaction(
            coinModel: addLiquidityController.coinModelB);
        updateAmountController
          ..amountBApproveSuccess =
              addLiquidityController.coinModelB.value * BigInt.from(2)
          ..idOfCoinApprroveSucessB = addLiquidityController.coinModelB.id;
      }

      final symbol = updateAmountController.isNeedApproveA &&
              updateAmountController.isNeedApproveB
          ? addLiquidityController.coinModelA.symbol +
              ',' +
              addLiquidityController.coinModelB.symbol
          : updateAmountController.isNeedApproveA
              ? addLiquidityController.coinModelA.symbol
              : addLiquidityController.coinModelB.symbol;
      await status.updateStatus(
        StateStatus.SUCCESS,
        showDialogSuccess: true,
        title: 'success_transaction'.tr,
        desc: 'success_approve_detail_addLiquidity'.trParams({
          'symbol': symbol,
        }),
      );
      updateAmountController.isApproveSuccess = true;
      updateAmountController.update([EnumUpdateInputAmountAddLiquidity.BUTTON]);
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
}
