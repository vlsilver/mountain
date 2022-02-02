import 'dart:convert';

import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/data/providers/repository.dart';

class HistoryTransactionRepository extends Repository {
  Future<void> getInformationOTransaction({
    required TransactionData transaction,
    required AddressModel addressModel,
  }) async {
    if (addressModel.blockChainId == BlockChainModel.stellar) {
      final jsonsString =
          await stellar.getInformationTransaction(hash: transaction.hash);
      final jsonData = jsonDecode(jsonsString);
      transaction.gasPrice = int.parse(jsonData['fee_charged']);
    } else if (addressModel.blockChainId == BlockChainModel.piTestnet) {
      final jsonsString =
          await piTestnet.getInformationTransaction(hash: transaction.hash);
      final jsonData = jsonDecode(jsonsString);
      transaction.gasPrice = int.parse(jsonData['fee_charged']);
    } else if (addressModel.blockChainId == BlockChainModel.tron) {
      final fee =
          await tron.getInformationTransactionFee(hash: transaction.hash);
      transaction.gasPrice = fee;
    } else {
      transaction.gasPrice = 0;
    }
  }
}
