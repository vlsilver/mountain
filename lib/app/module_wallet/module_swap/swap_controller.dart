import 'dart:math';

import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_pendding.dart';
import 'package:base_source/app/data/providers/crypto_provider/binance_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/ethereum_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/kardiachain_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/polygon_provider.dart';
import 'package:get/get.dart';

import '../wallet_controller.dart';
import 'swap_repo.dart';

enum EnumSwap { RATE }

class SwapController extends GetxController {
  late BlockChainModel blockChainModel;
  late AddressModel addressSender;
  AddressModel addressRecieve = AddressModel.empty();
  CoinModel coinModelFrom = CoinModel.empty();
  CoinModel coinModelTo = CoinModel.empty();
  double amountIn = 0.0;
  String amountStringIn = '0.0';
  double fee = 0.0;
  double rate = 0.0;
  bool isErroRate = false;
  bool isAutoGetAmount = true;
  final _walletController = Get.find<WalletController>();
  final _repo = SwapRepository();

  void handleResetData() {
    amountIn = 0.0;
    amountStringIn = '0.0';
    fee = 0.0;
    rate = 0.0;
    isErroRate = false;
    isAutoGetAmount = false;
  }

  void setData({
    required CoinModel coinModelSelect,
    required AddressModel addressModel,
    required BlockChainModel blockChain,
  }) {
    coinModelFrom = coinModelSelect;
    coinModelTo = CoinModel.empty();
    blockChainModel = blockChain;
    addressSender = addressModel;
    addressRecieve = addressSender;
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<double> calculatorFee({
    required bool isApprove,
    required bool isApproveSuccess,
    required bool isCalculator,
  }) async {
    var amountsIn =
        isCalculator ? coinModelFrom.value : getBigIntAmountCoinFrom;

    switch (addressSender.blockChainId) {
      case BlockChainModel.ethereum:
        if (isApprove && !isApproveSuccess) {
          fee = await _repo.calculatorFeeApproveEthereum(
            tokenContract: coinModelFrom.contractAddress,
            addressOwner: addressSender.address,
            addressSender: EthereumProvider.contractSwapAbi,
            amount: amountsIn,
          );
        } else if (!isApprove || isApproveSuccess) {
          fee = await _repo.calculatorFeeSwapOfEthereum(
            addressSender: addressSender.address,
            addrsassRecieve: addressRecieve.address,
            tokenContractFrom: coinModelFrom.contractAddress,
            tokenContractTo: coinModelTo.contractAddress,
            amount: amountsIn,
          );
        }
        return fee;
      case BlockChainModel.binanceSmart:
        if (isApprove && !isApproveSuccess) {
          fee = await _repo.calculatorFeeApproveBinanceSmart(
            tokenContract: coinModelFrom.contractAddress,
            addressOwner: addressSender.address,
            addressSender: BinanceSmartProvider.contractSwapAbi,
            amount: amountsIn,
          );
        } else if (!isApprove || isApproveSuccess) {
          fee = await _repo.calculatorFeeSwapOfBinanceSmart(
            addressSender: addressSender.address,
            addrsassRecieve: addressRecieve.address,
            tokenContractFrom: coinModelFrom.contractAddress,
            tokenContractTo: coinModelTo.contractAddress,
            amount: amountsIn,
          );
        }
        return fee;
      case BlockChainModel.polygon:
        if (isApprove && !isApproveSuccess) {
          fee = await _repo.calculatorFeeApprovePolygon(
            tokenContract: coinModelFrom.contractAddress,
            addressOwner: addressSender.address,
            addressSender: PolygonProvider.contractSwapAbi,
            amount: amountsIn,
          );
        } else if (!isApprove || isApproveSuccess) {
          fee = await _repo.calculatorFeeSwapOfPolygon(
            addressSender: addressSender.address,
            addrsassRecieve: addressRecieve.address,
            tokenContractFrom: coinModelFrom.contractAddress,
            tokenContractTo: coinModelTo.contractAddress,
            amount: amountsIn,
          );
        }

        return fee;
      case BlockChainModel.kardiaChain:
        if (isApprove && !isApproveSuccess) {
          fee = await _repo.calculatorFeeApproveKardiaChain(
            tokenContract: coinModelFrom.contractAddress,
            addressOwner: addressSender.address,
            addressSender: KardiaChainProvider.contractSwapAbi,
            amount: amountsIn,
          );
        } else if (!isApprove || isApproveSuccess) {
          fee = await _repo.calculatorFeeSwapOfKardiaChain(
            addressSender: addressSender.address,
            addrsassRecieve: addressRecieve.address,
            tokenContractFrom: coinModelFrom.contractAddress,
            tokenContractTo: coinModelTo.contractAddress,
            amount: amountsIn,
          );
        }
        return fee;
      default:
        return 0.0;
    }
  }

  Future<void> getRateCoinSwap() async {
    try {
      if (isLoadRate) {
        var rateresult = 0.0;
        var amountsIn =
            amountIn < pow(10, -coinModelFrom.decimals) || !isAvalibleValueInput
                ? BigInt.from(1 * coinModelFrom.powDecimals)
                : getBigIntAmountCoinFrom;
        switch (addressSender.blockChainId) {
          case BlockChainModel.ethereum:
            rateresult = await _repo.getAmountsOutEthereum(
                tokenContractFrom: coinModelFrom.contractAddress,
                tokenContractTo: coinModelTo.contractAddress,
                amount: amountsIn);
            break;
          case BlockChainModel.binanceSmart:
            rateresult = await _repo.getAmountsOutBinanceSmart(
                tokenContractFrom: coinModelFrom.contractAddress,
                tokenContractTo: coinModelTo.contractAddress,
                amount: amountsIn);
            break;
          case BlockChainModel.polygon:
            rateresult = await _repo.getAmountsOutPolygon(
                tokenContractFrom: coinModelFrom.contractAddress,
                tokenContractTo: coinModelTo.contractAddress,
                amount: amountsIn);
            break;
          case BlockChainModel.kardiaChain:
            rateresult = await _repo.getAmountsOutKardiaChain(
                tokenContractFrom: coinModelFrom.contractAddress,
                tokenContractTo: coinModelTo.contractAddress,
                amount: amountsIn);
            break;
          default:
        }
        rate =
            rateresult * pow(10, coinModelFrom.decimals - coinModelTo.decimals);
        isErroRate = false;
        update([EnumSwap.RATE]);
        if (isAutoGetAmount) {
          await Future.delayed(Duration(milliseconds: 1000));
        }
      } else {
        isErroRate = true;
        await Future.delayed(Duration(milliseconds: 1500));
      }
    } catch (exp) {
      rate = 0.0;
      isErroRate = true;
      AppError.handleError(exception: exp);
      await Future.delayed(Duration(milliseconds: 1500));
    }
  }

  Future<void> createSwapTransaction() async {
    TransactionData? transaction;
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
        transaction = await _repo.createSwapTransactionEthereum(
            tokenContractFrom: coinModelFrom.contractAddress,
            tokenContractTo: coinModelTo.contractAddress,
            addressSender: addressSender.address,
            addrsassRecieve: addressRecieve.address,
            privateKey: privateKey,
            amount: getBigIntAmountCoinFrom);
        break;
      case BlockChainModel.binanceSmart:
        transaction = await _repo.createSwapTransactionBinanceSmart(
            tokenContractFrom: coinModelFrom.contractAddress,
            tokenContractTo: coinModelTo.contractAddress,
            addressSender: addressSender.address,
            addrsassRecieve: addressRecieve.address,
            privateKey: privateKey,
            amount: getBigIntAmountCoinFrom);
        break;
      case BlockChainModel.polygon:
        transaction = await _repo.createSwapTransactionPolygon(
            tokenContractFrom: coinModelFrom.contractAddress,
            tokenContractTo: coinModelTo.contractAddress,
            addressSender: addressSender.address,
            addrsassRecieve: addressRecieve.address,
            privateKey: privateKey,
            amount: getBigIntAmountCoinFrom);
        break;
      case BlockChainModel.kardiaChain:
        transaction = await _repo.createSwapTransactionKardiaChain(
            tokenContractFrom: coinModelFrom.contractAddress,
            tokenContractTo: coinModelTo.contractAddress,
            addressSender: addressSender.address,
            addrsassRecieve: addressRecieve.address,
            privateKey: privateKey,
            amount: getBigIntAmountCoinFrom);
        break;
      default:
        break;
    }
    if (transaction != null) {
      addressSender.transactionPending.insert(0, transaction);
      _walletController.update([EnumUpdateWallet.CURRENCY_ACTIVE]);
      await _repo.saveDataToLocal(
          key: addressSender.keyOfTransactionPending,
          data: TransactionPenddingData(data: addressSender.transactionPending)
              .toJson());
    }
  }

  Future<void> createApproveTransaction() async {
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
            tokenContract: coinModelFrom.contractAddress,
            addressOwner: addressSender.address,
            addressSender: EthereumProvider.contractSwapAbi,
            privateKey: privateKey,
            amount: coinModelFrom.value * BigInt.from(2));
        break;
      case BlockChainModel.binanceSmart:
        await _repo.createApproveTransactionBinanceSmart(
            tokenContract: coinModelFrom.contractAddress,
            addressOwner: addressSender.address,
            privateKey: privateKey,
            addressSender: BinanceSmartProvider.contractSwapAbi,
            amount: coinModelFrom.value * BigInt.from(2));
        break;
      case BlockChainModel.polygon:
        await _repo.createApproveTransactionPolygon(
            tokenContract: coinModelFrom.contractAddress,
            addressOwner: addressSender.address,
            privateKey: privateKey,
            addressSender: PolygonProvider.contractSwapAbi,
            amount: coinModelFrom.value * BigInt.from(2));
        break;
      case BlockChainModel.kardiaChain:
        await _repo.createApproveTransactionKardiaChain(
            tokenContract: coinModelFrom.contractAddress,
            addressOwner: addressSender.address,
            addressSender: KardiaChainProvider.contractSwapAbi,
            privateKey: privateKey,
            amount: coinModelFrom.value * BigInt.from(2));
        break;
      default:
        break;
    }
  }

  Future<BigInt> checkAllowance() async {
    switch (addressSender.blockChainId) {
      case BlockChainModel.ethereum:
        return await _repo.getAllowanceEthereum(
            addressOwner: addressSender.address,
            addressSender: EthereumProvider.contractSwapAbi,
            addressContract: coinModelFrom.contractAddress);
      case BlockChainModel.binanceSmart:
        return await _repo.getAllowanceBinance(
            addressOwner: addressSender.address,
            addressSender: BinanceSmartProvider.contractSwapAbi,
            addressContract: coinModelFrom.contractAddress);
      case BlockChainModel.polygon:
        return await _repo.getAllowancePolygon(
            addressOwner: addressSender.address,
            addressSender: PolygonProvider.contractSwapAbi,
            addressContract: coinModelFrom.contractAddress);
      case BlockChainModel.kardiaChain:
        return await _repo.getAllowanceKardiaChain(
            addressOwner: addressSender.address,
            addressSender: KardiaChainProvider.contractSwapAbi,
            addressContract: coinModelFrom.contractAddress);

      default:
        return BigInt.from(0);
    }
  }

  BigInt get getBigIntAmountCoinFrom =>
      coinModelFrom.stringDoubleToBigInt(amountStringIn);

  bool get isAvalibleValueInput =>
      coinModelFrom.isValueAvalible(amountStringIn);

  bool get isLoadRate =>
      coinModelFrom.id.isNotEmpty && coinModelTo.id.isNotEmpty;
}
