import 'package:get/instance_manager.dart';

import 'guide_save_seedphrase_setp1_controller.dart';

class GuideSaveSeedPhraseStep1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GuideSaveSeedPhraseStep1Controller());
  }
}
