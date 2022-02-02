import 'dart:convert';
import 'dart:io';

import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/data/providers/repository.dart';
import 'package:base_source/app/data/services/setting_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomeRepository extends Repository {
  HomeRepository() : super();

  Future<Map<String, dynamic>> getCoinsExchangeAndPrice(
      List<String> coinsId) async {
    final result = await cryptoApi.getCoinExchangeAndPrice(coinsId);
    return result;
  }

  Future<Map<String, dynamic>> getVIDBANDLTDPriceAndExchange() async {
    final data = await cryptoApi.getDataNamiExchange();
    final ltdData = data.firstWhere((element) => element['symbol'] == 'LTDUSDT',
        orElse: () => {});
    final currency =
        Get.find<SettingService>().currencyActive.currency.toLowerCase();
    final usdtPrice = Crypto().price('tether');
    final ltdDataLastPrice = ltdData['last_price'] * usdtPrice;
    final ltdDataLastPrice24h = ltdData['last_price_24h'];
    final ltdDataChange24h = ltdData['change_24h'];
    final ltdDataMap = {
      currency: ltdDataLastPrice,
      '${currency}_24h_change':
          ((ltdDataChange24h / ltdDataLastPrice24h * 100) as double)
              .toPrecision(2)
    };
    final vidbVndcData = data.firstWhere(
        (element) => element['symbol'] == 'VIDBVNDC',
        orElse: () => {});
    final vndcPrice = Crypto().price('vndc');
    final vidbDataLastPrice = vidbVndcData['last_price'] * vndcPrice;
    final vidbDataLastPrice24h = vidbVndcData['last_price_24h'];
    final vidbDataChange24h = vidbVndcData['change_24h'];
    final vidbDataMap = {
      currency: vidbDataLastPrice,
      '${currency}_24h_change':
          ((vidbDataChange24h / vidbDataLastPrice24h * 100) as double)
              .toPrecision(2)
    };
    final result = {
      'ltd': ltdDataMap,
      'vidb': vidbDataMap,
    };
    return result;
  }

  Future<List<dynamic>> getTransactionsEthereum(
      {required AddressModel addressModel}) async {
    final listNormal =
        await ethereum.getTransactions(address: addressModel.address);
    final listERC20 =
        await ethereum.getTransactionsOfERC20(address: addressModel.address);
    listNormal.addAll(listERC20);
    listNormal.sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));
    return listNormal;
  }

  Future<List<dynamic>> getTransactionsBinance(
      {required AddressModel addressModel}) async {
    final listNormal =
        await binanceSmart.getTransactions(address: addressModel.address);
    final listBEP20 = await binanceSmart.getTransactionsOfBEP20(
        address: addressModel.address);
    listNormal.addAll(listBEP20);
    listNormal.sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));

    return listNormal;
  }

  Future<List<dynamic>> getTransactionsPolygon(
      {required AddressModel addressModel}) async {
    final listNormal =
        await polygon.getTransactions(address: addressModel.address);
    final listPECR20 =
        await polygon.getTransactionsOfPERC20(address: addressModel.address);
    listNormal.addAll(listPECR20);
    listNormal.sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));
    return listNormal;
  }

  Future<List<dynamic>> getTransactionBinanceNormal({
    required String address,
    int? offset,
    int? startblock,
    int? endblock,
  }) async {
    final blockNumber = await binanceSmart.getCurrentBlock();
    final listNormal = await binanceSmart.getTransactions(
      address: address,
      offset: offset,
      startblock: startblock,
      endblock: endblock,
    );
    return [listNormal, blockNumber];
  }

  Future<List<dynamic>> getTransactionEthereumNormal({
    required String address,
    int? offset,
    int? startblock,
    int? endblock,
  }) async {
    final blockNumber = await ethereum.getCurrentBlock();
    final listNormal = await ethereum.getTransactions(
      address: address,
      offset: offset,
      startblock: startblock,
      endblock: endblock,
    );
    return [listNormal, blockNumber];
  }

  Future<List<dynamic>> getTransactionPolygonNormal({
    required String address,
    int? offset,
    int? startblock,
    int? endblock,
  }) async {
    final blockNumber = await polygon.getCurrentBlock();
    final listNormal = await polygon.getTransactions(
      address: address,
      offset: offset,
      startblock: startblock,
      endblock: endblock,
    );
    return [listNormal, blockNumber];
  }

  Future<List<dynamic>> getTransactionsBitcoin(
      {required String address}) async {
    final transactions = await bitcoin.getTransactions(address: address);
    return transactions;
  }

  Future<BigInt> getBalanceBitcoin({required String address}) async {
    final balanceData = await bitcoin.getBalance(address: address);
    final chainStats = balanceData['chain_stats'];
    final fundedSum = BigInt.from(chainStats['funded_txo_sum']);
    final spentSum = BigInt.from(chainStats['spent_txo_sum']);
    final balance = fundedSum - spentSum;
    return balance;
  }

  Future<BigInt> getBalanceKardiaChain({
    required String address,
    required CoinModel coinModel,
  }) async {
    if (coinModel.contractAddress.isEmpty) {
      final balance = await kardiaChain.getBalance(address: address);
      return balance;
    } else {
      final balance = await kardiaChain.getBalanceOfKRC20(
          address: address, contractAddress: coinModel.contractAddress);
      return balance;
    }
  }

  Future<TransactionData> getTransactionKardiaChainLatest(
      {required String address}) async {
    final jsonData = await kardiaChain.getTransactionsLatest(address);
    if (jsonData.isNotEmpty) {
      final transaction = TransactionData.fromKardiaChain(jsonData);
      return transaction;
    } else {
      return TransactionData.empty();
    }
  }

  // Future<TransactionData> getTransactionBinanceLatest(
  //     {required String address}) async {
  //   final jsonData = await binanceSmart.getTransactionsLatest(address);
  //   if (jsonData.isNotEmpty) {
  //     final transaction = TransactionData.fromEthereumRaw(jsonData);
  //     return transaction;
  //   } else {
  //     return TransactionData.empty();
  //   }
  // }

  Future<int> getTransactionCountKardiaChain({required String address}) async {
    final nonce = await kardiaChain.getTransactionCount(address: address);
    return nonce;
  }

  Future<TransactionData> getTransactionKardiaChainByHash(
      {required String hash}) async {
    final jsonData = await kardiaChain.getTransactionByHash(hash);
    final transaction = TransactionData.fromKardiaChain(jsonData);
    return transaction;
  }

  Future<BigInt> getBalanceEthereum({
    required CoinModel coin,
    required String address,
  }) async {
    if (coin.contractAddress.isEmpty) {
      final balance = await ethereum.getBalance(address: address);
      return balance;
    } else {
      final balance = await ethereum.getBalanceOfERC20(
        address: address,
        contractAddress: coin.contractAddress,
      );
      return balance;
    }
  }

  Future<BigInt> getBalanceBinance({
    required CoinModel coin,
    required String address,
  }) async {
    if (coin.contractAddress.isEmpty) {
      final balance = await binanceSmart.getBalance(address: address);
      return balance;
    } else {
      final balance = await binanceSmart.getBalanceOfBEP20(
        address: address,
        contractAddress: coin.contractAddress,
      );

      return balance;
    }
  }

  Future<BigInt> getBalancePolygon({
    required CoinModel coin,
    required String address,
  }) async {
    if (coin.contractAddress.isEmpty) {
      final balance = await polygon.getBalance(address: address);
      return balance;
    } else {
      final balance = await polygon.getBalanceOfPERC20(
        address: address,
        contractAddress: coin.contractAddress,
      );
      return balance;
    }
  }

  Future<BigInt> getBalanceStellar({required String address}) async {
    final balance = await stellar.getBalance(address: address);
    return balance;
  }

  Future<BigInt> getBalancePiTestnet({required String address}) async {
    final balance = await piTestnet.getBalance(address: address);
    return balance;
  }

  Future<List<TransactionData>> getTransactionStellar(
      {required String address}) async {
    final jsonString = await stellar.getTransactions(address: address);
    final transactions =
        await compute(parseJsonToTransactionDataStellar, jsonString);
    return transactions;
  }

  Future<List<TransactionData>> getTransactionPiTestnet(
      {required String address}) async {
    final jsonString = await piTestnet.getTransactions(address: address);
    if (jsonString.isNotEmpty) {
      final transactions =
          await compute(parseJsonToTransactionDataStellar, jsonString);
      return transactions;
    } else {
      return <TransactionData>[];
    }
  }

  static List<TransactionData> parseJsonToTransactionDataStellar(String data) {
    final jsonData = jsonDecode(data) as Map<String, dynamic>;
    final jsonTransactions = jsonData['_embedded']['records'];
    var transactions = <TransactionData>[];
    var i = 0;
    for (var json in jsonTransactions) {
      if (json['type'] == 'payment' && json['asset_type'] == 'native') {
        final transaction = TransactionData.fromStellarPayment(json);
        if (i != 0 && transaction.hash == transactions[i - 1].hash) {
          transactions[i - 1].value =
              transactions[i - 1].value + transaction.value;
        } else {
          transactions.add(transaction);
          i++;
        }
      } else if (json['type'] == 'create_account') {
        final transaction = TransactionData.fromStellarCreateAccount(json);
        if (i != 0 && transaction.hash == transactions[i - 1].hash) {
          transactions[i - 1].value =
              transactions[i - 1].value + transaction.value;
        } else {
          transactions.add(transaction);
          i++;
        }
      }
    }
    return transactions;
  }

  Future<String?> getTransactionTxInternalOfBinance(
      {required String hash}) async {
    final data = await binanceSmart.getTransactionInternal(hash);
    if (data.isEmpty) {
      return null;
    }
    return data[0]['isError'] == '1'
        ? '1'
        : data[0]['contractAddress'] as String;
  }

  Future<Map<String, BigInt>> getBalanceTron({
    required String address,
  }) async {
    final balances = await tron.getBalance(address: address);
    return balances;
  }

  Future<List<dynamic>> getTransactionsTronAll(
      {required AddressModel addressModel}) async {
    final transactions =
        await tron.getTransactions(address: addressModel.address);
    return transactions;
  }

  Future<List<dynamic>> getTransactionsTronTRC20(
      {required AddressModel addressModel}) async {
    final transactions =
        await tron.getTransactionsTRC20(address: addressModel.address);
    return transactions;
  }

  Future<String> createTokenMoonApi(
      {required CoinModel coinModel,
      required File file,
      required String addressCreator}) async {
    return await moonApi.createToken(
      coinModel: coinModel,
      file: file,
      addressCreator: addressCreator,
    );
  }
}
