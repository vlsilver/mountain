import 'package:get/instance_manager.dart';

import 'choice_setup_controller.dart';

class ChoiceSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChoiceSetupController());
  }
}
