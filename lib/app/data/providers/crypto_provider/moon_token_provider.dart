import 'dart:convert';
import 'dart:io';

import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:http/http.dart' as http;

class MoonTokenApiProvider extends GetConnect {
  final String _baseUrl = 'https://api.moonwallet.net/api/v1/';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<dynamic> _getApi({
    required String method,
    dynamic query,
  }) async {
    final response = await httpClient
        .get(
          _baseUrl + method,
          query: query,
          headers: _headers,
        )
        .timeout(Duration(milliseconds: 10000));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('MoonProvider Error: ${response.body}');
    }
  }

  Future<dynamic> _postApi({
    required String method,
    dynamic header,
    dynamic body,
  }) async {
    final response = await httpClient.post(
      _baseUrl + method,
      body: body,
      headers: header ?? _headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('MoonProvider Error: ${response.body}');
    }
  }

  Future<List<dynamic>> getBlockChainSupport() async {
    final response = await _getApi(
      method: 'blockchain',
    );
    return jsonDecode(response) as List<dynamic>;
  }

  Future<List<dynamic>> getCoinsSupport() async {
    final response = await _getApi(
      method: 'crypto-currency',
    );
    return response as List<dynamic>;
  }

  Future<List<String>> findToken({
    required String blockChainId,
    required String symbol,
    required String addressContract,
  }) async {
    try {
      final body = {
        'symbol': symbol,
        'contractAddress': addressContract,
        'blockchainId': blockChainId,
      };
      final response = await _postApi(method: 'create-token', body: body);
      return [response['data']['id'], response['data']['image']];
    } catch (exp) {
      return ['', ''];
    }
  }

  Future<String> createToken(
      {required CoinModel coinModel,
      required File file,
      required String addressCreator}) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('${_baseUrl}crypto-currency'));
    request.fields.addAll({
      'id': coinModel.id,
      'name': coinModel.name,
      'symbol': coinModel.symbol,
      'decimals': coinModel.decimals.toString(),
      'type': coinModel.type,
      'contractAddress': coinModel.contractAddress,
      'blockchainId': coinModel.blockchainId,
      'addressCreator': addressCreator,
    });
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = await response.stream.bytesToString();
      return jsonDecode(data)['data']['image'];
    } else {
      final data = await response.stream.bytesToString();
      throw Exception('MoonProvider Error: $data');
    }
  }
}
