import 'dart:math';

import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/data/providers/crypto_provider/binance_provider.dart';
import 'package:base_source/app/data/providers/repository.dart';

class IDODepositRepository extends Repository {
  Future<double> calculatorFee({
    required bool isApprove,
    required bool isApproveSuccess,
    required BigInt amount,
    required String adddressOwner,
    required String contractBaseToken,
    required int index,
  }) async {
    if (isApprove && !isApproveSuccess) {
      return await calculatorFeeApproveBinanceSmart(
        tokenContract: contractBaseToken,
        addressOwner: adddressOwner,
        addressSender: BinanceSmartProvider.contractLaunchPad,
        amount: amount,
      );
    } else if (!isApprove || isApproveSuccess) {
      final gasPrice = await binanceSmart.getGasPrice();
      Crypto().gasPrice = gasPrice;
      final gasLimit = await binanceSmart.getGasLimitToDepositLaunchPadIDO(
          addressSender: adddressOwner,
          amount: amount,
          index: BigInt.from(index));

      Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
      return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
    } else {
      throw Exception('Caculator Failure by Local');
    }
  }

  Future<TransactionData?> createDepositTransactionBinanceSmart({
    required String addressSender,
    required String privateKey,
    required BigInt amount,
    required BigInt index,
    required String contractCoinBase,
  }) async {
    var transactionHash = '';
    // transactionHash = await binanceSmart.depositTransactionLaunchPadIDO(
    //   addressSender: addressSender,
    //   privateKey: privateKey,
    //   amount: amount,
    //   index: index,
    //   gasPrice: Crypto().gasPrice,
    //   gasLimit: Crypto().gasLimit,
    // );

    throw Exception('Send transaction failure. Please try again!');

    if (transactionHash.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 500));
      final data =
          await binanceSmart.getTransactionInformation(hash: transactionHash);
      if (data != null) {
        if (data['blockHash'] == null || data['blockNumber'] == null) {
          final transaction =
              TransactionData.fromEthereumPending(data).copyWith(
            value: contractCoinBase.isEmpty ? amount.toDouble() : 0.0,
            to: BinanceSmartProvider.contractLaunchPad,
            contractAddress: contractCoinBase,
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
          to: BinanceSmartProvider.contractLaunchPad,
          contractAddress: contractCoinBase,
          confirmations: '',
          value: contractCoinBase.isEmpty ? amount.toDouble() : 0.0,
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
