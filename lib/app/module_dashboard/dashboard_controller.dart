import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/list_add_liquidity/list_add_liquidity_page.dart';
import 'package:base_source/app/module_wallet/module_request_receive/pages/select_coin_page.dart';
import 'package:base_source/app/module_wallet/module_send/update_address_send/update_address_send_page.dart';
import 'package:base_source/app/module_wallet/module_swap/update_address_swap/update_address_swap_page.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DashBoardController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  final status = Status();

  void handleTextSendOnTap() {
    Get.to(() => SendNavigatorPage(
          isFullScreen: true,
        ));
  }

  void handleTextRecieveOnTap() {
    Get.bottomSheet(ReceiveNavigatorPage(), isScrollControlled: true);
  }

  void handleLaunchPadOnTap() {
    Get.toNamed(AppRoutes.LAUNCHPAD);
  }

  void handleSwapOnTap() {
    Get.to(() => SwapNavigatorPage(
          isFullScreen: true,
          isFast: false,
        ));
  }

  void handleAddLiquidityOnTap() {
    Get.to(() => AddLiquidityNavigatorPage(
          isFullScreen: true,
        ));
  }

  Future<void> handleOnTapOpenlink() async {
    try {
      await launch(
        'https://moonwallet.net',
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } catch (exp) {
      await status.updateStatus(StateStatus.FAILURE,
          isBack: false, showSnackbarError: true, desc: 'load_web_error'.tr);
      AppError.handleError(exception: exp);
    }
  }
}
