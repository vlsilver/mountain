import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:get/get.dart';

class UpdateAddressSwapController extends GetxController {
  final swapController = Get.find<SwapController>();
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
    swapController.setData(
      coinModelSelect: CoinModel.empty(),
      addressModel: addressModel,
      blockChain: blockChain,
    );
    swapController.isAutoGetAmount = true;
    Get.toNamed(AppRoutes.UPDATE_AMOUNT_SWAP, id: AppPages.NAVIGATOR_KEY_SWAP);
  }
}
