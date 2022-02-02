import 'package:base_source/app/data/models/local_model/address_add_liquidity_list.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';

import 'coin_model.dart';

class BlockChainModel {
  final String id;

  final int index;

  /// communicate with Trust Wallet Core
  int coinType;

  String name;

  String coin;

  String derivationPath;

  String nodeHttp;

  String nodeWss;

  String api;

  String image;

  /// list address model
  List<AddressModel> addresss;

  /// list address favourite
  List<AddressModel> addresssFavourite;

  /// list index coin active show on darboard, default coin of blockchain
  List<String> idOfCoinActives;

  /// list token user add
  List<CoinModel> coinsAddLocalDatabase;

  /// list coins of BlockChain
  List<CoinModel> coins;

  /// index current address active
  int indexAddressActive;

  BlockChainModel({
    required this.id,
    required this.addresss,
    required this.addresssFavourite,
    required this.idOfCoinActives,
    required this.coinsAddLocalDatabase,
    required this.indexAddressActive,
    required this.index,
    this.coinType = -1,
    this.name = '',
    this.coin = '',
    this.derivationPath = '',
    this.nodeHttp = '',
    this.nodeWss = '',
    this.api = '',
    this.image = '',
    this.coins = const <CoinModel>[],
  });

  factory BlockChainModel.init(Map<String, dynamic> map, int index) {
    return BlockChainModel(
      id: map['id'],
      index: index,
      addresss: <AddressModel>[],
      coin: map['coin'],
      addresssFavourite: <AddressModel>[],
      idOfCoinActives: <String>[map['coin']],
      coinsAddLocalDatabase: <CoinModel>[],
      indexAddressActive: 0,
    );
  }

  void initData(Map<String, dynamic> jsonData) {
    coinType = jsonData['coinType'] as int;
    name = jsonData['name'];
    coin = jsonData['coin'];
    derivationPath = jsonData['derivationPath'];
    nodeHttp = jsonData['nodeHttp'];
    nodeWss = jsonData['nodeWss'] ?? '';
    api = jsonData['api'] ?? '';
    image = jsonData['image'];
  }

  factory BlockChainModel.fromLocalDatabase(Map<String, dynamic> map) {
    return BlockChainModel(
      id: map['id'],
      index: map['index'],
      addresss: List<AddressModel>.from(
          map['addresss']?.map((x) => AddressModel.fromLocalDatabase(x))),
      addresssFavourite: List<AddressModel>.from(map['addresssFavourite']
          ?.map((x) => AddressModel.fromLocalDatabase(x))),
      idOfCoinActives: List<String>.from(map['idOfCoinActives']),
      coinsAddLocalDatabase: List<CoinModel>.from(map['coinsAddLocalDatabase']
          ?.map((x) => CoinModel.fromLocalDatabase(x))),
      indexAddressActive: map['indexAddressActive'],
    );
  }

  Map<String, dynamic> toLocalDatabase() {
    return {
      'id': id,
      'index': index,
      'addresss': addresss.map((x) => x.toLocalDatabase()).toList(),
      'addresssFavourite':
          addresssFavourite.map((x) => x.toLocalDatabase()).toList(),
      'idOfCoinActives': idOfCoinActives,
      'coinsAddLocalDatabase':
          coinsAddLocalDatabase.map((x) => x.toLocalDatabase()).toList(),
      'indexAddressActive': indexAddressActive,
    };
  }

  @override
  String toString() {
    return 'BlockChainModel(id: $id, index: $index, coinType: $coinType, name: $name, coin: $coin, derivationPath: $derivationPath, nodeHttp: $nodeHttp, nodeWss: $nodeWss, api: $api, image: $image, addresss: $addresss, addresssFavourite: $addresssFavourite, idOfCoinActives: $idOfCoinActives, coinsAddLocalDatabase: $coinsAddLocalDatabase, coins: $coins, indexAddressActive: $indexAddressActive)';
  }

  BlockChainModel copyWith({
    String? id,
    int? index,
    int? coinType,
    String? name,
    String? coin,
    String? derivationPath,
    String? nodeHttp,
    String? nodeWss,
    String? api,
    String? image,
    List<AddressModel>? addresss,
    List<AddressModel>? addresssFavourite,
    List<String>? idOfCoinActives,
    List<CoinModel>? coinsAddLocalDatabase,
    int? indexAddressActive,
  }) {
    return BlockChainModel(
      id: id ?? this.id,
      index: index ?? this.index,
      coinType: coinType ?? this.coinType,
      name: name ?? this.name,
      coin: coin ?? this.coin,
      derivationPath: derivationPath ?? this.derivationPath,
      nodeHttp: nodeHttp ?? this.nodeHttp,
      nodeWss: nodeWss ?? this.nodeWss,
      api: api ?? this.api,
      image: image ?? this.image,
      addresss: addresss ?? this.addresss,
      addresssFavourite: addresssFavourite ?? this.addresssFavourite,
      idOfCoinActives: idOfCoinActives ?? this.idOfCoinActives,
      coinsAddLocalDatabase:
          coinsAddLocalDatabase ?? this.coinsAddLocalDatabase,
      indexAddressActive: indexAddressActive ?? this.indexAddressActive,
    );
  }

  String getDerivationPathByIndex(int index) {
    final lenDerivation = derivationPath.length;
    var result = derivationPath.substring(0);

    if (result[lenDerivation - 1] == '0') {
      result =
          derivationPath.substring(0, lenDerivation - 1) + index.toString();
    } else if (result[lenDerivation - 2] == '0') {
      result = derivationPath.substring(0, lenDerivation - 2) +
          index.toString() +
          derivationPath.substring(lenDerivation - 1);
    }
    return result;
  }

  List<String> get addresssString =>
      addresss.map((address) => address.address).toList();

  void coinsInit({required List<dynamic> coinsJson}) {
    var coinsActive = <CoinModel>[];
    var coinsDisable = <CoinModel>[];
    for (var json in coinsJson) {
      final coinResult = CoinModel.fromJsonData(json);
      if (idOfCoinActives.contains(coinResult.id)) {
        coinResult.isActive = true;
        coinsActive.add(coinResult);
      } else {
        coinsDisable.add(coinResult);
      }
    }
    for (var coin in coinsAddLocalDatabase) {
      final isNotExited = (coinsActive + coinsDisable).indexWhere((element) =>
              element.contractAddress.toLowerCase() ==
              coin.contractAddress.toLowerCase()) ==
          -1;
      if (isNotExited) {
        if (coin.isActive) {
          if (isNotExited) {
            coinsActive.add(coin);
          }
        } else {
          coinsDisable.add(coin);
        }
      }
    }
    coins = coinsActive + coinsDisable;
  }

  CoinModel get coinOfBlockChain => coins.firstWhere(
      (element) => element.contractAddress.isEmpty && element.type == 'COIN');

  static String getNetwork(String id) {
    switch (id) {
      case bitcoin:
        return 'Bitcoin Network';
      case ethereum:
        return 'Ethereum Network';
      case binanceSmart:
        return 'Binance Smart Chain Network';
      case kardiaChain:
        return 'KardiaChain Network';
      case stellar:
        return 'Stellar Network';
      case piTestnet:
        return 'Pi Network';
      case tron:
        return 'Tron Network';
      case polygon:
        return 'Polygon Network';
      default:
        return 'Not support';
    }
  }

  static String getImageDefault(String id) {
    switch (id) {
      case bitcoin:
        return 'assets/global/bitcoin.png';
      case ethereum:
        return 'assets/global/ethereum.png';
      case binanceSmart:
        return 'assets/global/binance_smart_chain.png';
      case kardiaChain:
        return 'assets/global/kardiachain.png';
      case stellar:
        return 'assets/global/stellar.png';
      case piTestnet:
        return 'assets/global/pi.png';
      case tron:
        return 'assets/global/tron.png';
      case polygon:
        return 'assets/global/polygon.png';
      default:
        return 'Not support';
    }
  }

  static String getNameRouterApprove(String blockChainId) {
    switch (blockChainId) {
      case BlockChainModel.ethereum:
        return 'Uniswap V2';
      case BlockChainModel.binanceSmart:
        return 'PancakeSwap V2';
      case BlockChainModel.polygon:
        return 'QuickSwap';
      case BlockChainModel.kardiaChain:
        return 'KAIDEX V2';
      default:
        return '';
    }
  }

  static const bitcoin = 'bitcoin';
  static const ethereum = 'ethereum';
  static const binanceSmart = 'binance-smart-chain';
  static const kardiaChain = 'kardiachain';
  static const stellar = 'stellar';
  static const piTestnet = 'pitestnet';
  static const tron = 'tron';
  static const polygon = 'polygon-pos';

  AddressModel get addressModelActive => addresss[indexAddressActive];

  String get network => name + ' Network';

  double currencyValue() {
    var value = 0.0;
    for (var address in addresss) {
      value += address.currencyValue();
    }
    return value;
  }

  List<CoinModel> allCoins() {
    var coins = <CoinModel>[];
    for (var address in addresss) {
      for (var coin in address.coins) {
        final index = coins.indexWhere(
            (element) => coin.contractAddress == element.contractAddress);
        if (index == -1) {
          coins.add(coin.copyWith());
        } else {
          coins[index].value += coin.value;
        }
      }
    }
    return coins;
  }

  List<List<CoinModel>> allCoinsActive() {
    var coinsWithValue = <CoinModel>[];
    var coinsNovalue = <CoinModel>[];
    var coinsActive = <CoinModel>[];
    for (var coin in coins) {
      if (coin.isActive) {
        coinsActive.add(coin.copyWith());
      }
    }
    for (var address in addresss) {
      for (var coin in address.coins) {
        final indexWithValue = coinsActive.indexWhere(
            (coinActive) => coin.contractAddress == coinActive.contractAddress);
        if (indexWithValue != -1) {
          coinsActive[indexWithValue].value += coin.value;
        }
      }
    }
    for (var coin in coinsActive) {
      coin.value > BigInt.from(0)
          ? coinsWithValue.add(coin)
          : coinsNovalue.add(coin);
    }
    return [coinsWithValue, coinsNovalue];
  }

  AddressModel get addressAvalible =>
      addresss.firstWhere((element) => element.currencyValue() > 0.0,
          orElse: () => addressModelActive);

  List<AddLiquidityModel> addLiquidityList() {
    var data = <AddLiquidityModel>[];
    for (var addressModel in addresss) {
      data.addAll(addressModel.addLiquidityList!.data);
    }
    return data;
  }
}
