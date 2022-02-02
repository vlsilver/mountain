import 'package:get/instance_manager.dart';

import 'add_liquidity_controller.dart';

class AddLiquidityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddLiquidityController());
  }
}
