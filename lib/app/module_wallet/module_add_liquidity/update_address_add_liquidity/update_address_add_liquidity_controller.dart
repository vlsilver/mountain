import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:get/get.dart';

class UpdateAddressAddLiquidityController extends GetxController {
  final addLiquidityController = Get.find<AddLiquidityController>();
  bool isFullScreen = true;
  final _walletController = Get.find<WalletController>();
  List<BlockChainModel> get blockChainSupport =>
      _walletController.blockChainSupportSwap;

  @override
  void onInit() {
    super.onInit();
  }

  void handleAddressItemOnTap({
    required BlockChainModel blockChain,
    required AddressModel addressModel,
  }) {
    addLiquidityController.setData(
        coinAInit: CoinModel.empty(),
        coinBInit: CoinModel.empty(),
        addressSendInit: addressModel,
        addressRecieveInit: addressModel,
        blockChain: blockChain);
    addLiquidityController.isAutoGetAmount = true;
    Get.toNamed(AppRoutes.UPDATE_AMOUNT_ADD_LIQUIDITY,
        id: AppPages.NAVIGATOR_KEY_ADD_LIQUIDITY);
  }

  void handleIconBackOnTap() async {
    Get.back(id: AppPages.NAVIGATOR_KEY_ADD_LIQUIDITY);
  }
}
