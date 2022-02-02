import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:get/get.dart';

class ListAddLiquidityController extends GetxController {
  void handleAddLiquidityTextOnTap() async {
    await Get.toNamed(
      AppRoutes.UPDATE_ADDRESS_ADD_LIQUIDITY,
      id: AppPages.NAVIGATOR_KEY_ADD_LIQUIDITY,
    );
  }

  @override
  void onInit() {
    super.onInit();
  }
}
