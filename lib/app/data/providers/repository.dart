import 'dart:math';

import 'package:base_source/app/core/values/key_values.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/providers/crypto_provider/binance_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/bitcoin_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/kardiachain_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/pi_testnet_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/polygon_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/stellar_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/tron_provider.dart';
import 'package:base_source/app/data/providers/device_provider/device_provider.dart';
import 'package:get/get.dart';

import 'crypto_provider/crypto_provider.dart';
import 'crypto_provider/ethereum_provider.dart';
import 'crypto_provider/moon_token_provider.dart';
import 'db_provider/db_provider.dart';
import 'trust_wallet_provider/trust_wallet_provider.dart';

abstract class Repository {
  Repository() {
    _trustWallet = TrustWalletProvider();
    _device = DeviceProvider();
    _cryptoApi = CryptoApiProvider();
    _moon = MoonTokenApiProvider();
    _database = Get.find<DatabaseProvider>();
    _ethereum = Get.find<EthereumProvider>();
    _bitcoin = Get.find<BitcoinProvider>();
    _binanceSmart = Get.find<BinanceSmartProvider>();
    _kardiaChain = Get.find<KardiaChainProvider>();
    _stellar = Get.find<StellarChainProvider>();
    _piTestnet = Get.find<PiTestNetProvider>();
    _tron = Get.find<TronProvider>();
    _polygon = Get.find<PolygonProvider>();
  }
  late final TrustWalletProvider _trustWallet;
  late final DatabaseProvider _database;
  late final DeviceProvider _device;
  late final EthereumProvider _ethereum;
  late final BinanceSmartProvider _binanceSmart;
  late final PolygonProvider _polygon;
  late final BitcoinProvider _bitcoin;
  late final KardiaChainProvider _kardiaChain;
  late final CryptoApiProvider _cryptoApi;
  late final StellarChainProvider _stellar;
  late final PiTestNetProvider _piTestnet;
  late final TronProvider _tron;
  late final MoonTokenApiProvider _moon;

  TrustWalletProvider get trustWallet => _trustWallet;
  DatabaseProvider get database => _database;
  DeviceProvider get device => _device;
  EthereumProvider get ethereum => _ethereum;
  BinanceSmartProvider get binanceSmart => _binanceSmart;
  PolygonProvider get polygon => _polygon;
  BitcoinProvider get bitcoin => _bitcoin;
  CryptoApiProvider get cryptoApi => _cryptoApi;
  KardiaChainProvider get kardiaChain => _kardiaChain;
  StellarChainProvider get stellar => _stellar;
  PiTestNetProvider get piTestnet => _piTestnet;
  TronProvider get tron => _tron;
  MoonTokenApiProvider get moonApi => _moon;

  Future<bool> authenWithBiometric() async {
    return await device.authenWithBiometrics();
  }

  Future<void> saveAcceptBiometric({required bool acceptBiometric}) {
    return database.write(AppKeys.ENABLE_BIOMETRIC, acceptBiometric);
  }

  Future<void> saveDataToKeyChain(
      {required String key, required String data}) async {
    await database.writeSecure(key, data);
  }

  Future<void> saveDataToLocal(
      {required String key, required String data}) async {
    await database.write(key, data);
  }

  String? getDataFromLocal({required String key}) {
    return database.read(key);
  }

  Future<String> getPrivateKey({
    required String derivationPath,
    required int coinType,
  }) async {
    final privateKey = await trustWallet.getPrivateKey(
        derivationPath: derivationPath, coinType: coinType);
    return privateKey;
  }

  Future<bool> checkValidAddress({
    required String address,
    required int coinType,
  }) async {
    final isValid = await trustWallet.checkValidAddress(
      address: address,
      coinType: coinType,
    );
    return isValid;
  }

  Future<BigInt> getAllowanceBinance(
      {required String addressOwner,
      required String addressSender,
      required String addressContract}) async {
    final value = await binanceSmart.getAllowance(
        addressOwner: addressOwner,
        addressSender: addressSender,
        contractAddress: addressContract);
    return value;
  }

  Future<BigInt> getAllowanceEthereum(
      {required String addressOwner,
      required String addressSender,
      required String addressContract}) async {
    final value = await ethereum.getAllowance(
        addressOwner: addressOwner,
        addressSender: addressSender,
        contractAddress: addressContract);
    return value;
  }

  Future<BigInt> getAllowanceKardiaChain(
      {required String addressOwner,
      required String addressSender,
      required String addressContract}) async {
    final value = await kardiaChain.getAllowance(
        addressOwner: addressOwner,
        addressSender: addressSender,
        contractAddress: addressContract);
    return value;
  }

  Future<BigInt> getAllowancePolygon(
      {required String addressOwner,
      required String addressSender,
      required String addressContract}) async {
    final value = await polygon.getAllowance(
        addressOwner: addressOwner,
        addressSender: addressSender,
        contractAddress: addressContract);
    return value;
  }

  Future<double> calculatorFeeApproveKardiaChain({
    required String tokenContract,
    required String addressOwner,
    required String addressSender,
    required BigInt amount,
  }) async {
    final gasPrice = await kardiaChain.getGasPrice();
    Crypto().gasPrice = gasPrice;
    final gasLimit = await kardiaChain.getGasLimitApprove(
        addressContract: tokenContract,
        addrsassSender: addressSender,
        addressOwner: addressOwner,
        amount: amount);
    Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeApprovePolygon({
    required String tokenContract,
    required String addressOwner,
    required String addressSender,
    required BigInt amount,
  }) async {
    final gasPrice = await polygon.getGasPrice();
    Crypto().gasPrice = gasPrice;
    final gasLimit = await polygon.getGasLimitApprove(
        addressContract: tokenContract,
        addrsassSender: addressSender,
        addressOwner: addressOwner,
        amount: amount);
    Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeApproveBinanceSmart({
    required String tokenContract,
    required String addressOwner,
    required String addressSender,
    required BigInt amount,
  }) async {
    final gasPrice = await binanceSmart.getGasPrice();
    Crypto().gasPrice = gasPrice;
    final gasLimit = await binanceSmart.getGasLimitApprove(
        addressContract: tokenContract,
        addrsassSender: addressSender,
        addressOwner: addressOwner,
        amount: amount);
    Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<double> calculatorFeeApproveEthereum({
    required String tokenContract,
    required String addressOwner,
    required String addressSender,
    required BigInt amount,
  }) async {
    final gasPrice = await ethereum.getGasPrice();
    Crypto().gasPrice = gasPrice;
    final gasLimit = await ethereum.getGasLimitApprove(
        addressContract: tokenContract,
        addrsassSender: addressSender,
        addressOwner: addressOwner,
        amount: amount);
    Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    return (Crypto().gasPrice * Crypto().gasLimit).toDouble() / pow(10, 18);
  }

  Future<void> createApproveTransactionEthereum({
    required String tokenContract,
    required String addressOwner,
    required String addressSender,
    required String privateKey,
    required BigInt amount,
  }) async {
    var transactionHash = '';
    transactionHash = await ethereum.sendTransactionApprove(
        addressContract: tokenContract,
        ownerAddress: addressOwner,
        senderAddress: addressSender,
        privateKey: privateKey,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice);
    if (transactionHash.isNotEmpty) {
      while (true) {
        try {
          final data =
              await ethereum.getTransactionReceiptByHash(transactionHash);
          if (data != null && data['status'] == '0x1') {
            break;
          } else if (data != null && data['status'] == '0x0') {
            throw 'failure_approve_detail'.tr;
          } else {
            await Future.delayed(Duration(milliseconds: 500));
          }
        } catch (exp) {
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<void> createApproveTransactionBinanceSmart({
    required String tokenContract,
    required String addressOwner,
    required String addressSender,
    required String privateKey,
    required BigInt amount,
  }) async {
    var transactionHash = '';
    transactionHash = await binanceSmart.sendTransactionApprove(
        addressContract: tokenContract,
        ownerAddress: addressOwner,
        senderAddress: addressSender,
        privateKey: privateKey,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice);
    if (transactionHash.isNotEmpty) {
      while (true) {
        try {
          final data =
              await binanceSmart.getTransactionReceiptByHash(transactionHash);
          if (data != null && data['status'] == '0x1') {
            break;
          } else if (data != null && data['status'] == '0x0') {
            throw 'failure_approve_detail'.tr;
          } else {
            await Future.delayed(Duration(milliseconds: 500));
          }
        } catch (exp) {
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<void> createApproveTransactionKardiaChain({
    required String tokenContract,
    required String addressOwner,
    required String addressSender,
    required String privateKey,
    required BigInt amount,
  }) async {
    var transactionHash = '';
    transactionHash = await kardiaChain.sendTransactionApprove(
        addressContract: tokenContract,
        ownerAddress: addressOwner,
        senderAddress: addressSender,
        privateKey: privateKey,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice);
    if (transactionHash.isNotEmpty) {
      while (true) {
        try {
          final data =
              await kardiaChain.getTransactionReceiptByHash(transactionHash);
          if (data != null && data['status'] == 1) {
            break;
          } else if (data != null && data['status'] == 0) {
            throw 'failure_approve_detail'.tr;
          } else {
            await Future.delayed(Duration(milliseconds: 500));
          }
        } catch (exp) {
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<void> createApproveTransactionPolygon({
    required String tokenContract,
    required String addressOwner,
    required String addressSender,
    required String privateKey,
    required BigInt amount,
  }) async {
    var transactionHash = '';
    transactionHash = await polygon.sendTransactionApprove(
        addressContract: tokenContract,
        ownerAddress: addressOwner,
        senderAddress: addressSender,
        privateKey: privateKey,
        amount: amount,
        gasLimit: Crypto().gasLimit,
        gasPrice: Crypto().gasPrice);
    if (transactionHash.isNotEmpty) {
      while (true) {
        try {
          final data =
              await polygon.getTransactionReceiptByHash(transactionHash);
          if (data != null && data['status'] == '0x1') {
            break;
          } else if (data != null && data['status'] == '0x0') {
            throw 'failure_approve_detail'.tr;
          } else {
            await Future.delayed(Duration(milliseconds: 500));
          }
        } catch (exp) {
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<void> handleCheckTransactionSuccessBinanceSmart(
    String transactionHash,
    String title,
  ) async {
    if (transactionHash.isNotEmpty) {
      var status = -1;
      while (true) {
        try {
          final data =
              await binanceSmart.getTransactionReceiptByHash(transactionHash);
          if (data != null && data['status'] == '0x1') {
            break;
          } else if (data != null && data['status'] == '0x0') {
            status = 0;
            throw title;
          } else {
            await Future.delayed(const Duration(milliseconds: 500));
          }
        } catch (exp) {
          if (status == 0) {
            throw title;
          } else {
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
      }
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }

  Future<void> handleCheckTransactionSuccessKardiaChain(
    String transactionHash,
    String title,
  ) async {
    if (transactionHash.isNotEmpty) {
      var status = -1;
      while (true) {
        try {
          final data =
              await kardiaChain.getTransactionReceiptByHash(transactionHash);
          if (data != null && data['status'] == 1) {
            break;
          } else if (data != null && data['status'] == 0) {
            status = 0;
            throw title;
          } else {
            await Future.delayed(const Duration(milliseconds: 500));
          }
        } catch (exp) {
          if (status == 0) {
            throw title;
          } else {
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
      }
    } else {
      throw 'Send transaction failure. Please try again!';
    }
  }
}
