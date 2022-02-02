import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/routes/routes.dart';

enum EnumSelectCoinOfAddress { SEARCH }

class SelectCoinOfAddressController extends GetxController {
  final String titleSelectCoinStr = 'select_token'.tr;
  final String hintStr = 'search_token'.tr;

  final searchText = ''.obs;

  late final Worker worker;

  AddressModel addressRequest = AddressModel.empty();
  final amountController = TextEditingController();

  final FocusNode focusNode =
      FocusNode(debugLabel: AppRoutes.REQUEST_RECIEVE_SELECT);

  late CoinModel coinModel;

  late List<CoinModel> coinsInitial;

  late List<CoinModel> coinsSearch;

  @override
  void onInit() {
    super.onInit();
  }

  void handleInitDataController(AddressModel addressModel) {
    coinsInitial = addressModel.coins;
    coinsSearch = List.from(coinsInitial);
  }

  @override
  void onReady() {
    worker = debounce(searchText, (value) {
      if (searchText.isEmpty) {
        coinsSearch = coinsInitial;
        update([EnumSelectCoinOfAddress.SEARCH]);
      } else {
        final searhValue = searchText.toLowerCase();
        coinsSearch = coinsInitial.where((coin) {
          return coin.name.toLowerCase().contains(searhValue) ||
              coin.symbol.toLowerCase().contains(searhValue) ||
              coin.type.toLowerCase().contains(searhValue);
        }).toList();
        update([EnumSelectCoinOfAddress.SEARCH]);
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
    Get.back<CoinModel>(result: coin);
  }

  void handleIconBackOnTap() {
    Get.back();
  }
}
