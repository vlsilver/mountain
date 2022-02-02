import 'dart:math';

import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/data/providers/repository.dart';
import 'package:get/get.dart';

class Addliquidityrepository extends Repository {
  Future<List<dynamic>> getRateCoinPairEthereum({
    required String tokenContractFrom,
    required String tokenContractTo,
  }) async {
    final tokenLp = await ethereum.getPairFactory(
      tokenFrom: tokenContractFrom,
      tokenTo: tokenContractTo,
    );
    final dataPair = await ethereum.getReservesLPToken(tokenLP: tokenLp);
    final token0 = await ethereum.getLpTokenA(tokenLP: tokenLp);
    return [dataPair, token0, tokenLp];
  }

  Future<List<dynamic>> getRateCoinPairBinance({
    required String tokenContractFrom,
    required String tokenContractTo,
  }) async {
    final tokenLp = await binanceSmart.getPairFactory(
      tokenFrom: tokenContractFrom,
      tokenTo: tokenContractTo,
    );
    final dataPair = await binanceSmart.getReservesLPToken(tokenLP: tokenLp);
    final token0 = await binanceSmart.getLpTokenA(tokenLP: tokenLp);
    return [dataPair, token0, tokenLp];
  }

  Future<List<dynamic>> getRateCoinPairPolygon({
    required String tokenContractFrom,
    required String tokenContractTo,
  }) async {
    final tokenLp = await polygon.getPairFactory(
      tokenFrom: tokenContractFrom,
      tokenTo: tokenContractTo,
    );
    final dataPair = await polygon.getReservesLPToken(tokenLP: tokenLp);
    final token0 = await polygon.getLpTokenA(tokenLP: tokenLp);
    return [dataPair, token0, tokenLp];
  }

  Future<List<dynamic>> getRateCoinPairKardiaChain({
    required String tokenContractFrom,
    required String tokenContractTo,
  }) async {
    final tokenLp = await kardiaChain.getPairFactory(
      tokenFrom: tokenContractFrom,
      tokenTo: tokenContractTo,
    );
    final dataPair = await kardiaChain.getReservesLPToken(tokenLP: tokenLp);
    final token0 = await kardiaChain.getLpTokenA(tokenLP: tokenLp);
    return [dataPair, token0, tokenLp];
  }

  Future<double> calculatorFeeAddLiquidityEthereum({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountA,
    required BigInt amountB,
  }) async {
    final gasPrice = await ethereum.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenA.isEmpty || tokenB.isEmpty) {
      final gasLimit = await ethereum.getGasLimitAddLiquidityETH(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountToken: tokenA.isEmpty ? amountB : amountA,
          amountCoin: tokenA.isEmpty ? amountA : amountB);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      final gasLimit = await ethereum.getGasLimitAddLiquidityToken(
          tokenA: tokenA,
          tokenB: tokenB,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenA: amountA,
          amountTokenB: amountB);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      throw Exception();
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeAddLiquidityOfBinanceSmart({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountA,
    required BigInt amountB,
  }) async {
    final gasPrice = await binanceSmart.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenA.isEmpty || tokenB.isEmpty) {
      final gasLimit = await binanceSmart.getGasLimitAddLiquidityBNB(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountToken: tokenA.isEmpty ? amountB : amountA,
          amountCoin: tokenA.isEmpty ? amountA : amountB);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      final gasLimit = await binanceSmart.getGasLimitAddLiquidityToken(
          tokenA: tokenA,
          tokenB: tokenB,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenA: amountA,
          amountTokenB: amountB);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      throw Exception();
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeAddliquidityOfPolygon({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountA,
    required BigInt amountB,
  }) async {
    final gasPrice = await polygon.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenA.isEmpty || tokenB.isEmpty) {
      final gasLimit = await polygon.getGasLimitAddLiquidityMATIC(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountToken: tokenA.isEmpty ? amountB : amountA,
          amountCoin: tokenA.isEmpty ? amountA : amountB);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      final gasLimit = await polygon.getGasLimitAddLiquidityToken(
          tokenA: tokenA,
          tokenB: tokenB,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenA: amountA,
          amountTokenB: amountB);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      throw Exception();
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeAddliquidityOfKardiaChain({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountA,
    required BigInt amountB,
  }) async {
    final gasPrice = await kardiaChain.getGasPrice();
    Crypto().gasPrice = gasPrice;
    if (tokenA.isEmpty || tokenB.isEmpty) {
      final gasLimit = await kardiaChain.getGasLimitAddLiquidityKAI(
          token: tokenA.isEmpty ? tokenB : tokenA,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountToken: tokenA.isEmpty ? amountB : amountA,
          amountCoin: tokenA.isEmpty ? amountA : amountB);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      final gasLimit = await kardiaChain.getGasLimitAddLiquidityToken(
          tokenA: tokenA,
          tokenB: tokenB,
          addressSender: addressSender,
          addrsassRecieve: addrsassRecieve,
          amountTokenA: amountA,
          amountTokenB: amountB);
      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    } else {
      throw Exception();
    }
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<TransactionData?> createAddliquidityTransactionEthereum({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amountA,
    required BigInt amountB,
  }) async {
    var transactionHash = '';
    if (tokenA.isEmpty || tokenB.isEmpty) {
      transactionHash = await ethereum.addLiquidityETH(
        token: tokenA.isEmpty ? tokenB : tokenA,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountToken: tokenA.isEmpty ? amountB : amountA,
        amountCoin: tokenA.isEmpty ? amountA : amountA,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      transactionHash = await ethereum.addLiquidityToken(
        tokenA: tokenA,
        tokenB: tokenB,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountTokenA: amountA,
        amountTokenB: amountB,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
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
            throw 'failure_addliquidity_detail'.tr;
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
    // if (transactionHash.isNotEmpty) {
    //   await Future.delayed(Duration(milliseconds: 500));
    //   final data =
    //       await ethereum.getTransactionInformation(hash: transactionHash);
    //   if (data != null) {
    //     if (data['blockHash'] == null || data['blockNumber'] == null) {
    //       final transaction =
    //           TransactionData.fromEthereumPending(data).copyWith(
    //         value: tokenB.isNotEmpty && tokenA.isNotEmpty
    //             ? 0.0
    //             : tokenA.isEmpty
    //                 ? amountA.toDouble()
    //                 : amountB.toDouble(),
    //         to: addrsassRecieve,
    //         contractAddress: EthereumProvider.contractSwapAbi,
    //       );
    //       return transaction;
    //     }
    //   } else {
    //     return TransactionData(
    //       timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    //       hash: transactionHash,
    //       nonce: '0',
    //       isError: null,
    //       status: 'pending',
    //       from: addressSender,
    //       to: addrsassRecieve,
    //       contractAddress: '',
    //       confirmations: '',
    //       value: tokenB.isNotEmpty && tokenA.isNotEmpty
    //           ? 0.0
    //           : tokenA.isEmpty
    //               ? amountA.toDouble()
    //               : amountB.toDouble(),
    //       gasUsed: Crypto().gasLimit.toInt(),
    //       cumulativeGasUsed: 0,
    //       gasPrice: Crypto().gasPrice.toInt(),
    //     );
    //   }
    //   return null;
    // } else {
    //   throw 'Send transaction failure. Please try again!';
    // }
  }

  Future<TransactionData?> createAddliquidityTransactionBinanceSmart({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amountA,
    required BigInt amountB,
  }) async {
    var transactionHash = '';
    if (tokenA.isEmpty || tokenB.isEmpty) {
      transactionHash = await binanceSmart.addLiquidityBNB(
        token: tokenA.isEmpty ? tokenB : tokenA,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountToken: tokenA.isEmpty ? amountB : amountA,
        amountCoin: tokenA.isEmpty ? amountA : amountA,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      transactionHash = await binanceSmart.addLiquidityToken(
        tokenA: tokenA,
        tokenB: tokenB,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountTokenA: amountA,
        amountTokenB: amountB,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
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
            throw 'failure_addliquidity_detail'.tr;
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
    // if (transactionHash.isNotEmpty) {
    //   await Future.delayed(Duration(milliseconds: 500));
    //   final data =
    //       await binanceSmart.getTransactionInformation(hash: transactionHash);
    //   if (data != null) {
    //     if (data['blockHash'] == null || data['blockNumber'] == null) {
    //       final transaction =
    //           TransactionData.fromEthereumPending(data).copyWith(
    //         value: tokenB.isNotEmpty && tokenA.isNotEmpty
    //             ? 0.0
    //             : tokenA.isEmpty
    //                 ? amountA.toDouble()
    //                 : amountB.toDouble(),
    //         to: addrsassRecieve,
    //         contractAddress: '',
    //       );
    //       return transaction;
    //     }
    //   } else {
    //     return TransactionData(
    //       timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    //       hash: transactionHash,
    //       nonce: '0',
    //       isError: null,
    //       status: 'pending',
    //       from: addressSender,
    //       to: addrsassRecieve,
    //       contractAddress: '',
    //       confirmations: '',
    //       value: tokenB.isNotEmpty && tokenA.isNotEmpty
    //           ? 0.0
    //           : tokenA.isEmpty
    //               ? amountA.toDouble()
    //               : amountB.toDouble(),
    //       gasUsed: Crypto().gasLimit.toInt(),
    //       cumulativeGasUsed: 0,
    //       gasPrice: Crypto().gasPrice.toInt(),
    //     );
    //   }
    //   return null;
    // } else {
    //   throw 'Send transaction failure. Please try again!';
    // }
  }

  Future<void> createAddLiquidityTransactionKardiaChain({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amountA,
    required BigInt amountB,
  }) async {
    var transactionHash = '';
    if (tokenA.isEmpty || tokenB.isEmpty) {
      transactionHash = await kardiaChain.addLiquidityKAI(
        token: tokenA.isEmpty ? tokenB : tokenA,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountToken: tokenA.isEmpty ? amountB : amountA,
        amountCoin: tokenA.isEmpty ? amountA : amountA,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      transactionHash = await kardiaChain.addLiquidityToken(
        tokenA: tokenA,
        tokenB: tokenB,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountTokenA: amountA,
        amountTokenB: amountB,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
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
            throw 'failure_addliquidity_detail'.tr;
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
    // if (transactionHash.isNotEmpty) {
    //   final transaction = TransactionData(
    //     timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    //     timeString: '',
    //     hash: transactionHash,
    //     nonce: '',
    //     isError: null,
    //     status: 'pending',
    //     from: addressSender,
    //     to: addrsassRecieve,
    //     contractAddress: '',
    //     confirmations: '',
    //     value: tokenB.isNotEmpty && tokenA.isNotEmpty
    //         ? 0.0
    //         : tokenA.isEmpty
    //             ? amountA.toDouble()
    //             : amountB.toDouble(),
    //     gasUsed: Crypto().gasLimit.toInt(),
    //     cumulativeGasUsed: 0,
    //     gasPrice: Crypto().gasPrice.toInt(),
    //   );
    //   return transaction;
    // } else {
    //   throw 'Send transaction failure. Please try again!';
    // }
  }

  Future<TransactionData?> createAddLiquidityTransactionPolygon({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amountA,
    required BigInt amountB,
  }) async {
    var transactionHash = '';
    if (tokenA.isEmpty || tokenB.isEmpty) {
      transactionHash = await polygon.addLiquidityMATIC(
        token: tokenA.isEmpty ? tokenB : tokenA,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountToken: tokenA.isEmpty ? amountB : amountA,
        amountCoin: tokenA.isEmpty ? amountA : amountA,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
    } else if (tokenB.isNotEmpty && tokenA.isNotEmpty) {
      transactionHash = await polygon.addLiquidityToken(
        tokenA: tokenA,
        tokenB: tokenB,
        privateKey: privateKey,
        addressSender: addressSender,
        addrsassRecieve: addrsassRecieve,
        amountTokenA: amountA,
        amountTokenB: amountB,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
      );
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
            throw 'failure_addliquidity_detail'.tr;
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
    // if (transactionHash.isNotEmpty) {
    //   await Future.delayed(Duration(milliseconds: 500));
    //   final data =
    //       await polygon.getTransactionInformation(hash: transactionHash);
    //   if (data != null) {
    //     if (data['blockHash'] == null || data['blockNumber'] == null) {
    //       final transaction =
    //           TransactionData.fromEthereumPending(data).copyWith(
    //         value: tokenB.isNotEmpty && tokenA.isNotEmpty
    //             ? 0.0
    //             : tokenA.isEmpty
    //                 ? amountA.toDouble()
    //                 : amountB.toDouble(),
    //         to: addrsassRecieve,
    //         contractAddress: '',
    //       );
    //       return transaction;
    //     }
    //   } else {
    //     return TransactionData(
    //       timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    //       hash: transactionHash,
    //       nonce: '0',
    //       isError: null,
    //       status: 'pending',
    //       from: addressSender,
    //       to: addrsassRecieve,
    //       contractAddress: '',
    //       confirmations: '',
    //       value: tokenB.isNotEmpty && tokenA.isNotEmpty
    //           ? 0.0
    //           : tokenA.isEmpty
    //               ? amountA.toDouble()
    //               : amountB.toDouble(),
    //       gasUsed: Crypto().gasLimit.toInt(),
    //       cumulativeGasUsed: 0,
    //       gasPrice: Crypto().gasPrice.toInt(),
    //     );
    //   }
    //   return null;
    // } else {
    //   throw 'Send transaction failure. Please try again!';
    // }
  }

  Future<CoinModel> getBalanceLPTokenEthereum({
    required String tokenLp,
    required String address,
  }) async {
    final balance = await ethereum.getBalanceOfLPToken(
        address: address, contractAddress: tokenLp);
    final coinModel =
        await ethereum.getTokenModelLPInfo(addressContract: tokenLp);

    return coinModel.copyWith(value: balance);
  }

  Future<CoinModel> getBalanceLPTokenBinanceSmart({
    required String tokenLp,
    required String address,
  }) async {
    final balance = await binanceSmart.getBalanceOfLPToken(
        address: address, contractAddress: tokenLp);
    final coinModel =
        await binanceSmart.getTokenModelLPInfo(addressContract: tokenLp);
    return coinModel.copyWith(value: balance);
  }

  Future<CoinModel> getBalanceLPTokenPolygon({
    required String tokenLp,
    required String address,
  }) async {
    final balance = await polygon.getBalanceOfLPToken(
        address: address, contractAddress: tokenLp);
    final coinModel =
        await polygon.getTokenModelLPInfo(addressContract: tokenLp);

    return coinModel.copyWith(value: balance);
  }

  Future<CoinModel> getBalanceLPTokenKardiaChain({
    required String tokenLp,
    required String address,
  }) async {
    final balance = await kardiaChain.getBalanceOfLPToken(
        address: address, contractAddress: tokenLp);
    final coinModel =
        await kardiaChain.getTokenModelLPInfo(addressContract: tokenLp);

    return coinModel.copyWith(value: balance);
  }

  Future<BigInt> checkBalanceTokenLP(
      {required String tokenLp,
      required String address,
      required String blockChianId}) async {
    switch (blockChianId) {
      case BlockChainModel.ethereum:
        return await ethereum.getBalanceOfLPToken(
            address: address, contractAddress: tokenLp);
      case BlockChainModel.binanceSmart:
        return await binanceSmart.getBalanceOfLPToken(
            address: address, contractAddress: tokenLp);
      case BlockChainModel.polygon:
        return await polygon.getBalanceOfLPToken(
            address: address, contractAddress: tokenLp);
      case BlockChainModel.kardiaChain:
        return await kardiaChain.getBalanceOfLPToken(
            address: address, contractAddress: tokenLp);
      default:
        return BigInt.from(0);
    }
  }

  Future<BigInt> checkTotalSupplyTokenLP({
    required String tokenLp,
    required String blockChianId,
  }) async {
    switch (blockChianId) {
      case BlockChainModel.ethereum:
        return await ethereum.getTokenTotalSupplyLPToken(
            addressContract: tokenLp);
      case BlockChainModel.binanceSmart:
        return await binanceSmart.getTokenTotalSupplyLPToken(
            addressContract: tokenLp);
      case BlockChainModel.polygon:
        return await polygon.getTokenTotalSupplyLPToken(
            addressContract: tokenLp);
      case BlockChainModel.kardiaChain:
        return await kardiaChain.getTokenTotalSupplyLPToken(
            addressContract: tokenLp);
      default:
        return BigInt.from(0);
    }
  }
}
