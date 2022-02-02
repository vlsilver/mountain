import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/module_wallet/module_create/create_wallet/create_wallet_controller.dart';
import 'package:base_source/app/routes/routes.dart';

import 'package:get/get.dart';

import 'widget/dialog_skip_security_widget.dart';

class GuideSaveSeedPhraseStep1Controller extends GetxController {
  final String icSecure = AppAssets.createWalletSecure;

  final status = Status();

  void handleButtonOnTap() {
    Get.toNamed(AppRoutes.GUIDE_SAVE_SEEDPHRASE_STEP2);
  }

  void handleRemindTextOnTap() async {
    await Get.dialog(DialogSkipSecurityWidget(), barrierDismissible: false);
  }

  void handleButtonSkipOnTap() async {
    await Get.delete<CreateWalletController>(force: true);
    await Get.offAllNamed(AppRoutes.HOME);
  }
}
