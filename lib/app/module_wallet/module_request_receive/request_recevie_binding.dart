import 'package:base_source/app/module_wallet/module_request_receive/request_receive_controller.dart';
import 'package:get/instance_manager.dart';

class RequestRecieveBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RequestRecieveController());
  }
}
