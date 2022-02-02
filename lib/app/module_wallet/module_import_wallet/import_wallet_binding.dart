import 'package:get/instance_manager.dart';

import 'import_wallet_controller.dart';

class ImportWalletdBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ImportWalletController());
  }
}
