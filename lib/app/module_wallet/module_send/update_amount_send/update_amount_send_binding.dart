import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'update_amount_send_controller.dart';

class UpdateAmountSendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateAmountSendController());
  }
}
