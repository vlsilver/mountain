import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_pendding.dart';
import 'package:base_source/app/module_wallet/module_send/send_repo.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:get/get.dart';

class SendController extends GetxController {
  late BlockChainModel blockChainModel;
  late AddressModel addressSender;
  CoinModel coinModelSelect = CoinModel.empty();
  AddressModel addressRecieve = AddressModel.empty();
  double amount = 0.0;
  String amountString = '0.0';
  double fee = 0.0;
  var utxosBitcoin = <UtxoBitcoin>[];
  final _repo = SendTransactionRepository();
  final _walletController = Get.find<WalletController>();

  @override
  void onInit() {
    addressSender = _walletController.addressActive;
    blockChainModel = _walletController.blockChainActive;
    super.onInit();
  }

  void setData({
    required CoinModel coinModel,
    required AddressModel addressModel,
    required BlockChainModel blockChain,
  }) {
    coinModelSelect = coinModel;
    blockChainModel = blockChain;
    addressSender = addressModel;
  }

  void handleResetData() {
    amount = 0.0;
    amountString = '0.0';
    fee = 0.0;
  }

  Future<bool> checkValidAddress({required String address}) async {
    final isValid = await _repo.checkValidAddress(
      address: address,
      coinType: addressSender.coinType,
    );
    return isValid;
  }

  Future<void> createNewAddressFavourite({
    required String name,
    required String address,
  }) async {
    await _walletController.createNewAddressFavourite(
      name: name,
      address: address,
      blockChainId: blockChainModel.id,
    );
  }

  Future<double> calculatorFee() async {
    switch (coinModelSelect.blockchainId) {
      case BlockChainModel.bitcoin:
        final feeMediumPerByte = await _repo.calculatorFeePerByteOfBictoin();
        final utxos =
            await _repo.getUtxoBitcoin(address: addressSender.address);

        final data = addressSender.getTransactionsUnSpentForAmount(
          amountString: amountString,
          feeInSatoshiPerByte: feeMediumPerByte,
          addressSend: addressSender.address,
          addressRecieve: addressRecieve.address,
          utxos: utxos,
        );
        Crypto().feePerByte = feeMediumPerByte;
        utxosBitcoin = data[0] as List<UtxoBitcoin>;
        if (utxosBitcoin.isEmpty) {
          throw 'not_confirm_transaction'.tr;
        }
        fee = data[1];
        return fee;
      case BlockChainModel.ethereum:
        fee = await _repo.calculatorFeeOfEthereum(
            addressRecieve: addressRecieve,
            addressSender: addressSender,
            amount: getBigIntAmountCoin,
            coinModel: coinModelSelect);
        return fee;
      case BlockChainModel.binanceSmart:
        fee = await _repo.calculatorFeeOfBinance(
            addressRecieve: addressRecieve,
            addressSender: addressSender,
            amount: getBigIntAmountCoin,
            coinModel: coinModelSelect);
        return fee;
      case BlockChainModel.polygon:
        fee = await _repo.calculatorFeeOfPolygon(
            addressRecieve: addressRecieve,
            addressSender: addressSender,
            amount: getBigIntAmountCoin,
            coinModel: coinModelSelect);
        return fee;
      case BlockChainModel.kardiaChain:
        fee = await _repo.calculatorFeeOfKardiaChain(
            addressRecieve: addressRecieve,
            addressSender: addressSender,
            amount: getBigIntAmountCoin,
            coinModel: coinModelSelect);
        return fee;
      case BlockChainModel.stellar:
        fee = await _repo.calculatorFeeOfStellarChain();
        return fee;
      case BlockChainModel.piTestnet:
        fee = await _repo.calculatorFeeOfPiTestnet();
        return fee;
      case BlockChainModel.tron:
        fee = await _repo.calculatorFeeOfTron(
          coinModel: coinModelSelect,
          isSend: addressSender.transactions.isNotEmpty,
        );
        return fee;
      default:
        return 0.0;
    }
  }

  Future<void> createTransactionBitcoin() async {
    final transaction = await _repo.createTransactionBitcoin(
        fromAddress: addressSender.address,
        toAddress: addressRecieve.address,
        amountInSatoshi: getBigIntAmountCoin,
        byteFee: Crypto().feePerByte,
        derivationPath: addressSender.derivationPath,
        privateKey: addressSender.privatekey,
        fee: fee,
        utxos: utxosBitcoin);
    if (transaction != null) {
      addressSender.transactionPending.insert(0, transaction);
      _walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
      await _repo.saveDataToLocal(
          key: addressSender.keyOfTransactionPending,
          data: TransactionPenddingData(data: addressSender.transactionPending)
              .toJson());
    }
  }

  Future<void> createTransactionEthereum() async {
    TransactionData? transaction;
    if (coinModelSelect.contractAddress.isEmpty) {
      transaction = await _repo.createTransactionEthereum(
        addressRecieve: addressRecieve,
        addressSend: addressSender,
        coinModelSelect: coinModelSelect,
        amount: getBigIntAmountCoin,
      );
    } else {
      var privateKey = '';
      if (addressSender.privatekey.isNotEmpty) {
        privateKey = addressSender.privatekey;
      } else {
        privateKey = await _repo.getPrivateKey(
            derivationPath: addressSender.derivationPath,
            coinType: addressSender.coinType);
      }
      transaction = await _repo.createTransactionEthereumERC20(
        addressContract: coinModelSelect.contractAddress,
        addrsassRecieve: addressRecieve.address,
        addressSender: addressSender.address,
        privateKey: privateKey,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
        amount: getBigIntAmountCoin,
      );
    }
    if (transaction != null) {
      addressSender.transactionPending.insert(0, transaction);
      _walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
      await _repo.saveDataToLocal(
          key: addressSender.keyOfTransactionPending,
          data: TransactionPenddingData(data: addressSender.transactionPending)
              .toJson());
    }
  }

  Future<void> createTransactionBinanceSmart() async {
    TransactionData? transaction;
    if (coinModelSelect.contractAddress.isEmpty) {
      transaction = await _repo.createTransactionBinanceSmart(
        addressRecieve: addressRecieve,
        addressSend: addressSender,
        coinModelSelect: coinModelSelect,
        amount: getBigIntAmountCoin,
      );
    } else {
      var privateKey = '';
      if (addressSender.privatekey.isNotEmpty) {
        privateKey = addressSender.privatekey;
      } else {
        privateKey = await _repo.getPrivateKey(
            derivationPath: addressSender.derivationPath,
            coinType: addressSender.coinType);
      }
      transaction = await _repo.createTransactionBinanceSmartBEP20(
        addressContract: coinModelSelect.contractAddress,
        addrsassRecieve: addressRecieve.address,
        addressSender: addressSender.address,
        privateKey: privateKey,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
        amount: getBigIntAmountCoin,
      );
    }
    if (transaction != null) {
      addressSender.transactionPending.insert(0, transaction);
      _walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
      await _repo.saveDataToLocal(
          key: addressSender.keyOfTransactionPending,
          data: TransactionPenddingData(data: addressSender.transactionPending)
              .toJson());
    }
  }

  Future<void> createTransactionPolygon() async {
    TransactionData? transaction;
    if (coinModelSelect.contractAddress.isEmpty) {
      transaction = await _repo.createTransactionPolygon(
        addressRecieve: addressRecieve,
        addressSend: addressSender,
        coinModelSelect: coinModelSelect,
        amount: getBigIntAmountCoin,
      );
    } else {
      var privateKey = '';
      if (addressSender.privatekey.isNotEmpty) {
        privateKey = addressSender.privatekey;
      } else {
        privateKey = await _repo.getPrivateKey(
            derivationPath: addressSender.derivationPath,
            coinType: addressSender.coinType);
      }
      transaction = await _repo.createTransactionPolygonPERC20(
        addressContract: coinModelSelect.contractAddress,
        addrsassRecieve: addressRecieve.address,
        addressSender: addressSender.address,
        privateKey: privateKey,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
        amount: getBigIntAmountCoin,
      );
    }
    if (transaction != null) {
      addressSender.transactionPending.insert(0, transaction);
      _walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
      await _repo.saveDataToLocal(
          key: addressSender.keyOfTransactionPending,
          data: TransactionPenddingData(data: addressSender.transactionPending)
              .toJson());
    }
  }

  Future<void> createTransactionKardiaChain() async {
    var privateKey = '';
    TransactionData? transaction;
    if (addressSender.privatekey.isNotEmpty) {
      privateKey = addressSender.privatekey;
    } else {
      privateKey = await _repo.getPrivateKey(
          derivationPath: addressSender.derivationPath,
          coinType: addressSender.coinType);
    }
    if (coinModelSelect.contractAddress.isEmpty) {
      transaction = await _repo.createTransactionKardiachainByWeb3(
          amount: getBigIntAmountCoin,
          addressSend: addressSender.address,
          addressRecieve: addressRecieve.address,
          privatekey: privateKey,
          coinModelSelect: coinModelSelect);
    } else {
      transaction = await _repo.createTransactionKardiaChainKRC20(
        addressContract: coinModelSelect.contractAddress,
        addrsassRecieve: addressRecieve.address,
        addressSender: addressSender.address,
        privateKey: privateKey,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice,
        amount: getBigIntAmountCoin,
      );
    }

    if (transaction != null) {
      addressSender.transactionPending.insert(0, transaction);
      _walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
      await _repo.saveDataToLocal(
          key: addressSender.keyOfTransactionPending,
          data: TransactionPenddingData(data: addressSender.transactionPending)
              .toJson());
    }
  }

  Future<void> createTransactionStellar() async {
    final transaction = await _repo.createTransactionStellar(
        amount: Crypto.parseStringToBigIntMultiply(
            valueString: amountString, decimal: coinModelSelect.decimals),
        addressSend: addressSender,
        addressRecieve: addressRecieve,
        coinModelSelect: coinModelSelect);
    if (transaction != null) {
      addressSender.transactionPending.insert(0, transaction);
      _walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
      await _repo.saveDataToLocal(
          key: addressSender.keyOfTransactionPending,
          data: TransactionPenddingData(data: addressSender.transactionPending)
              .toJson());
    }
  }

  Future<void> createTransactionPiTestnet() async {
    final transaction = await _repo.createTransactionPiTestnet(
        amount: Crypto.parseStringToBigIntMultiply(
            valueString: amountString, decimal: coinModelSelect.decimals),
        addressSend: addressSender,
        addressRecieve: addressRecieve,
        coinModelSelect: coinModelSelect);
    if (transaction != null) {
      addressSender.transactionPending.insert(0, transaction);
      _walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
      await _repo.saveDataToLocal(
          key: addressSender.keyOfTransactionPending,
          data: TransactionPenddingData(data: addressSender.transactionPending)
              .toJson());
    }
  }

  Future<void> createTransactionTron() async {
    final transaction = await _repo.createTransactionOfTron(
        amount: Crypto.parseStringToBigIntMultiply(
            valueString: amountString, decimal: coinModelSelect.decimals),
        addressSend: addressSender,
        addressRecieve: addressRecieve,
        coinModelSelect: coinModelSelect);
    if (transaction != null) {
      addressSender.transactionPending.insert(0, transaction);
      _walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
      await _repo.saveDataToLocal(
          key: addressSender.keyOfTransactionPending,
          data: TransactionPenddingData(data: addressSender.transactionPending)
              .toJson());
    }
  }

  BigInt get getBigIntAmountCoin =>
      coinModelSelect.stringDoubleToBigInt(amountString);

  bool get isAvalibleValueInput =>
      coinModelSelect.isValueAvalible(amountString);
}
