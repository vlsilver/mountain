import 'package:base_source/app/data/providers/repository.dart';
import 'package:k_chart/flutter_k_chart.dart';

class ChartCoinRepository extends Repository {
  Future<List<double>> getHighLowPrice24hCoinKec(String id) async {
    final data = await cryptoApi.getHighLowPrice24hCoinKec(id);
    final lastPrice = (data[0]['current_price'] as num).toDouble();
    final highPrice = (data[0]['high_24h'] as num).toDouble();
    final lowPrice = (data[0]['low_24h'] as num).toDouble();
    final quoteVolume = (data[0]['total_volume'] as num).toDouble();
    final priceChangePercent =
        (data[0]['price_change_percentage_24h'] as num).toDouble();
    return [
      lastPrice,
      highPrice,
      lowPrice,
      quoteVolume,
      priceChangePercent,
    ];
  }

  Future<List<double>> getHighLowPrice24hBinance(String symbol) async {
    final data = await cryptoApi.getHighLowPrice24hBinance(symbol);
    final lastPrice = double.parse(data['lastPrice']);
    final highPrice = double.parse(data['highPrice']);
    final lowPrice = double.parse(data['lowPrice']);
    final quoteVolume = double.parse(data['quoteVolume']).floorToDouble();
    final priceChangePercent = double.parse(data['priceChangePercent']);
    return [
      lastPrice,
      highPrice,
      lowPrice,
      quoteVolume,
      priceChangePercent,
    ];
  }

  Future<List<double>> getHighLowPrice24hKuCoin(String symbol) async {
    final data = await cryptoApi.getHighLowPrice24hKuCoin(symbol);
    final lastPrice = double.parse(data['last']);
    final highPrice = double.parse(data['high']);
    final lowPrice = double.parse(data['low']);
    final quoteVolume = double.parse(data['volValue']);
    final priceChangePercent = double.parse(data['changeRate']);
    return [
      lastPrice,
      highPrice,
      lowPrice,
      quoteVolume,
      priceChangePercent,
    ];
  }

  Future<List<KLineEntity>> getDataTradingBinance(
      {required String symbol, required String time}) async {
    final data = await cryptoApi.getTradingDataBinance(
      symbol: symbol,
      time: time,
    );
    final dataChart = data
        .map(
          (tradingData) => KLineEntity.fromCustom(
              amount: double.parse(tradingData[5]),
              open: double.parse(tradingData[1]),
              close: double.parse(tradingData[4]),
              time: tradingData[0],
              high: double.parse(tradingData[2]),
              low: double.parse(tradingData[3]),
              vol: double.parse(tradingData[7]),
              change: 0.0,
              ratio: 0.0),
        )
        .toList();
    return dataChart;
  }

  Future<List<KLineEntity>> getDataTradingKuCoin(
      {required String symbol, required String time}) async {
    final data = await cryptoApi.getTradingDataKuCoin(
      symbol: symbol,
      time: time,
    );
    final dataChart = data
        .map(
          (tradingData) => KLineEntity.fromCustom(
              amount: double.parse(tradingData[6]),
              open: double.parse(tradingData[1]),
              close: double.parse(tradingData[2]),
              time: int.parse(tradingData[0]) * 1000,
              high: double.parse(tradingData[3]),
              low: double.parse(tradingData[4]),
              vol: double.parse(tradingData[5]),
              change: 0.0,
              ratio: 0.0),
        )
        .toList();
    return dataChart;
  }

  static List<double> parseJsonToHighLowPrice24h(List<dynamic> data) {
    final highPrice24h = (data[0]['high_24h'] as num).toDouble();
    final lowPrice24h = (data[0]['low_24h'] as num).toDouble();
    return [highPrice24h, lowPrice24h];
  }

  static List<KLineEntity> parseJsonToDataTradingBinance(List<dynamic> data) {
    final dataChart = data
        .map(
          (tradingData) => KLineEntity.fromCustom(
              amount: double.parse(tradingData[5]),
              open: double.parse(tradingData[1]),
              close: double.parse(tradingData[4]),
              time: tradingData[0],
              high: double.parse(tradingData[2]),
              low: double.parse(tradingData[3]),
              vol: double.parse(tradingData[7]),
              change: 0.0,
              ratio: 0.0),
        )
        .toList();
    return dataChart;
  }

  static List<KLineEntity> parseJsonToDataTradingKuCoin(List<dynamic> data) {
    final dataChart = data
        .map(
          (tradingData) => KLineEntity.fromCustom(
              amount: double.parse(tradingData[6]),
              open: double.parse(tradingData[1]),
              close: double.parse(tradingData[2]),
              time: int.parse(tradingData[0]) * 1000,
              high: double.parse(tradingData[3]),
              low: double.parse(tradingData[4]),
              vol: double.parse(tradingData[5]),
              change: 0.0,
              ratio: 0.0),
        )
        .toList();
    return dataChart;
  }
}
