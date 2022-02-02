import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/transition/app_transition.dart';
import 'app/data/services/authen_services.dart';
import 'app/data/services/setting_services.dart';
import 'app/module_wallet/wallet_controller.dart';
import 'app/routes/pages_routes.dart';

void main() async {
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  await Get.putAsync(() => SettingService().init());
  await Get.putAsync(() => AuthenService().init());
  await Firebase.initializeApp();
  final _settingService = Get.find<SettingService>();
  final _authenService = Get.find<AuthenService>();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    translations: AppTranslation(),
    theme: _settingService.theme,
    locale: _settingService.locale,
    defaultTransition: Transition.cupertino,
    initialRoute: _authenService.firstPage,
    initialBinding: InitialBinding(),
    getPages: AppPages.pages,
  ));
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WalletController(), permanent: true);
  }
}
