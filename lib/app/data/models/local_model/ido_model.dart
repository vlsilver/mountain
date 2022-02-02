import 'dart:convert';
import 'dart:math';

import 'package:base_source/app/core/utils/format_utils.dart';

import 'coin_model.dart';

class IDOData {
  List<IDOModel> data;
  IDOData({
    required this.data,
  });

  IDOData copyWith({
    List<IDOModel>? data,
  }) {
    return IDOData(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory IDOData.fromMap(Map<String, dynamic> map) {
    return IDOData(
      data: List<IDOModel>.from(map['data']?.map((x) => IDOModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory IDOData.fromJson(String source) =>
      IDOData.fromMap(json.decode(source));

  factory IDOData.fakeData() => IDOData(data: [
        IDOModel(
            index: 0,
            id: 'b03ac06d-9f86-4b3f-ad46-648ef0ea680e',
            name: 'Bukkake Inc.',
            symbol: 'BUK',
            baseCrypto: 'BNB',
            icon:
                'https://api.moonwallet.net/uploads/images/store/binance-coin-logo.webp',
            imageBanner: null,
            desc: 'buk coin description',
            website: 'website',
            twitter: 'twitter',
            facebook: 'facebook',
            telegram: 'telegram',
            reddit: 'reddit.com/buk',
            coinGecko: 'buk CoinGecko',
            address: 'address_path',
            chainId: 'chainId',
            chainName: 'chainName',
            launchpadPrice: 1,
            totalSupply: BigInt.parse('1000000000000000000000000000'),
            launchpadAmount: BigInt.parse('100000000000000000000000000'),
            maxBuy: BigInt.parse('10000000000000000000000'),
            minBuy: BigInt.parse('10000000000000'),
            addressDespositedData: [
              DataDeposit(
                  address: '0xDb76f2c5a18236bDa3021D2f19A22bd2C8950b78',
                  amountDeposited: BigInt.parse('1000000000000000000000'),
                  isClaimed: false,
                  decimal: 18),
              DataDeposit(
                  address: '0x459361A42119d114462c66c590Fc03c6C4658d22',
                  amountDeposited: BigInt.parse('0'),
                  isClaimed: false,
                  decimal: 18),
            ],
            timeStart: (1628852438482 + 2 * 60 * 1000) ~/ 1000,
            timeEnd: (1628852438482 + 20 * 60 * 1000) ~/ 1000,
            locked: false,
            totalBaseAmount: BigInt.parse('100000000000000000000000000'),
            addressBaseToken: '0xba2ae424d960c26247dd6c32edc70b295c744c43',
            decimal: 18,
            decimalBase: 18),
        IDOModel(
            index: 1,
            id: 'b03ac06d-9f86-4b3f-ad46-648ef0ea680e',
            name: 'Bukkake Inc.',
            symbol: 'BUK',
            baseCrypto: 'BNB',
            icon:
                'https://api.moonwallet.net/uploads/images/store/binance-coin-logo.webp',
            imageBanner: null,
            desc: 'buk coin description',
            website: 'website',
            twitter: 'twitter',
            facebook: 'facebook',
            telegram: 'telegram',
            reddit: 'reddit.com/buk',
            coinGecko: 'buk CoinGecko',
            address: 'address_path',
            chainId: 'chainId',
            chainName: 'chainName',
            launchpadPrice: 1.2,
            totalSupply: BigInt.parse('1000000000000000000000000000'),
            launchpadAmount: BigInt.parse('100000000000000000000000000'),
            maxBuy: BigInt.parse('10000000000000000000000'),
            minBuy: BigInt.parse('10000000000000'),
            timeStart: (1628852438482 - 20 * 60 * 1000) ~/ 1000,
            timeEnd: (1628852438482 + 100 * 24 * 2 * 60 * 1000) ~/ 1000,
            addressDespositedData: [
              DataDeposit(
                  address: '0xDb76f2c5a18236bDa3021D2f19A22bd2C8950b78',
                  amountDeposited: BigInt.parse('1000000000000000000000'),
                  isClaimed: false,
                  decimal: 18),
              DataDeposit(
                  address: '0x459361A42119d114462c66c590Fc03c6C4658d22',
                  amountDeposited: BigInt.parse('0'),
                  isClaimed: false,
                  decimal: 18),
            ],
            locked: false,
            totalBaseAmount: BigInt.parse('100000000000000000000000000'),
            addressBaseToken: '0xe9e7cea3dedca5984780bafc599bd69add087d56',
            decimal: 18,
            decimalBase: 18),
        IDOModel(
            index: 2,
            id: 'b03ac06d-9f86-4b3f-ad46-648ef0ea680e',
            name: 'Bukkake Inc.',
            symbol: 'BUK',
            baseCrypto: 'BNB',
            icon:
                'https://api.moonwallet.net/uploads/images/store/binance-coin-logo.webp',
            imageBanner: null,
            desc: 'buk coin description',
            website: 'website',
            twitter: 'twitter',
            facebook: 'facebook',
            telegram: 'telegram',
            reddit: 'reddit.com/buk',
            coinGecko: 'buk CoinGecko',
            address: 'address_path',
            chainId: 'chainId',
            chainName: 'chainName',
            launchpadPrice: 1,
            totalSupply: BigInt.parse('1000000000000000000000000000'),
            launchpadAmount: BigInt.parse('100000000000000000000000000'),
            maxBuy: BigInt.parse('10000000000000000000000'),
            minBuy: BigInt.parse('10000000000000'),
            addressDespositedData: [
              DataDeposit(
                  address: '0xDb76f2c5a18236bDa3021D2f19A22bd2C8950b78',
                  amountDeposited: BigInt.parse('1000000000000000000000'),
                  isClaimed: false,
                  decimal: 18),
              DataDeposit(
                  address: '0x459361A42119d114462c66c590Fc03c6C4658d22',
                  amountDeposited: BigInt.parse('0'),
                  isClaimed: false,
                  decimal: 18),
            ],
            timeStart: (1628852438482 - 20 * 60 * 1000) ~/ 1000,
            timeEnd: (1628852438482 + 10 * 24 * 2 * 60 * 1000) ~/ 1000,
            locked: false,
            totalBaseAmount: BigInt.parse('100000000000000000000000000'),
            addressBaseToken: '0xe9e7cea3dedca5984780bafc599bd69add087d56',
            decimal: 18,
            decimalBase: 18)
      ]);
}

class IDOModel {
  final int index;
  final String id;
  final String name;
  final String symbol;
  final String baseCrypto;
  final String icon;
  final String? imageBanner;
  final String desc;
  final String? website;
  final String? twitter;
  final String? facebook;
  final String? telegram;
  final String? reddit;
  final String? coinGecko;
  final String address;
  final String chainId;
  final String chainName;
  final double launchpadPrice;
  final BigInt totalSupply;
  final BigInt launchpadAmount;
  final BigInt maxBuy;
  final BigInt minBuy;
  BigInt totalBaseAmount;
  int timeStart;
  int timeEnd;
  String addressBaseToken;
  List<DataDeposit> addressDespositedData;
  int decimal;
  int decimalBase;
  final bool locked;

  IDOModel({
    required this.index,
    required this.id,
    required this.name,
    required this.symbol,
    required this.baseCrypto,
    required this.icon,
    required this.imageBanner,
    required this.desc,
    required this.website,
    required this.twitter,
    required this.facebook,
    required this.telegram,
    required this.reddit,
    required this.coinGecko,
    required this.address,
    required this.chainId,
    required this.chainName,
    required this.launchpadPrice,
    required this.totalSupply,
    required this.launchpadAmount,
    required this.maxBuy,
    required this.minBuy,
    required this.totalBaseAmount,
    required this.timeStart,
    required this.timeEnd,
    required this.addressBaseToken,
    required this.addressDespositedData,
    required this.decimal,
    required this.decimalBase,
    required this.locked,
  });

  IDOModel copyWith({
    int? index,
    String? id,
    String? name,
    String? symbol,
    String? baseCrypto,
    String? icon,
    String? imageBanner,
    String? desc,
    String? website,
    String? twitter,
    String? facebook,
    String? telegram,
    String? reddit,
    String? coinGecko,
    String? address,
    String? chainId,
    String? chainName,
    double? launchpadPrice,
    BigInt? totalSupply,
    BigInt? launchpadAmount,
    BigInt? maxBuy,
    BigInt? minBuy,
    BigInt? totalBaseAmount,
    int? timeStart,
    int? timeEnd,
    String? addressBaseToken,
    List<DataDeposit>? addressDespositedData,
    int? decimal,
    int? decimalBase,
    bool? locked,
  }) {
    return IDOModel(
      index: index ?? this.index,
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      baseCrypto: baseCrypto ?? this.baseCrypto,
      icon: icon ?? this.icon,
      imageBanner: imageBanner ?? this.imageBanner,
      desc: desc ?? this.desc,
      website: website ?? this.website,
      twitter: twitter ?? this.twitter,
      facebook: facebook ?? this.facebook,
      telegram: telegram ?? this.telegram,
      reddit: reddit ?? this.reddit,
      coinGecko: coinGecko ?? this.coinGecko,
      address: address ?? this.address,
      chainId: chainId ?? this.chainId,
      chainName: chainName ?? this.chainName,
      launchpadPrice: launchpadPrice ?? this.launchpadPrice,
      totalSupply: totalSupply ?? this.totalSupply,
      launchpadAmount: launchpadAmount ?? this.launchpadAmount,
      maxBuy: maxBuy ?? this.maxBuy,
      minBuy: minBuy ?? this.minBuy,
      totalBaseAmount: totalBaseAmount ?? this.totalBaseAmount,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      addressBaseToken: addressBaseToken ?? this.addressBaseToken,
      addressDespositedData:
          addressDespositedData ?? this.addressDespositedData,
      decimal: decimal ?? this.decimal,
      decimalBase: decimalBase ?? this.decimalBase,
      locked: locked ?? this.locked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'id': id,
      'name': name,
      'symbol': symbol,
      'baseCrypto': baseCrypto,
      'icon': icon,
      'imageBanner': imageBanner,
      'desc': desc,
      'website': website,
      'twitter': twitter,
      'facebook': facebook,
      'telegram': telegram,
      'reddit': reddit,
      'coinGecko': coinGecko,
      'address': address,
      'chainId': chainId,
      'chainName': chainName,
      'launchpadPrice': launchpadPrice,
      'totalSupply': totalSupply.toString(),
      'launchpadAmount': launchpadAmount.toString(),
      'maxBuy': maxBuy..toString(),
      'minBuy': minBuy..toString(),
      'totalBaseAmount': totalBaseAmount..toString(),
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'addressBaseToken': addressBaseToken,
      'addressDespositedData':
          addressDespositedData.map((x) => x.toMap()).toList(),
      'decimal': decimal,
      'decimalBase': decimalBase,
      'locked': locked,
    };
  }

  factory IDOModel.fromMap(Map<String, dynamic> map) {
    return IDOModel(
      index: map['index'],
      id: map['id'],
      name: map['name'],
      symbol: map['symbol'],
      baseCrypto: map['baseCrypto'],
      icon: map['icon'],
      imageBanner: map['imageBanner'],
      desc: map['desc'],
      website: map['website'],
      twitter: map['twitter'],
      facebook: map['facebook'],
      telegram: map['telegram'],
      reddit: map['reddit'],
      coinGecko: map['coinGecko'],
      address: map['address'],
      chainId: map['chainId'],
      chainName: map['chainName'],
      launchpadPrice: map['launchpadPrice'],
      totalSupply: BigInt.parse(map['totalSupply']),
      launchpadAmount: BigInt.parse(map['launchpadAmount']),
      maxBuy: BigInt.parse(map['maxBuy']),
      minBuy: BigInt.parse(map['minBuy']),
      totalBaseAmount: BigInt.parse(map['totalBaseAmount']),
      timeStart: map['timeStart'],
      timeEnd: map['timeEnd'],
      addressBaseToken: map['addressBaseToken'],
      addressDespositedData: List<DataDeposit>.from(
          map['addressDespositedData']?.map((x) => DataDeposit.fromMap(x))),
      decimal: map['decimal'],
      decimalBase: map['decimalBase'],
      locked: map['locked'],
    );
  }

  Duration get delayTime => isSubscription
      ? DateTime.fromMillisecondsSinceEpoch(timeEnd * 1000)
          .difference(DateTime.now())
      : DateTime.fromMillisecondsSinceEpoch(timeStart * 1000)
          .difference(DateTime.now());

  String toJson() => json.encode(toMap());
  factory IDOModel.fromJson(String source) =>
      IDOModel.fromMap(json.decode(source));
  String get formatBaseToken => ' $baseCrypto';
  double get amountOfferedDouble =>
      launchpadAmount / BigInt.from(pow(10, decimal));
  double get amountTotalSupplyDouble =>
      totalSupply / BigInt.from(pow(10, decimal));
  double get maxBuyDouble => maxBuy / BigInt.from(pow(10, decimal));
  double get minBuyDouble => minBuy / BigInt.from(pow(10, decimal));
  double get maxBuyBaseDouble => maxBuyDouble * launchpadPrice;
  double get minBuyBaseDouble => minBuyDouble * launchpadPrice;
  BigInt totalAmountDeposited() {
    var totaAmountDeposited = BigInt.from(0);
    for (var data in addressDespositedData) {
      totaAmountDeposited += data.amountDeposited;
    }
    return totaAmountDeposited;
  }

  double get totalAmountDepositedDouble =>
      totalAmountDeposited() / BigInt.from(pow(10, decimalBase));
  double get amountToTalBaseAmountDouble =>
      totalBaseAmount / BigInt.from(pow(10, decimalBase));
  String get formatTokenAmountOfferedWithSymbol =>
      Crypto.numberFormatNumberToken(amountOfferedDouble) + ' ' + symbol;
  String get formatTokenAmountTotalSupplyWithSymbol =>
      Crypto.numberFormatNumberToken(amountTotalSupplyDouble) + ' ' + symbol;
  String get formatRateWithBaseToken =>
      '1 ' + symbol + ' = ' + launchpadPrice.toString() + formatBaseToken;
  String get formatMaxBuy =>
      Crypto.numberFormatNumberTokenRate(maxBuyDouble) +
      ' ' +
      symbol +
      ' = ' +
      Crypto.numberFormatNumberTokenRate(maxBuyBaseDouble) +
      formatBaseToken;

  String get formatTotalAmountBaseToken =>
      Crypto.numberFormatNumberTokenRate(amountToTalBaseAmountDouble) +
      formatBaseToken;

  String get formatAmountDeposited =>
      Crypto.numberFormatNumberTokenRate(totalAmountDepositedDouble) +
      formatBaseToken;

  String get getTotalCommited => '0 BNB';

  bool get isFinished =>
      DateTime.now().millisecondsSinceEpoch ~/ 1000 > timeEnd;
  bool get isSubscription =>
      DateTime.now().millisecondsSinceEpoch ~/ 1000 >= timeStart &&
      DateTime.now().millisecondsSinceEpoch ~/ 1000 <= timeEnd;
  bool get isPreparation =>
      DateTime.now().millisecondsSinceEpoch ~/ 1000 < timeStart;

  String get timeEndFormat => AppFormat.formatTimeFromTimestamp(timeEnd);
  String get timeStartFormat => AppFormat.formatTimeFromTimestamp(timeStart);

  bool get isHaveFacebook => facebook != null && facebook!.isNotEmpty;
  bool get isHaveTelegram => telegram != null && telegram!.isNotEmpty;
  bool get isHaveTwitter => twitter != null && twitter!.isNotEmpty;
  bool get isHaveCoingecko => coinGecko != null && coinGecko!.isNotEmpty;
  bool get isHaveReddit => reddit != null && reddit!.isNotEmpty;
  bool get isWebsite => website != null && website!.isNotEmpty;

  @override
  String toString() {
    return 'IDOModel(index: $index, id: $id, name: $name, symbol: $symbol, baseCrypto: $baseCrypto, icon: $icon, imageBanner: $imageBanner, desc: $desc, website: $website, twitter: $twitter, facebook: $facebook, telegram: $telegram, reddit: $reddit, coinGecko: $coinGecko, address: $address, chainId: $chainId, chainName: $chainName, launchpadPrice: $launchpadPrice, totalSupply: $totalSupply, launchpadAmount: $launchpadAmount, maxBuy: $maxBuy, minBuy: $minBuy, totalBaseAmount: $totalBaseAmount, timeStart: $timeStart, timeEnd: $timeEnd, addressBaseToken: $addressBaseToken, addressDespositedData: $addressDespositedData, decimal: $decimal, decimalBase: $decimalBase, locked: $locked)';
  }
}

class DataDeposit {
  final String address;
  final BigInt amountDeposited;
  final bool isClaimed;
  final int decimal;
  DataDeposit({
    required this.address,
    required this.amountDeposited,
    required this.isClaimed,
    required this.decimal,
  });

  DataDeposit copyWith({
    String? address,
    BigInt? amountDeposited,
    bool? isClaimed,
    int? decimal,
  }) {
    return DataDeposit(
      address: address ?? this.address,
      amountDeposited: amountDeposited ?? this.amountDeposited,
      isClaimed: isClaimed ?? this.isClaimed,
      decimal: decimal ?? this.decimal,
    );
  }

  @override
  String toString() {
    return 'DataDeposit(address: $address, amountDeposited: $amountDeposited, isClaimed: $isClaimed, decimal: $decimal)';
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'amountDeposited': amountDeposited.toString(),
      'isClaimed': isClaimed,
      'decimal': decimal,
    };
  }

  factory DataDeposit.fromMap(Map<String, dynamic> map) {
    return DataDeposit(
      address: map['address'],
      amountDeposited: BigInt.parse(map['amountDeposited']),
      isClaimed: map['isClaimed'],
      decimal: map['decimal'],
    );
  }

  String toJson() => json.encode(toMap());

  double get getAmountDepositedDouble =>
      amountDeposited / BigInt.from(pow(10, decimal));

  String get formatDeposited =>
      Crypto.numberFormatNumberTokenRate(getAmountDepositedDouble);

  factory DataDeposit.fromJson(String source) =>
      DataDeposit.fromMap(json.decode(source));
}
