import 'dart:async';
import 'package:convert/convert.dart';
import 'package:flutter/services.dart';
import 'package:trust_wallet_core_plugin/base58/base58.dart';

class TrustWalletCorePlugin {
  static const MethodChannel _channel =
      const MethodChannel('trust_wallet_core_plugin');

  Future<String> createMultiCoinWallet({
    int strength = 128,
    // required String passphrase,
  }) async {
    final args = <String, dynamic>{
      'strength': strength,
      'passphrase': "",
    };
    // print('\n---------------createMultiCoinWallet-------------------');
    // print('args: $args');
    try {
      final mnemonic =
          await _channel.invokeMethod('createMultiCoinWallet', args);
      print('create new wallet: $mnemonic');
      return mnemonic;
    } catch (exp) {
      throw PlatformException(
        code: 'TrustWalletCoreError',
      );
    }
  }

  Future<bool> importMultiCoinWallet({
    required String mnemonic,
    // required String passphrase,
  }) async {
    final args = <String, dynamic>{
      'mnemonic': mnemonic,
      'passphrase': "",
    };
    // print('\n---------------importMultiCoinWallet-------------------');
    // print('args: $args');
    try {
      final _isValid =
          await _channel.invokeMethod('importMultiCoinWallet', args);
      // print('importMultiCoinWallet: $_isValid');
      return _isValid;
    } catch (exp) {
      throw PlatformException(
        code: 'TrustWalletCoreError',
      );
    }
  }

  Future<String> getAddressFromDerivationPath(
    int coinType,
    String derivationPath,
  ) async {
    final args = <String, dynamic>{
      'coinType': coinType,
      'derivationPath': derivationPath,
    };
    // print('\n---------------getAddressFromIndex-------------------');
    // print('args: $args');
    try {
      final _address = await _channel.invokeMethod('getAddressFromIndex', args);
      // print('getAddressFromIndex: $_address');
      return _address;
    } catch (exp) {
      throw PlatformException(
        code: 'TrustWalletCoreError',
      );
    }
  }

  Future<String> getAddressFromPrivakey(
    String privatekey,
    int coinType,
  ) async {
    final args = <String, dynamic>{
      'privatekey': privatekey,
      'coinType': coinType,
    };
    // print('\n---------------getAddressFromPrivakey-------------------');
    // print('args: $args');
    try {
      final address =
          await _channel.invokeMethod('getAddressFromPrivakey', args);
      // print('getAddressFromPrivakey: $address');
      return address;
    } catch (exp) {
      throw PlatformException(
        code: 'TrustWalletCoreError',
      );
    }
  }

  Future<List<dynamic>> getAddressFromSeedphrase(
    String seedphrase,
  ) async {
    final args = <String, dynamic>{
      'seedphrase': seedphrase,
    };
    print('\n---------------getAddressFromSeedphrase-------------------');
    print('args: $args');
    try {
      final data =
          await _channel.invokeMethod('getAddressFromSeedphrase', args);
      print('getAddressFromSeedphrase: $data');
      return data as List<dynamic>;
    } catch (exp) {
      throw PlatformException(
        code: 'TrustWalletCoreError',
      );
    }
  }

  Future<String> getPrivateKey(
    String derivationPath,
    int coinType,
  ) async {
    final args = <String, dynamic>{
      'derivationPath': derivationPath,
      'coinType': coinType,
    };
    // print('\n---------------getPrivatekey-------------------');
    // print('args: $args');
    try {
      final privateKey = await _channel.invokeMethod('getPrivateKey', args);
      return privateKey;
    } catch (exp) {
      throw PlatformException(
        code: 'TrustWalletCoreError',
      );
    }
  }

  Future<bool> checkValidAddressOfCoinType(
    String address,
    int coinType,
  ) async {
    final args = <String, dynamic>{
      'address': address,
      'coinType': coinType,
    };
    print('\n---------------checkValidAddressOfCoinType-------------------');
    print('args: $args');
    try {
      final isValid =
          await _channel.invokeMethod('checkValidAddressOfCoinType', args);
      print('checkValidAddressOfCoinType: $isValid');
      return isValid;
    } catch (exp) {
      throw PlatformException(
        code: 'TrustWalletCoreError',
      );
    }
  }

  Future<String> createTransactionBitcoin({
    required String toAddress,
    required String fromAddress,
    required BigInt amount,
    required String derivationPath,
    required int byteFee,
    required String privateKey,
    required List<int> amountUtxos,
    required List<int> indexUtxos,
    required List<String> hashs,
  }) async {
    final args = <String, dynamic>{
      'toAddress': toAddress,
      'fromAddress': fromAddress,
      'hashs': hashs,
      'indexUtxos': indexUtxos,
      'derivationPath': derivationPath,
      'byteFee': byteFee,
      'amount': amount.toRadixString(10),
      'amountUtxos': amountUtxos,
      'secretKey': privateKey,
    };

    try {
      print('\n---------------createTransactionBitcoin-------------------');
      print('args: $args');
      final transaction =
          await _channel.invokeMethod('createTransactionBitcoin', args);
      print('createTransactionBitcoin: $transaction');
      return transaction;
    } catch (exp) {
      throw 'Create transaction failure';
    }
  }

  Future<String> createTransactionEthereum({
    required String toAddress,
    required String amountHexString,
    required String nonceHexString,
    required String derivationPath,
    required String gasPriceHexString,
    required String gasLimitHexString,
    required String chainIdHexString,
    required String privateKey,
  }) async {
    final args = <String, dynamic>{
      'toAddress': toAddress,
      'nonce': nonceHexString,
      'derivationPath': derivationPath,
      'chainId': chainIdHexString,
      'amount': amountHexString,
      'gasPrice': gasPriceHexString,
      'gasLimit': gasLimitHexString,
      'secretKey': privateKey,
    };

    try {
      print('\n---------------createTransactionEthereum-------------------');
      print('args: $args');
      final transaction =
          await _channel.invokeMethod('createTransactionEthereum', args);
      print('createTransactionEthereum: $transaction');
      return transaction;
    } catch (exp) {
      throw 'Create transaction failure';
    }
  }

  Future<String> createTransactionBinanceSmart({
    required String toAddress,
    required String amountHexString,
    required String nonceHexString,
    required String derivationPath,
    required String gasPriceHexString,
    required String gasLimitHexString,
    required String chainIdHexString,
    required String privateKey,
  }) async {
    final args = <String, dynamic>{
      'toAddress': toAddress,
      'nonce': nonceHexString,
      'derivationPath': derivationPath,
      'chainId': chainIdHexString,
      'amount': amountHexString,
      'gasPrice': gasPriceHexString,
      'gasLimit': gasLimitHexString,
      'secretKey': privateKey,
    };

    try {
      print(
          '\n---------------createTransactionBinanceSmart-------------------');
      print('args: $args');
      final transaction =
          await _channel.invokeMethod('createTransactionBinanceSmart', args);
      print('createTransactionBinance: $transaction');
      return transaction;
    } catch (exp) {
      throw 'Create transaction failure';
    }
  }

  Future<String> createTransactionPolygon({
    required String toAddress,
    required String amountHexString,
    required String nonceHexString,
    required String derivationPath,
    required String gasPriceHexString,
    required String gasLimitHexString,
    required String chainIdHexString,
    required String privateKey,
  }) async {
    final args = <String, dynamic>{
      'toAddress': toAddress,
      'nonce': nonceHexString,
      'derivationPath': derivationPath,
      'chainId': chainIdHexString,
      'amount': amountHexString,
      'gasPrice': gasPriceHexString,
      'gasLimit': gasLimitHexString,
      'secretKey': privateKey,
    };

    try {
      print('\n---------------createTransactionPolygon-------------------');
      print('args: $args');
      final transaction =
          await _channel.invokeMethod('createTransactionPolygon', args);
      print('createTransactionPolygon: $transaction');
      return transaction;
    } catch (exp) {
      throw 'Create transaction failure';
    }
  }

  Future<String> createTransactionStellar({
    required String fromAddress,
    required String toAddress,
    required BigInt sequence,
    required int fee,
    required BigInt amount,
    required String derivationPath,
    required String privateKey,
  }) async {
    final args = <String, dynamic>{
      'fromAddress': fromAddress,
      'toAddress': toAddress,
      'sequence': sequence.toRadixString(10),
      'fee': fee,
      'amount': amount.toRadixString(10),
      'derivationPath': derivationPath,
      'secretKey': privateKey,
    };

    try {
      print('\n---------------createCreateAccountStellar-------------------');
      print('args: $args');
      final transaction =
          await _channel.invokeMethod('createTransactionStellar', args);
      print('createTransactionStellar: $transaction');
      return transaction;
    } catch (exp) {
      throw 'Create transaction failure';
    }
  }

  Future<String> createTransactionPiTestnet({
    required String fromAddress,
    required String toAddress,
    required BigInt sequence,
    required int fee,
    required BigInt amount,
    required String derivationPath,
    required String privateKey,
  }) async {
    final args = <String, dynamic>{
      'fromAddress': fromAddress,
      'toAddress': toAddress,
      'sequence': sequence.toRadixString(10),
      'fee': fee,
      'amount': amount.toRadixString(10),
      'derivationPath': derivationPath,
      'secretKey': privateKey,
    };

    try {
      print('\n---------------createTransactionPiTestnet-------------------');
      print('args: $args');
      final transaction =
          await _channel.invokeMethod('createTransactionPiTestnet', args);
      print('createTransactionPiTestnet: $transaction');
      return transaction;
    } catch (exp) {
      throw 'Create transaction failure';
    }
  }

  Future<String> createTransactionOfTron({
    required String contractAddress,
    required String fromAddress,
    required String toAddress,
    required int fee,
    required BigInt amount,
    required String derivationPath,
    required String privateKey,
    required String txTrieRoot,
    required String parentHash,
    required String witnessAddress,
    required int timestamp,
    required int number,
    required int version,
  }) async {
    try {
      print('\n---------------createTransactionTron-------------------');
      final args = <String, dynamic>{
        'contractAddress': contractAddress,
        'fromAddress': fromAddress,
        'toAddress': toAddress,
        'fee': fee,
        'amount': amount.toRadixString(10),
        'derivationPath': derivationPath,
        'secretKey': privateKey,
        'txTrieRoot': txTrieRoot,
        'parentHash': parentHash,
        'witnessAddress': witnessAddress,
        'timestamp': timestamp,
        'number': number,
        'version': version,
      };
      print('args: $args');

      if (contractAddress.isEmpty) {
        final transaction =
            await _channel.invokeMethod('createTransactionTron', args);

        print('createTransactionTron: $transaction');
        return transaction;
      } else {
        print('\n---------------createTransactionTronTRC20-------------------');
        final args = <String, dynamic>{
          'contractAddress': contractAddress,
          'fromAddress': fromAddress,
          'toAddress': toAddress,
          'fee': fee,
          'amount': bigIntToHexString(number: amount),
          'derivationPath': derivationPath,
          'secretKey': privateKey,
          'txTrieRoot': txTrieRoot,
          'parentHash': parentHash,
          'witnessAddress': witnessAddress,
          'timestamp': timestamp,
          'number': number,
          'version': version,
        };
        print('args: $args');
        final transaction =
            await _channel.invokeMethod('createTransactionTronTRC20', args);
        print('createTransactionTronTRC20: $transaction');
        return transaction;
      }
    } catch (exp) {
      throw 'Create transaction failure';
    }
  }

  static Future<String> base58Decode({
    required String addressString,
  }) async {
    try {
      // print('\n---------------base58Decode-------------------');
      final args = <String, dynamic>{
        'addressString': addressString,
      };
      // print('args: $args');
      final hexString = await _channel.invokeMethod('base58Decode', args);
      // print('base58Decode: $hexString');
      return hexString;
    } catch (exp) {
      throw PlatformException(
        code: 'TrustWalletCoreError',
      );
    }
  }

  static Future<String> base58Encode({
    required String addressHexString,
  }) async {
    try {
      // print('\n---------------base58Encode-------------------');
      final args = <String, dynamic>{
        'addressHexString': addressHexString,
      };
      // print('args: $args');
      final addressEncode = await _channel.invokeMethod('base58Encode', args);
      // print('base58Decode: $addressEncode');
      return addressEncode;
    } catch (exp) {
      throw PlatformException(
        code: 'TrustWalletCoreError',
      );
    }
  }

  static Map<String, dynamic>? decodeApprove({
    required String data,
  }) {
    try {
      // print('\n---------------decodeApprove-------------------');
      // final args = <String, dynamic>{
      //   'data': data,
      // };
      // print('args: $args');
      // final json = await _channel.invokeMethod('decodeApprove', args);

      if (data.length > 10 && data.substring(0, 10) == "0x095ea7b3") {
        final decodeJson = <String, dynamic>{
          "spender": '0x' + data.substring(10, 74).substring(24, 64),
          "value": BigInt.parse(data.substring(74, 138), radix: 16),
        };
        return decodeJson;
      } else {
        return null;
      }
    } catch (exp) {
      throw PlatformException(
        code: 'TrustWalletCoreError',
      );
    }
  }

  static Map<String, dynamic>? decodeTransfer({
    required String data,
  }) {
    try {
      // print('\n---------------decodeApprove-------------------');
      // final args = <String, dynamic>{
      //   'data': data,
      // };
      // print('args: $args');
      // final json = await _channel.invokeMethod('decodeApprove', args);

      if (data.length > 10 && data.substring(0, 10) == "0xa9059cbb") {
        final decodeJson = <String, dynamic>{
          "recipient": '0x' + data.substring(10, 74).substring(24, 64),
          "value": BigInt.parse(data.substring(74, 138), radix: 16),
        };
        return decodeJson;
      } else {
        return null;
      }
    } catch (exp) {
      throw PlatformException(
        code: 'TrustWalletCoreError',
      );
    }
  }

  static String base58StringToHexString({required String input}) {
    final bytesBase58 = Base58Decode(input);
    var hexString = hex.encoder.convert(bytesBase58);
    hexString = hexString.substring(2, hexString.length - 8);
    if (hexString.length % 2 != 0) {
      hexString = '0' + hexString;
    }
    return hexString;
  }

  static String base58StringToHexStringTronChain({required String input}) {
    final bytesBase58 = Base58Decode(input);
    var hexString = hex.encoder.convert(bytesBase58);
    hexString = hexString.substring(0);
    return hexString;
  }

  static String encodeHexStringToBase58StringTronChain(
      {required String input}) {
    final bytesBase58 = hex.decoder.convert(input + '391c9195');
    return Base58Encode(bytesBase58);
  }

  static String bigIntToHexString({required BigInt number, bool add = true}) {
    var hexString = number.toRadixString(16);
    if (!add) {
      return hexString;
    }
    if (hexString.length % 2 != 0) {
      hexString = '0' + hexString;
    }
    return hexString;
  }
}
