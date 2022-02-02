import 'package:get/instance_manager.dart';

import 'guide_save_seedphrase_step3_controller.dart';

class GuideSaveSeedPhraseStep3Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(GuideSaveSeedPhraseStep3Controller());
  }
}
