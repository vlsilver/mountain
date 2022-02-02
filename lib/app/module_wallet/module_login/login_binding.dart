import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}
