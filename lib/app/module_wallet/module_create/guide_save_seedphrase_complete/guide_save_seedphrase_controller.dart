import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/module_wallet/module_create/create_wallet/create_wallet_controller.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:get/get.dart';

class GuideSaveSeedPhraseCompleteController extends GetxController {
  final String icComplete = AppAssets.createWalletIcComple;

  void handleButtonOnTap() async {
    await Get.delete<CreateWalletController>(force: true);
    await Get.offAllNamed(AppRoutes.HOME);
  }
}
