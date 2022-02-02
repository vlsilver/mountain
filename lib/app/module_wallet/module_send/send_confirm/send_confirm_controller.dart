import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_wallet/module_send/send_controller.dart';
import 'package:get/get.dart';

enum EnumUpdateConfirmTransition { BUTTON }

class SendConfirmController extends GetxController {
  final status = Status();
  bool isFullScreen = true;
  final sendController = Get.find<SendController>();

  @override
  void onInit() {
    super.onInit();
  }

  void handleButtonSendOnTap() async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      switch (sendController.addressSender.blockChainId) {
        case BlockChainModel.bitcoin:
          await sendController.createTransactionBitcoin();
          break;
        case BlockChainModel.ethereum:
          await sendController.createTransactionEthereum();
          break;
        case BlockChainModel.binanceSmart:
          await sendController.createTransactionBinanceSmart();
          break;
        case BlockChainModel.polygon:
          await sendController.createTransactionPolygon();
          break;
        case BlockChainModel.kardiaChain:
          await sendController.createTransactionKardiaChain();
          break;
        case BlockChainModel.stellar:
          await sendController.createTransactionStellar();
          break;
        case BlockChainModel.piTestnet:
          await sendController.createTransactionPiTestnet();
          break;
        case BlockChainModel.tron:
          await sendController.createTransactionTron();
          break;
        default:
          break;
      }
      await status.updateStatus(
        StateStatus.SUCCESS,
        showDialogSuccess: true,
        title: 'success_transaction'.tr,
        desc: 'success_transaction_detail'
            .trParams({'symbol': sendController.coinModelSelect.symbol}),
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

  void handleIcbackOnTap() {
    Get.back();
  }
}
