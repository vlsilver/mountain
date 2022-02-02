import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/ido_model.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_project/ido_project_controller.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/launchpad_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:get/get.dart';

import 'ido_claim_confirm_page.dart';
import 'ido_claim_confirm_repo.dart';

enum EnumIDODeposit { BUTTON, COIN, ADDRESS_SENDER }

class IDOClaimController extends GetxController {
  final status = Status();
  double fee = 0.0;
  final launchPadController = Get.find<LaunchPadController>();
  final idoProjectController = Get.find<IDOProjectController>();
  final _walletController = Get.find<WalletController>();
  final _repo = IDOClaimRepository();

  AddressModel getAddressModelFromAddressDeposited(String address) =>
      _walletController.blockChainSupportLaunchPad.addresss
          .firstWhere((element) => element.address == address);

  List<DataDeposit> get getDataDeposited =>
      idoProjectController.idoModel.addressDespositedData;

  void handleAddressItemOnTap(
      AddressModel addressModel, DataDeposit dataDeposit) async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      if (dataDeposit.isClaimed) {
        await status.updateStatus(
          StateStatus.FAILURE,
          showDialogError: true,
          desc: 'claim_error'
              .trParams({'symbol': idoProjectController.idoModel.symbol}),
          title: 'global_error'.tr,
        );
        return;
      }
      if (dataDeposit.amountDeposited == BigInt.from(0)) {
        await status.updateStatus(
          StateStatus.FAILURE,
          showDialogError: true,
          desc: 'claim_error_not_deposited'
              .trParams({'symbol': idoProjectController.idoModel.symbol}),
          title: 'global_error'.tr,
        );
        return;
      }
      fee = await _repo.calculatorFee(
        adddressSender: addressModel.address,
        index: idoProjectController.idoModel.index,
      );
      if (!addressModel.coinOfBlockChain.isValueAvalibleForFee) {
        await status.updateStatus(StateStatus.FAILURE,
            showDialogError: true,
            title: 'global_error'.tr,
            desc: 'error_balance_not_enough'.tr);
        return;
      } else {
        await status.updateStatus(StateStatus.SUCCESS);
        await Get.bottomSheet(IDOClaimConfirmPage(addressModel: addressModel),
            isScrollControlled: true);
      }
    } catch (exp) {
      await status.updateStatus(
        StateStatus.FAILURE,
        showDialogError: true,
        title: 'global_error'.tr,
        desc: exp.toString(),
      );
      AppError.handleError(exception: exp);
    }
  }

  void handleClaimButtonConfirmOnTap(AddressModel addressModel) async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      var privateKey = '';
      if (addressModel.privatekey.isNotEmpty) {
        privateKey = addressModel.privatekey;
      } else {
        privateKey = await _repo.getPrivateKey(
            derivationPath: addressModel.derivationPath,
            coinType: addressModel.coinType);
      }
      await _repo.createuserClaimTokenTransactionBinanceSmart(
        addressSender: addressModel.address,
        privateKey: privateKey,
        index: BigInt.from(idoProjectController.idoModel.index),
      );

      final coinModelResult = CoinModel.empty().copyWith(
        id: idoProjectController.idoModel.name.toLowerCase() +
            addressModel.blockChainId,
        contractAddress: idoProjectController.idoModel.address,
        symbol: idoProjectController.idoModel.symbol,
        name: idoProjectController.idoModel.name,
        type: 'Token Binance Smart Chain',
        blockchainId: addressModel.blockChainId,
        image: idoProjectController.idoModel.icon,
        decimals: idoProjectController.idoModel.decimal,
        isActive: true,
      );
      final indexExit = addressModel.coins.indexWhere((element) =>
          coinModelResult.contractAddress.toLowerCase() ==
          element.contractAddress.toLowerCase());
      if (indexExit == -1) {
        final index = _walletController.blockChains.indexWhere(
            (blockChain) => blockChain.id == addressModel.blockChainId);
        _walletController.blockChains[index].coinsAddLocalDatabase
            .add(coinModelResult.copyWith());
        _walletController.blockChains[index].coins
            .add(coinModelResult.copyWith());
        _walletController.blockChains[index].idOfCoinActives
            .insert(0, coinModelResult.id);
        _walletController.wallet.coinSorts
            .insert(0, coinModelResult.blockchainId + '+' + coinModelResult.id);
        for (var address in _walletController.blockChains[index].addresss) {
          address.coins.add(coinModelResult.copyWith());
        }
        await _walletController.updateWallet();
        await status.updateStatus(StateStatus.SUCCESS);
      } else {}
      await status.updateStatus(StateStatus.SUCCESS,
          showDialogSuccess: true,
          title: 'success_transaction'.tr,
          desc: 'success_claim_detail'.tr);

      try {
        if (Get.isDialogOpen!) {
          Get.back();
        }
      } catch (exp) {}
      try {
        if (Get.isSnackbarOpen!) {
          Get.back();
        }
      } catch (exp) {}
      try {
        if (Get.isBottomSheetOpen!) {
          Get.back();
        }
      } catch (exp) {}
      Get.back();
    } catch (exp) {
      await status.updateStatus(
        StateStatus.FAILURE,
        showDialogError: true,
        desc: exp.toString(),
        title: 'global_error'.tr,
      );
      AppError.handleError(exception: exp);
    }
  }
}
