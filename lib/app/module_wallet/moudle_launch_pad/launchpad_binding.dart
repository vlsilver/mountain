import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import 'launchpad_controller.dart';

class LaunchPadBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LaunchPadController());
  }
}
