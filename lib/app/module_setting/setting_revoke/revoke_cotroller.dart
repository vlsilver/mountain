import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/address_approve_list.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_setting/setting_revoke/pages/revoke_dialog_widget.dart';
import 'package:base_source/app/module_setting/setting_revoke/pages/revoke_page_detail.dart';
import 'package:base_source/app/module_setting/setting_revoke/pages/revoke_send_page.dart';
import 'package:base_source/app/module_setting/setting_revoke/revoke_repo.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/select_address/select_address_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

enum EnumUpdateRevokePage { TRANSACTION, ADDRESS_OF_COIN }

class RevokeController extends GetxController {
  double fee = 0.0;
  AddressModel? addressActiveInitial;
  final walletController = Get.find<WalletController>();
  final _repo = RevokeRepository();
  final state = Status();

  AddressModel getAddressModelActive() {
    AddressModel? addressResult;
    for (var blockChain in walletController.blockChains) {
      if (blockChain.id == BlockChainModel.ethereum ||
          blockChain.id == BlockChainModel.binanceSmart ||
          blockChain.id == BlockChainModel.polygon ||
          blockChain.id == BlockChainModel.kardiaChain) {
        for (var address in blockChain.addresss) {
          addressResult ??= address;
          if (address.coinOfBlockChain.value > BigInt.from(0)) {
            addressResult = address;
            break;
          }
        }
        if (addressResult!.coinOfBlockChain.value > BigInt.from(0)) {
          break;
        }
      }
    }
    return addressResult!;
  }

  List<BlockChainModel> get blockChainsSupport => walletController.blockChains
      .where(
        (element) =>
            element.id == BlockChainModel.binanceSmart ||
            element.id == BlockChainModel.ethereum ||
            element.id == BlockChainModel.polygon ||
            element.id == BlockChainModel.kardiaChain,
      )
      .toList();

  AddressModel get addressActive =>
      addressActiveInitial ?? getAddressModelActive();

  @override
  void onInit() {
    super.onInit();
  }

  void handleAddressActiveOnTap() async {
    final result = await Get.bottomSheet<AddressModel>(
        SelectAddressWidget(
          blockChains: blockChainsSupport,
          addressModel: addressActive,
        ),
        isScrollControlled: true);
    if (result != null) {
      if (result.address != addressActive.address ||
          result.blockChainId != addressActive.blockChainId) {
        addressActiveInitial = result;
        update([
          EnumUpdateRevokePage.ADDRESS_OF_COIN,
          EnumUpdateRevokePage.TRANSACTION
        ]);
      }
    }
  }

  void handleItemRevokeOnTap(
    RevokeData revokeData,
    CoinModel coinModel,
  ) {
    Get.to(() => RevokePageDetail(
          revokeData: revokeData,
          coinModel: coinModel,
          onTap: () {
            handleRevokeOnTap(coinModel, revokeData, true);
          },
        ));
  }

  void handleRevokeOnTap(
    CoinModel coinModel,
    RevokeData revokeData,
    bool isDetail,
  ) {
    Get.dialog(
      DialogWarningRevokeWidget(
          symbol: coinModel.symbol.isEmpty
              ? coinModel.contractAddress
              : coinModel.symbol,
          onTap: () {
            handleRevokeConfirmOnTap(
              revokeData: revokeData,
              isDetail: isDetail,
            );
          }),
      barrierDismissible: false,
    );
  }

  void handleCreateRevokeTransaction({
    required RevokeData revokeData,
    required bool isDetail,
  }) async {
    try {
      await state.updateStatus(StateStatus.LOADING);
      if (addressActive.coinOfBlockChain.value < Crypto().fee) {
        await state.updateStatus(StateStatus.FAILURE,
            showDialogError: true,
            title: 'global_error'.tr,
            desc: 'error_balance_not_enough'.tr);
        return;
      }
      switch (addressActive.blockChainId) {
        case BlockChainModel.ethereum:
          await createTransactionRevokeEthereum(revokeData: revokeData);
          break;
        case BlockChainModel.binanceSmart:
          await createTransactionRevokeBinanceSmart(revokeData: revokeData);
          break;
        case BlockChainModel.polygon:
          await createTransactionRevokePolygon(revokeData: revokeData);
          break;
        case BlockChainModel.kardiaChain:
          await createTransactionRevokeKardiaChain(revokeData: revokeData);
          break;
        default:
      }
      await state.updateStatus(StateStatus.SUCCESS,
          showDialogSuccess: true,
          title: 'success_transaction'.tr,
          desc: 'success_revoke_detail'.trParams({
            'symbol': addressActive
                .getCoinModelByAddressContract(revokeData.contracAddress)
                .copyWith(blockchainId: addressActive.blockChainId)
                .symbol
          }));
      addressActive.revokeDataList!.data
          .removeWhere((element) => element.hash == revokeData.hash);
      update([EnumUpdateRevokePage.TRANSACTION]);
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
      if (isDetail) {
        Get.back();
      }
    } catch (exp) {
      await state.updateStatus(
        StateStatus.FAILURE,
        showDialogError: true,
        title: 'global_error'.tr,
        desc: exp.toString(),
      );
      AppError.handleError(exception: exp);
    }
  }

  Future<void> createTransactionRevokeBinanceSmart(
      {required RevokeData revokeData}) async {
    var privateKey = '';
    if (addressActive.privatekey.isNotEmpty) {
      privateKey = addressActive.privatekey;
    } else {
      privateKey = await _repo.getPrivateKey(
          derivationPath: addressActive.derivationPath,
          coinType: addressActive.coinType);
    }
    await _repo.createApproveTransactionBinanceSmart(
        tokenContract: revokeData.contracAddress,
        addressOwner: addressActive.address,
        addressSender: revokeData.sender,
        privateKey: privateKey,
        amount: BigInt.from(0));
  }

  Future<void> createTransactionRevokeEthereum(
      {required RevokeData revokeData}) async {
    var privateKey = '';
    if (addressActive.privatekey.isNotEmpty) {
      privateKey = addressActive.privatekey;
    } else {
      privateKey = await _repo.getPrivateKey(
          derivationPath: addressActive.derivationPath,
          coinType: addressActive.coinType);
    }
    await _repo.createApproveTransactionEthereum(
        tokenContract: revokeData.contracAddress,
        addressOwner: addressActive.address,
        addressSender: revokeData.sender,
        privateKey: privateKey,
        amount: BigInt.from(0));
  }

  Future<void> createTransactionRevokePolygon(
      {required RevokeData revokeData}) async {
    var privateKey = '';
    if (addressActive.privatekey.isNotEmpty) {
      privateKey = addressActive.privatekey;
    } else {
      privateKey = await _repo.getPrivateKey(
          derivationPath: addressActive.derivationPath,
          coinType: addressActive.coinType);
    }
    await _repo.createApproveTransactionPolygon(
        tokenContract: revokeData.contracAddress,
        addressOwner: addressActive.address,
        addressSender: revokeData.sender,
        privateKey: privateKey,
        amount: BigInt.from(0));
  }

  Future<void> createTransactionRevokeKardiaChain(
      {required RevokeData revokeData}) async {
    var privateKey = '';
    if (addressActive.privatekey.isNotEmpty) {
      privateKey = addressActive.privatekey;
    } else {
      privateKey = await _repo.getPrivateKey(
          derivationPath: addressActive.derivationPath,
          coinType: addressActive.coinType);
    }
    await _repo.createApproveTransactionKardiaChain(
        tokenContract: revokeData.contracAddress,
        addressOwner: addressActive.address,
        addressSender: revokeData.sender,
        privateKey: privateKey,
        amount: BigInt.from(0));
  }

  Future<void> handleRevokeConfirmOnTap({
    required RevokeData revokeData,
    required bool isDetail,
  }) async {
    try {
      await state.updateStatus(StateStatus.LOADING);

      switch (addressActive.blockChainId) {
        case BlockChainModel.ethereum:
          fee = await _repo.calculatorFeeApproveEthereum(
              tokenContract: revokeData.contracAddress,
              addressOwner: addressActive.address,
              addressSender: revokeData.sender,
              amount: BigInt.from(0));
          break;
        case BlockChainModel.binanceSmart:
          fee = await _repo.calculatorFeeApproveBinanceSmart(
              tokenContract: revokeData.contracAddress,
              addressOwner: addressActive.address,
              addressSender: revokeData.sender,
              amount: BigInt.from(0));
          break;

        case BlockChainModel.polygon:
          fee = await _repo.calculatorFeeApprovePolygon(
              tokenContract: revokeData.contracAddress,
              addressOwner: addressActive.address,
              addressSender: revokeData.sender,
              amount: BigInt.from(0));
          break;
        case BlockChainModel.kardiaChain:
          fee = await _repo.calculatorFeeApproveKardiaChain(
              tokenContract: revokeData.contracAddress,
              addressOwner: addressActive.address,
              addressSender: revokeData.sender,
              amount: BigInt.from(0));
          break;
        default:
      }
      await state.updateStatus(StateStatus.SUCCESS);
      await Get.bottomSheet(
          RevokeSendTransactionPage(
            revokeData: revokeData,
            isDetail: isDetail,
          ),
          isScrollControlled: true);
    } catch (exp) {
      await state.updateStatus(StateStatus.FAILURE);
      Get.back();
      Get.snackbar('errorStr'.tr, exp.toString(),
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING,
          colorText: AppColorTheme.error,
          backgroundColor: AppColorTheme.backGround,
          duration: Duration(milliseconds: 1500));
      AppError.handleError(exception: exp);
    }
  }
}
