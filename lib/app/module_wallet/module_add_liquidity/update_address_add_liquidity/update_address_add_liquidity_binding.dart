import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'update_address_add_liquidity_controller.dart';

class UpdateAddressAddLiquidityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateAddressAddLiquidityController());
  }
}
