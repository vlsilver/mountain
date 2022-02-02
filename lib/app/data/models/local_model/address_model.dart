import 'dart:convert';
import 'dart:math';

import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/core/values/string_values.dart';
import 'package:base_source/app/data/models/local_model/address_approve_list.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:get/get.dart';
import 'address_add_liquidity_list.dart';
import 'transaction_model.dart';

class AddressModel {
  /// index in list address of network to create derivationPath
  final int index;

  /// address
  String address;

  /// name
  String name;

  /// referencr to avatar
  int avatar;

  ///if addreess create via import privateKey, this will be here
  String privatekey;

  /// transactionLatest
  String transactionLatest;

  /// list coin model of address
  List<CoinModel> coins;

  /// list transactions
  List<TransactionData> transactions;

  /// list aproveTransactions;
  RevokeDataList? revokeDataList;

  /// list AddLiquidityList;
  AddLiquidityList? addLiquidityList;

  /// list transaction pending
  List<TransactionData> transactionPending;

  /// blockchain id
  String blockChainId;

  /// deravitionPath from blockChain
  String derivationPath;

  /// coinType from blockchain
  int coinType;

  AddressModel({
    required this.index,
    required this.name,
    required this.avatar,
    required this.privatekey,
    required this.transactionLatest,
    this.address = '',
    this.coins = const <CoinModel>[],
    this.transactions = const <TransactionData>[],
    this.transactionPending = const <TransactionData>[],
    this.revokeDataList,
    this.addLiquidityList,
    this.blockChainId = '',
    this.derivationPath = '',
    this.coinType = -1,
  });

  factory AddressModel.init() {
    return AddressModel(
      name: AppString.globalDefaultAddress,
      avatar: 0,
      index: 0,
      privatekey: '',
      transactionLatest: '',
      transactions: <TransactionData>[],
      transactionPending: <TransactionData>[],
    );
  }

  factory AddressModel.fromLocalDatabase(Map<String, dynamic> map) {
    return AddressModel(
      index: map['index'],
      name: map['name'],
      avatar: map['avatar'],
      privatekey: map['privatekey'],
      transactionLatest: map['transactionLatest'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toLocalDatabase() {
    return {
      'index': index,
      'name': name,
      'avatar': avatar,
      'privatekey': privatekey,
      'address': address,
      'transactionLatest': transactionLatest,
    };
  }

  String toJson() => json.encode(toLocalDatabase());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromLocalDatabase(json.decode(source));

  factory AddressModel.empty() => AddressModel(
      index: 0,
      address: '',
      name: '',
      avatar: 0,
      privatekey: '',
      transactionLatest: '',
      blockChainId: '',
      coins: [],
      derivationPath: '',
      coinType: -1);

  @override
  String toString() {
    return 'AddressModel(index: $index, address: $address, name: $name, avatar: $avatar, privatekey: $privatekey, transactionLatest: $transactionLatest, coins: $coins, transactions: $transactions, revokeDataList: $revokeDataList, transactionPending: $transactionPending, blockChainId: $blockChainId, derivationPath: $derivationPath, coinType: $coinType)';
  }

  AddressModel copyWith({
    int? index,
    String? address,
    String? name,
    int? avatar,
    String? privatekey,
    String? transactionLatest,
    List<CoinModel>? coins,
    List<TransactionData>? transactions,
    RevokeDataList? revokeDataList,
    AddLiquidityList? addLiquidityList,
    List<TransactionData>? transactionPending,
    String? blockChainId,
    String? derivationPath,
    int? coinType,
  }) {
    return AddressModel(
      index: index ?? this.index,
      address: address ?? this.address,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      privatekey: privatekey ?? this.privatekey,
      transactionLatest: transactionLatest ?? this.transactionLatest,
      coins: coins ?? this.coins,
      transactions: transactions ?? this.transactions,
      revokeDataList: revokeDataList ?? this.revokeDataList,
      addLiquidityList: addLiquidityList ?? this.addLiquidityList,
      transactionPending: transactionPending ?? this.transactionPending,
      blockChainId: blockChainId ?? this.blockChainId,
      derivationPath: derivationPath ?? this.derivationPath,
      coinType: coinType ?? this.coinType,
    );
  }

  CoinModel getCoinModelByAddressContract(String addressContract) =>
      coins.firstWhere((element) => element.contractAddress == addressContract,
          orElse: () =>
              CoinModel.empty().copyWith(contractAddress: addressContract));

  List<TransactionData> get allTransactions =>
      transactionPending + transactions;

  String get avatarAddress => 'assets/global/avatar/avatar_$avatar.svg';

  double currencyValue() {
    var value = 0.0;
    for (var crypto in coins) {
      value += crypto.currencyValue;
    }
    return value;
  }

  String get keyOfRevokeList => address + blockChainId + 'revoke';

  String get keyOfAddLiquidityList => address + blockChainId + 'addLiquidity';

  String get keyOfTransactionPending =>
      address + blockChainId + 'transactions_pending';

  String get currecyString => CoinModel.currentcyFormat(currencyValue());

  String get currencyStringWithRoundBracks =>
      AppFormat.formatRoundBrackets(value: currecyString);

  /// Số dư: 0 đ
  String get surPlus => 'global_surplus'.tr + '$currecyString';

  /// ( 0xhk4123h424123j22j4 )
  String get addreesWithRoundBrackets =>
      AppFormat.formatRoundBrackets(value: address);

  /// ( 0xhk4123.....h424123j22j4 )
  String get addreesFormatWithRoundBrackets =>
      AppFormat.formatRoundBrackets(value: addressFormat);

  /// 0xdfaskf...fasfgdf
  String get addressFormat =>
      address.substring(0, 15) +
      '...' +
      address.substring(address.length - 6, address.length);

  /// 0xdfaskf...fasfgdf
  static String addressFormatWithValue(String address) =>
      address.substring(0, 15) +
      '...' +
      address.substring(address.length - 6, address.length);

  CoinModel coinAvalible() {
    final coin = coins.firstWhere((coin) => coin.value > BigInt.from(0),
        orElse: () => coinOfBlockChain);
    return coin;
  }

  CoinModel get coinOfBlockChain => coins.firstWhere(
      (element) => element.contractAddress.isEmpty && element.type == 'COIN');

  void coinsInit(List<CoinModel> coinsOfBlockChain) {
    var coinsResult = <CoinModel>[];
    for (var coin in coinsOfBlockChain) {
      coinsResult.add(coin.copyWith());
    }
    coins = coinsResult;
    transactions = [];
  }

  List<TransactionData> transactionsUnSpentBicoin() {
    var transactionsUnspent = <TransactionData>[];
    for (var transaction in transactions) {
      if (transaction.spent == false) {
        transactionsUnspent.add(transaction);
      }
    }
    transactionsUnspent.sort((a, b) => b.value.compareTo(a.value));
    return transactionsUnspent;
  }

  List<dynamic> getTransactionsUnSpentForAmount({
    required int feeInSatoshiPerByte,
    required String addressSend,
    required String addressRecieve,
    required List<UtxoBitcoin> utxos,
    required String amountString,
  }) {
    var utxosResult = <UtxoBitcoin>[];
    var isAvalible = false;
    var fee = 0;

    final amountInSatoshi = Crypto.parseStringToBigIntMultiply(
        valueString: amountString, decimal: 8);
    var valueOfList = 0.0;
    final feeInput = getFeeInputBitcoin(addressSend);
    final feeOutput1 = getFeeOutputBitcoin(addressRecieve);
    final feeOutput2 = getFeeOutputBitcoin(addressSend);
    for (var utxo in utxos) {
      utxosResult.add(utxo);
      valueOfList += utxo.value;
      fee = feeInSatoshiPerByte *
          ((feeInput * utxosResult.length + feeOutput1 + feeOutput2 + 10.5)
              .toInt());
      if (valueOfList.toDouble() > (amountInSatoshi.toDouble() + fee)) {
        isAvalible = true;
        break;
      }
    }
    Crypto().gasLimit = BigInt.from(
        (feeInput * utxosResult.length + feeOutput1 + feeOutput2 + 10.5)
            .toInt());
    Crypto().gasPrice = BigInt.from(feeInSatoshiPerByte);
    final result = [
      isAvalible ? utxosResult : <UtxoBitcoin>[],
      fee / pow(10, 8),
    ];
    return result;
  }

  static double getFeeOutputBitcoin(String address) {
    /// A P2PKH (1... address) output is 34 vbytes.
    /// A P2SH (3... address) output is 32 vbytes.
    /// A P2WPKH (bc1q... address of length 42) output is 31 vbytes.
    /// A P2WSH (bc1q... address of length 62) output is 43 vbytes.
    var feeOutput = 0.0;
    if (address.substring(0, 4) == 'bc1q') {
      if (address.length == 62) {
        feeOutput = 43.0;
      } else {
        feeOutput = 31;
      }
    } else if (address[0] == '1') {
      feeOutput = 34.0;
    } else if (address[0] == '3') {
      feeOutput = 32.0;
    } else {
      feeOutput = 43.0;
    }
    return feeOutput;
  }

  static double getFeeInputBitcoin(String address) {
    /// A P2PKH spend with a compressed public key is 149 vbytes.
    /// A P2WPKH spend is 68 vbytes.
    /// A P2SH-P2WPKH spend is 93 vbytes.
    var feeInput = 0.0;
    if (address.substring(0, 4) == 'bc1q') {
      if (address.length == 62) {
        feeInput = 93.0;
      } else {
        feeInput = 68.5;
      }
    } else if (address[0] == '1') {
      feeInput = 149.0;
    } else if (address[0] == '3') {
      feeInput = 93.0;
    } else {
      feeInput = 149.0;
    }
    return feeInput;
  }
}
