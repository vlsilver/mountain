import 'package:base_source/app/module_setting/setting_controller.dart';
import 'package:get/instance_manager.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}
