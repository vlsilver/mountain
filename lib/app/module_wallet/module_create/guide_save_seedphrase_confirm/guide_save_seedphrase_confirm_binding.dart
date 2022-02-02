import 'package:get/instance_manager.dart';

import 'guide_save_seedphrase_confirm_controller.dart';

class GuideSaveSeedPhraseConfirmBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GuideSaveSeedPhraseConfirmController());
  }
}
