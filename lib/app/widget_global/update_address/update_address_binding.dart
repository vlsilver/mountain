import 'package:base_source/app/widget_global/update_address/update_address_controller.dart';
import 'package:get/instance_manager.dart';

class UpdateAddressBinding1 extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateAddressController1());
  }
}
