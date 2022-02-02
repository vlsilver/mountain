import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'create_new_address_controller.dart';

class CreateNewAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateNewAddressController());
  }
}
