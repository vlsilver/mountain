import 'package:get/instance_manager.dart';

import 'list_add_liquidity_controller.dart';

class ListAddLiquidBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ListAddLiquidityController());
  }
}
