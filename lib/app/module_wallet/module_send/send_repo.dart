import 'dart:convert';
import 'dart:math';

import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/data/providers/repository.dart';

class SendTransactionRepository extends Repository {
  Future<double> calculatorFeeOfEthereum({
    required AddressModel addressSender,
    required AddressModel addressRecieve,
    required CoinModel coinModel,
    required BigInt amount,
  }) async {
    final gasPrice = await ethereum.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (coinModel.contractAddress.isNotEmpty) {
      final gasLimit = await ethereum.getGasLimitToSendTransactionToken(
          addressContract: coinModel.contractAddress,
          addrsassRecieve: addressRecieve.address,
          addressSender: addressSender.address,
          amount: amount.toInt() == 0 ? BigInt.from(1) : amount);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      Crypto().gasLimit = await ethereum.getGasLimit(
          addressSend: addressSender.address,
          addressRecieve: addressRecieve.address,
          amount: amount);
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeOfBinance({
    required AddressModel addressSender,
    required AddressModel addressRecieve,
    required CoinModel coinModel,
    required BigInt amount,
  }) async {
    final gasPrice = await binanceSmart.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (coinModel.contractAddress.isNotEmpty) {
      final gasLimit = await binanceSmart.getGasLimitToSendTransactionToken(
          addressContract: coinModel.contractAddress,
          addrsassRecieve: addressRecieve.address,
          addressSender: addressSender.address,
          amount: amount.toInt() == 0 ? BigInt.from(1) : amount);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      Crypto().gasLimit = await binanceSmart.getGasLimit(
          addressSend: addressSender.address,
          addressRecieve: addressRecieve.address,
          amount: amount);
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeOfPolygon({
    required AddressModel addressSender,
    required AddressModel addressRecieve,
    required CoinModel coinModel,
    required BigInt amount,
  }) async {
    final gasPrice = await polygon.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (coinModel.contractAddress.isNotEmpty) {
      final gasLimit = await polygon.getGasLimitToSendTransactionToken(
          addressContract: coinModel.contractAddress,
          addrsassRecieve: addressRecieve.address,
          addressSender: addressSender.address,
          amount: amount.toInt() == 0 ? BigInt.from(1) : amount);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      Crypto().gasLimit = await polygon.getGasLimit(
          addressSend: addressSender.address,
          addressRecieve: addressRecieve.address,
          amount: amount);
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeOfKardiaChain({
    required AddressModel addressSender,
    required AddressModel addressRecieve,
    required CoinModel coinModel,
    required BigInt amount,
  }) async {
    final gasPrice = await kardiaChain.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (coinModel.contractAddress.isNotEmpty) {
      final gasLimit = await kardiaChain.getGasLimitToSendTransactionToken(
          addressContract: coinModel.contractAddress,
          addrsassRecieve: addressRecieve.address,
          addressSender: addressSender.address,
          amount: amount.toInt() == 0 ? BigInt.from(1) : amount);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      Crypto().gasLimit = await kardiaChain.getGasLimit(
          addressSend: addressSender.address,
          addressRecieve: addressRecieve.address,
          amount: amount);
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<int> calculatorFeePerByteOfBictoin() async {
    final fees = await bitcoin.getEstimateGas();
    return fees;
  }

  Future<List<UtxoBitcoin>> getUtxoBitcoin({required String address}) async {
    final utxosData = await bitcoin.getUtxo(address: address);
    var utxsResult = <UtxoBitcoin>[];
    for (var utxo in utxosData) {
      if (utxo['status']['confirmed']) {
        utxsResult.add(UtxoBitcoin.fromMap(utxo));
      }
    }
    return utxsResult;
  }

  // Future<double> calculatorFeeOfKardiaChain() async {
  //   final gasPrice = await kardiaChain.getGasPrice();
  //   Crypto().gasLimit = await kardiaChain.getGasLimit();
  //   Crypto().gasPrice = gasPrice;
  //   return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  // }

  Future<double> calculatorFeeOfStellarChain() async {
    final gasPrice = await stellar.getBaseFees();
    Crypto().gasLimit = BigInt.from(1);
    Crypto().gasPrice = BigInt.from(gasPrice);
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 7);
  }

  Future<double> calculatorFeeOfPiTestnet() async {
    final gasPrice = await piTestnet.getBaseFees();
    Crypto().gasLimit = BigInt.from(1);
    Crypto().gasPrice = BigInt.from(gasPrice);
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 7);
  }

  Future<double> calculatorFeeOfTron(
      {required CoinModel coinModel, required bool isSend}) async {
    if (coinModel.contractAddress.isEmpty) {
      Crypto().gasLimit = BigInt.from(100000);
      Crypto().gasPrice = isSend ? BigInt.from(0) : BigInt.from(1);
      return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 6);
    } else {
      Crypto().gasLimit = BigInt.from(1);
      Crypto().gasPrice = BigInt.from(5000000);
      return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 6);
    }
  }

  Future<TransactionData?> createTransactionBitcoin({
    required String fromAddress,
    required String toAddress,
    required BigInt amountInSatoshi,
    required int byteFee,
    required String derivationPath,
    required String privateKey,
    required List<UtxoBitcoin> utxos,
    required double fee,
  }) async {
    var indexUtxos = <int>[];
    var hashs = <String>[];
    var amountUtxos = <int>[];

    for (var transaction in utxos) {
      indexUtxos.add(transaction.indexOutput);
      amountUtxos.add(transaction.value);
      hashs.add(transaction.hash);
    }
    final transactionData = await trustWallet.createTransactionBitcoin(
      toAddress: toAddress,
      fromAddress: fromAddress,
      amount: amountInSatoshi,
      byteFee: byteFee,
      derivationPath: derivationPath,
      privateKey: privateKey,
      indexUtxos: indexUtxos,
      hashs: hashs,
      amountUtxos: amountUtxos,
    );

    final transactionHash =
        await bitcoin.sendRawTransaction(data: transactionData);
    await Future.delayed(Duration(milliseconds: 2000));
    try {
      final data =
          await bitcoin.getTransactionInformation(hash: transactionHash);
      final transaction =
          TransactionData.fromMapBitcoinUnconfirm(data, fromAddress);
      return transaction;
    } catch (exp) {
      return TransactionData(
        timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        timeString: '',
        hash: transactionHash,
        nonce: '0',
        isError: null,
        status: 'pending',
        from: fromAddress,
        to: toAddress,
        contractAddress: '',
        confirmations: '',
        value: amountInSatoshi.toDouble(),
        gasUsed: 0,
        cumulativeGasUsed: 0,
        gasPrice: (fee * pow(10, 8)).toInt(),
      );
    }
  }

  Future<TransactionData?> createTransactionEthereum({
    required BigInt amount,
    required AddressModel addressSend,
    required AddressModel addressRecieve,
    required CoinModel coinModelSelect,
  }) async {
    final nonceHexString =
        await ethereum.getTransactionCount(address: addressSend.address);
    final chainIdHexString = await ethereum.getChainId();
    final gasPriceHexString =
        AppFormat.bigIntToHexString(number: Crypto().gasPrice);
    final gasLimitHexString =
        AppFormat.bigIntToHexString(number: Crypto().gasLimit);
    final amountHexString = AppFormat.bigIntToHexString(number: amount);
    final transactionData = await trustWallet.createTransactionEthereum(
      toAddress: addressRecieve.address,
      amountHexString: amountHexString,
      gasPriceHexString: gasPriceHexString,
      gasLimitHexString: gasLimitHexString,
      nonceHexString: nonceHexString,
      chainIdHexString: chainIdHexString,
      privateKey: addressSend.privatekey,
      derivationPath: addressSend.derivationPath,
    );
    final transactionHash = await ethereum.sendTransaction(
        data: AppFormat.addPrefixHexString(hexString: transactionData));
    if (transactionHash.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 500));
      final data =
          await ethereum.getTransactionInformation(hash: transactionHash);
      if (data != null) {
        if (data['blockHash'] == null || data['blockNumber'] == null) {
          final transaction =
              TransactionData.fromEthereumPending(data).copyWith(
            value: amount.toDouble(),
            to: addressRecieve.address,
            contractAddress: coinModelSelect.contractAddress,
          );
          return transaction;
        }
      } else {
        return TransactionData(
          timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          hash: transactionHash,
          nonce: '0',
          isError: null,
          status: 'pending',
          from: addressSend.address,
          to: addressRecieve.address,
          contractAddress: coinModelSelect.contractAddress,
          confirmations: '',
          value: amount.toDouble(),
          gasUsed: Crypto().gasLimit.toInt(),
          cumulativeGasUsed: 0,
          gasPrice: Crypto().gasPrice.toInt(),
        );
      }
      return null;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<TransactionData?> createTransactionEthereumERC20({
    required String addressContract,
    required String addrsassRecieve,
    required String addressSender,
    required String privateKey,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final transactionHash = await ethereum.sendTransactionERC20(
        addressContract: addressContract,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        privateKey: privateKey,
        amount: amount,
        gasPrice: gasPrice,
        gasLimit: gasLimit);
    if (transactionHash.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 500));
      final data =
          await ethereum.getTransactionInformation(hash: transactionHash);
      if (data != null) {
        if (data['blockHash'] == null || data['blockNumber'] == null) {
          final transaction =
              TransactionData.fromEthereumPending(data).copyWith(
            value: amount.toDouble(),
            to: addrsassRecieve,
            contractAddress: addressContract,
          );
          return transaction;
        }
      } else {
        return TransactionData(
          timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          hash: transactionHash,
          nonce: '0',
          isError: null,
          status: 'pending',
          from: addressSender,
          to: addrsassRecieve,
          contractAddress: addressContract,
          confirmations: '',
          value: amount.toDouble(),
          gasUsed: Crypto().gasLimit.toInt(),
          cumulativeGasUsed: 0,
          gasPrice: Crypto().gasPrice.toInt(),
        );
      }
      return null;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<TransactionData?> createTransactionBinanceSmart({
    required BigInt amount,
    required AddressModel addressSend,
    required AddressModel addressRecieve,
    required CoinModel coinModelSelect,
  }) async {
    final nonceHexString =
        await binanceSmart.getTransactionCount(address: addressSend.address);
    final chainIdHexString = await binanceSmart.getChainId();
    final gasPriceHexString =
        AppFormat.bigIntToHexString(number: Crypto().gasPrice);
    final gasLimitHexString =
        AppFormat.bigIntToHexString(number: Crypto().gasLimit);
    final amountHexString = AppFormat.bigIntToHexString(number: amount);
    final transactionData = await trustWallet.createTransactionBinanceSmart(
      toAddress: addressRecieve.address,
      amountHexString: amountHexString,
      gasPriceHexString: gasPriceHexString,
      gasLimitHexString: gasLimitHexString,
      nonceHexString: nonceHexString,
      chainIdHexString: chainIdHexString,
      privateKey: addressSend.privatekey,
      derivationPath: addressSend.derivationPath,
    );
    final transactionHash = await binanceSmart.sendTransaction(
        data: AppFormat.addPrefixHexString(hexString: transactionData));
    if (transactionHash.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 500));
      final data =
          await binanceSmart.getTransactionInformation(hash: transactionHash);
      if (data != null) {
        if (data['blockHash'] == null || data['blockNumber'] == null) {
          final transaction =
              TransactionData.fromEthereumPending(data).copyWith(
            value: amount.toDouble(),
            to: addressRecieve.address,
            contractAddress: coinModelSelect.contractAddress,
          );
          return transaction;
        }
      } else {
        return TransactionData(
          timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          hash: transactionHash,
          nonce: '0',
          isError: null,
          status: 'pending',
          from: addressSend.address,
          to: addressRecieve.address,
          contractAddress: coinModelSelect.contractAddress,
          confirmations: '',
          value: amount.toDouble(),
          gasUsed: Crypto().gasLimit.toInt(),
          cumulativeGasUsed: 0,
          gasPrice: Crypto().gasPrice.toInt(),
        );
      }
      return null;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<TransactionData?> createTransactionBinanceSmartBEP20({
    required String addressContract,
    required String addrsassRecieve,
    required String addressSender,
    required String privateKey,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final transactionHash = await binanceSmart.sendTransactionBEP20(
      addressContract: addressContract,
      addressSender: addressSender,
      addrsassRecieve: addrsassRecieve,
      privateKey: privateKey,
      amount: amount,
      gasLimit: gasLimit,
      gasPrice: gasPrice,
    );
    if (transactionHash.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 500));
      final data =
          await binanceSmart.getTransactionInformation(hash: transactionHash);
      if (data != null) {
        if (data['blockHash'] == null || data['blockNumber'] == null) {
          final transaction =
              TransactionData.fromEthereumPending(data).copyWith(
            value: amount.toDouble(),
            to: addrsassRecieve,
            contractAddress: addressContract,
          );
          return transaction;
        }
      } else {
        return TransactionData(
          timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          hash: transactionHash,
          nonce: '0',
          isError: null,
          status: 'pending',
          from: addressSender,
          to: addrsassRecieve,
          contractAddress: addressContract,
          confirmations: '',
          value: amount.toDouble(),
          gasUsed: Crypto().gasLimit.toInt(),
          cumulativeGasUsed: 0,
          gasPrice: Crypto().gasPrice.toInt(),
        );
      }
      return null;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<TransactionData?> createTransactionPolygon({
    required BigInt amount,
    required AddressModel addressSend,
    required AddressModel addressRecieve,
    required CoinModel coinModelSelect,
  }) async {
    final nonceHexString =
        await polygon.getTransactionCount(address: addressSend.address);
    final chainIdHexString = await polygon.getChainId();
    final gasPriceHexString =
        AppFormat.bigIntToHexString(number: Crypto().gasPrice);
    final gasLimitHexString =
        AppFormat.bigIntToHexString(number: Crypto().gasLimit);
    final amountHexString = AppFormat.bigIntToHexString(number: amount);
    final transactionData = await trustWallet.createTransactionPolygon(
      toAddress: addressRecieve.address,
      amountHexString: amountHexString,
      gasPriceHexString: gasPriceHexString,
      gasLimitHexString: gasLimitHexString,
      nonceHexString: nonceHexString,
      chainIdHexString: chainIdHexString,
      privateKey: addressSend.privatekey,
      derivationPath: addressSend.derivationPath,
    );
    final transactionHash = await polygon.sendTransaction(
        data: AppFormat.addPrefixHexString(hexString: transactionData));
    if (transactionHash.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 500));
      final data =
          await polygon.getTransactionInformation(hash: transactionHash);
      if (data != null) {
        if (data['blockHash'] == null || data['blockNumber'] == null) {
          final transaction =
              TransactionData.fromEthereumPending(data).copyWith(
            value: amount.toDouble(),
            to: addressRecieve.address,
            contractAddress: coinModelSelect.contractAddress,
          );
          return transaction;
        }
      } else {
        return TransactionData(
          timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          hash: transactionHash,
          nonce: '0',
          isError: null,
          status: 'pending',
          from: addressSend.address,
          to: addressRecieve.address,
          contractAddress: coinModelSelect.contractAddress,
          confirmations: '',
          value: amount.toDouble(),
          gasUsed: Crypto().gasLimit.toInt(),
          cumulativeGasUsed: 0,
          gasPrice: Crypto().gasPrice.toInt(),
        );
      }
      return null;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<TransactionData?> createTransactionPolygonPERC20({
    required String addressContract,
    required String addrsassRecieve,
    required String addressSender,
    required String privateKey,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final transactionHash = await polygon.sendTransactionPERC20(
      addressContract: addressContract,
      addressSender: addressSender,
      addrsassRecieve: addrsassRecieve,
      privateKey: privateKey,
      amount: amount,
      gasLimit: gasLimit,
      gasPrice: gasPrice,
    );
    if (transactionHash.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 500));
      final data =
          await polygon.getTransactionInformation(hash: transactionHash);
      if (data != null) {
        if (data['blockHash'] == null || data['blockNumber'] == null) {
          final transaction =
              TransactionData.fromEthereumPending(data).copyWith(
            value: amount.toDouble(),
            to: addrsassRecieve,
            contractAddress: addressContract,
          );
          return transaction;
        }
      } else {
        return TransactionData(
          timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          hash: transactionHash,
          nonce: '0',
          isError: null,
          status: 'pending',
          from: addressSender,
          to: addrsassRecieve,
          contractAddress: addressContract,
          confirmations: '',
          value: amount.toDouble(),
          gasUsed: Crypto().gasLimit.toInt(),
          cumulativeGasUsed: 0,
          gasPrice: Crypto().gasPrice.toInt(),
        );
      }
      return null;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<TransactionData?> createTransactionKardiachainByWeb3({
    required BigInt amount,
    required String addressSend,
    required String addressRecieve,
    required String privatekey,
    required CoinModel coinModelSelect,
  }) async {
    final transactionHash = await kardiaChain.sendTransactionByWeb3(
      addressSender: addressSend,
      addrsassRecieve: addressRecieve,
      gasPrice: Crypto().gasPrice,
      gasLimit: Crypto().gasLimit.toInt(),
      amount: amount,
      privateKey: privatekey,
    );

    if (transactionHash.isNotEmpty) {
      final transaction = TransactionData(
        timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        timeString: '',
        hash: transactionHash,
        nonce: '',
        isError: null,
        status: 'pending',
        from: addressSend,
        to: addressRecieve,
        contractAddress: '',
        confirmations: '',
        value: amount.toDouble(),
        gasUsed: Crypto().gasLimit.toInt(),
        cumulativeGasUsed: 0,
        gasPrice: Crypto().gasPrice.toInt(),
      );
      return transaction;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<TransactionData?> createTransactionKardiaChainKRC20({
    required String addressContract,
    required String addrsassRecieve,
    required String addressSender,
    required String privateKey,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final transactionHash = await kardiaChain.sendTransactionKRC20(
      addressContract: addressContract,
      addressSender: addressSender,
      addrsassRecieve: addrsassRecieve,
      privateKey: privateKey,
      amount: amount,
      gasLimit: gasLimit,
      gasPrice: gasPrice,
    );
    if (transactionHash.isNotEmpty) {
      final transaction = TransactionData(
        timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        timeString: '',
        hash: transactionHash,
        nonce: '',
        isError: null,
        status: 'pending',
        from: addressSender,
        to: addrsassRecieve,
        contractAddress: addressContract,
        confirmations: '',
        value: amount.toDouble(),
        gasUsed: gasLimit.toInt(),
        cumulativeGasUsed: 0,
        gasPrice: Crypto().gasPrice.toInt(),
      );
      return transaction;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<TransactionData?> createTransactionStellar({
    required BigInt amount,
    required AddressModel addressSend,
    required AddressModel addressRecieve,
    required CoinModel coinModelSelect,
  }) async {
    final sequence = await stellar.getSequence(address: addressSend.address);
    final isCreateAccount =
        await stellar.checkCreateAccount(address: addressRecieve.address);
    if (isCreateAccount) {
      throw 'The recipient does not exist!';
    }
    final transactionData = await trustWallet.createTransactionStellar(
      fromAddress: addressSend.address,
      toAddress: addressRecieve.address,
      sequence: sequence,
      fee: (Crypto().gasPrice * Crypto().gasLimit).toInt(),
      amount: amount,
      derivationPath: addressSend.derivationPath,
      privateKey: addressSend.privatekey,
    );
    final data = await stellar.sendTransactionRaw(data: transactionData);
    if (data.isNotEmpty) {
      final transaction =
          TransactionData.fromStellarPaymentPending(jsonDecode(data)).copyWith(
        from: addressSend.address,
        to: addressRecieve.address,
        value: amount.toDouble(),
        contractAddress: coinModelSelect.contractAddress,
      );
      return transaction;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<TransactionData?> createTransactionPiTestnet({
    required BigInt amount,
    required AddressModel addressSend,
    required AddressModel addressRecieve,
    required CoinModel coinModelSelect,
  }) async {
    final sequence = await piTestnet.getSequence(address: addressSend.address);
    final isCreateAccount =
        await piTestnet.checkCreateAccount(address: addressRecieve.address);
    if (isCreateAccount) {
      throw 'The recipient does not exist!';
    }
    final transactionData = await trustWallet.createTransactionPiTestnet(
      fromAddress: addressSend.address,
      toAddress: addressRecieve.address,
      sequence: sequence,
      fee: (Crypto().gasPrice * Crypto().gasLimit).toInt(),
      amount: amount,
      derivationPath: addressSend.derivationPath,
      privateKey: addressSend.privatekey,
    );
    final data = await piTestnet.sendTransactionRaw(data: transactionData);
    if (data.isNotEmpty) {
      final transaction =
          TransactionData.fromStellarPaymentPending(jsonDecode(data)).copyWith(
        from: addressSend.address,
        to: addressRecieve.address,
        value: amount.toDouble(),
        contractAddress: coinModelSelect.contractAddress,
      );
      return transaction;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<TransactionData?> createTransactionOfTron({
    required BigInt amount,
    required AddressModel addressSend,
    required AddressModel addressRecieve,
    required CoinModel coinModelSelect,
  }) async {
    final blocHeader = await tron.getBlockHeader();
    final transactionData = await trustWallet.createTransactionOfTron(
      contractAddress: coinModelSelect.contractAddress,
      fromAddress: addressSend.address,
      toAddress: addressRecieve.address,
      fee: (Crypto().gasPrice * Crypto().gasLimit).toInt(),
      amount: amount,
      derivationPath: addressSend.derivationPath,
      privateKey: addressSend.privatekey,
      blockHeaderTron: blocHeader,
    );
    final success = await tron.sendTransactionRaw(data: transactionData);
    if (success) {
      final transaction =
          TransactionData.fromMapTronPending(jsonDecode(transactionData))
              .copyWith(
        from: addressSend.address,
        to: addressRecieve.address,
        value: amount.toDouble(),
        contractAddress: coinModelSelect.contractAddress,
      );
      return transaction;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }
}
