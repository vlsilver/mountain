import 'dart:async';

import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/address_add_liquidity_list.dart';
import 'package:base_source/app/data/models/local_model/address_approve_list.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_pendding.dart';
import 'package:base_source/app/data/models/local_model/wallet_model.dart';
import 'package:base_source/app/module_setting/setting_history_transaction/setting_history_transaction_controller.dart';
import 'package:base_source/app/module_setting/setting_history_transaction/setting_history_transaction_page.dart';
import 'package:base_source/app/module_wallet/module_create_token/create_token_controller.dart';
import 'package:base_source/app/module_wallet/module_create_token/create_token_page.dart';
import 'package:base_source/app/module_wallet/module_notification/notification_controller.dart';
import 'package:base_source/app/module_wallet/module_notification/notification_page.dart';
import 'package:base_source/app/module_wallet/module_swap/update_address_swap/update_address_swap_page.dart';
import 'package:base_source/app/module_wallet/wallet_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'module_add_token/pages/add_token_active_page.dart';
import 'module_history_transaction_coin/history_transaction_coin_controller.dart';
import 'module_history_transaction_coin/history_transaction_coin_page.dart';
import 'module_request_receive/pages/select_coin_page.dart';
import 'module_send/update_address_send/update_address_send_page.dart';
import 'module_swap/swap_controller.dart';

enum EnumUpdateWallet {
  PAGE,
  APPBAR,
  AVATAR,
  CURRENCY_ACTIVE,
  CURRENCY_ONLY,
  TRANSACTION,
  NOTIFICATION,
  REVOKE_LIST,
}

enum EnumPrivateKeyStatus { NOT_AVAILBLE, EXITED, SUCCESS }

class WalletController extends GetxController {
  final List<Color> colorIconList = const [
    Color.fromRGBO(22, 146, 255, 1),
    Color.fromRGBO(248, 115, 105, 1),
    Color.fromRGBO(79, 191, 193, 1),
    Color.fromRGBO(79, 191, 193, 1),
  ];
  final List<dynamic> icons = [
    Icons.save_alt,
    Icons.add_rounded,
    Icons.north_east,
    'assets/global/ic_swap.svg'
  ];

  final String icLogout = 'assets/wallet/ic_logout.svg';
  final String icAddtoken = 'assets/wallet/ic_add_token.svg';

  bool isLoadSuccess = false;

  List<AddressModel> notiTransactions = <AddressModel>[];

  bool autoStream = false;
  TotalWalletModel totalWallet = TotalWalletModel.empty();
  late ScrollController scrollController;
  WalletModel wallet = WalletModel.empty();
  final _repo = WalletTrustRepository();
  bool visibleAppbar = false;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    totalWallet = await _repo.getTotalWallet();
    if (totalWallet.active != null) {
      wallet = await _repo.getWallet(
          key: WalletModel.keyFromIndex(index: totalWallet.active!));
    }
    super.onReady();
  }

  void handleScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset > 70.0 && !visibleAppbar) {
        visibleAppbar = true;
        update([EnumUpdateWallet.APPBAR]);
      } else if (scrollController.offset <= 70.0 && visibleAppbar) {
        visibleAppbar = false;
        update([EnumUpdateWallet.APPBAR]);
      }
    });
  }

  Future<void> getWallet() async {
    wallet = await _repo.getWallet(
        key: WalletModel.keyFromIndex(index: totalWallet.active!));
  }

  Future<void> updateWallet() async {
    await _repo.saveDataToKeyChain(key: wallet.key, data: wallet.toJson());
  }

  Future<List<String>> createNewWallet({
    required String password,
    required bool biometricState,
  }) async {
    wallet = await _repo.createNewWallet(
        password: password,
        biometricState: biometricState,
        indexWallet: totalWallet.length);
    totalWallet.active = totalWallet.length;
    totalWallet.length = totalWallet.length + 1;
    return wallet.mnemonic.split(' ');
  }

  Future<bool> importWallet({
    required String mnemonic,
    required String password,
    required bool biometricState,
  }) async {
    var importSuccess = await _repo.importWallet(
        mnemonic: mnemonic,
        password: password,
        biometricState: biometricState,
        indexWallet: totalWallet.length,
        wallet: wallet);

    if (!importSuccess) {
      throw Exception();
    }
    final key = WalletModel.keyFromIndex(index: totalWallet.length);
    wallet = WalletModel.init(
      key: key,
      mnemonic: mnemonic,
      password: password,
      index: totalWallet.length,
    );
    final blockChains = await _repo.initBlockChains();
    wallet.blockChains = blockChains;
    totalWallet.active = totalWallet.length;
    totalWallet.length = totalWallet.length + 1;
    await _repo.saveDataToKeyChain(
        key: TotalWalletModel.key, data: totalWallet.toJson());
    await _repo.saveDataToKeyChain(key: wallet.key, data: wallet.toJson());
    if (biometricState) {
      importSuccess = await _repo.authenWithBiometric();
      if (!importSuccess) {
        return importSuccess;
      }
    }
    await _repo.saveAcceptBiometric(acceptBiometric: biometricState);

    return importSuccess;
  }

  Future<void> resetWallet() async {
    totalWallet.active = null;
    wallet = WalletModel.empty();
    await _repo.saveDataToKeyChain(
      key: TotalWalletModel.key,
      data: totalWallet.toJson(),
    );
  }

  Future<void> initWallet() async {
    await _repo.initWallet(mnemonic: wallet.mnemonic);
  }

  Future<void> deletedAllWallet() async {
    totalWallet = TotalWalletModel.empty();
    wallet = WalletModel.empty();
    await _repo.deletedAllWallet();
  }

  Future<void> getWalletData() async {
    try {
      final initCoinSorts = wallet.coinSorts.isEmpty;
      var updateBlockChain = false;
      final blockChainsSupport = await _repo.getBlockChainSupport();
      final coinsSupport = await _repo.getCoinsSupport();
      for (var i = 0; i < blockChainsSupport.length; i++) {
        final indexNewBlockChain = wallet.blockChains
            .indexWhere((element) => blockChainsSupport[i]['id'] == element.id);
        if (indexNewBlockChain == -1) {
          if (updateBlockChain = false) {
            updateBlockChain = true;
          }
          final blockChain = BlockChainModel.init(blockChainsSupport[i], i);
          final addressModel = AddressModel.init();
          blockChain.addresss.add(addressModel);
          wallet.blockChains.insert(i, blockChain);
          wallet.coinSorts.insert(0, '${blockChain.id}+${blockChain.coin}');
        }
      }
      await for (var blockChain in Stream.fromIterable(wallet.blockChains)) {
        final indexJsonData = blockChainsSupport
            .indexWhere((element) => element['id'] == blockChain.id);
        if (indexJsonData != -1) {
          blockChain.initData(blockChainsSupport[indexJsonData]);
          _repo.initBlockChainProvider(blockChain);
          await for (var addressModel
              in Stream.fromIterable(blockChain.addresss)) {
            addressModel.derivationPath =
                blockChain.getDerivationPathByIndex(addressModel.index);
            addressModel.coinType = blockChain.coinType;
            addressModel.blockChainId = blockChain.id;
            if (addressModel.address.isEmpty) {
              if (addressModel.privatekey.isEmpty) {
                final addressResult = await _repo.getAddressOfAdressModel(
                    addressModel: addressModel);
                addressModel.address = addressResult;
              } else {
                final addressResult = await _repo.getAddressFromPrivakey(
                    addressModel: addressModel);
                addressModel.address = addressResult;
              }
            }
          }
          final listAddressOfBlockChain = blockChain.addresssString;
          final coinsJson = coinsSupport.where((element) {
            return element['blockchainId'] == blockChain.id &&
                element['status'] == 'active' &&
                (element['addressCreator'] == null ||
                    listAddressOfBlockChain
                        .contains(element['addressCreator']));
          }).toList();
          blockChain.coinsInit(coinsJson: coinsJson);
          await for (var addressModel
              in Stream.fromIterable(blockChain.addresss)) {
            if (initCoinSorts) {
              wallet.coinSorts.add(
                  '${blockChain.coinOfBlockChain.blockchainId}+${blockChain.coinOfBlockChain.id}');
            }
            addressModel.coinsInit(blockChain.coins);
            final revokeDataList =
                _repo.getDataFromLocal(key: addressModel.keyOfRevokeList);
            final addLiquidity =
                _repo.getDataFromLocal(key: addressModel.keyOfAddLiquidityList);
            if (addLiquidity != null) {
              addressModel.addLiquidityList =
                  AddLiquidityList.fromJson(addLiquidity);
            } else {
              addressModel.addLiquidityList = AddLiquidityList.empty();
            }
            if (revokeDataList != null) {
              addressModel.revokeDataList =
                  RevokeDataList.fromJson(revokeDataList);
            } else {
              addressModel.revokeDataList = RevokeDataList.empty();
            }
            final transactionPendingString = _repo.getDataFromLocal(
                key: addressModel.keyOfTransactionPending);
            if (transactionPendingString != null) {
              final transactionPendingData =
                  TransactionPenddingData.fromJson(transactionPendingString);
              addressModel.transactionPending = transactionPendingData.data;
            } else {
              addressModel.transactionPending = [];
            }
          }
        }
      }
      if (initCoinSorts || updateBlockChain) {
        await _repo.saveDataToKeyChain(key: wallet.key, data: wallet.toJson());
      }
      isLoadSuccess = true;
      update([EnumUpdateWallet.PAGE]);
    } catch (exp) {
      update([EnumUpdateWallet.PAGE]);
      AppError.handleError(exception: exp);
    }
  }

  Future<void> changePassword() async {
    await _repo.saveDataToKeyChain(key: wallet.key, data: wallet.toJson());
  }

  Future<void> createNewAddress({
    required String name,
    required String blockChainId,
  }) async {
    final blockChain =
        blockChains.firstWhere((element) => element.id == blockChainId);
    var indexOfNewAddress = 0;
    for (var i = 0; i < blockChain.addresss.length + 1; i++) {
      final index =
          blockChain.addresss.indexWhere((element) => element.index == i);
      if (index == -1) {
        indexOfNewAddress = i;
      }
    }
    final newAddressModel = AddressModel(
      index: indexOfNewAddress,
      name: name,
      avatar: 0,
      privatekey: '',
      transactionLatest: '',
      blockChainId: blockChainId,
      coinType: blockChain.coinType,
      derivationPath: blockChain.getDerivationPathByIndex(indexOfNewAddress),
      revokeDataList: RevokeDataList.empty(),
      addLiquidityList: AddLiquidityList.empty(),
      transactionPending: [],
    );
    final addressOfNewAddressModel =
        await _repo.getAddressFromDerivationPath(addressModel: newAddressModel);
    newAddressModel.address = addressOfNewAddressModel;
    newAddressModel.coinsInit(blockChain.coins);
    blockChain.addresss.add(newAddressModel);
    await _repo.saveDataToKeyChain(key: wallet.key, data: wallet.toJson());
  }

  Future<EnumPrivateKeyStatus> createAddress({
    required String key,
    required String blockChainId,
  }) async {
    final blockChain =
        blockChains.firstWhere((element) => element.id == blockChainId);
    var loopWhile = true;
    var indexOfNewAddress = 0;
    while (loopWhile) {
      indexOfNewAddress = indexOfNewAddress - 1;
      final index = blockChain.addresss
          .indexWhere((element) => element.index == indexOfNewAddress);
      if (index == -1) {
        break;
      }
    }
    final newAddressModel = AddressModel(
      index: indexOfNewAddress,
      name: 'Import ${-indexOfNewAddress}',
      avatar: 0,
      privatekey: '',
      transactionLatest: '',
      blockChainId: blockChainId,
      coinType: blockChain.coinType,
      derivationPath: '',
      revokeDataList: RevokeDataList.empty(),
      addLiquidityList: AddLiquidityList.empty(),
      transactionPending: [],
    );
    var addressOfNewAddressModel = '';
    if (blockChainId == BlockChainModel.piTestnet) {
      if (key.contains(' ')) {
        final data = await _repo.getAddressFromSeedPhrase(seedphrase: key);
        addressOfNewAddressModel = data[0] as String;
        newAddressModel.privatekey = data[1] as String;
      } else {
        newAddressModel.privatekey =
            key.substring(0, 2) == '0x' ? key.substring(2) : key;
        addressOfNewAddressModel =
            await _repo.getAddressFromPrivakey(addressModel: newAddressModel);
      }
    } else {
      newAddressModel.privatekey =
          key.substring(0, 2) == '0x' ? key.substring(2) : key;
      addressOfNewAddressModel =
          await _repo.getAddressFromPrivakey(addressModel: newAddressModel);
    }

    if (addressOfNewAddressModel.isNotEmpty) {
      final index = blockChain.addresss.indexWhere(
          (addressModel) => addressModel.address == addressOfNewAddressModel);
      if (index != -1) {
        return EnumPrivateKeyStatus.EXITED;
      }
      newAddressModel.address = addressOfNewAddressModel;
      newAddressModel.coinsInit(blockChain.coins);
      blockChain.addresss.add(newAddressModel);
      await _repo.saveDataToKeyChain(key: wallet.key, data: wallet.toJson());
      return EnumPrivateKeyStatus.SUCCESS;
    } else {
      return EnumPrivateKeyStatus.NOT_AVAILBLE;
    }
  }

  Future<void> createNewAddressFavourite({
    required String name,
    required String address,
    required String blockChainId,
  }) async {
    final blockChain =
        blockChains.firstWhere((element) => element.id == blockChainId);

    final lenOfAddressBlockChain = blockChain.addresssFavourite.length;
    final indexOfNewAddress = lenOfAddressBlockChain == 0
        ? 0
        : blockChain.addresss[lenOfAddressBlockChain - 1].index + 1;
    final newAddress = AddressModel(
      index: indexOfNewAddress,
      address: address,
      name: name,
      avatar: 0,
      privatekey: '',
      transactionLatest: '',
      coinType: blockChain.coinType,
      blockChainId: blockChain.id,
    );
    blockChain.addresssFavourite.add(newAddress);
    await _repo.saveDataToKeyChain(
      key: wallet.key,
      data: wallet.toJson(),
    );
  }

  Future<void> deleteAddress({
    required String address,
    required String blockChainId,
  }) async {
    final blockChain =
        blockChains.firstWhere((element) => element.id == blockChainId);
    final indexOfResult =
        blockChain.addresss.indexWhere((element) => element.address == address);
    blockChain.addresss.removeAt(indexOfResult);
    await _repo.saveDataToKeyChain(key: wallet.key, data: wallet.toJson());

    // update([EnumUpdateWallet.COIN_ADDRESS]);
  }

  Future<void> updateIndexBlockChainActive({required int index}) async {
    wallet.indexBlockChainActive = index;
    await _repo.saveDataToKeyChain(key: wallet.key, data: wallet.toJson());
    update([
      // EnumUpdateWallet.COIN,
      // EnumUpdateWallet.COIN_ADDRESS,
      EnumUpdateWallet.AVATAR
    ]);
  }

  Future<void> updateIndexAddressActive({required int index}) async {
    blockChainActive.indexAddressActive = index;
    await _repo.saveDataToKeyChain(key: wallet.key, data: wallet.toJson());
    update([
      // EnumUpdateWallet.COIN_ADDRESS,
      EnumUpdateWallet.AVATAR,
    ]);
  }

  void updateCoinModel() {
    isLoadSuccess = false;
    update([EnumUpdateWallet.PAGE]);
    for (var blockChain in wallet.blockChains) {
      for (var coin in blockChain.coins) {
        if (blockChain.idOfCoinActives.contains(coin.id)) {
          coin.isActive = true;
        } else {
          coin.isActive = false;
        }
      }
    }
    isLoadSuccess = true;
    update([EnumUpdateWallet.PAGE]);
  }

  Future<void> updateAddressModel({required AddressModel addressModel}) async {
    final blockChain = wallet.blockChains
        .firstWhere((blockChain) => blockChain.id == addressModel.blockChainId);
    final index = blockChain.addresss
        .indexWhere((element) => element.address == addressModel.address);
    blockChain.addresss[index] = addressModel.copyWith();
    await _repo.saveDataToKeyChain(
      key: wallet.key,
      data: wallet.toJson(),
    );
  }

  Future<bool> loginWithPassword({required String passsowrd}) async {
    await _repo.initWallet(mnemonic: wallet.mnemonic);
    return passsowrd == wallet.password;
  }

  void handleItemFeatureOnTap({required int index}) async {
    switch (index) {
      case 0:
        await Get.bottomSheet(ReceiveNavigatorPage(), isScrollControlled: true);
        break;
      case 1:
        Get.put(CreateTokenController());
        await Get.bottomSheet(CreateTokenPage(), isScrollControlled: true);
        await Get.delete<CreateTokenController>();
        break;
      case 2:
        await Get.bottomSheet(SendNavigatorPage(isFullScreen: false),
            isScrollControlled: true);
        break;
      case 3:
        final swapController = Get.put(SwapController());
        await Get.bottomSheet(
            SwapNavigatorPage(
              isFullScreen: false,
              isFast: false,
            ),
            isScrollControlled: true);
        swapController.isAutoGetAmount = false;
        await Get.delete<SwapController>();
        break;
      default:
    }
  }

  void handleAvatarOnTap() async {
    Get.put(SettingHistoryTransactionController());
    await Get.to(() => SettingHistoryTransactionPage());
    await Get.delete<SettingHistoryTransactionController>();
  }

  void handleNewToken() async {
    await Get.bottomSheet(AddTokenNavigator(), isScrollControlled: true);
  }

  void handleCoinItemOnTap(CoinModel coinModel) async {
    Get.put(HistoryTransactionCoinController(coinModelInit: coinModel));
    await Get.to(() => HistoryTransactionCoinPage());
    await Get.delete<HistoryTransactionCoinController>();
  }

  void handleIcNotiOnTap() async {
    Get.put(NotificationController());
    await Get.to(() => NotificationPage());
    await Get.delete<NotificationController>();
  }

  List<AddressModel> addresssAll() {
    var addresss = <AddressModel>[];
    for (var coin in blockChains) {
      addresss.addAll(coin.addresss);
    }
    return addresss;
  }

  void handleChangePositionCoinActive(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final oldValue = wallet.coinSorts.removeAt(oldIndex);
    wallet.coinSorts.insert(newIndex, oldValue);
    updateWallet();
  }

  List<BlockChainModel> get blockChains => wallet.blockChains;

  List<BlockChainModel> get blockChainSupportCreateToken => wallet.blockChains
      .where((element) =>
          element.id == BlockChainModel.binanceSmart ||
          element.id == BlockChainModel.kardiaChain)
      .toList();
  List<BlockChainModel> get blockChainSupportSwap => wallet.blockChains
      .where((element) =>
          element.id == BlockChainModel.binanceSmart ||
          element.id == BlockChainModel.ethereum ||
          element.id == BlockChainModel.polygon ||
          element.id == BlockChainModel.kardiaChain)
      .toList();
  BlockChainModel get blockChainSupportLaunchPad => wallet.blockChains
      .firstWhere((element) => element.id == BlockChainModel.binanceSmart);
  BlockChainModel get blockChainActive =>
      blockChains.firstWhere((element) => element.currencyValue() > 0.0,
          orElse: () => blockChains[0]);

  BlockChainModel get blockChainActiveSupportSwap =>
      blockChainSupportSwap.firstWhere(
          (element) => element.currencyValue() > 0.0,
          orElse: () => blockChains[0]);

  List<AddressModel> get addresssActive => blockChainActive.addresss;

  List<AddressModel> get addresssActiveSupportSwap =>
      blockChainActiveSupportSwap.addresss;

  AddressModel get addressActive =>
      addresssActive.firstWhere((element) => element.currencyValue() > 0.0,
          orElse: () => addresssActive[0]);

  AddressModel get addressActiveSupportSwap =>
      addresssActiveSupportSwap.firstWhere(
          (element) => element.currencyValue() > 0.0,
          orElse: () => addresssActive[0]);

  List<AddressModel> get addresssFavouriteActive =>
      blockChainActive.addresssFavourite;
  BlockChainModel blockChainById(String id) =>
      wallet.blockChains.firstWhere((element) => element.id == id);
}
