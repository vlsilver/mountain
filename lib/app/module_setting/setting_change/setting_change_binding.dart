import 'package:base_source/app/module_setting/setting_change/setting_change_controller.dart';
import 'package:get/instance_manager.dart';

class SettingChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingChangeController());
  }
}
