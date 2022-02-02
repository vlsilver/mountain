import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'update_address_swap_controller.dart';

class UpdateAddressSwapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateAddressSwapController());
  }
}
