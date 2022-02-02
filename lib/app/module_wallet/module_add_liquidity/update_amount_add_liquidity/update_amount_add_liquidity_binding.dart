import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'update_amount_add_liquidity_controller.dart';

class UpdateAmountAddLiquidityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateAmountAddLiquidityController());
  }
}
