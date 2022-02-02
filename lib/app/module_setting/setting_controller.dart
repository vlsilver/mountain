import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/module_home/home_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingController extends GetxController {
  final List<int> hasDetails = [0, 1, 2];

  final status = Status();

  bool hasDetail(int index) => hasDetails.contains(index);

  void handleItemSettingOnTap(int index) async {
    switch (index) {
      case 0:
        await Get.toNamed(AppRoutes.REVOKE);
        break;
      case 1:
        await Get.toNamed(AppRoutes.SETTING_HISTORY_TRANSACTION);
        break;
      case 2:
        await Get.toNamed(AppRoutes.SETTING_CHANGE);
        break;
      case 3:
        await handleOnTapOpenlink('https://moonwallet.net/term');
        break;
      case 4:
        await handleOnTapOpenlink('https://moonwallet.net/privacy-policy');
        break;
      case 5:
        await handleOnTapOpenlink('https://moonwallet.net/contact');
        break;
      case 6:
        await logout();
        break;
      default:
    }
  }

  Future<void> handleOnTapOpenlink(String url) async {
    try {
      await launch(
        url,
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

  Future<void> logout() async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      final walletController = Get.find<WalletController>();
      walletController.isLoadSuccess = false;
      walletController.autoStream = false;
      walletController.visibleAppbar = false;

      try {
        walletController.scrollController.removeListener(() {});
        walletController.scrollController.dispose();
      } catch (exp) {}

      await walletController.updateWallet();
      await walletController.getWallet();
      await status.updateStatus(StateStatus.SUCCESS);
      await Get.delete<HomeController>();
      await Get.offAllNamed(AppRoutes.LOGIN);
    } catch (exp) {
      await status.updateStatus(StateStatus.FAILURE,
          showSnackbarError: true, desc: 'global_failure'.tr);
      AppError.handleError(exception: exp);
    }
  }
}
