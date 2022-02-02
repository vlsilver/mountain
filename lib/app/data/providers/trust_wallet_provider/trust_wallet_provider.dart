import 'package:base_source/app/data/providers/crypto_provider/tron_provider.dart';
import 'package:trust_wallet_core_plugin/trust_wallet_core_plugin.dart';

class TrustWalletProvider {
  late TrustWalletCorePlugin _trustWallet;
  TrustWalletProvider() {
    _trustWallet = TrustWalletCorePlugin();
  }

  Future<String> createNewWallet() async {
    final data = await _trustWallet.createMultiCoinWallet();
    return data;
  }

  Future<bool> importWallet({
    required String mnemonic,
  }) async {
    final _isValid =
        await _trustWallet.importMultiCoinWallet(mnemonic: mnemonic);
    return _isValid;
  }

  Future<String> getAddressFromderivationPath({
    required int coinType,
    required String derivationPath,
  }) async {
    final address = await _trustWallet.getAddressFromDerivationPath(
      coinType,
      derivationPath,
    );
    return address;
  }

  Future<String> getAddressFromPrivakey({
    required String privakey,
    required int coinType,
  }) async {
    final address =
        await _trustWallet.getAddressFromPrivakey(privakey, coinType);
    return address;
  }

  Future<List<dynamic>> getAddressFromSeedphrase({
    required String seedphrase,
  }) async {
    final data = await _trustWallet.getAddressFromSeedphrase(seedphrase);
    return data;
  }

  Future<String> getPrivateKey({
    required String derivationPath,
    required int coinType,
  }) async {
    final privateKey =
        await _trustWallet.getPrivateKey(derivationPath, coinType);
    return privateKey;
  }

  Future<bool> checkValidAddress({
    required String address,
    required int coinType,
  }) async {
    final isValid =
        await _trustWallet.checkValidAddressOfCoinType(address, coinType);
    return isValid;
  }

  Future<String> createTransactionBitcoin({
    required String toAddress,
    required String fromAddress,
    required BigInt amount,
    required int byteFee,
    required String privateKey,
    required String derivationPath,
    required List<int> amountUtxos,
    required List<int> indexUtxos,
    required List<String> hashs,
  }) async {
    final transaction = await _trustWallet.createTransactionBitcoin(
        toAddress: toAddress,
        fromAddress: fromAddress,
        amount: amount,
        amountUtxos: amountUtxos,
        derivationPath: derivationPath,
        indexUtxos: indexUtxos,
        byteFee: byteFee,
        hashs: hashs,
        privateKey: privateKey);
    return transaction;
  }

  Future<String> createTransactionBinanceSmart({
    required String toAddress,
    required String amountHexString,
    required String nonceHexString,
    required String gasPriceHexString,
    required String gasLimitHexString,
    required String chainIdHexString,
    required String privateKey,
    required String derivationPath,
  }) async {
    final transaction = await _trustWallet.createTransactionBinanceSmart(
        toAddress: toAddress,
        amountHexString: amountHexString,
        gasPriceHexString: gasPriceHexString,
        gasLimitHexString: gasLimitHexString,
        chainIdHexString: chainIdHexString,
        nonceHexString: nonceHexString,
        derivationPath: derivationPath,
        privateKey: privateKey);
    return transaction;
  }

  Future<String> createTransactionPolygon({
    required String toAddress,
    required String amountHexString,
    required String nonceHexString,
    required String gasPriceHexString,
    required String gasLimitHexString,
    required String chainIdHexString,
    required String privateKey,
    required String derivationPath,
  }) async {
    final transaction = await _trustWallet.createTransactionPolygon(
        toAddress: toAddress,
        amountHexString: amountHexString,
        gasPriceHexString: gasPriceHexString,
        gasLimitHexString: gasLimitHexString,
        chainIdHexString: chainIdHexString,
        nonceHexString: nonceHexString,
        derivationPath: derivationPath,
        privateKey: privateKey);
    return transaction;
  }

  Future<String> createTransactionEthereum({
    required String toAddress,
    required String amountHexString,
    required String nonceHexString,
    required String gasPriceHexString,
    required String gasLimitHexString,
    required String chainIdHexString,
    required String privateKey,
    required String derivationPath,
  }) async {
    final transaction = await _trustWallet.createTransactionEthereum(
        toAddress: toAddress,
        amountHexString: amountHexString,
        gasPriceHexString: gasPriceHexString,
        gasLimitHexString: gasLimitHexString,
        chainIdHexString: chainIdHexString,
        nonceHexString: nonceHexString,
        derivationPath: derivationPath,
        privateKey: privateKey);
    return transaction;
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
    final transaction = await _trustWallet.createTransactionStellar(
      fromAddress: fromAddress,
      toAddress: toAddress,
      sequence: sequence,
      fee: fee,
      amount: amount,
      derivationPath: derivationPath,
      privateKey: privateKey,
    );
    return transaction;
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
    final transaction = await _trustWallet.createTransactionPiTestnet(
      fromAddress: fromAddress,
      toAddress: toAddress,
      sequence: sequence,
      fee: fee,
      amount: amount,
      derivationPath: derivationPath,
      privateKey: privateKey,
    );
    return transaction;
  }

  Future<String> createTransactionOfTron({
    required String contractAddress,
    required String fromAddress,
    required String toAddress,
    required int fee,
    required BigInt amount,
    required String derivationPath,
    required String privateKey,
    required BlockHeaderTron blockHeaderTron,
  }) async {
    final transaction = await _trustWallet.createTransactionOfTron(
      contractAddress: contractAddress,
      fromAddress: fromAddress,
      toAddress: toAddress,
      fee: fee,
      amount: amount,
      derivationPath: derivationPath,
      privateKey: privateKey,
      number: blockHeaderTron.number,
      version: blockHeaderTron.version,
      timestamp: blockHeaderTron.timestamp,
      txTrieRoot: blockHeaderTron.txTrieRoot,
      parentHash: blockHeaderTron.parentHash,
      witnessAddress: blockHeaderTron.witnessAddress,
    );
    return transaction;
  }
}
