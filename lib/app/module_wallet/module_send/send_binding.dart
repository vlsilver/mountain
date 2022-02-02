import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'send_controller.dart';

class SendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SendController());
  }
}
