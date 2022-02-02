import 'package:base_source/app/data/services/authen_services.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:get/get.dart';

class InitialAppErrorController extends GetxController {
  final String btnStr = 'Restart App'.tr;

  late final AuthenService _authenService;

  @override
  void onInit() {
    _authenService = Get.find<AuthenService>();
    super.onInit();
  }

  void handleButtonRestartOnTap() async {
    await _authenService.initialApp();
    if (_authenService.firstPage != AppRoutes.INITAL_APP_ERROR) {
      await Get.offAllNamed(_authenService.firstPage);
    }
  }
}
