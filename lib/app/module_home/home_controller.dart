import 'dart:async';

import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/data/models/local_model/address_approve_list.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_pendding.dart';
import 'package:base_source/app/module_account/account_page.dart';
import 'package:base_source/app/module_dashboard/dashboard_page.dart';
import 'package:base_source/app/module_markets/pages/markets_page.dart';
import 'package:base_source/app/module_setting/setting_page.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/module_wallet/wallet_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:trust_wallet_core_plugin/trust_wallet_core_plugin.dart';

import 'home_repo.dart';

enum EnumUpdateHome { BOTTOM_BAR }

class HomeController extends GetxController {
  late final WalletController _walletController;
  final _repo = HomeRepository();

  List<Widget> get pages => const [
        WalletPage(),
        MarketsPage(),
        AccountPage(),
        SettingPage(),
        DashBoardPage(),
      ];

  List<String> bottomBarAssetActive = [
    AppAssets.icBottomBarWallet,
    AppAssets.icBottomBarMarket,
    AppAssets.icBottomBarAccount,
    AppAssets.icBottomBarSetting
  ];

  late final Stream<bool> streamCurrency;
  late final Stream<AddressModel> streamTransactionEthereum;
  late final Stream<AddressModel> streamTransactionBianance;
  late final Stream<AddressModel> streamTransactionPolygon;
  late final Stream<AddressModel> streamTransactionBitcoin;
  late final Stream<AddressModel> streamBalanceKardiaChain;
  late final Stream<AddressModel> stramBalanceStellar;
  late final Stream<AddressModel> stramBalancePiTestnet;
  late final Stream<AddressModel> streamBalanceTron;
  late final StreamSubscription<bool> streamSubscriptionCurrency;
  late final StreamSubscription<AddressModel>
      streamSubscriptionTransactionEthereum;
  late final StreamSubscription<AddressModel>
      streamSubscriptionTransactionBinance;
  late final StreamSubscription<AddressModel>
      streamSubscriptionTransactionPolygon;
  late final StreamSubscription<AddressModel>
      streamSubscriptionTransactionBitcoin;
  late final StreamSubscription<AddressModel> streamSubscriptionKardiaChain;
  late final StreamSubscription<AddressModel> streamSubscriptionStellar;
  late final StreamSubscription<AddressModel> streamSubscriptionPiTestnet;
  late final StreamSubscription<AddressModel> streamSubscriptionTron;
  bool get getAuto => _walletController.autoStream;
  final PageController pageController = PageController(initialPage: 0);

  final status = Status();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    await Future.delayed(Duration(milliseconds: 200));
    _walletController = Get.find<WalletController>();
    _walletController.autoStream = true;
    await _walletController.getWalletData();
    streamCurrency = updateAutoCurrency();
    streamTransactionBitcoin = checkNewTransactionBitcoin();
    streamTransactionEthereum = checkNewBalanceEthereum();
    streamTransactionBianance = checkNewBalanceBinance();
    streamTransactionPolygon = checkNewBalancePolygon();
    streamBalanceTron = checkNewTransactionTronChain();
    streamBalanceKardiaChain = checkBalanceOfKardiaChain();
    stramBalanceStellar = checkBalanceOfStellarChain();
    stramBalancePiTestnet = checkBalanceOfPiTestnet();

    streamSubscriptionCurrency = streamCurrency.listen((isSuccess) {
      if (isSuccess) {
        _walletController.update([
          EnumUpdateWallet.CURRENCY_ACTIVE,
          EnumUpdateWallet.CURRENCY_ONLY,
        ]);
      }
    });
    streamSubscriptionTransactionBitcoin =
        streamTransactionBitcoin.listen((addressModel) {
      _updateNotification(addressModel);
    });
    streamSubscriptionTransactionEthereum =
        streamTransactionEthereum.listen((addressModel) {
      _updateNotification(addressModel);
    });

    streamSubscriptionTransactionBinance =
        streamTransactionBianance.listen((addressModel) {
      _updateNotification(addressModel);
    });

    streamSubscriptionTransactionPolygon =
        streamTransactionPolygon.listen((addressModel) {
      _updateNotification(addressModel);
    });

    streamSubscriptionKardiaChain =
        streamBalanceKardiaChain.listen((addressModel) {
      _updateNotification(addressModel);
    });

    streamSubscriptionStellar = stramBalanceStellar.listen((addressModel) {
      _updateNotification(addressModel);
    });

    streamSubscriptionPiTestnet = stramBalancePiTestnet.listen((addressModel) {
      _updateNotification(addressModel);
    });

    streamSubscriptionTron = streamBalanceTron.listen((addressModel) {
      _updateNotification(addressModel);
    });

    super.onReady();
  }

  void _updateNotification(AddressModel addressModel) {
    final blockChainId = addressModel.blockChainId;
    final network =
        _walletController.wallet.getNetworkByBlockChainId(blockChainId);
    Get.snackbar('noti_new_transaction'.tr, '$network - ${addressModel.name}',
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        colorText: AppColorTheme.accent,
        backgroundColor: AppColorTheme.backGround,
        duration: Duration(milliseconds: 1500));
    _walletController.notiTransactions.add(addressModel);
    _walletController.update([EnumUpdateWallet.NOTIFICATION]);
  }

  // void _popupGetDataFailure(String blockChainId) {
  //   final network =
  //       _walletController.wallet.getNetworkByBlockChainId(blockChainId);
  //   Get.snackbar('load_data_error'.tr, network,
  //       snackPosition: SnackPosition.TOP,
  //       snackStyle: SnackStyle.FLOATING,
  //       colorText: AppColorTheme.accent,
  //       backgroundColor: AppColorTheme.backGround,
  //       duration: Duration(milliseconds: 1500));
  // }

  @override
  void onClose() async {
    await streamSubscriptionCurrency.cancel();
    await streamSubscriptionTransactionEthereum.cancel();
    await streamSubscriptionTransactionBinance.cancel();
    await streamSubscriptionTransactionBitcoin.cancel();
    await streamSubscriptionKardiaChain.cancel();
    await streamSubscriptionStellar.cancel();
    await streamSubscriptionPiTestnet.cancel();
    await streamSubscriptionTron.cancel();
    super.onClose();
  }

  /// update currency each 2s
  Stream<bool> updateAutoCurrency() async* {
    while (getAuto) {
      try {
        final data = await _repo
            .getCoinsExchangeAndPrice(_walletController.wallet.allCoinIds());
        Crypto().priceAndExchange = data;
        _walletController.update([
          EnumUpdateWallet.CURRENCY_ACTIVE,
          EnumUpdateWallet.CURRENCY_ONLY,
        ]);
        final dataVNDC = await _repo.getVIDBANDLTDPriceAndExchange();
        Crypto().priceAndExchange.addAll(dataVNDC);
        yield true;
        await Future.delayed(Duration(seconds: 4));
      } catch (exp) {
        AppError.handleError(exception: exp);
        await Future.delayed(Duration(seconds: 5));
        yield false;
      }
    }
  }

  Stream<AddressModel> checkNewBalanceEthereum() async* {
    var indexOfBlockChain = _walletController.blockChains
        .indexWhere((element) => element.id == BlockChainModel.ethereum);
    if (indexOfBlockChain != -1) {
      while (getAuto) {
        try {
          for (var addressModel
              in _walletController.blockChains[indexOfBlockChain].addresss) {
            await for (var coin in Stream.fromIterable(addressModel.coins)) {
              if (_walletController
                      .blockChains[indexOfBlockChain].idOfCoinActives
                      .contains(coin.id) ||
                  coin.contractAddress.isEmpty) {
                final value = await _repo.getBalanceEthereum(
                    coin: coin, address: addressModel.address);
                final oldCoinValue = coin.value;
                coin.value = value;
                if (oldCoinValue != value) {
                  _walletController.update([
                    EnumUpdateWallet.CURRENCY_ACTIVE,
                    EnumUpdateWallet.CURRENCY_ONLY,
                  ]);
                  final transactionsJson = await _repo.getTransactionsEthereum(
                      addressModel: addressModel);
                  final haveNoTransaction = addressModel.transactions.isEmpty;
                  final haveNewTransaction = transactionsJson[0]['hash'] !=
                      addressModel.transactionLatest;
                  if (transactionsJson.isNotEmpty &&
                      (addressModel.transactionLatest.isEmpty ||
                          haveNoTransaction ||
                          haveNewTransaction)) {
                    final transactionsAddress = await compute(
                        parseJsonToTransactionDataEthereum, transactionsJson);
                    addressModel.transactions = transactionsAddress;
                    _walletController.update([
                      EnumUpdateWallet.CURRENCY_ACTIVE,
                      EnumUpdateWallet.CURRENCY_ONLY,
                    ]);
                    if (!(haveNoTransaction && !haveNewTransaction)) {
                      yield addressModel;
                    }
                    addressModel.transactionLatest =
                        transactionsJson[0]['hash'];
                    await _walletController.updateWallet();
                    await scanTransationPendding(
                        addressModel, transactionsAddress);
                    scanRevokeDataForEthereumAddressModel(addressModel);
                  }
                }
              }
              await Future.delayed(Duration(milliseconds: 200));
            }
          }
        } catch (exp) {
          print(
              '---------------------checkNewBalanceEthereum---------------------');
          AppError.handleError(exception: exp);
          print(
              '---------------------checkNewBalanceEthereum---------------------');
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    }
  }

  Stream<AddressModel> checkNewBalanceBinance() async* {
    var indexOfBlockChain = _walletController.blockChains
        .indexWhere((element) => element.id == BlockChainModel.binanceSmart);
    if (indexOfBlockChain != -1) {
      while (getAuto) {
        try {
          for (var addressModel
              in _walletController.blockChains[indexOfBlockChain].addresss) {
            await for (var coin in Stream.fromIterable(addressModel.coins)) {
              if (_walletController
                      .blockChains[indexOfBlockChain].idOfCoinActives
                      .contains(coin.id) ||
                  coin.contractAddress.isEmpty) {
                final value = await _repo.getBalanceBinance(
                    coin: coin, address: addressModel.address);
                final oldCoinValue = coin.value;
                coin.value = value;
                if (oldCoinValue != value) {
                  _walletController.update([
                    EnumUpdateWallet.CURRENCY_ACTIVE,
                    EnumUpdateWallet.CURRENCY_ONLY,
                  ]);

                  final transactionsJson = await _repo.getTransactionsBinance(
                      addressModel: addressModel);
                  final haveNoTransaction = addressModel.transactions.isEmpty;
                  final haveNewTransaction = transactionsJson[0]['hash'] !=
                      addressModel.transactionLatest;
                  // var transactionCheckRaw = TransactionData.empty();
                  // var haveNewTransactionRawData = false;
                  // if (!haveNewTransaction) {
                  //   print('---------------------1111---------------------');
                  //   print(1111);
                  //   print('---------------------1111----------------------');
                  //   final transactionLatestCheckRaw =
                  //       await _repo.getTransactionBinanceLatest(
                  //           address: addressModel.address);
                  //   if (transactionLatestCheckRaw.hash !=
                  //           addressModel.transactionLatest &&
                  //       transactionLatestCheckRaw.hash.isNotEmpty) {
                  //     transactionCheckRaw = transactionLatestCheckRaw;
                  //     haveNewTransactionRawData = true;
                  //   }
                  // }
                  if (transactionsJson.isNotEmpty &&
                      (addressModel.transactionLatest.isEmpty ||
                          haveNoTransaction ||
                          haveNewTransaction)) {
                    final transactionsAddress = await compute(
                        parseJsonToTransactionDataEthereum, transactionsJson);
                    // if (haveNewTransactionRawData) {
                    //   transactionsAddress.insert(0, transactionCheckRaw);
                    // }
                    addressModel.transactions = transactionsAddress;
                    _walletController.update([
                      EnumUpdateWallet.CURRENCY_ACTIVE,
                      EnumUpdateWallet.CURRENCY_ONLY,
                    ]);
                    if (!(haveNoTransaction && !haveNewTransaction)) {
                      yield addressModel;
                    }
                    addressModel.transactionLatest =
                        transactionsJson[0]['hash'];
                    await _walletController.updateWallet();
                    await scanTransationPendding(
                        addressModel, transactionsAddress);
                    scanRevokeDataForBinanceAddressModel(addressModel);
                  }
                }
              }
              await Future.delayed(Duration(milliseconds: 500));
            }
          }
        } catch (exp) {
          print(
              '---------------------checkNewBalanceBinance---------------------');
          AppError.handleError(exception: exp);
          print(
              '---------------------checkNewBalanceBinance---------------------');
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    }
  }

  Stream<AddressModel> checkNewBalancePolygon() async* {
    var indexOfBlockChain = _walletController.blockChains
        .indexWhere((element) => element.id == BlockChainModel.polygon);
    if (indexOfBlockChain != -1) {
      while (getAuto) {
        try {
          for (var addressModel
              in _walletController.blockChains[indexOfBlockChain].addresss) {
            await for (var coin in Stream.fromIterable(addressModel.coins)) {
              if (_walletController
                      .blockChains[indexOfBlockChain].idOfCoinActives
                      .contains(coin.id) ||
                  coin.contractAddress.isEmpty) {
                final value = await _repo.getBalancePolygon(
                    coin: coin, address: addressModel.address);
                final oldCoinValue = coin.value;
                coin.value = value;
                if (oldCoinValue != value) {
                  _walletController.update([
                    EnumUpdateWallet.CURRENCY_ACTIVE,
                    EnumUpdateWallet.CURRENCY_ONLY,
                  ]);
                  await Future.delayed(Duration(milliseconds: 200));
                  final transactionsJson = await _repo.getTransactionsPolygon(
                      addressModel: addressModel);
                  final haveNoTransaction = addressModel.transactions.isEmpty;
                  final haveNewTransaction = transactionsJson[0]['hash'] !=
                      addressModel.transactionLatest;
                  if (transactionsJson.isNotEmpty &&
                      (addressModel.transactionLatest.isEmpty ||
                          haveNoTransaction ||
                          haveNewTransaction)) {
                    final transactionsAddress = await compute(
                        parseJsonToTransactionDataEthereum, transactionsJson);
                    addressModel.transactions = transactionsAddress;
                    _walletController.update([
                      EnumUpdateWallet.CURRENCY_ACTIVE,
                      EnumUpdateWallet.CURRENCY_ONLY,
                    ]);
                    if (!(haveNoTransaction && !haveNewTransaction)) {
                      yield addressModel;
                    }
                    addressModel.transactionLatest =
                        transactionsJson[0]['hash'];
                    await _walletController.updateWallet();
                    await scanTransationPendding(
                        addressModel, transactionsAddress);
                    scanRevokeDataForPolygonAddressModel(addressModel);
                  }
                }
              }
              await Future.delayed(Duration(milliseconds: 1000));
            }
          }
        } catch (exp) {
          print(
              '---------------------checkNewBalancePolygon---------------------');
          AppError.handleError(exception: exp);
          print(
              '---------------------checkNewBalancePolygon---------------------');
          await Future.delayed(Duration(milliseconds: 2000));
        }
      }
    }
  }

  Stream<AddressModel> checkBalanceOfKardiaChain() async* {
    var index = -1;
    var indexOfBlockChain = _walletController.blockChains
        .indexWhere((element) => element.id == BlockChainModel.kardiaChain);
    if (indexOfBlockChain != -1) {
      while (getAuto) {
        index++;
        try {
          for (var addressModel
              in _walletController.blockChains[indexOfBlockChain].addresss) {
            await for (var coin in Stream.fromIterable(addressModel.coins)) {
              if (_walletController
                      .blockChains[indexOfBlockChain].idOfCoinActives
                      .contains(coin.id) ||
                  coin.contractAddress.isEmpty) {
                final balance = await _repo.getBalanceKardiaChain(
                  address: addressModel.address,
                  coinModel: coin,
                );
                if (balance != coin.value) {
                  coin.value = balance;
                  _walletController.update([
                    EnumUpdateWallet.CURRENCY_ACTIVE,
                    EnumUpdateWallet.CURRENCY_ONLY,
                  ]);
                  if (index != 0) {
                    final transactionLatest =
                        await _repo.getTransactionKardiaChainLatest(
                            address: addressModel.address);
                    if ((addressModel.transactions.isEmpty &&
                            transactionLatest.hash.isNotEmpty) ||
                        (transactionLatest.hash.isNotEmpty &&
                            transactionLatest.hash !=
                                addressModel.transactions[0].hash)) {
                      addressModel.transactions.insert(0, transactionLatest);
                      addressModel.transactionLatest = transactionLatest.hash +
                          '-' +
                          addressModel.transactionLatest;
                      scanRevokeDataForKardiaChainAddressModel(addressModel);
                      addressModel.transactionPending = <TransactionData>[];
                      await _repo.saveDataToLocal(
                          key: addressModel.keyOfTransactionPending,
                          data: TransactionPenddingData(
                                  data: addressModel.transactionPending)
                              .toJson());
                      await _walletController.updateWallet();
                      yield addressModel;
                    }
                  } else {
                    if (addressModel.transactionLatest.isNotEmpty ||
                        addressModel.transactionPending.isNotEmpty) {
                      await _walletController.updateWallet();
                      for (var transaction in addressModel.transactionPending) {
                        addressModel.transactionLatest = transaction.hash +
                            '-' +
                            addressModel.transactionLatest;
                      }
                      addressModel.transactionPending = <TransactionData>[];
                      await _repo.saveDataToLocal(
                          key: addressModel.keyOfTransactionPending,
                          data: TransactionPenddingData(
                                  data: addressModel.transactionPending)
                              .toJson());
                      final transactionsLocal =
                          addressModel.transactionLatest.split('-');
                      var transactionsResult = <TransactionData>[];
                      var i = 0;
                      await for (var data
                          in Stream.fromIterable(transactionsLocal)) {
                        i++;
                        if (data.isNotEmpty) {
                          try {
                            final transaction = await _repo
                                .getTransactionKardiaChainByHash(hash: data);
                            transactionsResult.add(transaction);
                          } catch (exp) {}
                          if (i == 10) {
                            break;
                          }
                        }
                      }
                      addressModel.transactions = transactionsResult;
                      scanRevokeDataForKardiaChainAddressModel(addressModel);
                    }
                  }
                }
              }
            }
            await Future.delayed(Duration(milliseconds: 200));
          }
        } catch (exp) {
          // _popupGetDataFailure(BlockChainModel.kardiaChain);
          print(
              '---------------------checkBalanceOfKardiaChain---------------------');
          AppError.handleError(exception: exp);
          print(
              '---------------------checkBalanceOfKardiaChain---------------------');
          await Future.delayed(Duration(seconds: 1));
        }
      }
    }
  }

  Stream<AddressModel> checkNewTransactionTronChain() async* {
    var indexOfBlockChain = _walletController.blockChains
        .indexWhere((element) => element.id == BlockChainModel.tron);
    while (getAuto) {
      try {
        if (indexOfBlockChain != -1) {
          for (var addressModel
              in _walletController.blockChains[indexOfBlockChain].addresss) {
            final transactionsJson =
                await _repo.getTransactionsTronAll(addressModel: addressModel);
            final transactions = await compute(
                parseJsonToTransactionDataTronAll, transactionsJson);
            if (transactions.isNotEmpty &&
                (addressModel.transactionLatest.isEmpty ||
                    transactions[0].hash != addressModel.transactionLatest)) {
              final balances =
                  await _repo.getBalanceTron(address: addressModel.address);
              if (balances.isNotEmpty) {
                for (var coin in addressModel.coins) {
                  if (balances[coin.contractAddress] != null) {
                    final balance = balances[coin.contractAddress]!;
                    if (coin.value != balance) {
                      coin.value = balance;
                      _walletController.update([
                        EnumUpdateWallet.CURRENCY_ACTIVE,
                        EnumUpdateWallet.CURRENCY_ONLY,
                      ]);
                    }
                  }
                }
              }
              for (var transaction in transactions) {
                transaction.from = await TrustWalletCorePlugin.base58Encode(
                    addressHexString: transaction.from);
                transaction.to = await TrustWalletCorePlugin.base58Encode(
                    addressHexString: transaction.to);
              }
              addressModel.transactions = transactions;
              final transactionsJsonTRC20 = await _repo
                  .getTransactionsTronTRC20(addressModel: addressModel);
              final transactionsTRC20 = await compute(
                  parseJsonToTransactionDataTronTRC20, transactionsJsonTRC20);
              addressModel.transactions.addAll(transactionsTRC20);
              addressModel.transactionLatest = (transactions[0].hash);
              await scanTransationPendding(
                  addressModel, addressModel.transactions);
              await _walletController.updateWallet();
              yield addressModel;
            } else if (addressModel.transactions.isEmpty &&
                transactionsJson.isNotEmpty) {
              final balances =
                  await _repo.getBalanceTron(address: addressModel.address);
              if (balances.isNotEmpty) {
                for (var coin in addressModel.coins) {
                  if (balances[coin.contractAddress] != null) {
                    final balance = balances[coin.contractAddress]!;
                    if (coin.value != balance) {
                      coin.value = balance;
                      _walletController.update([
                        EnumUpdateWallet.CURRENCY_ACTIVE,
                        EnumUpdateWallet.CURRENCY_ONLY,
                      ]);
                    }
                  }
                }
              }
              final transactions = await compute(
                  parseJsonToTransactionDataTronAll, transactionsJson);
              for (var transaction in transactions) {
                transaction.from = await TrustWalletCorePlugin.base58Encode(
                    addressHexString: transaction.from);
                transaction.to = await TrustWalletCorePlugin.base58Encode(
                    addressHexString: transaction.to);
              }
              addressModel.transactions = transactions;
              final transactionsJsonTRC20 = await _repo
                  .getTransactionsTronTRC20(addressModel: addressModel);
              final transactionsTRC20 = await compute(
                  parseJsonToTransactionDataTronTRC20, transactionsJsonTRC20);
              addressModel.transactions.addAll(transactionsTRC20);
              await scanTransationPendding(
                  addressModel, addressModel.transactions);
            }
            await Future.delayed(Duration(milliseconds: 1000));
          }
        } else {
          throw Exception();
        }
      } catch (exp) {
        // _popupGetDataFailure(BlockChainModel.tron);
        print('---------------------tron---------------------');
        AppError.handleError(exception: exp);
        print('---------------------tron----------------------');
        await Future.delayed(Duration(seconds: 1));
      }
    }
  }

  Stream<AddressModel> checkNewTransactionBitcoin() async* {
    var indexOfBlockChain = _walletController.blockChains
        .indexWhere((element) => element.id == BlockChainModel.bitcoin);
    while (getAuto) {
      try {
        if (indexOfBlockChain != -1) {
          for (var addressModel
              in _walletController.blockChains[indexOfBlockChain].addresss) {
            final transactions = await _repo.getTransactionsBitcoin(
                address: addressModel.address);
            var transactionsLatest = '';
            var status = false;
            if (transactions.isNotEmpty) {
              transactionsLatest = transactions[0]['txid'];
              status = transactions[0]['status']['confirmed'];
            }
            if (transactionsLatest.isNotEmpty &&
                status &&
                (addressModel.transactionLatest.isEmpty ||
                    transactionsLatest != addressModel.transactionLatest)) {
              addressModel.coinOfBlockChain.value =
                  await _repo.getBalanceBitcoin(address: addressModel.address);
              addressModel.transactionLatest = transactionsLatest;
              await _walletController.updateWallet();
              final transactionsAddress = await compute(
                  parseJsonToTransactionDataBitcoin,
                  [transactions, addressModel.address]);

              addressModel.transactions = transactionsAddress;
              await scanTransationPendding(addressModel, transactionsAddress);
              _walletController.update([
                EnumUpdateWallet.CURRENCY_ACTIVE,
                EnumUpdateWallet.CURRENCY_ONLY,
              ]);
              yield addressModel;
            } else if (addressModel.transactions.isEmpty &&
                transactions.isNotEmpty) {
              addressModel.coinOfBlockChain.value =
                  await _repo.getBalanceBitcoin(address: addressModel.address);
              final transactionsAddress = await compute(
                  parseJsonToTransactionDataBitcoin,
                  [transactions, addressModel.address]);
              addressModel.transactions = transactionsAddress;
              await scanTransationPendding(addressModel, transactionsAddress);
              _walletController.update([
                EnumUpdateWallet.CURRENCY_ACTIVE,
                EnumUpdateWallet.CURRENCY_ONLY,
              ]);
            }
            await Future.delayed(Duration(milliseconds: 1000));
          }
        } else {
          throw Exception();
        }
      } catch (exp) {
        // _popupGetDataFailure(BlockChainModel.bitcoin);
        print('---------------------Bitcoin---------------------');
        AppError.handleError(exception: exp);
        print('---------------------Bitcoin----------------------');
        await Future.delayed(Duration(seconds: 1));
      }
    }
  }

  Stream<AddressModel> checkBalanceOfStellarChain() async* {
    var index = -1;
    var indexOfBlockChain = _walletController.blockChains
        .indexWhere((element) => element.id == BlockChainModel.stellar);
    while (getAuto) {
      index++;
      try {
        if (indexOfBlockChain != -1) {
          for (var addressModel
              in _walletController.blockChains[indexOfBlockChain].addresss) {
            final balance =
                await _repo.getBalanceStellar(address: addressModel.address);
            await scanTransationPendding(
                addressModel, addressModel.transactions);
            if (balance != addressModel.coinOfBlockChain.value) {
              addressModel.coinOfBlockChain.value = balance;
              _walletController.update([
                EnumUpdateWallet.CURRENCY_ACTIVE,
                EnumUpdateWallet.CURRENCY_ONLY,
              ]);
              if (index != 0) {
                final transactions = await _repo.getTransactionStellar(
                    address: addressModel.address);
                if (transactions.isNotEmpty) {
                  addressModel.transactions = transactions;
                  addressModel.transactionLatest = transactions[0].hash;
                  await _walletController.updateWallet();
                }

                yield addressModel;
              } else {
                final transactions = await _repo.getTransactionStellar(
                    address: addressModel.address);
                if (transactions.isNotEmpty) {
                  addressModel.transactions = transactions;
                  addressModel.transactionLatest = transactions[0].hash;
                  await _walletController.updateWallet();
                }
              }
            }
            await Future.delayed(Duration(milliseconds: 1000));
          }
        } else {
          throw Exception();
        }
      } catch (exp) {
        // _popupGetDataFailure(BlockChainModel.stellar);
        print(
            '---------------------checkBalanceOfStellarChain---------------------');
        AppError.handleError(exception: exp);
        print(
            '---------------------checkBalanceOfStellarChain----------------------');
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  Stream<AddressModel> checkBalanceOfPiTestnet() async* {
    var index = -1;
    var indexOfBlockChain = _walletController.blockChains
        .indexWhere((element) => element.id == BlockChainModel.piTestnet);
    while (getAuto) {
      index++;
      try {
        if (indexOfBlockChain != -1) {
          for (var addressModel
              in _walletController.blockChains[indexOfBlockChain].addresss) {
            final balance =
                await _repo.getBalancePiTestnet(address: addressModel.address);
            await scanTransationPendding(
                addressModel, addressModel.transactions);
            if (balance != addressModel.coinOfBlockChain.value) {
              addressModel.coinOfBlockChain.value = balance;
              _walletController.update([
                EnumUpdateWallet.CURRENCY_ACTIVE,
                EnumUpdateWallet.CURRENCY_ONLY,
              ]);
              if (index != 0) {
                final transactions = await _repo.getTransactionPiTestnet(
                    address: addressModel.address);
                if (transactions.isNotEmpty) {
                  addressModel.transactions = transactions;
                  addressModel.transactionLatest = transactions[0].hash;
                  await _walletController.updateWallet();
                }
                yield addressModel;
              } else {
                final transactions = await _repo.getTransactionPiTestnet(
                    address: addressModel.address);
                if (transactions.isNotEmpty) {
                  addressModel.transactions = transactions;
                  addressModel.transactionLatest = transactions[0].hash;
                  await _walletController.updateWallet();
                }
              }
            }
            await Future.delayed(Duration(milliseconds: 1000));
          }
        } else {
          throw Exception();
        }
      } catch (exp) {
        // _popupGetDataFailure(BlockChainModel.piTestnet);
        print('---------------------Pi test net---------------------');
        AppError.handleError(exception: exp);
        print('---------------------Pi test net----------------------');
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  // Stream<AddressModel> checkNewTransactionEthereum() async* {
  //   var indexOfBlockChain = _walletController.blockChains
  //       .indexWhere((element) => element.id == BlockChainModel.ethereum);
  //   if (indexOfBlockChain != -1) {
  //     while (getAuto) {
  //       try {
  //         for (var addressModel
  //             in _walletController.blockChains[indexOfBlockChain].addresss) {
  //           final transactionsJson =
  //               await _repo.getTransactionsEthereum(addressModel: addressModel);
  //           if (transactionsJson.isNotEmpty &&
  //               (addressModel.transactionLatest.isEmpty ||
  //                   transactionsJson[0]['hash'] !=
  //                       addressModel.transactionLatest)) {
  //             final transactionsAddress = await compute(
  //                 parseJsonToTransactionDataEthereum, transactionsJson);
  //             addressModel.transactions = transactionsAddress;
  //             await for (var coin in Stream.fromIterable(addressModel.coins)) {
  //               final value = await _repo.getBalanceEthereum(
  //                   coin: coin, address: addressModel.address);
  //               final oldCoinValue = coin.value;
  //               coin.value = value;
  //               if (oldCoinValue != value) {
  //                 _walletController.update([
  //                   EnumUpdateWallet.CURRENCY_ACTIVE,
  //                   EnumUpdateWallet.CURRENCY_ONLY,
  //                 ]);
  //               }
  //             }
  //             addressModel.transactionLatest = transactionsJson[0]['hash'];
  //             await _walletController.updateWallet();
  //             await scanTransationPendding(addressModel, transactionsAddress);
  //             scanRevokeDataForEthereumAddressModel(addressModel);
  //             yield addressModel;
  //           } else if (addressModel.transactions.isEmpty &&
  //               transactionsJson.isNotEmpty) {
  //             final transactionsAddress = await compute(
  //                 parseJsonToTransactionDataEthereum, transactionsJson);
  //             addressModel.transactions = transactionsAddress;
  //             await for (var coin in Stream.fromIterable(addressModel.coins)) {
  //               final value = await _repo.getBalanceEthereum(
  //                   coin: coin, address: addressModel.address);
  //               coin.value = value;
  //               if (coin.value > 0.0) {
  //                 _walletController.update([
  //                   EnumUpdateWallet.CURRENCY_ACTIVE,
  //                   EnumUpdateWallet.CURRENCY_ONLY,
  //                 ]);
  //               }
  //             }
  //             await scanTransationPendding(addressModel, transactionsAddress);
  //             scanRevokeDataForEthereumAddressModel(addressModel);
  //           }
  //           await Future.delayed(Duration(milliseconds: 100));
  //         }
  //       } catch (exp) {
  //         print('---------------------Ethereum---------------------');
  //         AppError.handleError(exception: exp);
  //         print('---------------------Ethereum---------------------');
  //         await Future.delayed(Duration(seconds: 1));
  //       }
  //     }
  //   }
  // }

  // Stream<AddressModel> checkNewTransactionBinance() async* {
  //   var indexOfBlockChain = _walletController.blockChains
  //       .indexWhere((element) => element.id == BlockChainModel.binanceSmart);
  //   if (indexOfBlockChain != -1) {
  //     while (getAuto) {
  //       try {
  //         for (var addressModel
  //             in _walletController.blockChains[indexOfBlockChain].addresss) {
  //           final transactionsJson =
  //               await _repo.getTransactionsBinance(addressModel: addressModel);
  //           if (transactionsJson.isNotEmpty &&
  //               (addressModel.transactionLatest.isEmpty ||
  //                   transactionsJson[0]['hash'] !=
  //                       addressModel.transactionLatest)) {
  //             final transactionsAddress = await compute(
  //                 parseJsonToTransactionDataEthereum, transactionsJson);
  //             addressModel.transactions = transactionsAddress;
  //             await for (var coin in Stream.fromIterable(addressModel.coins)) {
  //               final value = await _repo.getBalanceBinance(
  //                   coin: coin, address: addressModel.address);
  //               final oldCoinValue = coin.value;
  //               coin.value = value;
  //               if (oldCoinValue != value) {
  //                 _walletController.update([
  //                   EnumUpdateWallet.CURRENCY_ACTIVE,
  //                   EnumUpdateWallet.CURRENCY_ONLY,
  //                 ]);
  //               }
  //             }
  //             addressModel.transactionLatest = (transactionsJson[0]['hash']);
  //             await _walletController.updateWallet();

  //             await scanTransationPendding(addressModel, transactionsAddress);
  //             scanRevokeDataForBinanceAddressModel(addressModel);
  //             yield addressModel;
  //           } else if (addressModel.transactions.isEmpty &&
  //               transactionsJson.isNotEmpty) {
  //             final transactionsAddress = await compute(
  //                 parseJsonToTransactionDataEthereum, transactionsJson);
  //             addressModel.transactions = transactionsAddress;
  //             await scanTransationPendding(addressModel, transactionsAddress);
  //             await for (var coin in Stream.fromIterable(addressModel.coins)) {
  //               final value = await _repo.getBalanceBinance(
  //                   coin: coin, address: addressModel.address);
  //               coin.value = value;
  //               if (coin.value > 0.0) {
  //                 _walletController.update([
  //                   EnumUpdateWallet.CURRENCY_ACTIVE,
  //                   EnumUpdateWallet.CURRENCY_ONLY,
  //                 ]);
  //               }
  //             }
  //             scanRevokeDataForBinanceAddressModel(addressModel);
  //           }
  //           await Future.delayed(Duration(milliseconds: 100));
  //         }
  //       } catch (exp) {
  //         print('---------------------Binance---------------------');
  //         AppError.handleError(exception: exp);
  //         print('---------------------Binance---------------------');
  //         await Future.delayed(Duration(seconds: 1));
  //       }
  //     }
  //   }
  // }

  // Stream<AddressModel> checkNewTransactionPolygon() async* {
  //   var indexOfBlockChain = _walletController.blockChains
  //       .indexWhere((element) => element.id == BlockChainModel.polygon);
  //   if (indexOfBlockChain != -1) {
  //     while (getAuto) {
  //       try {
  //         for (var addressModel
  //             in _walletController.blockChains[indexOfBlockChain].addresss) {
  //           final transactionsJson =
  //               await _repo.getTransactionsPolygon(addressModel: addressModel);
  //           if (transactionsJson.isNotEmpty &&
  //               (addressModel.transactionLatest.isEmpty ||
  //                   transactionsJson[0]['hash'] !=
  //                       addressModel.transactionLatest)) {
  //             final transactionsAddress = await compute(
  //                 parseJsonToTransactionDataEthereum, transactionsJson);
  //             addressModel.transactions = transactionsAddress;
  //             await for (var coin in Stream.fromIterable(addressModel.coins)) {
  //               final value = await _repo.getBalancePolygon(
  //                   coin: coin, address: addressModel.address);
  //               final oldCoinValue = coin.value;
  //               coin.value = value;
  //               if (oldCoinValue != value) {
  //                 _walletController.update([
  //                   EnumUpdateWallet.CURRENCY_ACTIVE,
  //                   EnumUpdateWallet.CURRENCY_ONLY,
  //                 ]);
  //               }
  //             }
  //             addressModel.transactionLatest = (transactionsJson[0]['hash']);
  //             await _walletController.updateWallet();
  //             await scanTransationPendding(addressModel, transactionsAddress);
  //             scanRevokeDataForPolygonAddressModel(addressModel);
  //             yield addressModel;
  //           } else if (addressModel.transactions.isEmpty &&
  //               transactionsJson.isNotEmpty) {
  //             final transactionsAddress = await compute(
  //                 parseJsonToTransactionDataEthereum, transactionsJson);
  //             addressModel.transactions = transactionsAddress;
  //             await scanTransationPendding(addressModel, transactionsAddress);
  //             await for (var coin in Stream.fromIterable(addressModel.coins)) {
  //               final value = await _repo.getBalancePolygon(
  //                   coin: coin, address: addressModel.address);
  //               coin.value = value;
  //               if (coin.value > 0.0) {
  //                 _walletController.update([
  //                   EnumUpdateWallet.CURRENCY_ACTIVE,
  //                   EnumUpdateWallet.CURRENCY_ONLY,
  //                 ]);
  //               }
  //             }
  //             scanRevokeDataForPolygonAddressModel(addressModel);
  //           }
  //           await Future.delayed(Duration(milliseconds: 100));
  //         }
  //       } catch (exp) {
  //         // _popupGetDataFailure(BlockChainModel.binanceSmart);
  //         print('---------------------Polygon---------------------');
  //         AppError.handleError(exception: exp);
  //         print('---------------------Polygon---------------------');
  //         await Future.delayed(Duration(seconds: 1));
  //       }
  //     }
  //   }
  // }

  void scanRevokeDataForBinanceAddressModel(AddressModel addressModel) {
    final startBlock = addressModel.revokeDataList!.currentBlock ?? 0;
    _repo
        .getTransactionBinanceNormal(
      address: addressModel.address,
      startblock: startBlock,
      offset: 50,
    )
        .then((listData) async {
      addressModel.revokeDataList!.currentBlock = listData[1];
      await for (var transaction in Stream.fromIterable(listData[0])) {
        final approveJson =
            TrustWalletCorePlugin.decodeApprove(data: transaction['input']);
        if (approveJson != null) {
          final value = await _repo.getAllowanceBinance(
              addressOwner: addressModel.address,
              addressSender: approveJson['spender'],
              addressContract: transaction['to']);
          final approve = RevokeData(
              hash: transaction['hash'],
              time: int.parse(transaction['timeStamp']),
              block: int.parse(transaction['blockNumber']),
              sender: approveJson['spender'],
              owner: addressModel.address,
              contracAddress: transaction['to'],
              valueApprove: approveJson['value'].toDouble(),
              valueResidual: value.toDouble());
          final indexExited = addressModel.revokeDataList!.data.indexWhere(
              (element) =>
                  element.sender == approve.sender &&
                  element.contracAddress == approve.contracAddress);
          if (indexExited != -1) {
            if (value.toDouble() == 0.0) {
              addressModel.revokeDataList!.data.removeAt(indexExited);
            } else {
              addressModel.revokeDataList!.data[indexExited] = approve;
            }
          } else {
            if (value.toDouble() > 0.0) {
              addressModel.revokeDataList!.data.add(approve);
            }
          }
        }
      }
      await _repo.saveDataToLocal(
          key: addressModel.address + addressModel.blockChainId,
          data: addressModel.revokeDataList!.toJson());
      _walletController.update([EnumUpdateWallet.REVOKE_LIST]);
    });
  }

  void scanRevokeDataForPolygonAddressModel(AddressModel addressModel) {
    final startBlock = addressModel.revokeDataList!.currentBlock ?? 0;
    _repo
        .getTransactionPolygonNormal(
      address: addressModel.address,
      startblock: startBlock,
      offset: 50,
    )
        .then((listData) async {
      addressModel.revokeDataList!.currentBlock = listData[1];
      await for (var transaction in Stream.fromIterable(listData[0])) {
        final approveJson =
            TrustWalletCorePlugin.decodeApprove(data: transaction['input']);
        if (approveJson != null) {
          final value = await _repo.getAllowancePolygon(
              addressOwner: addressModel.address,
              addressSender: approveJson['spender'],
              addressContract: transaction['to']);
          final approve = RevokeData(
              hash: transaction['hash'],
              time: int.parse(transaction['timeStamp']),
              block: int.parse(transaction['blockNumber']),
              sender: approveJson['spender'],
              owner: addressModel.address,
              contracAddress: transaction['to'],
              valueApprove: approveJson['value'].toDouble(),
              valueResidual: value.toDouble());
          final indexExited = addressModel.revokeDataList!.data.indexWhere(
              (element) =>
                  element.sender == approve.sender &&
                  element.contracAddress == approve.contracAddress);
          if (indexExited != -1) {
            if (value.toDouble() == 0.0) {
              addressModel.revokeDataList!.data.removeAt(indexExited);
            } else {
              addressModel.revokeDataList!.data[indexExited] = approve;
            }
          } else {
            if (value.toDouble() > 0.0) {
              addressModel.revokeDataList!.data.add(approve);
            }
          }
        }
      }
      await _repo.saveDataToLocal(
          key: addressModel.address + addressModel.blockChainId,
          data: addressModel.revokeDataList!.toJson());
      _walletController.update([EnumUpdateWallet.REVOKE_LIST]);
    });
  }

  void scanRevokeDataForEthereumAddressModel(AddressModel addressModel) {
    final startBlock = addressModel.revokeDataList!.currentBlock ?? 0;
    _repo
        .getTransactionEthereumNormal(
      address: addressModel.address,
      startblock: startBlock,
      offset: 50,
    )
        .then((listData) async {
      addressModel.revokeDataList!.currentBlock = listData[1];
      await for (var transaction in Stream.fromIterable(listData[0])) {
        final approveJson =
            TrustWalletCorePlugin.decodeApprove(data: transaction['input']);
        if (approveJson != null) {
          final value = await _repo.getAllowanceEthereum(
              addressOwner: addressModel.address,
              addressSender: approveJson['spender'],
              addressContract: transaction['to']);
          final approve = RevokeData(
              hash: transaction['hash'],
              time: int.parse(transaction['timeStamp']),
              block: int.parse(transaction['blockNumber']),
              sender: approveJson['spender'],
              owner: addressModel.address,
              contracAddress: transaction['to'],
              valueApprove: approveJson['value'].toDouble(),
              valueResidual: value.toDouble());
          final indexExited = addressModel.revokeDataList!.data.indexWhere(
              (element) =>
                  element.sender == approve.sender &&
                  element.contracAddress == approve.contracAddress);
          if (indexExited != -1) {
            if (value.toDouble() == 0.0) {
              addressModel.revokeDataList!.data.removeAt(indexExited);
            } else {
              addressModel.revokeDataList!.data[indexExited] = approve;
            }
          } else {
            if (value.toDouble() > 0.0) {
              addressModel.revokeDataList!.data.add(approve);
            }
          }
        }
      }
      await _repo.saveDataToLocal(
          key: addressModel.keyOfRevokeList,
          data: addressModel.revokeDataList!.toJson());
      _walletController.update([EnumUpdateWallet.REVOKE_LIST]);
    });
  }

  void scanRevokeDataForKardiaChainAddressModel(
      AddressModel addressModel) async {
    for (var transaction in addressModel.transactions) {
      final approveJson =
          TrustWalletCorePlugin.decodeApprove(data: transaction.confirmations);
      if (approveJson != null) {
        final value = await _repo.getAllowanceKardiaChain(
            addressOwner: addressModel.address,
            addressSender: approveJson['spender'],
            addressContract: transaction.to);
        final approve = RevokeData(
            hash: transaction.hash,
            time: transaction.timeStamp,
            block: 0,
            sender: approveJson['spender'],
            owner: addressModel.address,
            contracAddress: transaction.to,
            valueApprove: approveJson['value'].toDouble(),
            valueResidual: value.toDouble());
        final indexExited = addressModel.revokeDataList!.data.indexWhere(
            (element) =>
                element.sender == approve.sender &&
                element.contracAddress == approve.contracAddress);
        if (indexExited != -1) {
          if (value.toDouble() == 0.0) {
            addressModel.revokeDataList!.data.removeAt(indexExited);
          } else {
            addressModel.revokeDataList!.data[indexExited] = approve;
          }
        } else {
          if (value.toDouble() > 0.0) {
            addressModel.revokeDataList!.data.add(approve);
          }
        }
      }
    }
    await _repo.saveDataToLocal(
        key: addressModel.keyOfRevokeList,
        data: addressModel.revokeDataList!.toJson());
    _walletController.update([EnumUpdateWallet.REVOKE_LIST]);
  }

  Future<void> scanTransationPendding(
      AddressModel addressModel, List<TransactionData> transactions) async {
    var scan = false;
    var transactionsPending = <TransactionData>[];
    for (var transaction in addressModel.transactionPending) {
      final index = transactions
          .indexWhere((element) => element.hash == transaction.hash);
      if (index != -1) {
        if (!scan) {
          scan = true;
        }
      } else {
        transactionsPending.add(transaction);
      }
    }
    if (scan) {
      addressModel.transactionPending = transactionsPending;
      await _repo.saveDataToLocal(
          key: addressModel.keyOfTransactionPending,
          data: TransactionPenddingData(data: addressModel.transactionPending)
              .toJson());
    }
  }

  static List<TransactionData> parseJsonToTransactionDataBitcoin(
      List<dynamic> data) {
    var transactions = <TransactionData>[];
    for (var json in data[0]) {
      final transaction = TransactionData.fromMapBitcoinConfirm(json, data[1]);
      if (transaction.hash.isNotEmpty) {
        transactions.add(transaction);
      }
    }
    return transactions;
  }

  static List<TransactionData> parseJsonToTransactionDataEthereum(
      List<dynamic> data) {
    return data.map((json) => TransactionData.fromEthereum(json)).toList();
  }

  static List<TransactionData> parseJsonToTransactionDataTronAll(
      List<dynamic> data) {
    var transactions = <TransactionData>[];
    for (var json in data) {
      final transaction = TransactionData.fromMapTronAll(json);
      if (transaction.hash.isNotEmpty) {
        transactions.add(transaction);
      }
    }
    return transactions;
  }

  static List<TransactionData> parseJsonToTransactionDataTronTRC20(
      List<dynamic> data) {
    return data.map((json) => TransactionData.fromMapTronTRC20(json)).toList();
  }

  void handleItemBottomBarOnTap({required int index}) async {
    if (index != pageController.page) {
      if (_walletController.visibleAppbar) {
        _walletController.visibleAppbar = false;
      }
      pageController.jumpToPage(index);
      update([EnumUpdateHome.BOTTOM_BAR]);
    }
  }

  int page() {
    try {
      return pageController.page == null ? 0 : pageController.page!.toInt();
    } catch (exp) {
      return 0;
    }
  }

  bool isActive(int index) {
    try {
      return index == (pageController.page ?? 0);
    } catch (exp) {
      return index == 0;
    }
  }
}
