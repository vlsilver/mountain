import 'dart:math';

import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/data/providers/repository.dart';

class SwapRepository extends Repository {
  Future<double> getAmountsOutEthereum({
    required String tokenContractFrom,
    required String tokenContractTo,
    required BigInt amount,
  }) async {
    return await ethereum.getAmountsOut(
      tokenContractFrom: tokenContractFrom,
      tokenContractTo: tokenContractTo,
      amount: amount,
    );
  }

  Future<double> getAmountsOutBinanceSmart({
    required String tokenContractFrom,
    required String tokenContractTo,
    required BigInt amount,
  }) async {
    return await binanceSmart.getAmountsOut(
      tokenContractFrom: tokenContractFrom,
      tokenContractTo: tokenContractTo,
      amount: amount,
    );
  }

  Future<double> getAmountsOutPolygon({
    required String tokenContractFrom,
    required String tokenContractTo,
    required BigInt amount,
  }) async {
    return await polygon.getAmountsOut(
      tokenContractFrom: tokenContractFrom,
      tokenContractTo: tokenContractTo,
      amount: amount,
    );
  }

  Future<double> getAmountsOutKardiaChain({
    required String tokenContractFrom,
    required String tokenContractTo,
    required BigInt amount,
  }) async {
    return await kardiaChain.getAmountsOut(
      tokenContractFrom: tokenContractFrom,
      tokenContractTo: tokenContractTo,
      amount: amount,
    );
  }

  Future<double> calculatorFeeSwapOfEthereum({
    required String tokenContractFrom,
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final gasPrice = await ethereum.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenContractFrom.isEmpty && tokenContractTo.isNotEmpty) {
      final gasLimit = await ethereum.getGasLimitToSwapExactETHForTokens(
        tokenContractTo: tokenContractTo,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenContractTo.isEmpty && tokenContractFrom.isNotEmpty) {
      final gasLimit = await ethereum.getGasLimitSwapExactTokensForETH(
        tokenContractFrom: tokenContractFrom,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenContractTo.isNotEmpty && tokenContractFrom.isNotEmpty) {
      final gasLimit = await ethereum.getGasLimitSwapExactTokensForTokens(
        tokenContractFrom: tokenContractFrom,
        tokenContractTo: tokenContractTo,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeSwapOfBinanceSmart({
    required String tokenContractFrom,
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final gasPrice = await binanceSmart.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenContractFrom.isEmpty && tokenContractTo.isNotEmpty) {
      final gasLimit = await binanceSmart.getGasLimitToSwapExactBNBForTokens(
        tokenContractTo: tokenContractTo,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenContractTo.isEmpty && tokenContractFrom.isNotEmpty) {
      final gasLimit = await binanceSmart.getGasLimitSwapExactTokensForBNB(
        tokenContractFrom: tokenContractFrom,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenContractTo.isNotEmpty && tokenContractFrom.isNotEmpty) {
      final gasLimit = await binanceSmart.getGasLimitSwapExactTokensForTokens(
        tokenContractFrom: tokenContractFrom,
        tokenContractTo: tokenContractTo,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeSwapOfPolygon({
    required String tokenContractFrom,
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final gasPrice = await polygon.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenContractFrom.isEmpty && tokenContractTo.isNotEmpty) {
      final gasLimit = await polygon.getGasLimitToSwapExactMATICForTokens(
        tokenContractTo: tokenContractTo,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenContractTo.isEmpty && tokenContractFrom.isNotEmpty) {
      final gasLimit = await polygon.getGasLimitSwapExactTokensForMATIC(
        tokenContractFrom: tokenContractFrom,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenContractTo.isNotEmpty && tokenContractFrom.isNotEmpty) {
      final gasLimit = await polygon.getGasLimitSwapExactTokensForTokens(
        tokenContractFrom: tokenContractFrom,
        tokenContractTo: tokenContractTo,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeSwapOfKardiaChain({
    required String tokenContractFrom,
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final gasPrice = await kardiaChain.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenContractFrom.isEmpty && tokenContractTo.isNotEmpty) {
      final gasLimit = await kardiaChain.getGasLimitToSwapExactKAIForTokens(
        tokenContractTo: tokenContractTo,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenContractTo.isEmpty && tokenContractFrom.isNotEmpty) {
      final gasLimit = await kardiaChain.getGasLimitSwapExactTokensForKAI(
        tokenContractFrom: tokenContractFrom,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble());
    } else if (tokenContractTo.isNotEmpty && tokenContractFrom.isNotEmpty) {
      final gasLimit = await kardiaChain.getGasLimitSwapExactTokensForTokens(
        tokenContractFrom: tokenContractFrom,
        tokenContractTo: tokenContractTo,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble());
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<TransactionData?> createSwapTransactionEthereum({
    required String tokenContractFrom,
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amount,
  }) async {
    var transactionHash = '';
    if (tokenContractFrom.isEmpty && tokenContractTo.isNotEmpty) {
      transactionHash =
          await ethereum.swapExactETHForTokensSupportingFeeOnTransferTokens(
        tokenContractTo: tokenContractTo,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenContractTo.isEmpty && tokenContractFrom.isNotEmpty) {
      transactionHash =
          await ethereum.swapExactTokensForETHSupportingFeeOnTransferTokens(
        tokenContractFrom: tokenContractFrom,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenContractTo.isNotEmpty && tokenContractFrom.isNotEmpty) {
      transactionHash =
          await ethereum.swapExactTokensForTokensSupportingFeeOnTransferTokens(
        tokenContractFrom: tokenContractFrom,
        tokenContractTo: tokenContractTo,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else {
      throw 'Function not support';
    }
    if (transactionHash.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 500));
      final data =
          await ethereum.getTransactionInformation(hash: transactionHash);
      if (data != null) {
        if (data['blockHash'] == null || data['blockNumber'] == null) {
          final transaction =
              TransactionData.fromEthereumPending(data).copyWith(
            value: tokenContractFrom.isEmpty ? amount.toDouble() : 0.0,
            to: addrsassRecieve,
            contractAddress: tokenContractFrom,
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
          contractAddress: tokenContractFrom,
          confirmations: '',
          value: tokenContractFrom.isEmpty ? amount.toDouble() : 0.0,
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

  Future<TransactionData?> createSwapTransactionBinanceSmart({
    required String tokenContractFrom,
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amount,
  }) async {
    var transactionHash = '';
    if (tokenContractFrom.isEmpty && tokenContractTo.isNotEmpty) {
      transactionHash =
          await binanceSmart.swapExactBNBForTokensSupportingFeeOnTransferTokens(
        tokenContractTo: tokenContractTo,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenContractTo.isEmpty && tokenContractFrom.isNotEmpty) {
      transactionHash =
          await binanceSmart.swapExactTokensForBNBSupportingFeeOnTransferTokens(
        tokenContractFrom: tokenContractFrom,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenContractTo.isNotEmpty && tokenContractFrom.isNotEmpty) {
      transactionHash = await binanceSmart
          .swapExactTokensForTokensSupportingFeeOnTransferTokens(
        tokenContractFrom: tokenContractFrom,
        tokenContractTo: tokenContractTo,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else {
      throw 'Function not support';
    }
    if (transactionHash.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 500));
      final data =
          await binanceSmart.getTransactionInformation(hash: transactionHash);
      if (data != null) {
        if (data['blockHash'] == null || data['blockNumber'] == null) {
          final transaction =
              TransactionData.fromEthereumPending(data).copyWith(
            value: tokenContractFrom.isEmpty ? amount.toDouble() : 0.0,
            to: addrsassRecieve,
            contractAddress: tokenContractFrom,
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
          contractAddress: tokenContractFrom,
          confirmations: '',
          value: tokenContractFrom.isEmpty ? amount.toDouble() : 0.0,
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

  Future<TransactionData> createSwapTransactionKardiaChain({
    required String tokenContractFrom,
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amount,
  }) async {
    var transactionHash = '';
    if (tokenContractFrom.isEmpty && tokenContractTo.isNotEmpty) {
      transactionHash =
          await kardiaChain.swapExactKAIForTokensSupportingFeeOnTransferTokens(
        tokenContractTo: tokenContractTo,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenContractTo.isEmpty && tokenContractFrom.isNotEmpty) {
      transactionHash =
          await kardiaChain.swapExactTokensForKAISupportingFeeOnTransferTokens(
        tokenContractFrom: tokenContractFrom,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenContractTo.isNotEmpty && tokenContractFrom.isNotEmpty) {
      transactionHash = await kardiaChain
          .swapExactTokensForTokensSupportingFeeOnTransferTokens(
        tokenContractFrom: tokenContractFrom,
        tokenContractTo: tokenContractTo,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else {
      throw 'Function not support';
    }
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
        contractAddress: '',
        confirmations: '',
        value: tokenContractFrom.isEmpty ? amount.toDouble() : 0.0,
        gasUsed: Crypto().gasLimit.toInt(),
        cumulativeGasUsed: 0,
        gasPrice: Crypto().gasPrice.toInt(),
      );
      return transaction;
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<TransactionData?> createSwapTransactionPolygon({
    required String tokenContractFrom,
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amount,
  }) async {
    var transactionHash = '';
    if (tokenContractFrom.isEmpty && tokenContractTo.isNotEmpty) {
      transactionHash =
          await polygon.swapExactMATICForTokensSupportingFeeOnTransferTokens(
        tokenContractTo: tokenContractTo,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenContractTo.isEmpty && tokenContractFrom.isNotEmpty) {
      transactionHash =
          await polygon.swapExactTokensForMATICSupportingFeeOnTransferTokens(
        tokenContractFrom: tokenContractFrom,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenContractTo.isNotEmpty && tokenContractFrom.isNotEmpty) {
      transactionHash =
          await polygon.swapExactTokensForTokensSupportingFeeOnTransferTokens(
        tokenContractFrom: tokenContractFrom,
        tokenContractTo: tokenContractTo,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else {
      throw Exception();
    }
    if (transactionHash.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 500));
      final data =
          await polygon.getTransactionInformation(hash: transactionHash);
      if (data != null) {
        if (data['blockHash'] == null || data['blockNumber'] == null) {
          final transaction =
              TransactionData.fromEthereumPending(data).copyWith(
            value: tokenContractFrom.isEmpty ? amount.toDouble() : 0.0,
            to: addrsassRecieve,
            contractAddress: tokenContractFrom,
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
          contractAddress: tokenContractFrom,
          confirmations: '',
          value: tokenContractFrom.isEmpty ? amount.toDouble() : 0.0,
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
}
