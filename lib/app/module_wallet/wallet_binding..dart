import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletController());
  }
}
