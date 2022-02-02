import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:k_chart/flutter_k_chart.dart';

import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_markets/markets_controller.dart';
import 'package:base_source/app/module_markets/module_chart_coin.dart/chart_coin_repo.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';

enum EnumUpdateChartPage {
  LOAD_DATA,
  STREAM_DATA,
  TIME_ACITVE,
  INFORMATION,
  STAR,
  SHOW_MORE,
}

class ChartCoinController extends GetxController {
  ChartCoinController({
    required this.coinModel,
    required this.isFavourite,
  });
  final _marketsController = Get.find<MarketsController>();
  final _walletController = Get.find<WalletController>();
  List<KLineEntity>? dataChart;
  CoinModel coinModel = CoinModel.empty();
  bool isFavourite;
  bool isShowMore = false;
  final _repo = ChartCoinRepository();
  var lastPrice = 0.0;
  var highPrice = 0.0;
  var lowPrice = 0.0;
  var quoteVolume = 0.0;
  var priceChangePercent = 0.0;
  var status = StateStatus.INITIAL;
  var auto = false;
  var timeActive = '1d';
  var isBinance = true;
  var listTimeActive = ['1d', '4h', '1h'];
  var listTimeAllBinance = [
    '1m',
    // '3m',
    '5m',
    // '15m',
    '30m',
    '1h',
    // '2h',
    '4h',
    '6h',
    '8h',
    '12h',
    '1d',
    '3d',
    '1w',
    '1M',
  ];

  var listTimeAllKuCoin = [
    '1min',
    '5min',
    '30min',
    '1hour',
    '4hour',
    '4hour',
    '8hour',
    '12hour',
    '1day',
    '1day',
    '1week',
    '1week'
  ];

  bool get getAuto => auto;
  @override
  void onInit() async {
    await initData(timeActive);
    if (status == StateStatus.SUCCESS) {
      auto = true;
      updateHighLowPrice();
      updateAutoCurrency();
    }
    super.onInit();
  }

  @override
  void onClose() {
    auto = false;
    super.onClose();
  }

  void updateHighLowPrice() async {
    while (getAuto) {
      try {
        final dataHighLow24h =
            await _repo.getHighLowPrice24hCoinKec(coinModel.id);
        lastPrice = dataHighLow24h[0];
        highPrice = dataHighLow24h[1];
        lowPrice = dataHighLow24h[2];
        quoteVolume = dataHighLow24h[3];
        priceChangePercent = dataHighLow24h[4];
        await Future.delayed(Duration(seconds: 3));
        if (status == StateStatus.INITIAL) {
        } else {
          update([EnumUpdateChartPage.INFORMATION]);
        }
      } catch (exp) {
        AppError.handleError(exception: exp);
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  void updateAutoCurrency() async {
    while (getAuto) {
      try {
        if (isBinance) {
          dataChart = await _repo.getDataTradingBinance(
              symbol: coinModel.symbol.toUpperCase() + 'USDT',
              time: timeActive);
          DataUtil.calculate(dataChart!);
          // final dataHighLow24h = await _repo.getHighLowPrice24hBinance(
          //     coinModel.symbol.toUpperCase() + 'USDT');
          // lastPrice = dataHighLow24h[0];
          // highPrice = dataHighLow24h[1];
          // lowPrice = dataHighLow24h[2];
          // quoteVolume = dataHighLow24h[3];
          // priceChangePercent = dataHighLow24h[4];
        } else {
          final index = listTimeAllBinance.indexOf(timeActive);
          dataChart = (await _repo.getDataTradingKuCoin(
                  symbol: coinModel.symbol.toUpperCase() + '-USDT',
                  time: listTimeAllKuCoin[index]))
              .reversed
              .toList();
          DataUtil.calculate(dataChart!);
          // final dataHighLow24h = await _repo.getHighLowPrice24hKuCoin(
          //     coinModel.symbol.toUpperCase() + '-USDT');
          // lastPrice = dataHighLow24h[0];
          // highPrice = dataHighLow24h[1];
          // lowPrice = dataHighLow24h[2];
          // quoteVolume = dataHighLow24h[3];
          // priceChangePercent = dataHighLow24h[4];
        }
        await Future.delayed(Duration(milliseconds: 500));
        if (status == StateStatus.INITIAL) {
          status = StateStatus.SUCCESS;
          update([EnumUpdateChartPage.LOAD_DATA]);
        } else {
          update([EnumUpdateChartPage.STREAM_DATA]);
        }
      } catch (exp) {
        AppError.handleError(exception: exp);
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  void handleSetData(CoinModel coinModel) {
    coinModel = coinModel;
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> initData(String timeActive) async {
    try {
      try {
        dataChart = await _repo.getDataTradingBinance(
            symbol: coinModel.symbol.toUpperCase() + 'USDT', time: timeActive);
        DataUtil.calculate(dataChart!);
        isBinance = true;
      } catch (exp) {
        final index = listTimeAllBinance.indexOf(timeActive);
        dataChart = (await _repo.getDataTradingKuCoin(
                symbol: coinModel.symbol.toUpperCase() + '-USDT',
                time: listTimeAllKuCoin[index]))
            .reversed
            .toList();
        DataUtil.calculate(dataChart!);
        isBinance = false;
      }
      final dataHighLow24h =
          await _repo.getHighLowPrice24hCoinKec(coinModel.id);
      lastPrice = dataHighLow24h[0];
      highPrice = dataHighLow24h[1];
      lowPrice = dataHighLow24h[2];
      quoteVolume = dataHighLow24h[3];
      priceChangePercent = dataHighLow24h[4];
      status = StateStatus.SUCCESS;
      update([EnumUpdateChartPage.LOAD_DATA]);
    } catch (exp) {
      status = StateStatus.FAILURE;
      update([EnumUpdateChartPage.LOAD_DATA]);
      AppError.handleError(exception: exp);
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void handleChangeTimeActiveOnTap(String value) async {
    if (timeActive != value) {
      // var oldActive = timeActive;
      timeActive = value;
      if (!listTimeActive.contains(timeActive)) {
        if (listTimeActive.length == 4) {
          listTimeActive.removeAt(3);
        }
        listTimeActive.add(timeActive);
      }
      status = StateStatus.INITIAL;
      update([
        EnumUpdateChartPage.LOAD_DATA,
        EnumUpdateChartPage.TIME_ACITVE,
      ]);
      // try {
      //   if (isBinance) {
      //     dataChart = await _repo.getDataTradingBinance(
      //         symbol: coinModel.symbol.toUpperCase() + 'USDT',
      //         time: timeActive);
      //     DataUtil.calculate(dataChart!);
      //   } else {
      //     final index = listTimeAllBinance.indexOf(timeActive);
      //     dataChart = (await _repo.getDataTradingKuCoin(
      //             symbol: coinModel.symbol.toUpperCase() + '-USDT',
      //             time: listTimeAllKuCoin[index]))
      //         .reversed
      //         .toList();
      //     DataUtil.calculate(dataChart!);
      //   }
      //   status = StateStatus.SUCCESS;
      //   update([
      //     EnumUpdateCharPage.TIME_ACITVE,
      //     EnumUpdateCharPage.LOAD_DATA,
      //   ]);
      // } catch (exp) {
      //   timeActive = oldActive;
      //   auto = true;
      //   status = StateStatus.SUCCESS;
      //   update([
      //     EnumUpdateCharPage.TIME_ACITVE,
      //     EnumUpdateCharPage.LOAD_DATA,
      //   ]);
      //   Get.snackbar('errorStr'.tr, 'request_failure'.tr,
      //       snackPosition: SnackPosition.BOTTOM,
      //       snackStyle: SnackStyle.FLOATING,
      //       colorText: AppColorTheme.error,
      //       backgroundColor: AppColorTheme.backGround,
      //       duration: Duration(milliseconds: 1500));
      // }
    }
  }

  void handleFavouriteChangeOnTap() async {
    if (isFavourite) {
      _marketsController.listFavouriteSaveLocal
          .remove(coinModel.symbol + '/USD');
      _marketsController.listSearchFavouriteInitial.removeWhere(
          (element) => element.contractAddress == coinModel.contractAddress);
      _marketsController.listSearchFavouriteResult.removeWhere(
          (element) => element.contractAddress == coinModel.contractAddress);
      await _repo.saveDataToLocal(
        key: _walletController.wallet.keyForFavouritePairCoin,
        data: FavouriteCoinPairData(
                data: _marketsController.listFavouriteSaveLocal)
            .toJson(),
      );

      _marketsController.update([
        EnumUpdateMaketsPage.LIST_FAVOURITE,
        EnumUpdateMaketsPage.LIST_MARKET,
      ]);
      _marketsController.listSearchFavouriteResultOld = [
        ..._marketsController.listSearchFavouriteResult
      ];
    } else {
      _marketsController.listFavouriteSaveLocal
          .insert(0, coinModel.symbol + '/USD');
      _marketsController.listSearchFavouriteInitial.insert(0, coinModel);
      _marketsController.listSearchFavouriteResult.insert(0, coinModel);
      await _repo.saveDataToLocal(
        key: _walletController.wallet.keyForFavouritePairCoin,
        data: FavouriteCoinPairData(
                data: _marketsController.listFavouriteSaveLocal)
            .toJson(),
      );
      _marketsController.update([
        EnumUpdateMaketsPage.LIST_FAVOURITE,
        EnumUpdateMaketsPage.LIST_MARKET,
      ]);
      _marketsController.listSearchFavouriteResultOld = [
        ..._marketsController.listSearchFavouriteResult
      ];
    }
    isFavourite = !isFavourite;
    update([EnumUpdateChartPage.STAR]);
  }

  void handleClickShowMore() {
    isShowMore = !isShowMore;
    update([EnumUpdateChartPage.SHOW_MORE]);
  }
}
