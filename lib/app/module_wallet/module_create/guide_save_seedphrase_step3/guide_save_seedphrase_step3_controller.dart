import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/module_wallet/module_create/create_wallet/create_wallet_controller.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:flutter/animation.dart';

import 'package:get/get.dart';

class GuideSaveSeedPhraseStep3Controller extends GetxController {
  final String icEyeVisible = AppAssets.globalIcEyeVisible;
  bool isActiveButton = false;

  late AnimationController animationController;
  late final List<String> seedPhrase;
  late final CreateWalletController createWallet;

  @override
  void onInit() async {
    createWallet = Get.find<CreateWalletController>();
    seedPhrase = createWallet.seedPhrase;
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void handleButtonOnTap() {
    Get.toNamed(AppRoutes.GUIDE_SAVE_SEEDPHRASE_CONFIRM);
  }

  void handleButtonSeenOnTap() {
    animationController.reverse();
    isActiveButton = true;
    update();
  }

  void handleButtonBackAppBarOnTap() {
    Get.back();
  }
}
