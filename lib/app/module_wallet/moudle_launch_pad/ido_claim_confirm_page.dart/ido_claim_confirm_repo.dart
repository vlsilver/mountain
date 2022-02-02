import 'dart:math';

import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/providers/repository.dart';
import 'package:get/get.dart';

class IDOClaimRepository extends Repository {
  Future<double> calculatorFee({
    required String adddressSender,
    required int index,
  }) async {
    final gasPrice = await binanceSmart.getGasPrice();
    Crypto().gasPrice = gasPrice;
    final gasLimit = await binanceSmart.getGasLimitToUserClaimLaunchPadIDO(
      addressSender: adddressSender,
      index: BigInt.from(index),
    );
    Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<void> createuserClaimTokenTransactionBinanceSmart({
    required String addressSender,
    required String privateKey,
    required BigInt index,
  }) async {
    // var transactionHash = '';
    // transactionHash = await binanceSmart.userClaimTokenTransactionLaunchPadIDO(
    //   addressSender: addressSender,
    //   privateKey: privateKey,
    //   index: index,
    //   gasPrice: Crypto().gasPrice,
    //   gasLimit: Crypto().gasLimit,
    // );

    throw Exception('Send transaction failure. Please try again!');

    //   if (transactionHash.isNotEmpty) {
    //     while (true) {
    //       try {
    //         final data =
    //             await binanceSmart.getTransactionReceiptByHash(transactionHash);
    //         if (data != null && data['status'] == '0x1') {
    //           break;
    //         } else if (data != null && data['status'] == '0x0') {
    //           throw 'failure_approve_detail'.tr;
    //         } else {
    //           await Future.delayed(Duration(milliseconds: 500));
    //         }
    //       } catch (exp) {
    //         await Future.delayed(Duration(milliseconds: 500));
    //       }
    //     }
    //   } else {
    //     throw 'Send transaction failure. Please try again!';
    //   }
    // }
  }
}
