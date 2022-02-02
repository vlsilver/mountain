import 'package:base_source/app/widget_global/select_address/select_address_widget.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/module_setting/setting_history_transaction/settign_history_transaction_repo.dart';
import 'package:base_source/app/module_setting/setting_history_transaction/widget/transaction_not_full_information_widget.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';

import 'widget/transaction_full_information_widget.dart';

enum EnumUpdateHistoryTransaction { TRANSACTION, ADDRESS_OF_COIN }

class SettingHistoryTransactionController extends GetxController {
  SettingHistoryTransactionController({this.addressModel});

  final AddressModel? addressModel;
  late AddressModel? addressActiveInitial;

  final walletController = Get.find<WalletController>();
  final _repo = SettingHistoryTransactionRepository();
  final state = Status();
  int indexAddressActiveOfCoinModel = 0;

  @override
  void onInit() async {
    addressActiveInitial = addressModel;
    super.onInit();
  }

  bool get isOnlyOneAddressModel => addressModel != null;

  String get network => walletController.wallet
      .getNetworkByBlockChainId(addressActive.blockChainId);

  AddressModel get addressActive =>
      addressActiveInitial ?? walletController.addressActive;

  List<TransactionData> transactions() {
    if (addressActive.blockChainId == BlockChainModel.ethereum ||
        addressActive.blockChainId == BlockChainModel.binanceSmart ||
        addressActive.blockChainId == BlockChainModel.polygon) {
      final transactions = addressActive.allTransactions;
      var result = <TransactionData>[];

      for (var i = 0; i < transactions.length; i++) {
        if (i == transactions.length - 1) {
          result.add(transactions[i]);
          break;
        }
        if (transactions[i].nonce == transactions[i + 1].nonce) {
          if (transactions[i].contractAddress.isEmpty) {
            result.add(transactions[i + 1]);
            i = i + 1;
          } else if (transactions[i + 1].contractAddress.isEmpty) {
            result.add(transactions[i]);
            i = i + 1;
          } else {
            result.add(transactions[i]);
          }
        } else {
          result.add(transactions[i]);
        }
      }
      return result;
    } else {
      return addressActive.allTransactions;
    }
  }

  void handleAddressActiveOnTap() async {
    final result = await Get.bottomSheet<AddressModel>(
        SelectAddressWidget(
            blockChains: walletController.blockChains,
            addressModel: addressActive),
        isScrollControlled: true);
    if (result != null) {
      if (result.address != addressActive.address ||
          result.blockChainId != addressActive.blockChainId) {
        addressActiveInitial = result;
        update([
          EnumUpdateHistoryTransaction.ADDRESS_OF_COIN,
          EnumUpdateHistoryTransaction.TRANSACTION
        ]);
      }
    }
  }

  void handleTransactionItemOnTap({
    required TransactionData transaction,
    required AddressModel addressModel,
    required CoinModel coinModel,
  }) async {
    if (addressModel.blockChainId != BlockChainModel.stellar &&
        addressModel.blockChainId != BlockChainModel.piTestnet &&
        addressModel.blockChainId != BlockChainModel.stellar) {
      await Get.bottomSheet(
          TransactionFullInformationWidget(
            transaction: transaction,
            addressModel: addressModel,
            coinModel: coinModel,
            onTap: () {
              handleDetailTransaction(
                  addressModel.blockChainId, transaction.hash);
            },
          ),
          isScrollControlled: true);
    } else {
      await handleGetInformationTransaction(
          transaction: transaction, addressModel: addressModel);
      await Get.bottomSheet(
          TransactionNotFullInformationWidget(
            transaction: transaction,
            addressModel: addressModel,
            coinModel: coinModel,
            onTap: () {
              handleDetailTransaction(
                  addressModel.blockChainId, transaction.hash);
            },
          ),
          isScrollControlled: true);
    }
  }

  void handleButtonCloseOnTap() {
    Get.back();
  }

  Future<void> handleGetInformationTransaction(
      {required TransactionData transaction,
      required AddressModel addressModel}) async {
    try {
      await state.updateStatus(StateStatus.LOADING);
      await _repo.getInformationOTransaction(
          transaction: transaction, addressModel: addressModel);
      await state.updateStatus(StateStatus.SUCCESS);
    } catch (exp) {
      await state.updateStatus(StateStatus.FAILURE,
          showSnackbarError: true, desc: 'load_transaction_error'.tr);
      AppError.handleError(exception: exp);
    }
  }

  Future<void> handleDetailTransaction(String id, String hash) async {
    try {
      await state.updateStatus(StateStatus.LOADING);
      var url = '';
      switch (id) {
        case BlockChainModel.bitcoin:
          url = 'https://www.blockchain.com/btc/tx/$hash';
          break;
        case BlockChainModel.ethereum:
          url = 'https://etherscan.io/tx/$hash';
          break;
        case BlockChainModel.binanceSmart:
          url = 'https://bscscan.com/tx/$hash';
          break;
        case BlockChainModel.polygon:
          url = 'https://polygonscan.com/tx/$hash';
          break;
        case BlockChainModel.kardiaChain:
          url = 'https://explorer.kardiachain.io/tx/$hash';
          break;
        case BlockChainModel.stellar:
          url = 'https://stellar.expert/explorer/public/tx/$hash';
          break;
        case BlockChainModel.piTestnet:
          url = 'https://pi-blockchain.net/tx/$hash';
          break;
        case BlockChainModel.tron:
          url = 'https://tronscan.org/#/transaction/$hash';
          break;
        default:
      }
      if (await canLaunch(url)) {
        await state.updateStatus(StateStatus.SUCCESS);
        await launch(
          url,
          forceSafariVC: true,
          forceWebView: true,
          enableJavaScript: true,
        );
      } else {
        throw Exception();
      }
    } catch (exp) {
      await state.updateStatus(StateStatus.FAILURE,
          showSnackbarError: true, desc: 'load_transaction_error'.tr);
      AppError.handleError(exception: exp);
    }
  }
}
