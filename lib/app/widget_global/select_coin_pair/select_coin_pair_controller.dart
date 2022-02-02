import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/routes/routes.dart';

enum EnumSelectCoinPairOfAddress { SEARCH }

class SelectCoinPairController extends GetxController {
  final String titleSelectCoinStr = 'select_token'.tr;
  final String hintStr = 'search_token'.tr;
  bool isFrom = true;
  final searchText = ''.obs;
  late final Worker worker;
  late TabController tabController;

  AddressModel addressRequest = AddressModel.empty();
  final FocusNode focusNode =
      FocusNode(debugLabel: AppRoutes.REQUEST_RECIEVE_SELECT);
  late List<CoinModel> coinsInitial;
  late List<CoinModel> coinsSearch;
  late CoinModel coinFrom;
  late CoinModel coinTo;

  bool isCoinSelect(CoinModel coinModel) => tabController.index == 0
      ? coinFrom.id == coinModel.id
      : coinTo.id == coinModel.id;

  @override
  void onInit() {
    super.onInit();
  }

  void handleInitDataController({
    required AddressModel addressModel,
    required CoinModel coinFromInit,
    required CoinModel coinToInit,
  }) {
    coinsInitial = addressModel.coins;
    coinsSearch = List.from(coinsInitial);
    coinFrom = coinFromInit;
    coinTo = coinToInit;
  }

  @override
  void onReady() {
    worker = debounce(searchText, (value) {
      if (searchText.isEmpty) {
        coinsSearch = coinsInitial;
        update([EnumSelectCoinPairOfAddress.SEARCH]);
      } else {
        final searhValue = searchText.toLowerCase();
        coinsSearch = coinsInitial.where((coin) {
          return coin.name.toLowerCase().contains(searhValue) ||
              coin.symbol.toLowerCase().contains(searhValue) ||
              coin.type.toLowerCase().contains(searhValue);
        }).toList();
        update([EnumSelectCoinPairOfAddress.SEARCH]);
      }
    }, time: Duration(milliseconds: 300));
    super.onReady();
  }

  @override
  void onClose() {
    worker.dispose();
    super.onClose();
  }

  void handleCoinItemOnTap(CoinModel coin) {
    if (tabController.index == 0 && coinFrom.id != coin.id) {
      coinFrom = coin;
      tabController.animateTo(1);
      update([
        EnumSelectCoinPairOfAddress.SEARCH,
      ]);
    } else if (tabController.index == 1 && coinTo.id != coin.id) {
      coinTo = coin;
      tabController.animateTo(0);
      update([
        EnumSelectCoinPairOfAddress.SEARCH,
      ]);
    }
  }

  void handleDoneOnTap() {
    Get.back<List<CoinModel>?>(result: [coinFrom, coinTo]);
  }
}
