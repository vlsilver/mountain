import 'dart:math';

import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/providers/repository.dart';
import 'package:get/get.dart';

class RemoveAddLiquidityRepository extends Repository {
  Future<double> calculatorFeeRemoveAddLiquidityKardiaChain({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
  }) async {
    final gasPrice = await kardiaChain.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenA.isEmpty || tokenB.isEmpty) {
      final gasLimit = await kardiaChain.getGasLimitRemoveAddLiquidityKAI(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      final gasLimit = await kardiaChain.getGasLimitRemoveAddLiquidityToken(
        tokenA: tokenA,
        tokenB: tokenB,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountTokenLP: amountTokenLP,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      throw Exception();
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<void> createRemoveAddLiquidityTransactionKardiaChain({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amountTokenLP,
  }) async {
    var transactionHash = '';
    if (tokenA.isEmpty || tokenB.isEmpty) {
      transactionHash = await kardiaChain.removeAdddLiquidityKAI(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP,
          privateKey: privateKey,
          gasLimit: Crypto().gasLimit,
          gasPrice: Crypto().gasPrice);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      transactionHash = await kardiaChain.removeAddLiquidityToken(
          tokenA: tokenA,
          tokenB: tokenB,
          privateKey: privateKey,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP,
          gasLimit: Crypto().gasLimit,
          gasPrice: Crypto().gasPrice);
    } else {
      throw 'Function not support';
    }
    if (transactionHash.isNotEmpty) {
      while (true) {
        try {
          final data =
              await kardiaChain.getTransactionReceiptByHash(transactionHash);
          if (data != null && data['status'] == 1) {
            break;
          } else if (data != null && data['status'] == 0) {
            throw 'failure_remove_addliquidity_detail'.tr;
          } else {
            await Future.delayed(Duration(milliseconds: 500));
          }
        } catch (exp) {
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<double> calculatorFeeRemoveAddLiquidityBinance({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
  }) async {
    final gasPrice = await binanceSmart.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenA.isEmpty || tokenB.isEmpty) {
      final gasLimit = await binanceSmart.getGasLimitRemoveAddLiquidityBNB(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      final gasLimit = await binanceSmart.getGasLimitRemoveAddLiquidityToken(
        tokenA: tokenA,
        tokenB: tokenB,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountTokenLP: amountTokenLP,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      throw Exception();
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<void> createRemoveAddLiquidityTransactionBinance({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amountTokenLP,
  }) async {
    var transactionHash = '';
    if (tokenA.isEmpty || tokenB.isEmpty) {
      transactionHash = await binanceSmart.removeAdddLiquidityBNB(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP,
          privateKey: privateKey,
          gasLimit: Crypto().gasLimit,
          gasPrice: Crypto().gasPrice);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      transactionHash = await binanceSmart.removeAddLiquidityToken(
          tokenA: tokenA,
          tokenB: tokenB,
          privateKey: privateKey,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP,
          gasLimit: Crypto().gasLimit,
          gasPrice: Crypto().gasPrice);
    } else {
      throw 'Function not support';
    }
    if (transactionHash.isNotEmpty) {
      while (true) {
        try {
          final data =
              await binanceSmart.getTransactionReceiptByHash(transactionHash);
          if (data != null && data['status'] == '0x1') {
            break;
          } else if (data != null && data['status'] == '0x0') {
            throw 'failure_remove_addliquidity_detail'.tr;
          } else {
            await Future.delayed(Duration(milliseconds: 500));
          }
        } catch (exp) {
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<double> calculatorFeeRemoveAddLiquidityPolygon({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
  }) async {
    final gasPrice = await polygon.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenA.isEmpty || tokenB.isEmpty) {
      final gasLimit = await polygon.getGasLimitRemoveAddLiquidityMATIC(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      final gasLimit = await polygon.getGasLimitRemoveAddLiquidityToken(
        tokenA: tokenA,
        tokenB: tokenB,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountTokenLP: amountTokenLP,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      throw Exception();
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<void> createRemoveAddLiquidityTransactionPolygon({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amountTokenLP,
  }) async {
    var transactionHash = '';
    if (tokenA.isEmpty || tokenB.isEmpty) {
      transactionHash = await polygon.removeAdddLiquidityMATIC(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP,
          privateKey: privateKey,
          gasLimit: Crypto().gasLimit,
          gasPrice: Crypto().gasPrice);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      transactionHash = await polygon.removeAddLiquidityToken(
          tokenA: tokenA,
          tokenB: tokenB,
          privateKey: privateKey,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP,
          gasLimit: Crypto().gasLimit,
          gasPrice: Crypto().gasPrice);
    } else {
      throw 'Function not support';
    }
    if (transactionHash.isNotEmpty) {
      while (true) {
        try {
          final data =
              await polygon.getTransactionReceiptByHash(transactionHash);
          if (data != null && data['status'] == '0x1') {
            break;
          } else if (data != null && data['status'] == '0x0') {
            throw 'failure_remove_addliquidity_detail'.tr;
          } else {
            await Future.delayed(Duration(milliseconds: 500));
          }
        } catch (exp) {
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<double> calculatorFeeRemoveAddLiquidityEthereum({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
  }) async {
    final gasPrice = await ethereum.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenA.isEmpty || tokenB.isEmpty) {
      final gasLimit = await ethereum.getGasLimitRemoveAddLiquidityETH(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      final gasLimit = await ethereum.getGasLimitRemoveAddLiquidityToken(
        tokenA: tokenA,
        tokenB: tokenB,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountTokenLP: amountTokenLP,
      );
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      throw Exception();
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<void> createRemoveAddLiquidityTransactionEthereum({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amountTokenLP,
  }) async {
    var transactionHash = '';
    if (tokenA.isEmpty || tokenB.isEmpty) {
      transactionHash = await ethereum.removeAdddLiquidityETH(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP,
          privateKey: privateKey,
          gasLimit: Crypto().gasLimit,
          gasPrice: Crypto().gasPrice);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      transactionHash = await ethereum.removeAddLiquidityToken(
          tokenA: tokenA,
          tokenB: tokenB,
          privateKey: privateKey,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenLP: amountTokenLP,
          gasLimit: Crypto().gasLimit,
          gasPrice: Crypto().gasPrice);
    } else {
      throw 'Function not support';
    }
    if (transactionHash.isNotEmpty) {
      while (true) {
        try {
          final data =
              await ethereum.getTransactionReceiptByHash(transactionHash);
          if (data != null && data['status'] == '0x1') {
            break;
          } else if (data != null && data['status'] == '0x0') {
            throw 'failure_remove_addliquidity_detail'.tr;
          } else {
            await Future.delayed(Duration(milliseconds: 500));
          }
        } catch (exp) {
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }
}
