import 'package:get/instance_manager.dart';

import 'guide_save_seedphrase_controller.dart';

class GuideSaveSeedPhraseCompleteBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GuideSaveSeedPhraseCompleteController());
  }
}
