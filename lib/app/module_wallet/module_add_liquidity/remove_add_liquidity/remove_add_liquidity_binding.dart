import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'remove_add_liquidity_controller.dart';

class RemoveAddLiquidityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RemoveAddLiquidityController());
  }
}
