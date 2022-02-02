import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/providers/crypto_provider/binance_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/ethereum_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/kardiachain_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/polygon_provider.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_controller.dart';
import 'package:base_source/app/module_wallet/module_swap/update_amount_swap/update_amount_swap_controller.dart';
import 'package:get/get.dart';

class SwapApproveConfirmController extends GetxController {
  final status = Status();

  final swapController = Get.find<SwapController>();
  final updateAmountController = Get.find<UpdateAmountSwapController>();

  @override
  void onInit() {
    super.onInit();
  }

  String getNameAddressRouter() {
    switch (swapController.addressSender.blockChainId) {
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
      await swapController.createApproveTransaction();
      await status.updateStatus(
        StateStatus.SUCCESS,
        showDialogSuccess: true,
        title: 'success_transaction'.tr,
        desc: 'success_approve_detail'.trParams({
          'symbol': swapController.coinModelFrom.symbol,
        }),
      );
      updateAmountController.isApproveSuccess = true;
      updateAmountController
        ..amountApproveSuccess =
            swapController.coinModelFrom.value * BigInt.from(2)
        ..idOfCoinApprroveSucess = swapController.coinModelFrom.id;
      updateAmountController.update([EnumUpdateInputAmountSwap.BUTTON]);
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
