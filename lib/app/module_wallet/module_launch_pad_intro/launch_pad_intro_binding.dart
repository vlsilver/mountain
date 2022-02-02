import 'package:get/instance_manager.dart';

import 'launch_pad_intro_controller.dart';

class LaunchPadIntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LaunchPadIntroController());
  }
}
