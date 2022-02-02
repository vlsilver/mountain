import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/services/setting_services.dart';
import 'package:base_source/app/module_markets/module_chart_coin.dart/chart_coin_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';

import 'markets_repo.dart';
import 'module_chart_coin.dart/chart_coin_pages.dart';

enum EnumUpdateMaketsPage {
  LIST_MARKET,
  PAGE,
  LIST_FAVOURITE,
}

class MarketsController extends GetxController {
  final walletController = Get.find<WalletController>();
  final settingService = Get.find<SettingService>();
  late TabController tabController;
  final _repo = MarketRepository();
  final focusNode = FocusNode(debugLabel: 'MarketsController');
  final searchValue = ''.obs;
  bool isFirstTime = true;
  Worker? worker;
  var listSearchMarketsInitial = <CoinModel>[];
  var listSearchMarketsResult = <CoinModel>[];
  var listSearchMarketsResultOld = <CoinModel>[];
  var listSearchFavouriteInitial = <CoinModel>[];
  var listSearchFavouriteResult = <CoinModel>[];
  var listSearchFavouriteResultOld = <CoinModel>[];
  var listFavouriteSaveLocal = <String>[];
  var searchMarketsName = 0;
  var searchMarketsVol = 0;
  var searchMartketsLastPrice = 0;
  var searchMartkets24Chg = 0;
  var searchFavouriteName = 0;
  var searchFavouriteVol = 0;
  var searchFavouriteLastPrice = 0;
  var searchFavourite24Chg = 0;
  String get currency => settingService.currencyActive.currency;

  @override
  void onReady() {
    super.onReady();
  }

  void handleSetData() async {
    final data = _repo.getDataFromLocal(
        key: walletController.wallet.keyForFavouritePairCoin);
    if (data != null) {
      listFavouriteSaveLocal = FavouriteCoinPairData.fromJson(data).data;
    }

    for (var blockChain in walletController.blockChains) {
      if (data == null) {
        listFavouriteSaveLocal.add(blockChain.coinOfBlockChain.symbol + '/USD');
      }
      for (var coin in blockChain.coins) {
        if (listSearchMarketsInitial
                    .indexWhere((element) => element.id == coin.id) ==
                -1 &&
            coin.price != 0.0 &&
            coin.marketVol != 0.0) {
          listSearchMarketsInitial.add(coin);
          if (listFavouriteSaveLocal.contains(coin.symbol + '/USD')) {
            listSearchFavouriteInitial.add(coin);
          }
        }
      }
    }
    if (data == null) {
      await _repo.saveDataToLocal(
        key: walletController.wallet.keyForFavouritePairCoin,
        data: FavouriteCoinPairData(data: listFavouriteSaveLocal).toJson(),
      );
    }
    listSearchMarketsResult = [...listSearchMarketsInitial];
    listSearchMarketsResultOld = [...listSearchMarketsResult];
    listSearchFavouriteResult = [...listSearchFavouriteInitial];
    listSearchFavouriteResultOld = [...listSearchFavouriteResult];
    searchMarketsName = 0;
    searchMarketsVol = 0;
    searchMartketsLastPrice = 0;
    searchMartkets24Chg = 0;
    searchFavouriteName = 0;
    searchFavouriteVol = 0;
    searchFavouriteLastPrice = 0;
    searchFavourite24Chg = 0;
  }

  void checkInitDataSucces() async {
    listSearchMarketsInitial = [];
    listSearchMarketsResult = [];
    listSearchFavouriteInitial = [];
    listSearchFavouriteResult = [];
    if (isFirstTime) {
      await Future.delayed(Duration(milliseconds: 2000));
      isFirstTime = false;
    } else {
      await Future.delayed(Duration(milliseconds: 500));
    }
    handleSetData();
    update([EnumUpdateMaketsPage.PAGE]);
  }

  void handleSearchWorker() {
    worker = debounce(searchValue, (value) {
      if (searchValue.value.isNotEmpty) {
        listSearchMarketsResult = listSearchMarketsInitial
            .where((element) =>
                element.id
                    .toLowerCase()
                    .contains(searchValue.value.toLowerCase()) ||
                element.symbol
                    .toLowerCase()
                    .contains(searchValue.value.toLowerCase()))
            .toList();
        listSearchFavouriteResult = listSearchFavouriteInitial
            .where((element) =>
                element.id
                    .toLowerCase()
                    .contains(searchValue.value.toLowerCase()) ||
                element.symbol
                    .toLowerCase()
                    .contains(searchValue.value.toLowerCase()))
            .toList();
        listSearchMarketsResultOld = [...listSearchMarketsResult];
        listSearchFavouriteResultOld = [...listSearchFavouriteResult];
        update([
          EnumUpdateMaketsPage.LIST_MARKET,
          EnumUpdateMaketsPage.LIST_FAVOURITE
        ]);
      } else {
        listSearchMarketsResult = [...listSearchMarketsInitial];
        listSearchMarketsResultOld = [...listSearchMarketsResult];
        listSearchFavouriteResult = [...listSearchFavouriteInitial];
        listSearchFavouriteResultOld = [...listSearchFavouriteResult];
        update([
          EnumUpdateMaketsPage.LIST_MARKET,
          EnumUpdateMaketsPage.LIST_FAVOURITE
        ]);
      }
    }, time: 300.milliseconds);
  }

  void handleWorkerClose() {
    worker!.dispose();
  }

  void handleSearchNameOnTap() {
    focusNode.unfocus();
    if (tabController.index == 1) {
      if (searchMarketsName == 0) {
        searchMarketsName += 1;
        listSearchMarketsResult.sort(
            (a, b) => a.symbol.toUpperCase().compareTo(b.symbol.toUpperCase()));
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      } else if (searchMarketsName == 1) {
        searchMarketsName += 1;
        listSearchMarketsResult.sort(
            (a, b) => b.symbol.toUpperCase().compareTo(a.symbol.toUpperCase()));
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      } else {
        searchMarketsName = 0;
        listSearchMarketsResult = [...listSearchMarketsResultOld];
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      }
    } else {
      if (searchFavouriteName == 0) {
        searchFavouriteName += 1;
        listSearchFavouriteResult.sort(
            (a, b) => a.symbol.toUpperCase().compareTo(b.symbol.toUpperCase()));
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      } else if (searchFavouriteName == 1) {
        searchFavouriteName += 1;
        listSearchFavouriteResult.sort(
            (a, b) => b.symbol.toUpperCase().compareTo(a.symbol.toUpperCase()));
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      } else {
        searchFavouriteName = 0;
        listSearchFavouriteResult = [...listSearchFavouriteResultOld];
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      }
    }
  }

  void handleSearchVolOnTap() {
    focusNode.unfocus();
    if (tabController.index == 1) {
      if (searchMarketsVol == 0) {
        searchMarketsVol += 1;
        listSearchMarketsResult
            .sort((a, b) => a.marketVol.compareTo(b.marketVol));
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      } else if (searchMarketsVol == 1) {
        searchMarketsVol += 1;
        listSearchMarketsResult
            .sort((a, b) => b.marketVol.compareTo(a.marketVol));
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      } else {
        searchMarketsVol = 0;
        listSearchMarketsResult = [...listSearchMarketsResultOld];
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      }
    } else {
      if (searchFavouriteVol == 0) {
        searchFavouriteVol += 1;
        listSearchFavouriteResult
            .sort((a, b) => a.marketVol.compareTo(b.marketVol));
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      } else if (searchFavouriteVol == 1) {
        searchFavouriteVol += 1;
        listSearchFavouriteResult
            .sort((a, b) => b.marketVol.compareTo(a.marketVol));
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      } else {
        searchFavouriteVol = 0;
        listSearchFavouriteResult = [...listSearchFavouriteResultOld];
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      }
    }
  }

  void handleSearchLastPriceOnTap() {
    focusNode.unfocus();
    if (tabController.index == 1) {
      if (searchMartketsLastPrice == 0) {
        searchMartketsLastPrice += 1;
        listSearchMarketsResult.sort((a, b) => a.price.compareTo(b.price));
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      } else if (searchMartketsLastPrice == 1) {
        searchMartketsLastPrice += 1;
        listSearchMarketsResult.sort((a, b) => b.price.compareTo(a.price));
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      } else {
        searchMartketsLastPrice = 0;
        listSearchMarketsResult = [...listSearchMarketsResultOld];
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      }
    } else {
      if (searchFavouriteLastPrice == 0) {
        searchFavouriteLastPrice += 1;
        listSearchFavouriteResult.sort((a, b) => a.price.compareTo(b.price));
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      } else if (searchFavouriteLastPrice == 1) {
        searchFavouriteLastPrice += 1;
        listSearchFavouriteResult.sort((a, b) => b.price.compareTo(a.price));
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      } else {
        searchFavouriteLastPrice = 0;
        listSearchFavouriteResult = [...listSearchFavouriteResultOld];
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      }
    }
  }

  void handleSearch24ChgOnTap() {
    focusNode.unfocus();
    if (tabController.index == 1) {
      if (searchMartkets24Chg == 0) {
        searchMartkets24Chg += 1;
        listSearchMarketsResult
            .sort((a, b) => a.exchange.compareTo(b.exchange));
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      } else if (searchMartkets24Chg == 1) {
        searchMartkets24Chg += 1;
        listSearchMarketsResult
            .sort((a, b) => b.exchange.compareTo(a.exchange));
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      } else {
        searchMartkets24Chg = 0;
        listSearchMarketsResult = [...listSearchMarketsResultOld];
        update([EnumUpdateMaketsPage.LIST_MARKET]);
      }
    } else {
      if (searchFavourite24Chg == 0) {
        searchFavourite24Chg += 1;
        listSearchFavouriteResult
            .sort((a, b) => a.exchange.compareTo(b.exchange));
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      } else if (searchFavourite24Chg == 1) {
        searchFavourite24Chg += 1;
        listSearchFavouriteResult
            .sort((a, b) => b.exchange.compareTo(a.exchange));
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      } else {
        searchFavourite24Chg = 0;
        listSearchFavouriteResult = [...listSearchFavouriteResultOld];
        update([EnumUpdateMaketsPage.LIST_FAVOURITE]);
      }
    }
  }

  void handleCoinPairOnTap(
      {required CoinModel coinModel, required bool isFavourite}) async {
    focusNode.unfocus();
    Get.put(
        ChartCoinController(coinModel: coinModel, isFavourite: isFavourite));
    await Get.to(() => KChartCoinPage());
    await Get.delete<ChartCoinController>();
  }

  void handleFavouriteChangeOnTap(bool isFavourite, CoinModel coinModel) async {
    if (isFavourite) {
      listFavouriteSaveLocal.remove(coinModel.symbol + '/USD');
      listSearchFavouriteInitial.removeWhere(
          (element) => element.contractAddress == coinModel.contractAddress);
      listSearchFavouriteResult.removeWhere(
          (element) => element.contractAddress == coinModel.contractAddress);
      await _repo.saveDataToLocal(
        key: walletController.wallet.keyForFavouritePairCoin,
        data: FavouriteCoinPairData(data: listFavouriteSaveLocal).toJson(),
      );
      listSearchFavouriteResultOld = [...listSearchFavouriteResult];
      update([
        EnumUpdateMaketsPage.LIST_FAVOURITE,
        EnumUpdateMaketsPage.LIST_MARKET,
      ]);
    } else {
      listFavouriteSaveLocal.insert(0, coinModel.symbol + '/USD');
      listSearchFavouriteInitial.insert(0, coinModel);
      listSearchFavouriteResult.insert(0, coinModel);
      await _repo.saveDataToLocal(
        key: walletController.wallet.keyForFavouritePairCoin,
        data: FavouriteCoinPairData(data: listFavouriteSaveLocal).toJson(),
      );
      listSearchFavouriteResultOld = [...listSearchFavouriteResult];
      update([
        EnumUpdateMaketsPage.LIST_FAVOURITE,
        EnumUpdateMaketsPage.LIST_MARKET,
      ]);
    }
  }

  bool isFavourite(String id) => listFavouriteSaveLocal.contains(id);
}

class FavouriteCoinPairData {
  List<String> data;
  FavouriteCoinPairData({
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data,
    };
  }

  factory FavouriteCoinPairData.fromMap(Map<String, dynamic> map) {
    return FavouriteCoinPairData(
      data: List<String>.from(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FavouriteCoinPairData.fromJson(String source) =>
      FavouriteCoinPairData.fromMap(json.decode(source));
}
