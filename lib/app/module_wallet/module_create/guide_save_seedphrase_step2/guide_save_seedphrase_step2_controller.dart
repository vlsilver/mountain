import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/routes/routes.dart';

import 'package:get/get.dart';

class GuideSaveSeedPhraseStep2Controller extends GetxController {
  final String icInfo = AppAssets.createWalletIcInfo;

  void handleButtonOnTap() {
    Get.toNamed(AppRoutes.GUIDE_SAVE_SEEDPHRASE_STEP3);
  }

  void handleButtonBackAppBarOnTap() {
    Get.back();
  }
}
