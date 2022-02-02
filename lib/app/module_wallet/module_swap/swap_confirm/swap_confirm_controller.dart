import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_controller.dart';
import 'package:get/get.dart';

class SwapConfirmController extends GetxController {
  final status = Status();

  final swapController = Get.find<SwapController>();
  bool isFullScreen = true;
  @override
  void onInit() {
    super.onInit();
  }

  void handleButtonSwapOnTap() async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      await swapController.createSwapTransaction();
      await status.updateStatus(
        StateStatus.SUCCESS,
        showDialogSuccess: true,
        title: 'success_transaction'.tr,
        desc: 'success_swap_detail'.trParams({
          'symbolFrom': swapController.coinModelFrom.symbol,
          'symbolTo': swapController.coinModelTo.symbol
        }),
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
}
