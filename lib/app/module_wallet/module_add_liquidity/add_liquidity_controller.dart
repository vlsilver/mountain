import 'dart:math';

import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/address_add_liquidity_list.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/providers/crypto_provider/binance_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/ethereum_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/kardiachain_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/polygon_provider.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_detail/add_liquidity_detail_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../wallet_controller.dart';
import 'add_liquidity_detail/add_liquidity_detail_page.dart';
import 'add_liquidity_repo.dart';

enum EnumAddLiquidity { RATE, LIST_DATA }

class AddLiquidityController extends GetxController {
  late BlockChainModel blockChainModel;
  late AddressModel addressSender;
  late List<AddLiquidityModel> addLiquidityList;
  AddressModel addressRecieve = AddressModel.empty();
  CoinModel coinModelA = CoinModel.empty();
  CoinModel coinModelB = CoinModel.empty();
  double amountDoubleA = 0.0;
  double amountDoubleB = 0.0;
  String amountStringInA = '0.0';
  String amountStringInB = '0.0';
  double fee = 0.0;
  double rate = 0.0;
  double shareOfPool = 0.0;
  String token0 = '';
  String tokenLP = '';
  bool isErroRate = false;
  bool isAutoGetAmount = true;
  final _walletController = Get.find<WalletController>();
  final _repo = Addliquidityrepository();
  final status = Status();

  void handleResetData() {
    amountDoubleA = 0.0;
    amountDoubleB = 0.0;
    amountStringInA = '0.0';
    amountStringInB = '0.0';
    fee = 0.0;
    rate = 0.0;
    shareOfPool = 0.0;
    isErroRate = false;
    isAutoGetAmount = false;
  }

  void setData({
    required CoinModel coinAInit,
    required CoinModel coinBInit,
    required AddressModel addressSendInit,
    required AddressModel addressRecieveInit,
    required BlockChainModel blockChain,
  }) {
    coinModelA = coinAInit;
    coinModelB = coinBInit;
    addressSender = addressSendInit;
    addressRecieve = addressRecieveInit;
    blockChainModel = blockChain;
  }

  @override
  void onInit() {
    addLiquidityList = _walletController.wallet.addLiquidityList();
    super.onInit();
  }

  void handleResetDatList() {
    addLiquidityList = _walletController.wallet.addLiquidityList();
  }

  Future<bool> checkValidAddress({required String address}) async {
    final isValid = await _repo.checkValidAddress(
      address: address,
      coinType: addressSender.coinType,
    );
    return isValid;
  }

  Future<void> createNewAddressFavourite({
    required String name,
    required String address,
  }) async {
    await _walletController.createNewAddressFavourite(
      name: name,
      address: address,
      blockChainId: blockChainModel.id,
    );
  }

  Future<double> calculatorFee({
    required bool isApprove,
    required bool isApproveSuccess,
    required bool isNeedApproveA,
    required bool isNeedApproveB,
    required bool isCalculator,
  }) async {
    var amountsInA = isCalculator ? coinModelA.value : getBigIntAmountCoinA;
    var amountsInB = isCalculator ? coinModelB.value : getBigIntAmountCoinB;
    fee = 0.0;
    switch (addressSender.blockChainId) {
      case BlockChainModel.ethereum:
        if (isApprove && !isApproveSuccess) {
          if (isNeedApproveA) {
            fee += await _repo.calculatorFeeApproveEthereum(
              tokenContract: coinModelA.contractAddress,
              addressOwner: addressSender.address,
              addressSender: EthereumProvider.contractSwapAbi,
              amount: amountsInA,
            );
          }
          if (isNeedApproveB) {
            fee += await _repo.calculatorFeeApproveEthereum(
              tokenContract: coinModelB.contractAddress,
              addressOwner: addressSender.address,
              addressSender: EthereumProvider.contractSwapAbi,
              amount: amountsInB,
            );
          }
        } else if (!isApprove || isApproveSuccess) {
          fee = await _repo.calculatorFeeAddLiquidityEthereum(
              tokenA: coinModelA.contractAddress,
              tokenB: coinModelB.contractAddress,
              addressSender: addressSender.address,
              addrsassRecieve: addressRecieve.address,
              amountA: amountsInA,
              amountB: amountsInB);
        }
        return fee;
      case BlockChainModel.binanceSmart:
        if (isApprove && !isApproveSuccess) {
          if (isNeedApproveA) {
            fee += await _repo.calculatorFeeApproveBinanceSmart(
              tokenContract: coinModelA.contractAddress,
              addressOwner: addressSender.address,
              addressSender: BinanceSmartProvider.contractSwapAbi,
              amount: amountsInA,
            );
          }
          if (isNeedApproveB) {
            fee += await _repo.calculatorFeeApproveBinanceSmart(
              tokenContract: coinModelB.contractAddress,
              addressOwner: addressSender.address,
              addressSender: BinanceSmartProvider.contractSwapAbi,
              amount: amountsInB,
            );
          }
        } else if (!isApprove || isApproveSuccess) {
          fee = await _repo.calculatorFeeAddLiquidityOfBinanceSmart(
              tokenA: coinModelA.contractAddress,
              tokenB: coinModelB.contractAddress,
              addressSender: addressSender.address,
              addrsassRecieve: addressRecieve.address,
              amountA: amountsInA,
              amountB: amountsInB);
        }
        return fee;
      case BlockChainModel.polygon:
        if (isApprove && !isApproveSuccess) {
          if (isNeedApproveA) {
            fee += await _repo.calculatorFeeApprovePolygon(
              tokenContract: coinModelA.contractAddress,
              addressOwner: addressSender.address,
              addressSender: PolygonProvider.contractSwapAbi,
              amount: amountsInA,
            );
          }
          if (isNeedApproveB) {
            fee += await _repo.calculatorFeeApprovePolygon(
              tokenContract: coinModelB.contractAddress,
              addressOwner: addressSender.address,
              addressSender: PolygonProvider.contractSwapAbi,
              amount: amountsInB,
            );
          }
        } else if (!isApprove || isApproveSuccess) {
          fee = await _repo.calculatorFeeAddliquidityOfPolygon(
              tokenA: coinModelA.contractAddress,
              tokenB: coinModelB.contractAddress,
              addressSender: addressSender.address,
              addrsassRecieve: addressRecieve.address,
              amountA: amountsInA,
              amountB: amountsInB);
        }

        return fee;
      case BlockChainModel.kardiaChain:
        if (isApprove && !isApproveSuccess) {
          if (isNeedApproveA) {
            fee += await _repo.calculatorFeeApproveKardiaChain(
              tokenContract: coinModelA.contractAddress,
              addressOwner: addressSender.address,
              addressSender: KardiaChainProvider.contractSwapAbi,
              amount: amountsInA,
            );
          }
          if (isNeedApproveB) {
            fee += await _repo.calculatorFeeApproveKardiaChain(
              tokenContract: coinModelB.contractAddress,
              addressOwner: addressSender.address,
              addressSender: KardiaChainProvider.contractSwapAbi,
              amount: amountsInB,
            );
          }
        } else if (!isApprove || isApproveSuccess) {
          fee = await _repo.calculatorFeeAddliquidityOfKardiaChain(
              tokenA: coinModelA.contractAddress,
              tokenB: coinModelB.contractAddress,
              addressSender: addressSender.address,
              addrsassRecieve: addressRecieve.address,
              amountA: amountsInA,
              amountB: amountsInB);
        }
        return fee;
      default:
        return 0.0;
    }
  }

  Future<void> getRateCoinAddLiquidity() async {
    try {
      if (isLoadRate) {
        var data = <dynamic>[];
        switch (addressSender.blockChainId) {
          case BlockChainModel.ethereum:
            data = await _repo.getRateCoinPairEthereum(
              tokenContractFrom: coinModelA.contractAddress,
              tokenContractTo: coinModelB.contractAddress,
            );
            break;
          case BlockChainModel.binanceSmart:
            data = await _repo.getRateCoinPairBinance(
              tokenContractFrom: coinModelA.contractAddress,
              tokenContractTo: coinModelB.contractAddress,
            );
            break;
          case BlockChainModel.polygon:
            data = await _repo.getRateCoinPairPolygon(
              tokenContractFrom: coinModelA.contractAddress,
              tokenContractTo: coinModelB.contractAddress,
            );
            break;
          case BlockChainModel.kardiaChain:
            data = await _repo.getRateCoinPairKardiaChain(
              tokenContractFrom: coinModelA.contractAddress,
              tokenContractTo: coinModelB.contractAddress,
            );
            break;
          default:
        }
        token0 = data[1];
        tokenLP = data[2];
        final rateData = data[0];
        if (isPositionCorrect) {
          shareOfPool = coinModelA.stringDoubleToBigInt(amountStringInA) /
              (rateData[0] + coinModelA.stringDoubleToBigInt(amountStringInA));
          rate = (rateData[1] / rateData[0]) *
              pow(10, coinModelA.decimals - coinModelB.decimals);
        } else {
          shareOfPool = coinModelB.stringDoubleToBigInt(amountStringInA) /
              (rateData[1] + coinModelB.stringDoubleToBigInt(amountStringInA));
          rate = (rateData[0] / rateData[1]) *
              pow(10, coinModelA.decimals - coinModelB.decimals);
        }
        isErroRate = false;
        update([EnumAddLiquidity.RATE]);
        if (isAutoGetAmount) {
          await Future.delayed(Duration(milliseconds: 1000));
        }
      } else {
        isErroRate = true;
        await Future.delayed(Duration(milliseconds: 1500));
      }
    } catch (exp) {
      rate = 0.0;
      shareOfPool = 0.0;
      isErroRate = true;
      AppError.handleError(exception: exp);
      await Future.delayed(Duration(milliseconds: 1500));
    }
  }

  Future<void> createAddliquidityTransaction() async {
    // TransactionData? transaction;
    var tokenModel = CoinModel.empty();
    var privateKey = '';
    if (addressSender.privatekey.isNotEmpty) {
      privateKey = addressSender.privatekey;
    } else {
      privateKey = await _repo.getPrivateKey(
          derivationPath: addressSender.derivationPath,
          coinType: addressSender.coinType);
    }
    switch (addressSender.blockChainId) {
      case BlockChainModel.ethereum:
        // transaction =
        await _repo.createAddliquidityTransactionEthereum(
          tokenA: coinModelA.contractAddress,
          tokenB: coinModelB.contractAddress,
          addressSender: addressSender.address,
          addrsassRecieve: addressRecieve.address,
          privateKey: privateKey,
          amountA: getBigIntAmountCoinA,
          amountB: getBigIntAmountCoinB,
        );
        tokenModel = await _repo.getBalanceLPTokenEthereum(
          address: addressRecieve.address,
          tokenLp: tokenLP,
        );
        break;
      case BlockChainModel.binanceSmart:
        // transaction =
        await _repo.createAddliquidityTransactionBinanceSmart(
          tokenA: coinModelA.contractAddress,
          tokenB: coinModelB.contractAddress,
          addressSender: addressSender.address,
          addrsassRecieve: addressRecieve.address,
          privateKey: privateKey,
          amountA: getBigIntAmountCoinA,
          amountB: getBigIntAmountCoinB,
        );
        tokenModel = await _repo.getBalanceLPTokenBinanceSmart(
          address: addressRecieve.address,
          tokenLp: tokenLP,
        );
        break;
      case BlockChainModel.polygon:
        // transaction =
        await _repo.createAddLiquidityTransactionPolygon(
          tokenA: coinModelA.contractAddress,
          tokenB: coinModelB.contractAddress,
          addressSender: addressSender.address,
          addrsassRecieve: addressRecieve.address,
          privateKey: privateKey,
          amountA: getBigIntAmountCoinA,
          amountB: getBigIntAmountCoinB,
        );
        tokenModel = await _repo.getBalanceLPTokenPolygon(
          address: addressRecieve.address,
          tokenLp: tokenLP,
        );
        break;
      case BlockChainModel.kardiaChain:
        await _repo.createAddLiquidityTransactionKardiaChain(
          tokenA: coinModelA.contractAddress,
          tokenB: coinModelB.contractAddress,
          addressSender: addressSender.address,
          addrsassRecieve: addressRecieve.address,
          privateKey: privateKey,
          amountA: getBigIntAmountCoinA,
          amountB: getBigIntAmountCoinB,
        );
        tokenModel = await _repo.getBalanceLPTokenKardiaChain(
          address: addressRecieve.address,
          tokenLp: tokenLP,
        );
        break;
      default:
        break;
    }
    final addLiquidityModel = AddLiquidityModel(
      addressSend: addressSender.address,
      addressRecive: addressRecieve.address,
      blockChainId: addressSender.blockChainId,
      tokenLP: tokenModel,
      tokenA: coinModelA.copyWith(value: getBigIntAmountCoinA),
      tokenB: coinModelB.copyWith(value: getBigIntAmountCoinB),
      shareOfPool: shareOfPool,
      status: 'success',
    );
    addressSender.addLiquidityList!.data.removeWhere((element) =>
        element.tokenLP.contractAddress == tokenLP &&
        element.addressRecive == addLiquidityModel.addressRecive);
    addressSender.addLiquidityList!.data.insert(0, addLiquidityModel);
    addLiquidityList = _walletController.wallet.addLiquidityList();
    await _repo.saveDataToLocal(
        key: addressSender.keyOfAddLiquidityList,
        data: addressSender.addLiquidityList!.toJson());
    update([EnumAddLiquidity.LIST_DATA]);
  }

  Future<void> createApproveTransaction({required CoinModel coinModel}) async {
    var privateKey = '';
    if (addressSender.privatekey.isNotEmpty) {
      privateKey = addressSender.privatekey;
    } else {
      privateKey = await _repo.getPrivateKey(
          derivationPath: addressSender.derivationPath,
          coinType: addressSender.coinType);
    }
    switch (addressSender.blockChainId) {
      case BlockChainModel.ethereum:
        await _repo.createApproveTransactionEthereum(
          tokenContract: coinModel.contractAddress,
          addressOwner: addressSender.address,
          addressSender: EthereumProvider.contractSwapAbi,
          privateKey: privateKey,
          amount: coinModel.value * BigInt.from(2),
        );
        break;
      case BlockChainModel.binanceSmart:
        await _repo.createApproveTransactionBinanceSmart(
          tokenContract: coinModel.contractAddress,
          addressOwner: addressSender.address,
          addressSender: BinanceSmartProvider.contractSwapAbi,
          privateKey: privateKey,
          amount: coinModel.value * BigInt.from(2),
        );
        break;
      case BlockChainModel.polygon:
        await _repo.createApproveTransactionPolygon(
          tokenContract: coinModel.contractAddress,
          addressOwner: addressSender.address,
          addressSender: PolygonProvider.contractSwapAbi,
          privateKey: privateKey,
          amount: coinModel.value * BigInt.from(2),
        );
        break;
      case BlockChainModel.kardiaChain:
        await _repo.createApproveTransactionKardiaChain(
          tokenContract: coinModel.contractAddress,
          addressOwner: addressSender.address,
          addressSender: KardiaChainProvider.contractSwapAbi,
          privateKey: privateKey,
          amount: coinModel.value * BigInt.from(2),
        );
        break;
      default:
        break;
    }
  }

  Future<BigInt> checkAllowance({required CoinModel coinModel}) async {
    switch (addressSender.blockChainId) {
      case BlockChainModel.ethereum:
        return await _repo.getAllowanceEthereum(
            addressOwner: addressSender.address,
            addressSender: EthereumProvider.contractSwapAbi,
            addressContract: coinModel.contractAddress);
      case BlockChainModel.binanceSmart:
        return await _repo.getAllowanceBinance(
            addressOwner: addressSender.address,
            addressSender: BinanceSmartProvider.contractSwapAbi,
            addressContract: coinModel.contractAddress);
      case BlockChainModel.polygon:
        return await _repo.getAllowancePolygon(
            addressOwner: addressSender.address,
            addressSender: PolygonProvider.contractSwapAbi,
            addressContract: coinModel.contractAddress);
      case BlockChainModel.kardiaChain:
        return await _repo.getAllowanceKardiaChain(
            addressOwner: addressSender.address,
            addressSender: KardiaChainProvider.contractSwapAbi,
            addressContract: coinModel.contractAddress);

      default:
        return BigInt.from(0);
    }
  }

  void handleShowDetailAddliquidity(AddLiquidityModel data) async {
    try {
      await status.updateStatus(StateStatus.LOADING);
      final balance = await _repo.checkBalanceTokenLP(
        tokenLp: data.tokenLP.contractAddress,
        address: data.addressRecive,
        blockChianId: data.blockChainId,
      );
      final totalSupply = await _repo.checkTotalSupplyTokenLP(
        tokenLp: data.tokenLP.contractAddress,
        blockChianId: data.blockChainId,
      );
      final rate = balance / totalSupply;
      if (data.tokenLP.value != balance || rate != data.shareOfPool) {
        data.tokenLP.value = balance;
        data.shareOfPool = balance / totalSupply;
      }
      await status.updateStatus(StateStatus.SUCCESS);
      Get.put(AddLiquidityDetailController()).addLiquidityModel = data;
      await Get.bottomSheet(
          AddLiquidityDetailPage(
            height: Get.height * 0.85,
            data: data,
          ),
          isScrollControlled: true);
      await Get.delete<AddLiquidityDetailController>();
    } catch (exp) {
      await status.updateStatus(
        StateStatus.FAILURE,
        showSnackbarError: true,
      );
      AppError.handleError(exception: exp);
    }
  }

  BigInt get getBigIntAmountCoinA =>
      coinModelA.stringDoubleToBigInt(amountStringInA);

  BigInt get getBigIntAmountCoinB =>
      coinModelB.stringDoubleToBigInt(amountStringInB);

  bool get isAvalibleValueInputA => coinModelA.isValueAvalible(amountStringInA);
  bool get isAvalibleValueInputB => coinModelB.isValueAvalible(amountStringInB);

  String get formatShareOfPool => shareOfPool > 1
      ? '100%'
      : shareOfPool == 0.0
          ? '0.0%'
          : shareOfPool * 100 < pow(10, -3)
              ? '< 0.001%'
              : (shareOfPool * 100).toStringAsFixed(3) + '%';
  bool get isPositionCorrect => !coinModelA.isToken
      ? token0.toLowerCase() != coinModelB.contractAddress.toLowerCase()
      : token0.toLowerCase() == coinModelA.contractAddress.toLowerCase();

  String formatShareOfPoolWithValue(double value) => value > 1
      ? '100%'
      : value == 0.0
          ? '0.0%'
          : value * 100 < pow(10, -3)
              ? '< 0.001%'
              : (value * 100).toStringAsFixed(3) + '%';

  bool get isLoadRate => coinModelA.id.isNotEmpty && coinModelB.id.isNotEmpty;
}
