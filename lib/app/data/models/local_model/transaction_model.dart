import 'dart:convert';
import 'dart:math';

import 'package:intl/intl.dart';

import 'package:base_source/app/data/models/local_model/coin_model.dart';

import 'address_model.dart';
import 'blockchain_model.dart';

class TransactionData {
  final int timeStamp;
  final String hash;
  final String nonce;
  final String? isError;
  final String? status;
  String from;
  String to;
  int gasPrice;
  final String contractAddress;
  final String confirmations;
  double value;
  final int gasUsed;
  final int cumulativeGasUsed;
  final int? indexInput;
  final int? indexOutput;
  final bool? spent;
  final bool? doubleSpent;
  final String? timeString;

  TransactionData({
    required this.timeStamp,
    required this.hash,
    required this.nonce,
    required this.isError,
    required this.status,
    required this.from,
    required this.to,
    required this.contractAddress,
    required this.confirmations,
    required this.value,
    required this.gasUsed,
    required this.cumulativeGasUsed,
    required this.gasPrice,
    this.indexInput,
    this.indexOutput,
    this.spent,
    this.doubleSpent,
    this.timeString,
  });

  factory TransactionData.fromEthereum(Map<String, dynamic> map) {
    return TransactionData(
      timeStamp: int.parse(map['timeStamp'] ?? '0'),
      hash: map['hash'],
      nonce: map['nonce'],
      isError: map['isError'],
      status: 'success',
      from: map['from'],
      to: map['to'],
      contractAddress: map['contractAddress'] ?? '',
      confirmations: map['confirmations'],
      value: double.parse(map['value']),
      gasUsed: int.parse(map['gasUsed']),
      cumulativeGasUsed: int.parse(map['cumulativeGasUsed']),
      gasPrice: int.parse(map['gasPrice']),
    );
  }

  factory TransactionData.fromEthereumRaw(Map<String, dynamic> map) {
    return TransactionData(
      timeStamp: map['timeStamp'] != null
          ? int.parse(map['timeStamp'])
          : DateTime.now().millisecondsSinceEpoch ~/ 1000,
      hash: map['hash'],
      nonce:
          int.parse((map['nonce'] ?? '0x0').substring(2), radix: 16).toString(),
      isError: map['isError'],
      status: 'success',
      from: map['from'],
      to: map['to'],
      contractAddress: map['contractAddress'] ?? '',
      confirmations: map['input'],
      value: BigInt.parse((map['value'] ?? '0x0').substring(2), radix: 16)
          .toDouble(),
      gasUsed: int.parse((map['gas'] ?? '0x0').substring(2), radix: 16),
      cumulativeGasUsed: 0,
      gasPrice: int.parse((map['gasPrice'] ?? '0x0').substring(2), radix: 16),
    );
  }

  factory TransactionData.fromEthereumPending(Map<String, dynamic> map) {
    return TransactionData(
      timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      hash: map['hash'],
      nonce: int.parse(map['nonce'].substring(2), radix: 16).toString(),
      isError: map['isError'],
      status: 'pending',
      from: map['from'],
      to: '',
      contractAddress: map['contractAddress'] ?? '',
      confirmations: map['confirmations'] ?? '',
      value: 0,
      gasUsed: int.parse(map['gas'].substring(2), radix: 16),
      cumulativeGasUsed: 0,
      gasPrice: int.parse(map['gasPrice'].substring(2), radix: 16),
    );
  }

  factory TransactionData.fromKardiaChain(Map<String, dynamic> map) {
    final time = DateTime.parse((map['time'] as String).split('.')[0])
            .millisecondsSinceEpoch ~/
        1000;
    return TransactionData(
      timeStamp: time,
      timeString: '',
      hash: map['hash'],
      nonce: map['nonce'].toString(),
      isError: map['status'].toString(),
      status: 'success',
      from: map['from'],
      to: map['to'],
      contractAddress: '',
      confirmations: map['input'],
      value: double.parse(map['value']),
      gasUsed: map['gas'],
      cumulativeGasUsed: int.parse(map['cumulativeGasUsed'] ?? '0'),
      gasPrice: map['gasPrice'],
    );
  }

  factory TransactionData.fromStellarPayment(Map<String, dynamic> map) {
    return TransactionData(
      timeStamp: 0,
      timeString: map['created_at'],
      hash: map['transaction_hash'],
      nonce: '0',
      isError: map['transaction_successful'] ? '0' : '1',
      status: 'success',
      from: map['from'],
      to: map['to'],
      contractAddress: '',
      confirmations: '',
      value: map['asset_type'] == 'native'
          ? double.parse(map['amount']) * pow(10, 7)
          : 0.0,
      gasUsed: 0,
      cumulativeGasUsed: 0,
      gasPrice: 0,
    );
  }

  factory TransactionData.fromStellarPaymentPending(Map<String, dynamic> map) {
    return TransactionData(
      timeStamp: 0,
      timeString: map['created_at'],
      hash: map['hash'],
      nonce: '0',
      isError: map['successful'] ? '0' : '1',
      status: 'pending',
      from: '',
      to: '',
      contractAddress: '',
      confirmations: '',
      value: 0.0,
      gasUsed: 0,
      cumulativeGasUsed: 0,
      gasPrice: 0,
    );
  }

  factory TransactionData.fromStellarCreateAccount(Map<String, dynamic> map) {
    return TransactionData(
      timeStamp: 0,
      timeString: map['created_at'],
      hash: map['transaction_hash'],
      nonce: '0',
      isError: map['transaction_successful'] ? '0' : '1',
      status: 'success',
      from: map['funder'],
      to: map['account'],
      contractAddress: '',
      confirmations: '',
      value: double.parse(map['starting_balance']) * pow(10, 7),
      gasUsed: 0,
      cumulativeGasUsed: 0,
      gasPrice: 0,
    );
  }

  factory TransactionData.fromMapBitcoinConfirm(
      Map<String, dynamic> map, String address) {
    final status = map['status']['confirmed'];
    if (!status) {
      return TransactionData.empty();
    }
    var valueInput = 0;
    var valueOutput = 0;
    var addressInput = '';
    var addressOutput = '';
    var vin = map['vin'] as List<dynamic>;
    var vout = map['vout'] as List<dynamic>;
    final fee = map['fee'] as int;
    for (var item in vin) {
      final prevout = item['prevout'];
      if (prevout['scriptpubkey_address'] == address) {
        valueInput += prevout['value'] as int;
      } else {
        addressInput = prevout['scriptpubkey_address'];
      }
    }
    for (var item in vout) {
      if (item['scriptpubkey_address'] == address) {
        valueOutput += item['value'] as int;
      } else {
        addressOutput = item['scriptpubkey_address'];
      }
    }
    final isSender = valueInput - valueOutput >= 0;
    final value = isSender ? valueInput - valueOutput - fee : valueOutput;
    return TransactionData(
      timeStamp: map['status']['block_time'],
      timeString: '',
      hash: map['txid'],
      nonce: '0',
      isError: null,
      status: map['status']['confirmed'] ? 'success' : 'pending',
      from: isSender ? address : addressInput,
      to: !isSender ? address : addressOutput,
      contractAddress: '',
      confirmations: '',
      value: value.toDouble(),
      gasUsed: 0,
      cumulativeGasUsed: 0,
      gasPrice: fee,
    );
  }

  factory TransactionData.fromMapBitcoinUnconfirm(
      Map<String, dynamic> map, String address) {
    var valueInput = 0;
    var valueOutput = 0;
    var addressInput = '';
    var addressOutput = '';
    var vin = map['vin'] as List<dynamic>;
    var vout = map['vout'] as List<dynamic>;
    final fee = map['fee'] as int;
    for (var item in vin) {
      final prevout = item['prevout'];
      if (prevout['scriptpubkey_address'] == address) {
        valueInput += prevout['value'] as int;
      } else {
        addressInput = prevout['scriptpubkey_address'];
      }
    }
    for (var item in vout) {
      if (item['scriptpubkey_address'] == address) {
        valueOutput += item['value'] as int;
      } else {
        addressOutput = item['scriptpubkey_address'];
      }
    }
    final isSender = valueInput - valueOutput >= 0;
    final value = isSender ? valueInput - valueOutput - fee : valueOutput;
    return TransactionData(
      timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      timeString: '',
      hash: map['txid'],
      nonce: '0',
      isError: null,
      status: 'pending',
      from: isSender ? address : addressInput,
      to: !isSender ? address : addressOutput,
      contractAddress: '',
      confirmations: '',
      value: value.toDouble(),
      gasUsed: 0,
      cumulativeGasUsed: 0,
      gasPrice: fee,
    );
  }

  factory TransactionData.fromMapTronAll(Map<String, dynamic> map) {
    final rawData = map['raw_data'];
    final contract = rawData['contract'][0];
    final value = contract['parameter']['value'];
    final type = contract['type'] == 'TransferContract';
    final typeSupport = contract['type'] == 'TransferContract' ||
        contract['type'] == 'TriggerSmartContract';
    if (typeSupport) {
      return TransactionData(
        timeStamp: rawData['timestamp'],
        hash: map['txID'],
        nonce: '0',
        isError: map['ret'][0]['contractRet'] == 'SUCCESS' ? '0' : '1',
        status: 'success',
        from: value['owner_address'],
        to: value['to_address'] ?? value['contract_address'],
        contractAddress: '',
        confirmations: '',
        value: type ? (value['amount'] as int).toDouble() : 0.0,
        gasUsed: 1,
        cumulativeGasUsed: 0,
        gasPrice: map['energy_fee'] ?? 0,
      );
    } else {
      return TransactionData.empty();
    }
  }

  factory TransactionData.fromMapTronPending(Map<String, dynamic> map) {
    return TransactionData(
      timeStamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      hash: map['txID'],
      nonce: '0',
      isError: null,
      status: 'pending',
      from: '',
      to: '',
      contractAddress: '',
      confirmations: '',
      value: 0,
      gasUsed: 1,
      cumulativeGasUsed: 0,
      gasPrice: 0,
    );
  }

  factory TransactionData.fromMapTronTRC20(Map<String, dynamic> map) {
    return TransactionData(
      timeStamp: map['block_timestamp'],
      hash: map['transaction_id'],
      status: 'success',
      isError: null,
      nonce: '0',
      from: map['from'],
      to: map['to'],
      contractAddress: map['token_info']['address'],
      confirmations: '',
      value: double.parse(map['value']),
      gasUsed: 0,
      cumulativeGasUsed: 0,
      gasPrice: 1,
    );
  }

  factory TransactionData.empty() {
    return TransactionData(
        timeStamp: 0,
        timeString: '',
        hash: '',
        nonce: '0',
        isError: null,
        status: null,
        from: '',
        to: '',
        contractAddress: '',
        confirmations: '',
        value: 0,
        gasUsed: 0,
        cumulativeGasUsed: 0,
        gasPrice: 0,
        indexInput: 0,
        indexOutput: 0,
        spent: null,
        doubleSpent: false);
  }

  String time() {
    if (timeStamp != 0) {
      if (timeStamp.toString().length == 13) {
        var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
        var formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(date);
        return formattedDate;
      } else if (timeStamp.toString().length == 10) {
        var date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
        var formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(date);
        return formattedDate;
      } else {
        var date = DateTime.fromMillisecondsSinceEpoch(timeStamp ~/ 1000);
        var formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(date);
        return formattedDate;
      }
    } else {
      return timeString!;
    }
  }

  CoinModel? getCoinModel({
    required AddressModel addressModel,
  }) {
    if (addressModel.blockChainId != BlockChainModel.bitcoin) {
      final index = addressModel.coins
          .indexWhere((coin) => coin.contractAddress == contractAddress);
      if (index == -1) {
        return null;
      } else {
        return addressModel.coins[index];
      }
    } else {
      return addressModel.coinOfBlockChain;
    }
  }

  double valueFormat(CoinModel coinModel) =>
      value.toDouble() / coinModel.powDecimals;

  String valueFormatString(CoinModel coinModel) =>
      '${Crypto.numberFormatNumberToken(value.toDouble() / coinModel.powDecimals)}';

  String feeFormatStringByCoinModel(CoinModel coinModel) {
    switch (coinModel.blockchainId) {
      case BlockChainModel.bitcoin:
        return '${gasPrice / pow(10, 8)} BTC';
      case BlockChainModel.ethereum:
        return '${gasPrice * gasUsed / pow(10, 18)} ETH';
      case BlockChainModel.binanceSmart:
        return '${gasPrice * gasUsed / pow(10, 18)} BNB';
      case BlockChainModel.polygon:
        return '${gasPrice * gasUsed / pow(10, 18)} MATIC';
      case BlockChainModel.kardiaChain:
        return '${gasPrice * gasUsed / pow(10, 18)} KAI';
      case BlockChainModel.stellar:
        return '${gasPrice / pow(10, 7)} XLM';
      case BlockChainModel.piTestnet:
        return '${gasPrice / pow(10, 7)} PI';
      case BlockChainModel.tron:
        return '${gasPrice / pow(10, 6)} TRX';
      default:
        return '0 SUPPORT';
    }
  }

  String valueFormatCurrencyByCoinModel(CoinModel coinModel) =>
      CoinModel.currentcyFormat(valueFormat(coinModel) * coinModel.price);

  bool get isFailure => isError == '1';

  bool get isPending => status == 'pending';

  bool isSender({required AddressModel addressModel}) {
    return addressModel.address.toLowerCase() == from.toLowerCase();
  }

  static String feeFormatWithSymbolByData({
    required double fees,
    required String blockChainId,
  }) {
    switch (blockChainId) {
      case BlockChainModel.bitcoin:
        return '$fees BTC';
      case BlockChainModel.ethereum:
        return '$fees ETH';
      case BlockChainModel.binanceSmart:
        return '$fees BNB';
      case BlockChainModel.polygon:
        return '$fees MATIC';
      case BlockChainModel.kardiaChain:
        return '$fees KAI';
      case BlockChainModel.stellar:
        return '$fees XLM';
      case BlockChainModel.piTestnet:
        return '$fees PI';
      case BlockChainModel.tron:
        return '$fees TRX';
      default:
        return '0 SUPPORT';
    }
  }

  double feeValue(CoinModel coinModel) {
    switch (coinModel.blockchainId) {
      case BlockChainModel.bitcoin:
        return gasPrice / pow(10, 8);
      case BlockChainModel.ethereum:
        return gasPrice * gasUsed / pow(10, 18);
      case BlockChainModel.binanceSmart:
        return gasPrice * gasUsed / pow(10, 18);
      case BlockChainModel.polygon:
        return gasPrice * gasUsed / pow(10, 18);
      case BlockChainModel.kardiaChain:
        return gasPrice * gasUsed / pow(10, 18);
      case BlockChainModel.stellar:
        return gasPrice / pow(10, 7);
      case BlockChainModel.piTestnet:
        return gasPrice / pow(10, 7);
      case BlockChainModel.tron:
        return gasPrice / pow(10, 6);
      default:
        return 0.0;
    }
  }

  static double feePrice(String id) {
    switch (id) {
      case BlockChainModel.bitcoin:
        return Crypto().price('bitcoin');
      case BlockChainModel.ethereum:
        return Crypto().price('ethereum');
      case BlockChainModel.binanceSmart:
        return Crypto().price('binancecoin');
      case BlockChainModel.polygon:
        return Crypto().price('matic-network');
      case BlockChainModel.kardiaChain:
        return Crypto().price('kardiachain');
      case BlockChainModel.stellar:
        return Crypto().price('stellar');
      case BlockChainModel.piTestnet:
        return Crypto().price('pi');
      case BlockChainModel.tron:
        return Crypto().price('tron');
      default:
        return 0.0;
    }
  }

  String totalFormatCurrencyByCoinModel(CoinModel coinModel) {
    return CoinModel.currentcyFormat((valueFormat(coinModel) * coinModel.price +
        feeValue(coinModel) * feePrice(coinModel.blockchainId)));
  }

  String feeFormatCurrencyByCoinModel(CoinModel coinModel) {
    return CoinModel.currentcyFormat(
        feeValue(coinModel) * feePrice(coinModel.blockchainId));
  }

  static String totalFormatByData({
    required CoinModel coinModel,
    required double fee,
    required double amount,
  }) {
    final feeCurrency = fee * feePrice(coinModel.blockchainId);
    final amountCurrency = amount * coinModel.price;
    return CoinModel.currentcyFormat(feeCurrency + amountCurrency);
  }

  static String totalFormatForAddliquididy({
    required CoinModel coinModelA,
    required CoinModel coinModelB,
    required double fee,
    required double amountA,
    required double amountB,
  }) {
    final feeCurrency = fee * feePrice(coinModelA.blockchainId);
    final amountCurrencyA = amountA * coinModelA.price;
    final amountCurrencyB = amountB * coinModelB.price;
    return CoinModel.currentcyFormat(
        feeCurrency + amountCurrencyA + amountCurrencyB);
  }

  @override
  String toString() {
    return 'TransactionData(timeStamp: $timeStamp, hash: $hash, nonce: $nonce, isError: $isError, status: $status, from: $from, to: $to, gasPrice: $gasPrice, contractAddress: $contractAddress, confirmations: $confirmations, value: $value, gasUsed: $gasUsed, cumulativeGasUsed: $cumulativeGasUsed, indexInput: $indexInput, indexOutput: $indexOutput, spent: $spent, doubleSpent: $doubleSpent, timeBitcoin: $timeString)';
  }

  TransactionData copyWith({
    int? timeStamp,
    String? hash,
    String? nonce,
    String? isError,
    String? status,
    String? from,
    String? to,
    int? gasPrice,
    String? contractAddress,
    String? confirmations,
    double? value,
    int? gasUsed,
    int? cumulativeGasUsed,
    int? indexInput,
    int? indexOutput,
    bool? spent,
    bool? doubleSpent,
    String? timeString,
  }) {
    return TransactionData(
      timeStamp: timeStamp ?? this.timeStamp,
      hash: hash ?? this.hash,
      nonce: nonce ?? this.nonce,
      isError: isError ?? this.isError,
      status: status ?? this.status,
      from: from ?? this.from,
      to: to ?? this.to,
      gasPrice: gasPrice ?? this.gasPrice,
      contractAddress: contractAddress ?? this.contractAddress,
      confirmations: confirmations ?? this.confirmations,
      value: value ?? this.value,
      gasUsed: gasUsed ?? this.gasUsed,
      cumulativeGasUsed: cumulativeGasUsed ?? this.cumulativeGasUsed,
      indexInput: indexInput ?? this.indexInput,
      indexOutput: indexOutput ?? this.indexOutput,
      spent: spent ?? this.spent,
      doubleSpent: doubleSpent ?? this.doubleSpent,
      timeString: timeString ?? this.timeString,
    );
  }

  Map<String, dynamic> toLocalDatabase() {
    return {
      'timeStamp': timeStamp,
      'hash': hash,
      'nonce': nonce,
      'isError': isError,
      'status': status,
      'from': from,
      'to': to,
      'gasPrice': gasPrice,
      'contractAddress': contractAddress,
      'confirmations': confirmations,
      'value': value,
      'gasUsed': gasUsed,
      'cumulativeGasUsed': cumulativeGasUsed,
      'indexInput': indexInput,
      'indexOutput': indexOutput,
      'spent': spent,
      'doubleSpent': doubleSpent,
      'timeString': timeString,
    };
  }

  factory TransactionData.fromLocalDatabase(Map<String, dynamic> map) {
    return TransactionData(
      timeStamp: map['timeStamp'],
      hash: map['hash'],
      nonce: map['nonce'],
      isError: map['isError'],
      status: map['status'],
      from: map['from'],
      to: map['to'],
      gasPrice: map['gasPrice'],
      contractAddress: map['contractAddress'],
      confirmations: map['confirmations'],
      value: map['value'],
      gasUsed: map['gasUsed'],
      cumulativeGasUsed: map['cumulativeGasUsed'],
      indexInput: map['indexInput'],
      indexOutput: map['indexOutput'],
      spent: map['spent'],
      doubleSpent: map['doubleSpent'],
      timeString: map['timeString'],
    );
  }

  String toJson() => json.encode(toLocalDatabase());

  factory TransactionData.fromJson(String source) =>
      TransactionData.fromLocalDatabase(json.decode(source));
}

class UtxoBitcoin {
  final String hash;
  final int indexOutput;
  final int value;
  UtxoBitcoin({
    required this.hash,
    required this.indexOutput,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'hash': hash,
      'indexOutput': indexOutput,
      'value': value,
    };
  }

  factory UtxoBitcoin.fromMap(Map<String, dynamic> map) {
    return UtxoBitcoin(
      hash: map['txid'],
      indexOutput: map['vout'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UtxoBitcoin.fromJson(String source) =>
      UtxoBitcoin.fromMap(json.decode(source));

  @override
  String toString() =>
      'UtxoBitcoin(hash: $hash, indexOutput: $indexOutput, value: $value)';
}
