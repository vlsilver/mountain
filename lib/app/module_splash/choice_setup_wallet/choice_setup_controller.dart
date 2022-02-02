import 'package:base_source/app/routes/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ChoiceSetupController extends GetxController {
  late final TapGestureRecognizer handleTextRecognize;

  final String titleStr = 'new_wallet_headline'.tr;
  final String descStr = 'new_wallet_body'.tr;
  final String btnImportStr = 'new_wallet_btn_input'.tr;
  final String btnSyncStr = 'new_wallet_btn_sync'.tr;
  final String btnNewStr = 'new_wallet_btn_new'.tr;
  final String privacy1Str = 'new_wallet_pravicy_p1'.tr;
  final String privacy2Str = 'new_wallet_pravicy_p2'.tr;

  @override
  void onInit() {
    handleTextRecognize = TapGestureRecognizer()..onTap = _handleTextOnTap;
    super.onInit();
  }

  @override
  void onClose() {
    handleTextRecognize.dispose();
    super.onClose();
  }

  void _handleTextOnTap() async {
    await launch(
      'https://moonwallet.net/term',
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    );
  }

  void handleButtonImportMnemonicOnTap() async {
    await Get.toNamed(AppRoutes.IMPORT_WALLET);
  }

  void handleButtonCreateNewWalletOnTap() async {
    await Get.toNamed(AppRoutes.CREATE_WALLET);
  }
}
