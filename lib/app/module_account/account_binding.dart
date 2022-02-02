import 'package:base_source/app/module_account/account_controller.dart';
import 'package:get/instance_manager.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountController());
  }
}
