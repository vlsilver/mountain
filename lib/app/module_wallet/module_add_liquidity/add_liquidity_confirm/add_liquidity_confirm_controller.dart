import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_controller.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:get/get.dart';

class AddLiquidityConfirmController extends GetxController {
  final status = Status();

  final addLiquidityController = Get.find<AddLiquidityController>();
  bool isFullScreen = true;
  @override
  void onInit() {
    super.onInit();
  }

  void handleButtonAddliquidityOnTap() async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      await addLiquidityController.createAddliquidityTransaction();
      await status.updateStatus(
        StateStatus.SUCCESS,
        showDialogSuccess: true,
        title: 'success_transaction'.tr,
        desc: 'success_add_liquidity_detail'.trParams({
          'symbolFrom': addLiquidityController.coinModelA.symbol,
          'symbolTo': addLiquidityController.coinModelB.symbol
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
      Get.back(id: AppPages.NAVIGATOR_KEY_ADD_LIQUIDITY);
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
}
