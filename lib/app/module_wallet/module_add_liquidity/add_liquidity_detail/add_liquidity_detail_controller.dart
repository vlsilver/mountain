import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/data/models/local_model/address_add_liquidity_list.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_controller.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/remove_add_liquidity/remove_add_liquidity_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AddLiquidityDetailController extends GetxController {
  final addLiquidityController = Get.find<AddLiquidityController>();
  final _walletController = Get.find<WalletController>();
  final status = Status();
  late final AddLiquidityModel addLiquidityModel;
  AddressModel owner = AddressModel.empty();
  BlockChainModel? blockChainModel;
  bool isRemove = true;

  bool checkRemove() {
    blockChainModel = _walletController.wallet
        .getBlockChainModel(addLiquidityModel.blockChainId);
    final index = blockChainModel!.addresss.indexWhere(
        (element) => element.address == addLiquidityModel.addressRecive);
    if (index != -1) {
      owner = blockChainModel!.addresss[index];
      isRemove = true;
      return true;
    } else {
      isRemove = false;
      return false;
    }
  }

  void handleAddButtonOnTap() {
    Get.back();
    final coinAInit = owner.coins.firstWhere(
        (element) => element.id == addLiquidityModel.tokenA.id,
        orElse: () => CoinModel.empty());
    final coinBInit = owner.coins.firstWhere(
        (element) => element.id == addLiquidityModel.tokenB.id,
        orElse: () => CoinModel.empty());
    addLiquidityController.setData(
        coinAInit: coinAInit,
        coinBInit: coinBInit,
        addressSendInit: isRemove ? owner : blockChainModel!.addressAvalible,
        addressRecieveInit: isRemove ? owner : blockChainModel!.addressAvalible,
        blockChain: blockChainModel!);
    addLiquidityController.isAutoGetAmount = true;
    Get.toNamed(AppRoutes.UPDATE_AMOUNT_ADD_LIQUIDITY,
        id: AppPages.NAVIGATOR_KEY_ADD_LIQUIDITY);
  }

  void handleButtonRemoveOntap() {
    Get.back();
    Get.put(RemoveAddLiquidityController())
      ..addLiquidityModel = addLiquidityModel
      ..addressSender = owner;
    Get.toNamed(AppRoutes.REMOVE_ADD_LIQUIDITY,
        id: AppPages.NAVIGATOR_KEY_ADD_LIQUIDITY);
  }

  // void handleRemoveConfirmOnTap() async {
  //   try {
  //     await status.updateStatus(StateStatus.LOADING);
  //     await addLiquidityController.calculatorFeeRemoveAddLiquidity(
  //       tokenA: addLiquidityModel.tokenA.contractAddress,
  //       tokenB: addLiquidityModel.tokenB.contractAddress,
  //       addressSender: owner.address,
  //       addrsassRecieve: owner.address,
  //       amountTokenLP: addLiquidityModel.tokenLP.value,
  //       blocChainId: owner.blockChainId,
  //     );
  //     if (!owner.coinOfBlockChain.isValueAvalibleForFee) {
  //       await status.updateStatus(StateStatus.FAILURE,
  //           showDialogError: true,
  //           title: 'global_error'.tr,
  //           desc: 'error_balance_not_enough'.tr);
  //     } else {
  //       await addLiquidityController.removeAddliquidityTransaction(
  //         tokenA: addLiquidityModel.tokenA.contractAddress,
  //         tokenB: addLiquidityModel.tokenB.contractAddress,
  //         addressSender: owner,
  //         addrsassRecieve: owner.address,
  //         amountTokenLP: addLiquidityModel.tokenLP.value,
  //       );
  //       await status.updateStatus(
  //         StateStatus.SUCCESS,
  //         showDialogSuccess: true,
  //         title: 'success_transaction'.tr,
  //         desc: 'success_remove_add_liquidity_detail'.trParams({
  //           'symbolA': addLiquidityModel.tokenA.symbol,
  //           'symbolB': addLiquidityModel.tokenB.symbol
  //         }),
  //       );
  //       try {
  //         if (Get.isDialogOpen!) {
  //           Get.back();
  //         }
  //       } catch (exp) {}
  //       try {
  //         if (Get.isSnackbarOpen!) {
  //           Get.back();
  //         }
  //       } catch (exp) {}
  //       try {
  //         if (Get.isBottomSheetOpen!) {
  //           Get.back();
  //         }
  //       } catch (exp) {}
  //     }

  //     return;
  //   } catch (exp) {
  //     await status.updateStatus(
  //       StateStatus.FAILURE,
  //       showDialogError: true,
  //       desc: exp.toString(),
  //       title: 'global_error'.tr,
  //     );
  //     AppError.handleError(exception: exp);
  //   }
  // }
}
