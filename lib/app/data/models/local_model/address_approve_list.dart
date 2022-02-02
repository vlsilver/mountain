import 'dart:convert';

import 'package:intl/intl.dart';

class RevokeDataList {
  int? currentBlock;
  List<RevokeData> data;
  RevokeDataList({
    required this.currentBlock,
    required this.data,
  });

  Map<String, dynamic> toLocalDatabase() {
    return {
      'currentBlock': currentBlock,
      'datas': data.map((x) => x.toMap()).toList(),
    };
  }

  factory RevokeDataList.empty() =>
      RevokeDataList(currentBlock: null, data: <RevokeData>[]);

  factory RevokeDataList.fromLocalDatabase(Map<String, dynamic> map) {
    return RevokeDataList(
      currentBlock: map['currentBlock'],
      data:
          List<RevokeData>.from(map['datas'].map((x) => RevokeData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toLocalDatabase());

  factory RevokeDataList.fromJson(String source) =>
      RevokeDataList.fromLocalDatabase(json.decode(source));

  @override
  String toString() =>
      'RevokeDataList(currentBlock: $currentBlock, data: $data)';
}

class RevokeData {
  final String hash;
  final int time;
  final int block;
  final String sender;
  final String owner;
  final String contracAddress;
  final double valueApprove;
  final double valueResidual;
  RevokeData({
    required this.hash,
    required this.time,
    required this.block,
    required this.sender,
    required this.owner,
    required this.contracAddress,
    required this.valueApprove,
    required this.valueResidual,
  });

  RevokeData copyWith({
    String? hash,
    int? time,
    int? block,
    String? sender,
    String? owner,
    String? contracAddress,
    double? valueApprove,
    double? valueResidual,
  }) {
    return RevokeData(
      hash: hash ?? this.hash,
      time: time ?? this.time,
      block: block ?? this.block,
      sender: sender ?? this.sender,
      owner: owner ?? this.owner,
      contracAddress: contracAddress ?? this.contracAddress,
      valueApprove: valueApprove ?? this.valueApprove,
      valueResidual: valueResidual ?? this.valueResidual,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hash': hash,
      'time': time,
      'block': block,
      'sender': sender,
      'owner': owner,
      'contracAddress': contracAddress,
      'valueApprove': valueApprove,
      'valueResidual': valueResidual,
    };
  }

  factory RevokeData.fromMap(Map<String, dynamic> map) {
    return RevokeData(
      hash: map['hash'],
      time: map['time'],
      block: map['block'],
      sender: map['sender'],
      owner: map['owner'],
      contracAddress: map['contracAddress'],
      valueApprove: map['valueApprove'],
      valueResidual: map['valueResidual'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RevokeData.fromJson(String source) =>
      RevokeData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ApproveTransactionData(hash: $hash, time: $time, block: $block, sender: $sender, owner: $owner, contracAddress: $contracAddress, valueApprove: $valueApprove, valueResidual: $valueResidual)';
  }

  String timeString() {
    var date = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(date);
    return formattedDate;
  }
}
