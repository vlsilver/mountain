import 'package:base_source/app/module_wallet/module_notification/notification_controller.dart';
import 'package:get/instance_manager.dart';

class NotificationBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController());
  }
}
