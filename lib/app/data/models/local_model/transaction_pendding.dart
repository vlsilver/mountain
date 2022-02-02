import 'dart:convert';

import 'package:base_source/app/data/models/local_model/transaction_model.dart';

class TransactionPenddingData {
  final List<TransactionData> data;
  TransactionPenddingData({
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toLocalDatabase()).toList(),
    };
  }

  factory TransactionPenddingData.fromMap(Map<String, dynamic> map) {
    return TransactionPenddingData(
      data: List<TransactionData>.from(
          map['data'].map((x) => TransactionData.fromLocalDatabase(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionPenddingData.fromJson(String source) =>
      TransactionPenddingData.fromMap(json.decode(source));
}
