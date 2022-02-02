import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/module_setting/setting_history_transaction/widget/transaction_not_full_information_widget.dart';
import 'package:base_source/app/module_setting/setting_history_transaction/widget/transaction_full_information_widget.dart';
import 'package:base_source/app/module_wallet/module_request_receive/pages/select_coin_page.dart';
import 'package:base_source/app/module_wallet/module_request_receive/request_receive_controller.dart';
import 'package:base_source/app/module_wallet/module_send/send_controller.dart';
import 'package:base_source/app/module_wallet/module_send/update_address_send/update_address_send_page.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_controller.dart';
import 'package:base_source/app/module_wallet/module_swap/update_address_swap/update_address_swap_page.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:base_source/app/widget_global/select_address/select_address_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:trust_wallet_core_plugin/trust_wallet_core_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import 'coin_detail_page.dart';
import 'history_transaction_repo.dart';

enum EnumUpdateHistoryTransactionCoin { TRANSACTION, APPBAR }

class HistoryTransactionCoinController extends GetxController {
  HistoryTransactionCoinController({
    required this.coinModelInit,
  });

  final status = Status();
  final scrollController = ScrollController();
  final walletController = Get.find<WalletController>();
  final _repo = HistoryTransactionRepository();
  final CoinModel coinModelInit;
  late AddressModel addressSelect;
  bool visibleAppBar = false;

  bool get supportSwap =>
      addressSelect.blockChainId == BlockChainModel.ethereum ||
      addressSelect.blockChainId == BlockChainModel.binanceSmart ||
      addressSelect.blockChainId == BlockChainModel.polygon ||
      addressSelect.blockChainId == BlockChainModel.kardiaChain;

  List<Color> get colorIconList => supportSwap
      ? [
          Color.fromRGBO(22, 146, 255, 1),
          Color(0xFFFFD06E),
          Color.fromRGBO(79, 191, 193, 1),
          Color.fromRGBO(79, 191, 193, 1),
        ]
      : [
          Color.fromRGBO(22, 146, 255, 1),
          Color(0xFFFFD06E),
          Color.fromRGBO(79, 191, 193, 1),
        ];

  List<dynamic> get icons => supportSwap
      ? [
          Icons.save_alt,
          Icons.file_copy_rounded,
          Icons.north_east,
          'assets/global/ic_swap.svg'
        ]
      : [
          Icons.save_alt,
          Icons.file_copy_rounded,
          Icons.north_east,
        ];

  @override
  void onInit() async {
    addressSelect = addressAvailableOfCoinModel;
    super.onInit();
  }

  List<TransactionData> transactions() {
    if (addressSelect.blockChainId != BlockChainModel.kardiaChain) {
      return addressSelect.allTransactions
          .where((transaction) =>
              transaction.contractAddress == coinModelSelect.contractAddress)
          .toList();
    } else {
      if (coinModelSelect.contractAddress.isEmpty) {
        return addressSelect.allTransactions;
      } else {
        var transactions = <TransactionData>[];
        for (var transaction in addressSelect.allTransactions) {
          if (transaction.to == coinModelSelect.contractAddress) {
            final data = TrustWalletCorePlugin.decodeTransfer(
                data: transaction.confirmations);
            if (data != null) {
              transactions.add(transaction.copyWith(
                  to: data['recipient'],
                  contractAddress: coinModelSelect.contractAddress,
                  value: (data['value'] as BigInt).toDouble()));
            }
          } else if (transaction.contractAddress ==
              coinModelSelect.contractAddress) {
            transactions.add(transaction);
          }
        }
        return transactions;
      }
    }
  }

  CoinModel get coinModelSelect => addressSelect.coins
      .firstWhere((element) => element.id == coinModelInit.id);

  bool get isStellarChain =>
      coinModelSelect.blockchainId == BlockChainModel.stellar ||
      coinModelSelect.blockchainId == BlockChainModel.piTestnet &&
          coinModelSelect.value == BigInt.from(0);

  String get network => coinModelSelect.blockChainOfCoin().network;

  @override
  void onReady() async {
    await Future.delayed(Duration(milliseconds: 500));
    scrollController.addListener(() {
      if (scrollController.offset > Get.width / 2 * 0.55 + 64.0 &&
          !visibleAppBar) {
        visibleAppBar = true;
        update([EnumUpdateHistoryTransactionCoin.APPBAR]);
      } else if (scrollController.offset <= Get.width / 2 * 0.55 + 64.0 &&
          visibleAppBar) {
        visibleAppBar = false;
        update([EnumUpdateHistoryTransactionCoin.APPBAR]);
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.onClose();
  }

  void handleItemFeatureOnTap({required int index}) async {
    switch (index) {
      case 0:
        final result = Get.put(RequestRecieveController());
        result.setData(
          coin: coinModelSelect,
          address: addressSelect,
          isBack: false,
        );
        await Get.bottomSheet(
            ReceiveNavigatorPage(
              initialPage: AppRoutes.REQUEST_RECIEVE_SIMPLE,
            ),
            isScrollControlled: true);
        await Get.delete<RequestRecieveController>();
        break;
      case 1:
        await handleIconCopyOntap();
        break;
      case 2:
        final sendController = Get.put(SendController());
        sendController.setData(
          coinModel: coinModelSelect,
          addressModel: addressSelect,
          blockChain: blockChainOfCoinModel,
        );
        await Get.bottomSheet(SendNavigatorPage(isFullScreen: false),
            isScrollControlled: true);
        await Get.delete<SendController>();
        break;
      case 3:
        final swapController = Get.put(SwapController());
        swapController.setData(
          coinModelSelect: coinModelSelect,
          addressModel: addressSelect,
          blockChain: blockChainOfCoinModel,
        );
        await Get.bottomSheet(
          SwapNavigatorPage(
            isFullScreen: false,
            isFast: true,
          ),
          isScrollControlled: true,
        );
        swapController.isAutoGetAmount = false;
        await Get.delete<SwapController>();
        break;
      default:
    }
  }

  BlockChainModel get blockChainOfCoinModel => walletController
      .wallet.blockChains
      .firstWhere((blockChain) => blockChain.id == coinModelInit.blockchainId);

  List<AddressModel> addresssOfCoinModel() {
    return blockChainOfCoinModel.addresss;
  }

  AddressModel get addressAvailableOfCoinModel =>
      addresssOfCoinModel().firstWhere(
          (addressModel) =>
              addressModel.coins
                  .firstWhere((coin) => coin.id == coinModelInit.id)
                  .value >
              BigInt.from(0),
          orElse: () => addresssOfCoinModel()[0]);

  void handleAddressActiveOnTap() async {
    final result = await Get.bottomSheet<AddressModel>(
        SelectAddressWidget(
          blockChains: [blockChainOfCoinModel],
          addressModel: addressSelect,
        ),
        isScrollControlled: true);

    if (result != null) {
      if (result.address != addressSelect.address ||
          result.blockChainId != addressSelect.blockChainId) {
        addressSelect = result;
        update([EnumUpdateHistoryTransactionCoin.TRANSACTION]);
      }
    }
  }

  Future<void> handleIconCopyOntap() async {
    await Clipboard.setData(ClipboardData(text: addressSelect.address));
    await status.updateStatus(StateStatus.SUCCESS,
        showSnackbarSuccess: true,
        isBack: false,
        desc: 'Address: ${addressSelect.address}'.tr);
  }

  void handleTransactionItemOnTap({
    required TransactionData transaction,
    required AddressModel addressModel,
    required CoinModel coinModel,
  }) async {
    if (addressModel.blockChainId != BlockChainModel.stellar &&
        addressModel.blockChainId != BlockChainModel.piTestnet &&
        addressModel.blockChainId != BlockChainModel.tron) {
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

  Future<void> handleGetInformationTransaction(
      {required TransactionData transaction,
      required AddressModel addressModel}) async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      await _repo.getInformationOTransaction(
          transaction: transaction, addressModel: addressModel);
      await status.updateStatus(StateStatus.SUCCESS);
    } catch (exp) {
      await status.updateStatus(StateStatus.FAILURE,
          showSnackbarError: true, desc: 'load_transaction_error'.tr);
      AppError.handleError(exception: exp);
    }
  }

  Future<void> handleDetailTransaction(String id, String hash) async {
    try {
      await status.updateStatus(StateStatus.LOADING);
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
        await status.updateStatus(StateStatus.SUCCESS);
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
      await status.updateStatus(StateStatus.FAILURE,
          showSnackbarError: true, desc: 'load_transaction_error'.tr);
      AppError.handleError(exception: exp);
    }
  }

  Future<void> handleDetailCoin(String id, String contract) async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      var url = '';
      switch (id) {
        case BlockChainModel.ethereum:
          url = 'https://etherscan.io/token/$contract';
          break;
        case BlockChainModel.binanceSmart:
          url = 'https://bscscan.com/token/$contract';
          break;
        case BlockChainModel.polygon:
          url = 'https://polygonscan.com/token/$contract';
          break;
        case BlockChainModel.kardiaChain:
          url = 'https://explorer.kardiachain.io/token/$contract';
          break;
        case BlockChainModel.tron:
          url = 'https://tronscan.org/#/token20/$contract';
          break;
        default:
      }
      if (await canLaunch(url)) {
        await status.updateStatus(StateStatus.SUCCESS);
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
      await status.updateStatus(StateStatus.FAILURE,
          showSnackbarError: true, desc: 'request_failure'.tr);
      AppError.handleError(exception: exp);
    }
  }

  Future<void> handleIconCopyContractAddressOntap() async {
    await Clipboard.setData(
        ClipboardData(text: coinModelSelect.contractAddress));
    await status.updateStatus(StateStatus.SUCCESS,
        showSnackbarSuccess: true,
        isBack: false,
        desc: 'Contract: ${coinModelSelect.contractAddress}');
  }

  void handleAvatarCoinOnTap(CoinModel coinModel) async {
    await Get.bottomSheet(CoinDetailPage(coinModel: coinModel),
        isScrollControlled: true);
  }
}
