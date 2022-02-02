import 'package:get/instance_manager.dart';

import 'initial_app_error_controller.dart';

class InitialAppErrorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InitialAppErrorController());
  }
}
