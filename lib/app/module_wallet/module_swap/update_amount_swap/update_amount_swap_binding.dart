import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'update_amount_swap_controller.dart';

class UpdateAmountSwapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateAmountSwapController());
  }
}
