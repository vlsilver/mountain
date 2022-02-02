import 'package:get/get.dart';

import 'dashboard_controller.dart';

class DashBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashBoardController());
  }
}
