import 'package:base_source/app/module_setting/setting_history_transaction/setting_history_transaction_controller.dart';
import 'package:get/instance_manager.dart';

class SettingHistoryTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingHistoryTransactionController());
  }
}
