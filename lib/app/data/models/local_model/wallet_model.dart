import 'dart:convert';

import 'package:base_source/app/core/values/key_values.dart';
import 'package:base_source/app/data/models/local_model/address_add_liquidity_list.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';

import 'blockchain_model.dart';

class TotalWalletModel {
  /// current wallet active.
  int? active;

  /// length of wallet be created.
  int length;
  TotalWalletModel({
    required this.active,
    required this.length,
  });

  Map<String, dynamic> toMap() {
    return {
      'active': active,
      'length': length,
    };
  }

  factory TotalWalletModel.fromMap(Map<String, dynamic> map) {
    return TotalWalletModel(
      active: map['active'],
      length: map['length'],
    );
  }

  factory TotalWalletModel.empty() {
    return TotalWalletModel(
      active: null,
      length: 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TotalWalletModel.fromJson(String source) =>
      TotalWalletModel.fromMap(json.decode(source));

  static String get key => AppKeys.TOTAL_WALLET_KEY;

  List<int> get listIndexOfWallet => List.generate(length, (index) => index);

  TotalWalletModel copyWith({
    int? active,
    int? length,
  }) {
    return TotalWalletModel(
      active: active ?? this.active,
      length: length ?? this.length,
    );
  }

  @override
  String toString() => 'TotalWalletModel(active: $active, length: $length)';
}

class WalletModel {
  /// key to access keychain.
  final String key;

  /// recovery seed phrase.
  final String mnemonic;

  /// index in list wallets.
  final int index;

  List<String> coinSorts;

  /// name of wallet.
  String name;

  /// current active blockchain
  int indexBlockChainActive;

  /// password to login.
  String password;

  List<BlockChainModel> blockChains;

  WalletModel({
    required this.key,
    required this.mnemonic,
    required this.index,
    required this.name,
    required this.indexBlockChainActive,
    required this.password,
    required this.blockChains,
    required this.coinSorts,
  });

  factory WalletModel.empty() => WalletModel(
        key: '',
        mnemonic: '',
        password: '',
        name: '',
        index: 0,
        blockChains: [],
        indexBlockChainActive: 0,
        coinSorts: [],
      );

  factory WalletModel.init({
    required String key,
    required String mnemonic,
    required String password,
    required int index,
  }) {
    return WalletModel(
      password: password,
      mnemonic: mnemonic,
      index: index,
      key: key,
      indexBlockChainActive: 0,
      name: index == 0 ? 'Main Wallet' : 'Wallet $index',
      blockChains: [],
      coinSorts: [],
    );
  }

  factory WalletModel.fromLocalDatabase(Map<String, dynamic> map) {
    return WalletModel(
      key: map['key'],
      mnemonic: map['mnemonic'],
      index: map['index'],
      name: map['name'],
      indexBlockChainActive: map['blockChainActive'],
      password: map['password'],
      coinSorts: List<String>.from(map['coinSorts']?.map((x) => x)),
      blockChains: List<BlockChainModel>.from(
          map['blockChains']?.map((x) => BlockChainModel.fromLocalDatabase(x))),
    );
  }

  Map<String, dynamic> toLocaDatabase() {
    return {
      'key': key,
      'mnemonic': mnemonic,
      'index': index,
      'name': name,
      'blockChainActive': indexBlockChainActive,
      'password': password,
      'blockChains': blockChains.map((x) => x.toLocalDatabase()).toList(),
      'coinSorts': coinSorts.map((x) => x).toList()
    };
  }

  String toJson() => json.encode(toLocaDatabase());

  factory WalletModel.fromJson(String source) =>
      WalletModel.fromLocalDatabase(json.decode(source));

  @override
  String toString() {
    return 'WalletModel(key: $key, mnemonic: $mnemonic, index: $index, name: $name, blockChainActive: $indexBlockChainActive, password: $password, blockChains: $blockChains)';
  }

  static String keyFromIndex({required int index}) =>
      AppKeys.WALLET_KEY + index.toString();

  String get keyForFavouritePairCoin =>
      'favourite_coin_pair_wallet' + index.toString();

  WalletModel copyWith({
    String? key,
    String? mnemonic,
    int? index,
    String? name,
    int? indexBlockChainActive,
    String? password,
    List<BlockChainModel>? blockChains,
    List<String>? coinSorts,
  }) {
    return WalletModel(
      key: key ?? this.key,
      mnemonic: mnemonic ?? this.mnemonic,
      index: index ?? this.index,
      name: name ?? this.name,
      indexBlockChainActive:
          indexBlockChainActive ?? this.indexBlockChainActive,
      password: password ?? this.password,
      blockChains: blockChains ?? this.blockChains,
      coinSorts: coinSorts ?? this.coinSorts,
    );
  }

  double currencyValue() {
    var value = 0.0;
    for (var network in blockChains) {
      value += network.currencyValue();
    }
    return value;
  }

  String getNetworkByBlockChainId(String id) {
    return blockChains
        .firstWhere((blockChain) => blockChain.id == id,
            orElse: () => blockChains[0])
        .network;
  }

  String getImageByBlockChainId(String id) {
    return blockChains.firstWhere((blockChain) => blockChain.id == id).image;
  }

  String get currencyString => CoinModel.currentcyFormat(currencyValue());

  BlockChainModel getBlockChainModel(String id) =>
      blockChains.firstWhere((element) => element.id == id);

  List<CoinModel> allCoinsAtive() {
    var coinsWithValue = <CoinModel>[];
    var coinsNoValue = <CoinModel>[];
    for (var blockChain in blockChains) {
      final data = blockChain.allCoinsActive();
      coinsWithValue.addAll(data[0]);
      coinsNoValue.addAll(data[1]);
    }
    final listData = coinsWithValue + coinsNoValue;
    var listActivesHasValue = <CoinModel>[];
    var listActivesNoValue = <CoinModel>[];
    var coinsSortNewHasValue = <String>[];
    var coinsSortNewNoValue = <String>[];
    if (listData.isEmpty) {
      return [];
    }
    for (var coinSort in coinSorts) {
      var index = listData.indexWhere(
          (element) => element.blockchainId + '+' + element.id == coinSort);
      if (index != -1) {
        if (listData[index].value > BigInt.from(0)) {
          listActivesHasValue.add(listData[index]);
          coinsSortNewHasValue
              .add(listData[index].blockchainId + '+' + listData[index].id);
        } else {
          listActivesNoValue.add(listData[index]);
          coinsSortNewNoValue
              .add(listData[index].blockchainId + '+' + listData[index].id);
          // }
          listData.removeAt(index);
        }
      }
    }
    coinSorts = coinsSortNewHasValue + coinsSortNewNoValue;
    return listActivesHasValue + listActivesNoValue;
  }

  List<CoinModel> allCoins() {
    var coins = <CoinModel>[];
    for (var blockChain in blockChains) {
      coins.addAll(blockChain.coins);
    }
    return coins;
  }

  List<String> get seedPhrase => mnemonic.split(' ');

  List<String> allCoinIds() {
    var coinIds = <String>[];
    for (var coin in allCoins()) {
      coinIds.add(coin.id);
    }
    return coinIds;
  }

  List<AddLiquidityModel> addLiquidityList() {
    var data = <AddLiquidityModel>[];
    for (var blockChain in blockChains) {
      data.addAll(blockChain.addLiquidityList());
    }
    return data;
  }
}
