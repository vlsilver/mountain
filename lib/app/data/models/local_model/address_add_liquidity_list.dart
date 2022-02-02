import 'dart:convert';

import 'coin_model.dart';

class AddLiquidityList {
  List<AddLiquidityModel> data;
  AddLiquidityList({
    required this.data,
  });
  factory AddLiquidityList.empty() =>
      AddLiquidityList(data: <AddLiquidityModel>[]);

  AddLiquidityList copyWith({
    List<AddLiquidityModel>? data,
  }) {
    return AddLiquidityList(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory AddLiquidityList.fromMap(Map<String, dynamic> map) {
    return AddLiquidityList(
      data: List<AddLiquidityModel>.from(
          map['data']?.map((x) => AddLiquidityModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddLiquidityList.fromJson(String source) =>
      AddLiquidityList.fromMap(json.decode(source));

  @override
  String toString() => 'AddLiquidityList(data: $data)';
}

class AddLiquidityModel {
  final String addressSend;
  final String addressRecive;
  final String blockChainId;
  final CoinModel tokenLP;
  final CoinModel tokenA;
  final CoinModel tokenB;
  double shareOfPool;
  final String status;
  AddLiquidityModel({
    required this.addressSend,
    required this.addressRecive,
    required this.blockChainId,
    required this.tokenLP,
    required this.tokenA,
    required this.tokenB,
    required this.shareOfPool,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'addressSend': addressSend,
      'blockChainId': blockChainId,
      'tokenLP': tokenLP.toLocalDatabaseWithValue(),
      'tokenA': tokenA.toLocalDatabaseWithValue(),
      'tokenB': tokenB.toLocalDatabaseWithValue(),
      'shareOfPool': shareOfPool,
      'addressRecive': addressRecive,
      'status': status,
    };
  }

  factory AddLiquidityModel.fromMap(Map<String, dynamic> map) {
    return AddLiquidityModel(
      addressSend: map['addressSend'],
      blockChainId: map['blockChainId'],
      tokenLP: CoinModel.fromLocalWithValue(map['tokenLP']),
      tokenA: CoinModel.fromLocalWithValue(map['tokenA']),
      tokenB: CoinModel.fromLocalWithValue(map['tokenB']),
      shareOfPool: map['shareOfPool'],
      addressRecive: map['addressRecive'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddLiquidityModel.fromJson(String source) =>
      AddLiquidityModel.fromMap(json.decode(source));

  AddLiquidityModel copyWith({
    String? addressSend,
    String? addressRecive,
    String? blockChainId,
    CoinModel? tokenLP,
    CoinModel? tokenA,
    CoinModel? tokenB,
    double? shareOfPool,
    String? status,
  }) {
    return AddLiquidityModel(
      addressSend: addressSend ?? this.addressSend,
      addressRecive: addressRecive ?? this.addressRecive,
      blockChainId: blockChainId ?? this.blockChainId,
      tokenLP: tokenLP ?? this.tokenLP,
      tokenA: tokenA ?? this.tokenA,
      tokenB: tokenB ?? this.tokenB,
      shareOfPool: shareOfPool ?? this.shareOfPool,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'AddLiquidityModel(addressSend: $addressSend, addressRecive: $addressRecive, blockChainId: $blockChainId, tokenLP: $tokenLP, tokenA: $tokenA, tokenB: $tokenB, shareOfPool: $shareOfPool, status: $status)';
  }
}
