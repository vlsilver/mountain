import 'dart:convert';

import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';

class StellarChainProvider extends GetConnect {
  final Map<String, String> _headers = {'Content-Type': 'application/json'};
  final Map<String, String> _headersPost = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  late String _httpUrl;

  void initData(BlockChainModel blockChain) {
    _httpUrl = blockChain.nodeHttp;
  }

  Future<double> getBaseFees() async {
    try {
      final result = await get('$_httpUrl/fee_stats', headers: _headers);
      if (result.statusCode == 200) {
        final baseFee =
            await compute(parseJsonStringtoBaseFee, result.body as String);
        return baseFee;
      } else {
        throw Exception(
            'Stellar Chain Provider Error: ${jsonDecode(result.body)['title']}');
      }
    } catch (exp) {
      throw 'Calculator fee failure';
    }
  }

  static double parseJsonStringtoBaseFee(String jsonString) {
    final baseFeeString = jsonDecode(jsonString)['last_ledger_base_fee'];
    return double.parse(baseFeeString);
  }

  Future<String> sendTransactionRaw({
    required String data,
  }) async {
    data = data.replaceAll('\+', '%2B');
    final result = await post(
      '$_httpUrl/transactions?tx=$data',
      {},
      headers: _headersPost,
    );
    if (result.statusCode != 200) {
      throw jsonDecode(result.body)['title'] ?? 'Send raw transaction failure';
    } else {
      return result.body;
    }
  }

  Future<BigInt> getBalance({required String address}) async {
    final result = await get(
      '$_httpUrl/accounts/$address',
      headers: _headers,
    );
    if (result.statusCode == 200) {
      final balance =
          await compute(parseJsonStringtoBalance, result.body as String);
      return balance;
    } else {
      if (jsonDecode(result.body)['title'] == 'Resource Missing') {
        return BigInt.from(0);
      } else {
        throw jsonDecode(result.body)['title'] ?? 'Get balance failure';
      }
    }
  }

  Future<bool> checkCreateAccount({required String address}) async {
    final result = await get(
      '$_httpUrl/accounts/$address',
      headers: _headers,
    );
    if (result.statusCode == 200) {
      await compute(parseJsonStringtoBalance, result.body as String);
      return false;
    } else {
      if (jsonDecode(result.body)['title'] == 'Resource Missing') {
        return true;
      } else {
        throw jsonDecode(result.body)['title'] ?? 'Get balance failure';
      }
    }
  }

  Future<BigInt> getSequence({required String address}) async {
    final result = await get(
      '$_httpUrl/accounts/$address',
      headers: _headers,
    );
    if (result.statusCode == 200) {
      final sequence =
          await compute(parseJsonStringtoSequence, result.body as String);
      return sequence;
    } else {
      throw jsonDecode(result.body)['title'] ?? 'Get sequence failure';
    }
  }

  static BigInt parseJsonStringtoSequence(String jsonString) {
    final sequence = jsonDecode(jsonString)['sequence'];
    return BigInt.from(double.parse(sequence as String));
  }

  static BigInt parseJsonStringtoBalance(String jsonString) {
    final balances = jsonDecode(jsonString)['balances'] as List<dynamic>;
    return Crypto.parseStringToBigIntMultiply(
        valueString: balances[balances.length - 1]['balance'] as String,
        decimal: 7);
  }

  Future<String> getTransactions({required String address}) async {
    final query = {
      'limit': '20',
      'order': 'desc',
      'include_failed': 'true',
    };
    final result = await get(
      '$_httpUrl/accounts/$address/payments',
      headers: _headers,
      query: query,
    );
    if (result.statusCode == 200) {
      return result.body;
    } else {
      if (jsonDecode(result.body)['title'] == 'Resource Missing') {
        return '';
      }
      throw jsonDecode(result.body)['title'] ?? 'Get tranactions list failure';
    }
  }

  Future<String> getInformationTransaction({required String hash}) async {
    final response =
        await httpClient.get('$_httpUrl/transactions/$hash', headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw jsonDecode(response.body)['title'] ??
          'Get transaction infomation failure';
    }
  }
}
