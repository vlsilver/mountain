import 'package:base_source/app/data/services/setting_services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';

class CryptoApiProvider extends GetConnect {
  final String _baseUrl = 'https://api.coingecko.com/api/v3/';
  final String _namiBaseUrl = 'https://nami.exchange/api/v1.0/market/summaries';
  final String _baseUrlTradingBiance = 'https://api.binance.com/api/v3/';
  final String _baseUrlTradingKuCoin = 'https://api.kucoin.com/api/v1/market/';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<dynamic> getApi({
    required String method,
    required dynamic query,
  }) async {
    final response = await httpClient
        .get(
          _baseUrl + method,
          query: query,
          headers: _headers,
        )
        .timeout(Duration(milliseconds: 10000));
    // print(
    //     '\n---------------------Block Chain Network Provider---------------------');
    // print('query: $query');
    // print('response.statusCode: ${response.statusCode}');
    // print('response.body: ${response.body}');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('CryptoApiProvider Error: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getCoinExchangeAndPrice(
      List<String> coinsId) async {
    if (!coinsId.contains('ethereum')) {
      coinsId.add('ethereum');
    }
    if (!coinsId.contains('binancecoin')) {
      coinsId.add('binancecoin');
    }
    final query = {
      'ids': coinsId.join(','),
      'vs_currencies':
          '${Get.find<SettingService>().currencyActive.currency.toLowerCase()},usd',
      'include_24hr_change': 'true',
      'include_24hr_vol': 'true',
      'include_market_cap': 'true',
    };
    final response = await getApi(method: 'simple/price', query: query);
    return response as Map<String, dynamic>;
  }

  Future<List<dynamic>> getDataNamiExchange() async {
    final response = await httpClient.get(_namiBaseUrl, headers: _headers);
    if (response.statusCode == 200) {
      return response.body['data'];
    } else {
      throw Exception('CryptoApiProvider Error: ${response.body}');
    }
  }

  Future<List<String>> getTokenEthereumERC20Info(String addressContract) async {
    final query = {'id': 'ethereum', 'contract_address': addressContract};
    try {
      final Map<String, dynamic> response = await getApi(
          method: 'coins/ethereum/contract/$addressContract', query: query);

      return [
        response['id'] as String,
        (response['image'] as Map<String, dynamic>)['large'] as String
      ];
    } catch (exp) {
      return ['', ''];
    }
  }

  Future<List<String>> getTokenBiannceBEP20Info(String addressContract) async {
    try {
      final query = {
        'id': 'binance-smart-chain',
        'contract_address': addressContract
      };
      final Map<String, dynamic> response = await getApi(
          method: 'coins/binance-smart-chain/contract/$addressContract',
          query: query);
      return [
        response['id'] as String,
        (response['image'] as Map<String, dynamic>)['large'] as String
      ];
    } catch (exp) {
      return ['', ''];
    }
  }

  Future<List<String>> getTokenPolygonPERC20Info(String addressContract) async {
    try {
      final query = {'id': 'polygon-pos', 'contract_address': addressContract};
      final Map<String, dynamic> response = await getApi(
          method: 'coins/polygon-pos/contract/$addressContract', query: query);
      return [
        response['id'] as String,
        (response['image'] as Map<String, dynamic>)['large'] as String
      ];
    } catch (exp) {
      return ['', ''];
    }
  }

  Future<List<dynamic>> getHighLowPrice24hCoinKec(String id) async {
    final query = {
      'ids': id,
      'vs_currency': 'usd',
    };
    final response = await getApi(method: 'coins/markets', query: query);
    return response as List<dynamic>;
  }

  Future<Map<String, dynamic>> getHighLowPrice24hBinance(String symbol) async {
    final query = {
      'symbol': symbol,
    };
    final response = await httpClient.get('${_baseUrlTradingBiance}ticker/24hr',
        query: query);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Get data trading Error');
    }
  }

  Future<Map<String, dynamic>> getHighLowPrice24hKuCoin(String symbol) async {
    final query = {
      'symbol': symbol,
    };
    final response =
        await httpClient.get('${_baseUrlTradingKuCoin}stats', query: query);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Get data trading Error');
    }
  }

  Future<List<dynamic>> getTradingDataBinance({
    required String symbol,
    required String time,
  }) async {
    final query = {
      'symbol': symbol,
      'interval': time,
      'limit': '1000',
    };
    final response = await httpClient
        .get('${_baseUrlTradingBiance}klines', query: query)
        .timeout(Duration(milliseconds: 10000));
    if (response.statusCode == 200) {
      return response.body as List<dynamic>;
    } else {
      throw Exception('Get data trading Error');
    }
  }

  Future<List<dynamic>> getTradingDataKuCoin({
    required String symbol,
    required String time,
  }) async {
    final query = {
      'symbol': symbol,
      'type': time,
    };
    final response = await httpClient
        .get('${_baseUrlTradingKuCoin}candles', query: query)
        .timeout(Duration(milliseconds: 10000));
    if (response.statusCode == 200) {
      return response.body['data'] as List<dynamic>;
    } else {
      throw Exception('Get data trading Error');
    }
  }
}
