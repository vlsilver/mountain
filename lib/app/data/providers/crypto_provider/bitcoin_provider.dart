import 'dart:convert';

import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:get/get_connect.dart';

class BitcoinProvider extends GetConnect {
  final Map<String, String> _headers = {
    'Content-type': 'application/json',
  };

  late String _httpUrl;
  void initData(BlockChainModel blockChain) {
    _httpUrl = blockChain.nodeHttp;
  }

  Future<List<dynamic>> getTransactions({required String address}) async {
    final response = await httpClient.get('$_httpUrl/address/$address/txs',
        headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw 'Get transactions list failure';
    }
  }

  Future<Map<dynamic, dynamic>> getBalance({required String address}) async {
    final response =
        await httpClient.get('$_httpUrl/address/$address', headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw 'Get balance failure';
    }
  }

  Future<int> getEstimateGas() async {
    final response =
        await httpClient.get('$_httpUrl/mempool', headers: _headers);
    if (response.statusCode == 200) {
      final data = response.body;
      return ((data['total_fee'] / data['vsize']) as double).toInt();
    } else {
      throw 'Estimate gas failure';
    }
  }

  Future<List<dynamic>> getUtxo({required String address}) async {
    final response = await httpClient.get('$_httpUrl/address/$address/utxo',
        headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw 'Get Utxos failure';
    }
  }

  Future<String> sendRawTransaction({required String data}) async {
    final response = await httpClient.post(
      '$_httpUrl/tx',
      body: data,
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return response.body as String;
    } else {
      throw jsonDecode(response.body.toString().split(': ')[1])['message'];
    }
  }

  Future<Map<String, dynamic>> getTransactionInformation(
      {required String hash}) async {
    final response =
        await httpClient.get('$_httpUrl/tx/$hash', headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw 'Get transaction information failure';
    }
  }
}
