import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/core/values/key_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/services/setting_services.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';

import 'blockchain_model.dart';

class CoinModel {
  final String id;
  final String name;
  final String symbol;
  final int decimals;
  final String type;
  final String contractAddress;
  final String blockchainId;
  final String image;
  bool isActive;
  BigInt value;

  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.decimals,
    required this.blockchainId,
    required this.contractAddress,
    required this.type,
    required this.image,
    required this.value,
    this.isActive = false,
  });

  Map<String, dynamic> toLocalDatabase() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'decimals': decimals,
      'blockchainId': blockchainId,
      'contractAddress': contractAddress,
      'type': type,
      'image': image,
      'isActive': isActive,
    };
  }

  factory CoinModel.fromJsonData(Map<String, dynamic> map) {
    return CoinModel(
      id: map['id'],
      symbol: map['symbol'],
      name: map['name'],
      decimals: map['decimals'],
      blockchainId: map['blockchainId'],
      contractAddress: map['contractAddress'] ?? '',
      type: map['type'],
      image: map['image'],
      value: BigInt.from(0),
    );
  }

  factory CoinModel.fromLocalDatabase(Map<String, dynamic> map) {
    return CoinModel(
      id: map['id'],
      symbol: map['symbol'],
      name: map['name'],
      decimals: map['decimals'],
      blockchainId: map['blockchainId'],
      contractAddress: map['contractAddress'],
      type: map['type'],
      image: map['image'],
      isActive: map['isActive'],
      value: BigInt.parse(map['value'] ?? '0'),
    );
  }

  Map<String, dynamic> toLocalDatabaseWithValue() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'decimals': decimals,
      'blockchainId': blockchainId,
      'contractAddress': contractAddress,
      'type': type,
      'image': image,
      'isActive': isActive,
      'value': value.toString(),
    };
  }

  factory CoinModel.fromLocalWithValue(Map<String, dynamic> map) {
    return CoinModel(
      id: map['id'],
      symbol: map['symbol'],
      name: map['name'],
      decimals: map['decimals'],
      blockchainId: map['blockchainId'],
      contractAddress: map['contractAddress'],
      type: map['type'],
      image: map['image'],
      isActive: map['isActive'],
      value: BigInt.parse(map['value'] ?? '0'),
    );
  }

  factory CoinModel.empty() {
    return CoinModel(
      id: '',
      symbol: '',
      name: '',
      decimals: 0,
      blockchainId: '',
      contractAddress: '',
      type: '',
      image: '',
      isActive: true,
      value: BigInt.from(0),
    );
  }

  String toJson() => json.encode(toLocalDatabase());

  factory CoinModel.fromJson(String source) =>
      CoinModel.fromLocalDatabase(json.decode(source));

  @override
  String toString() {
    return 'CoinModel(id: $id, name: $name, symbol: $symbol, decimals: $decimals, type: $type, contractAddress: $contractAddress, blockchainId: $blockchainId, image: $image, isActive: $isActive, value: $value)';
  }

  double get price => Crypto().price(id);

  double get priceUSD => Crypto().priceUSD(id);

  double get powDecimals => pow(10, decimals).toDouble();

  double get exchange => Crypto().exchange(id);

  String get priceCurrencyString => Crypto.currencyFormat.format(price);

  String get priceUSDString => Crypto.currencyUSDFormater.format(priceUSD);

  double get marketCap => Crypto().marketCap(id);

  String get marketCapCurrencyString => Crypto.currencyFormat.format(marketCap);

  double get marketVol => Crypto().marketVol(id);

  String get marketVolFormatNumber => Crypto.doubleFormat.format(marketVol);

  double get amount => value / BigInt.from(pow(10, decimals));

  String get icon => 'assets/global/coin/$symbol.svg';
  // String get network => '$name Network';

  ///1000.000.000 đ
  String get currencyString => Crypto.currencyFormat.format(amount * price);

  /// 10000000000
  double get currencyValue => amount * price;

  ///1000.000.000 đ
  static String currentcyFormat(double value) =>
      '${Crypto.currencyFormat.format(value)}';

  /// - 5.00%
  String get ratePercentFormat => exchange == 0.0
      ? '0.00%'
      : exchange > 0
          ? ' + ${exchange.toStringAsFixed(2)}%'
          : ' - ${exchange.toStringAsFixed(2).substring(1)}%';

  List<AddressModel> addresssOfCoin() {
    return blockChainOfCoin().addresss;
  }

  BlockChainModel blockChainOfCoin() {
    final blockChains = Get.find<WalletController>().wallet.blockChains;
    final blockChain =
        blockChains.firstWhere((blockChain) => blockChain.id == blockchainId);
    return blockChain;
  }

  static String getKeyFromAddressKey({
    required String addressKey,
    required int index,
  }) {
    return addressKey + AppKeys.CRYPTO_KEY + index.toString();
  }

  /// 1.0 BTC
  String valueWithSymbol(double value) =>
      '${Crypto.numberFormatNumberToken(value)} $symbol';

  /// 1.0 BTC
  String get valueWithSymbolString =>
      '${Crypto.numberFormatNumberToken(amount)} $symbol';

  ///(100.000đ)
  String get currencyWithRoundBracks =>
      AppFormat.formatRoundBrackets(value: currencyString);

  ///1.000 đ
  String currencyOfValue(double value) =>
      Crypto.currencyFormat.format(value * price);

  /// (0 BTC)
  String get valueWithRoundBrackets => AppFormat.formatRoundBrackets(
      value: '${Crypto.numberFormatNumberToken(amount)}  $symbol');

  /// 0 BTC
  String get valueNoRoundBrackets =>
      '${Crypto.numberFormatNumberToken(amount)} $symbol';

  /// Số dư: 0 BTC
  String get surPlus => 'global_surplus'.tr + '$valueNoRoundBrackets';

  static int get defaultNumberCrypto => 1;

  bool get isToken => contractAddress.isNotEmpty;

  bool isValueAvalible(String text) {
    try {
      if (value != BigInt.from(0)) {
        return Crypto.parseStringToBigIntMultiply(
                    valueString: text, decimal: decimals) <=
                value &&
            (double.parse(text) >= pow(10, -decimals) ||
                double.parse(text) == 0.0);
      } else {
        return double.parse(text) <= value.toDouble();
      }
    } catch (exp) {
      return false;
    }
  }

  bool isValueAvaliblePlusFee(String text) =>
      Crypto.parseStringToBigIntMultiply(valueString: text, decimal: decimals) +
          Crypto().fee <=
      value;

  BigInt stringDoubleToBigInt(String doubleString) =>
      Crypto.parseStringToBigIntMultiply(
          valueString: doubleString, decimal: decimals);

  bool get isValueAvalibleForFee => Crypto().fee <= value;

  bool get isValueZero => value == BigInt.from(0);

  CoinModel copyWith({
    String? id,
    String? name,
    String? symbol,
    int? decimals,
    String? type,
    String? contractAddress,
    String? blockchainId,
    String? image,
    bool? isActive,
    BigInt? value,
  }) {
    return CoinModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      decimals: decimals ?? this.decimals,
      type: type ?? this.type,
      contractAddress: contractAddress ?? this.contractAddress,
      blockchainId: blockchainId ?? this.blockchainId,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      value: value ?? this.value,
    );
  }
}

class Crypto {
  static final Crypto _cryptoPrice = Crypto._internal();
  factory Crypto() {
    return _cryptoPrice;
  }

  static String rateFormat(double value) => value == 0.0
      ? '0.00%'
      : value > 0
          ? ' + ${value.toStringAsFixed(2)}%'
          : ' - ${value.toStringAsFixed(2).substring(1)}%';

  String get currency =>
      Get.find<SettingService>().currencyActive.currency.toLowerCase();

  Crypto._internal();
  static NumberFormat get currencyFormat =>
      NumberFormat.simpleCurrency(locale: Get.find<SettingService>().currency);

  static NumberFormat get currencyUSDFormater =>
      NumberFormat.simpleCurrency(locale: 'en_US');

  static String numberFormatNumberToken(double value, [int? max]) {
    if (value.toString().contains('e')) {
      return value.toString();
    }
    final listData = value.toString().split('.');
    if (listData[0].length > 15) {
      return value.toStringAsExponential(15);
    }
    if (listData.length == 1) {
      return doubleFormat.format(value);
    } else {
      return doubleFormat.format(double.parse(listData[0])) + '.' + listData[1];
    }
  }

  static String numberFormatNumberTokenRate(double value) {
    final listData = value.toString().split('.');
    if (value >= 1) {
      if (listData[0].length > 10) {
        return value.toStringAsExponential(10);
      }

      if (listData.length == 1) {
        return doubleFormat.format(value);
      } else {
        final maxChar = 12 - listData[0].length;
        final surfix = listData[1].length > maxChar
            ? listData[1].substring(0, maxChar)
            : listData[1];
        return doubleFormat.format(double.parse(listData[0])) + '.' + surfix;
      }
    } else {
      if (value.toString().contains('.')) {
        final indexOfE = listData[1].indexOf('e');
        var surfix = '';
        if (indexOfE == -1) {
          surfix = listData[1].length > 9
              ? listData[1].substring(0, 9)
              : listData[1];
        } else {
          if (indexOfE > 6) {
            surfix =
                listData[1].substring(0, 6) + listData[1].substring(indexOfE);
          } else {
            surfix = listData[1];
          }
        }

        return doubleFormat.format(double.parse(listData[0])) + '.' + surfix;
      } else {
        return value.toString();
      }
    }
  }

  static NumberFormat doubleFormat = NumberFormat(',###');

  double price(String id) {
    if ((Crypto().priceAndExchange[id] == null)) {
      return 0.0;
    }
    return ((Crypto().priceAndExchange[id][currency] ?? 0) as num).toDouble();
  }

  double priceUsd(String id) {
    if ((Crypto().priceAndExchange[id] == null)) {
      return 0.0;
    }
    return ((Crypto().priceAndExchange[id]['usd'] ?? 0) as num).toDouble();
  }

  double exchange(String id) {
    if ((Crypto().priceAndExchange[id] == null)) {
      return 0.0;
    }
    return ((Crypto().priceAndExchange[id]['${currency}_24h_change'] ?? 0)
            as num)
        .toDouble();
  }

  double marketCap(String id) {
    if ((Crypto().priceAndExchange[id] == null)) {
      return 0.0;
    }
    return ((Crypto().priceAndExchange[id]['${currency}_market_cap'] ?? 0)
            as num)
        .toDouble();
  }

  double marketVol(String id) {
    if ((Crypto().priceAndExchange[id] == null)) {
      return 0.0;
    }
    return ((Crypto().priceAndExchange[id]['${currency}_24h_vol'] ?? 0) as num)
        .toDouble();
  }

  double priceUSD(String id) {
    var price = 0.0;
    if ((Crypto().priceAndExchange[id] != null)) {
      price = ((Crypto().priceAndExchange[id]['usd'] ?? 0) as num).toDouble();
    }
    return price;
    // final data = price /
    //     ((Crypto().priceAndExchange['tether']['usd'] ?? 0) as num).toDouble();
    // if (data > 1) {
    //   return data.toPrecision(4);
    // } else {
    //   return data.toPrecision(12);
    // }
  }

  static BigInt parseStringToBigIntMultiply({
    required String valueString,
    required int decimal,
  }) {
    try {
      final indexOfE = valueString.indexOf('e');
      var decimalCalculator = decimal;
      var valueStringCalculator = valueString;
      if (indexOfE != -1) {
        decimalCalculator =
            decimal + int.parse(valueString.substring(indexOfE + 1));
        valueStringCalculator = valueString.substring(0, indexOfE);
      }
      final index = valueString.indexOf('.');
      if (index != -1) {
        final numb = valueStringCalculator.length - index - 1;
        if (numb <= decimalCalculator) {
          final data = valueStringCalculator.replaceAll('.', '') +
              '0' * (decimalCalculator - numb);
          return BigInt.parse(data);
        } else {
          if (decimalCalculator >= 0) {
            final data = valueStringCalculator.replaceAll('.', '').substring(0,
                valueStringCalculator.length - (numb - decimalCalculator + 1));
            return BigInt.parse(data);
          } else {
            return BigInt.from(0);
          }
        }
      } else {
        final data = valueStringCalculator + '0' * decimalCalculator;
        return BigInt.parse(data);
      }
    } catch (exp) {
      return BigInt.from(0);
    }
  }

  static String bigIntToStringWithDevide({
    required String bigIntString,
    required int decimal,
  }) {
    if (decimal == 0) {
      return bigIntString;
    } else {
      final len = bigIntString.length;
      if (decimal >= len) {
        return '0.' + '0' * (decimal - len) + bigIntString;
      } else {
        return bigIntString.substring(0, len - decimal) +
            '.' +
            bigIntString.substring(len - decimal);
      }
    }
  }

  /// For Ethereum/BinanceSmartChain BlockChain in wei
  BigInt gasPrice = BigInt.from(0);

  /// For BlockChain Bitocin in satoshi
  int feePerByte = 0;

  ////
  BigInt gasLimit = BigInt.from(21000);

  Map<String, dynamic> priceAndExchange = {};

  BigInt get fee => gasLimit * gasPrice;
}
