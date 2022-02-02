import 'package:get/instance_manager.dart';

import 'guide_save_seedphrase_step2_controller.dart';

class GuideSaveSeedPhraseStep2Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(GuideSaveSeedPhraseStep2Controller());
  }
}
