import 'dart:convert';
import 'dart:math';

import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';

class TronProvider extends GetConnect {
  Map<String, String> _headers(String apiKey) => {
        'Content-Type': 'application/json',
        'TRON-PRO-API-KEY': apiKey,
      };

  late String _httpUrl;
  void initData(BlockChainModel blockChain) {
    _httpUrl = blockChain.nodeHttp;
  }

  final _random = Random();

  final dataListKeys1 = [
    '474f5b72-cfc1-4ba8-ab5d-a9f7968d142e',
    'c56a8aad-2ab5-4c3e-9cad-a0512a6d34b7',
    'e97da01c-9836-49d5-bd5b-e848e34fdbcd',
  ];
  final dataListKeys2 = [
    'cd08a8d2-ca34-47d7-babd-96df4af3c89d',
    '8bdda0aa-266b-43c6-ad11-039fa2baa40d',
    'b3c3fcf2-c221-4c95-bb5a-8d593ee488d1',
  ];
  final dataListKeys3 = [
    'f0adbf4a-eb39-4760-8e6a-0008bb620ac5',
    '6dd00cbb-d1c0-483b-880a-fce96f1f8a09',
    'dadf27dd-8789-4fe7-babf-e91a77ceeb16',
  ];

  Future<Map<String, BigInt>> getBalance({required String address}) async {
    final key = dataListKeys2[_random.nextInt(dataListKeys2.length)];
    final result = await get(
      '$_httpUrl/v1/accounts/$address',
      headers: _headers(key),
    );
    if (result.statusCode == 200) {
      if (result.body['data'].isEmpty) {
        return {};
      }
      final data = result.body['data'][0] as Map<String, dynamic>;
      var balances = <String, BigInt>{};
      balances.addAll({'': BigInt.from((data['balance'] ?? 0))});
      for (var data in data['trc20'] as List<dynamic>) {
        balances.addAll({data.keys.first: BigInt.parse(data.values.first)});
      }
      return balances;
    } else {
      throw 'Get balance failure';
    }
  }

  // static Map<String, BigInt> parseJsonStringtoBalance(
  //     Map<String, dynamic> data) {
  //   var balances = <String, BigInt>{};
  //   balances.addAll({'': BigInt.from((data['balance'] ?? 0))});
  //   for (var data in data['trc20'] as List<dynamic>) {
  //     balances.addAll({data.keys.first: BigInt.parse(data.values.first)});
  //   }
  //   return balances;
  // }

  Future<List<dynamic>> getTransactions({required String address}) async {
    final query = {'limit': '25', 'only_confirmed': 'true'};
    final key = dataListKeys1[_random.nextInt(dataListKeys1.length)];

    final result = await get(
      '$_httpUrl/v1/accounts/$address/transactions',
      headers: _headers(key),
      query: query,
    );
    if (result.statusCode == 200) {
      final data = result.body['data'];
      return data;
    } else {
      throw 'Get transactions list failure';
    }
  }

  Future<List<dynamic>> getTransactionsTRC20({required String address}) async {
    final key = dataListKeys3[_random.nextInt(dataListKeys3.length)];
    final query = {
      'limit': '25',
      'only_confirmed': 'true',
    };
    final result = await get(
      '$_httpUrl/v1/accounts/$address/transactions/trc20',
      headers: _headers(key),
      query: query,
    );
    if (result.statusCode == 200) {
      final data = result.body['data'];
      return data;
    } else {
      throw 'Get transactions list failure';
    }
  }

  Future<int> getInformationTransactionFee({required String hash}) async {
    final key = dataListKeys2[_random.nextInt(dataListKeys2.length)];
    final query = {
      'value': hash,
    };
    final response = await httpClient.get(
      '$_httpUrl/wallet/gettransactioninfobyid',
      headers: _headers(key),
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        return (jsonData['fee'] ?? 0);
      } catch (exp) {
        final jsonData = response.body;
        return (jsonData['fee'] ?? 0);
      }
    } else {
      throw 'Get transaction information failure';
    }
  }

  Future<Map<String, dynamic>> getInformationTransaction(
      {required String hash}) async {
    final key = dataListKeys2[_random.nextInt(dataListKeys2.length)];
    final query = {
      'value': hash,
    };
    final response = await httpClient.get(
      '$_httpUrl/wallet/gettransactioninfobyid',
      headers: _headers(key),
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        return response.body;
      } catch (exp) {
        return jsonDecode(response.body);
      }
    } else {
      throw 'Get transactions list failure';
    }
  }

  Future<BlockHeaderTron> getBlockHeader() async {
    final key = dataListKeys2[_random.nextInt(dataListKeys2.length)];
    final response = await httpClient.post(
      '$_httpUrl/wallet/getnowblock',
      headers: _headers(key),
    );
    if (response.statusCode == 200) {
      try {
        final result =
            BlockHeaderTron.fromMap(response.body['block_header']['raw_data']);
        return result;
      } catch (exp) {
        final result = BlockHeaderTron.fromMap(
            jsonDecode(response.body)['block_header']['raw_data']);
        return result;
      }
    } else {
      throw 'Get block header failure';
    }
  }

  Future<bool> sendTransactionRaw({required String data}) async {
    final key = dataListKeys2[_random.nextInt(dataListKeys2.length)];
    final response = await httpClient.post(
      '$_httpUrl/wallet/broadcasttransaction',
      headers: _headers(key),
      body: data,
    );
    if (response.statusCode == 200) {
      try {
        final isSuccess = response.body['result'];
        if (isSuccess) {
          return response.body['result'];
        } else {
          throw 'Send raw transaction failure';
        }
      } catch (exp) {
        final isSuccess = jsonDecode(response.body['result']);
        if (isSuccess) {
          return jsonDecode(response.body['result']);
        } else {
          throw 'Send raw transaction failure';
        }
      }
    } else {
      throw 'Send raw transaction failure';
    }
  }
}

class BlockHeaderTron {
  final int timestamp;
  final int number;
  final int version;
  final String txTrieRoot;
  final String parentHash;
  final String witnessAddress;
  BlockHeaderTron({
    required this.timestamp,
    required this.number,
    required this.version,
    required this.txTrieRoot,
    required this.parentHash,
    required this.witnessAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'number': number,
      'version': version,
      'txTrieRoot': txTrieRoot,
      'parentHash': parentHash,
      'witnessAddress': witnessAddress,
    };
  }

  factory BlockHeaderTron.fromMap(Map<String, dynamic> map) {
    return BlockHeaderTron(
      timestamp: map['timestamp'],
      number: map['number'],
      version: map['version'],
      txTrieRoot: map['txTrieRoot'],
      parentHash: map['parentHash'],
      witnessAddress: map['witness_address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockHeaderTron.fromJson(String source) =>
      BlockHeaderTron.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BlockHeaderTron(timestamp: $timestamp, number: $number, version: $version, txTrieRoot: $txTrieRoot, parentHash: $parentHash, witnessAddress: $witnessAddress)';
  }
}
