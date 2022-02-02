import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'update_address_send_controller.dart';

class UpdateAddressSendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateAddressSendController());
  }
}
