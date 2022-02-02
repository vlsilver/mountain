import 'dart:io';
import 'dart:math';

import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/providers/crypto_provider/binance_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/kardiachain_provider.dart';
import 'package:base_source/app/data/providers/repository.dart';
import 'package:get/get.dart';

class CreateTokenRepository extends Repository {
  Future<void> createNewToken({
    required String name,
    required String symbol,
    required BigInt totalSuply,
    required BigInt gasLimit,
    required BigInt gasPrice,
    required AddressModel addressModel,
  }) async {
    var privateKey = '';
    if (addressModel.privatekey.isNotEmpty) {
      privateKey = addressModel.privatekey;
    } else {
      privateKey = await getPrivateKey(
          derivationPath: addressModel.derivationPath,
          coinType: addressModel.coinType);
    }
    if (addressModel.blockChainId == BlockChainModel.binanceSmart) {
      final transactionHash = await binanceSmart.createNewTokenBEP20(
        name: name,
        symbol: symbol,
        addressContract: BinanceSmartProvider.contractCreateTokenAbi,
        addressSender: addressModel.address,
        totalSuply: totalSuply,
        privateKey: privateKey,
        gasLimit: gasLimit,
        gasPrice: gasPrice,
      );
      await handleCheckTransactionSuccessBinanceSmart(
        transactionHash,
        'failure_create_token_detail'.tr,
      );
    } else if (addressModel.blockChainId == BlockChainModel.kardiaChain) {
      final transactionHash = await kardiaChain.createNewTokenKRC20(
        name: name,
        symbol: symbol,
        addressContract: KardiaChainProvider.contractCreateTokenAbi,
        addressSender: addressModel.address,
        totalSuply: totalSuply,
        privateKey: privateKey,
        gasLimit: gasLimit,
        gasPrice: gasPrice,
      );
      await handleCheckTransactionSuccessKardiaChain(
        transactionHash,
        'failure_create_token_detail'.tr,
      );
    } else {
      throw Exception('Not support BlockChain');
    }
  }

  Future<double> calculatorFeeToCreateToken({
    required String name,
    required String symbol,
    required BigInt totalSuply,
    required AddressModel addressModel,
  }) async {
    var gasLimit = BigInt.from(0);
    var gasPrice = BigInt.from(0);
    if (addressModel.blockChainId == BlockChainModel.binanceSmart) {
      gasLimit = await binanceSmart.getGasLimitToCreateTokenBEP20(
        name: name,
        symbol: symbol,
        addressContract: BinanceSmartProvider.contractCreateTokenAbi,
        addressSender: addressModel.address,
        totalSuply: totalSuply,
      );
      gasPrice = await binanceSmart.getGasPrice();
    } else if (addressModel.blockChainId == BlockChainModel.kardiaChain) {
      gasLimit = await kardiaChain.getGasLimitToCreateTokenKRC20(
        name: name,
        symbol: symbol,
        addressContract: KardiaChainProvider.contractCreateTokenAbi,
        addressSender: addressModel.address,
        totalSuply: totalSuply,
      );
      gasPrice = await kardiaChain.getGasPrice();
    } else {
      throw Exception('Not support BlockChain');
    }
    Crypto().gasLimit = BigInt.from(gasLimit.toDouble() * 1.05);
    Crypto().gasPrice = gasPrice;
    final fee =
        (Crypto().gasLimit * Crypto().gasPrice).toDouble() / pow(10, 18);
    return fee;
  }

  Future<String> callCreateToken({
    required String name,
    required String symbol,
    required BigInt totalSuply,
    required AddressModel addressModel,
  }) async {
    if (addressModel.blockChainId == BlockChainModel.binanceSmart) {
      return await binanceSmart.callCreateTokenBEP20(
        name: name,
        symbol: symbol,
        addressContract: BinanceSmartProvider.contractCreateTokenAbi,
        addressSender: addressModel.address,
        totalSuply: totalSuply,
      );
    } else if (addressModel.blockChainId == BlockChainModel.kardiaChain) {
      return await kardiaChain.callCreateTokenKRC20(
        name: name,
        symbol: symbol,
        addressContract: KardiaChainProvider.contractCreateTokenAbi,
        addressSender: addressModel.address,
        totalSuply: totalSuply,
      );
    } else {
      throw Exception('Not support BlockChain');
    }
  }

  Future<String> createTokenMoonApi(
      {required CoinModel coinModel,
      required File file,
      required String addressCreator}) async {
    return await moonApi.createToken(
      coinModel: coinModel,
      file: file,
      addressCreator: addressCreator,
    );
  }

  Future<BigInt> getBalanceToken({
    required CoinModel coin,
    required String address,
    required String blockChainId,
  }) async {
    if (blockChainId == BlockChainModel.binanceSmart) {
      final balance = await binanceSmart.getBalanceOfBEP20(
          address: address, contractAddress: coin.contractAddress);
      return balance;
    } else if (blockChainId == BlockChainModel.kardiaChain) {
      final balance = await kardiaChain.getBalanceOfKRC20(
          address: address, contractAddress: coin.contractAddress);
      return balance;
    } else {
      throw 'Not support BlockChain';
    }
  }
}
