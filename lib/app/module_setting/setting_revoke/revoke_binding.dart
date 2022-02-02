import 'package:base_source/app/module_setting/setting_revoke/revoke_cotroller.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

class RevokeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RevokeController());
  }
}
