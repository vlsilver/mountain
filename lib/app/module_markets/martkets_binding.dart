import 'package:base_source/app/module_markets/markets_controller.dart';
import 'package:get/instance_manager.dart';

class MartketsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MarketsController());
  }
}
