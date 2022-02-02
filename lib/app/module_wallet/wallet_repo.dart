import 'package:base_source/app/core/values/key_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/wallet_model.dart';
import 'package:base_source/app/data/models/raw_data.dart/blockchains.dart';
import 'package:base_source/app/data/models/raw_data.dart/coins.dart';
import 'package:base_source/app/data/providers/repository.dart';

class WalletTrustRepository extends Repository {
  Future<TotalWalletModel> getTotalWallet() async {
    final result = await database.readSecure(TotalWalletModel.key);
    final totalWallet = result != null
        ? TotalWalletModel.fromJson(result)
        : TotalWalletModel.empty();
    return totalWallet;
  }

  Future<WalletModel> getWallet({required String key}) async {
    final result = await database.readSecure(key);
    final wallet =
        result != null ? WalletModel.fromJson(result) : WalletModel.empty();
    return wallet;
  }

  Future<WalletModel> createNewWallet({
    required String password,
    required bool biometricState,
    required int indexWallet,
  }) async {
    try {
      var isAuthen = true;
      if (biometricState) {
        isAuthen = await authenWithBiometric();
      }
      if (isAuthen) {
        final mnemonic = await trustWallet.createNewWallet();
        final key = WalletModel.keyFromIndex(index: indexWallet);
        final totalWalletModel = TotalWalletModel(
          active: indexWallet,
          length: indexWallet + 1,
        );
        final wallet = WalletModel.init(
          key: key,
          mnemonic: mnemonic,
          password: password,
          index: indexWallet,
        );
        final blockChains = await initBlockChains();
        wallet.blockChains = blockChains;
        await database.write(AppKeys.ENABLE_BIOMETRIC, biometricState);
        await saveDataToKeyChain(
            key: TotalWalletModel.key, data: totalWalletModel.toJson());
        await saveDataToKeyChain(key: wallet.key, data: wallet.toJson());
        return wallet;
      } else {
        throw Exception();
      }
    } catch (exp) {
      rethrow;
    }
  }

  Future<bool> importWallet({
    required String mnemonic,
    required String password,
    required bool biometricState,
    required int indexWallet,
    required WalletModel wallet,
  }) async {
    var importSuccess = await initWallet(mnemonic: mnemonic);

    return importSuccess;
  }

  Future<List<BlockChainModel>> initBlockChains() async {
    var blockChains = <BlockChainModel>[];
    var index = 0;
    final blockChainsSupport = await getBlockChainSupport();
    for (var jsonData in blockChainsSupport) {
      final blockChain = BlockChainModel.init(jsonData, index);
      final addressModel = AddressModel.init();
      blockChain.addresss.add(addressModel);
      blockChains.add(blockChain);
      index++;
    }
    return blockChains;
  }

  Future<bool> initWallet({
    required String mnemonic,
  }) async {
    final result = await trustWallet.importWallet(mnemonic: mnemonic);
    return result;
  }

  Future<void> deletedAllWallet() async {
    await database.deleteSecureAll();
  }

  Future<String> getAddressOfAdressModel({
    required AddressModel addressModel,
  }) async {
    if (addressModel.privatekey.isNotEmpty) {
      return await getAddressFromPrivakey(addressModel: addressModel);
    } else {
      return await getAddressFromDerivationPath(addressModel: addressModel);
    }
  }

  Future<String> getAddressFromDerivationPath({
    required AddressModel addressModel,
  }) async {
    final address = await trustWallet.getAddressFromderivationPath(
      coinType: addressModel.coinType,
      derivationPath: addressModel.derivationPath,
    );
    return address;
  }

  Future<String> getAddressFromPrivakey({
    required AddressModel addressModel,
  }) async {
    final result = await trustWallet.getAddressFromPrivakey(
      privakey: addressModel.privatekey,
      coinType: addressModel.coinType,
    );
    return result;
  }

  Future<List<dynamic>> getAddressFromSeedPhrase({
    required String seedphrase,
  }) async {
    final result =
        await trustWallet.getAddressFromSeedphrase(seedphrase: seedphrase);
    return result;
  }

  void initBlockChainProvider(BlockChainModel blockChain) async {
    switch (blockChain.id) {
      case BlockChainModel.bitcoin:
        bitcoin.initData(blockChain);
        break;
      case BlockChainModel.ethereum:
        ethereum.initData(blockChain);
        break;
      case BlockChainModel.binanceSmart:
        binanceSmart.initData(blockChain);
        break;
      case BlockChainModel.polygon:
        polygon.initData(blockChain);
        break;
      case BlockChainModel.kardiaChain:
        kardiaChain.initData(blockChain);
        break;
      case BlockChainModel.tron:
        tron.initData(blockChain);
        break;
      case BlockChainModel.stellar:
        stellar.initData(blockChain);
        break;
      case BlockChainModel.piTestnet:
        piTestnet.initData(blockChain);
        break;
      default:
    }
  }

  Future<List<dynamic>> getBlockChainSupport() async {
    try {
      final blockChains = await moonApi.getBlockChainSupport();
      return blockChains;
    } catch (exp) {
      return BLOCKCHAIN_SUPPORT;
    }
  }

  Future<List<dynamic>> getCoinsSupport() async {
    try {
      final coins = await moonApi.getCoinsSupport();
      return coins;
    } catch (exp) {
      return [
        ...COINS_BITCOIN,
        ...COINS_ETHEREUM,
        ...COINS_BINANCE_SMARTCHAIN,
        ...COINS_POLYGON,
        ...COINS_KARDIACHAIN,
        ...COINS_TRON,
        ...COINS_STELLAR,
        ...COINS_PI,
      ];
    }
  }
}
