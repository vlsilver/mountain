import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/providers/repository.dart';

class AddTokenRepository extends Repository {
  Future<CoinModel> addNewToken({
    required String blockChainId,
    required String addressContract,
  }) async {
    switch (blockChainId) {
      case BlockChainModel.ethereum:
        final coinModel = await ethereum.getTokenModelERC20Info(
            addressContract: addressContract);
        final data = await moonApi.findToken(
            blockChainId: blockChainId,
            symbol: coinModel.symbol,
            addressContract: addressContract);
        return coinModel.copyWith(
          id: data[0],
          image: data[1].isNotEmpty
              ? data[1]
              : 'https://api.moonwallet.net/uploads/images/store/ethereum_default.png',
          blockchainId: blockChainId,
        );
      case BlockChainModel.binanceSmart:
        final coinModel = await binanceSmart.getTokenModelBEP20Info(
            addressContract: addressContract);
        final data = await moonApi.findToken(
            blockChainId: blockChainId,
            symbol: coinModel.symbol,
            addressContract: addressContract);
        return coinModel.copyWith(
          id: data[0],
          image: data[1].isNotEmpty
              ? data[1]
              : 'https://api.moonwallet.net/uploads/images/store/binance-smart-chain_default.png',
          blockchainId: blockChainId,
        );

      case BlockChainModel.polygon:
        final coinModel = await polygon.getTokenModelPERC20Info(
            addressContract: addressContract);
        final data = await moonApi.findToken(
            blockChainId: blockChainId,
            symbol: coinModel.symbol,
            addressContract: addressContract);
        return coinModel.copyWith(
          id: data[0],
          image: data[1].isNotEmpty
              ? data[1]
              : 'https://api.moonwallet.net/uploads/images/store/polygon_default.png',
          blockchainId: blockChainId,
        );
      case BlockChainModel.kardiaChain:
        final coinModel = await kardiaChain.getTokenModelKRC20Info(
            addressContract: addressContract);
        final data = await moonApi.findToken(
            blockChainId: blockChainId,
            symbol: coinModel.symbol,
            addressContract: addressContract);
        return coinModel.copyWith(
          id: data[0],
          image: data[1].isNotEmpty
              ? data[1]
              : 'https://api.moonwallet.net/uploads/images/store/kardiachain_default.png',
          blockchainId: blockChainId,
        );

      default:
        throw Exception('Add Token Failure, Not support BlockChain');
    }
  }

  Future<BigInt> getBalanceOfToken(
      {required String address, required CoinModel coinModel}) async {
    switch (coinModel.blockchainId) {
      case BlockChainModel.ethereum:
        final balance = await ethereum.getBalanceOfERC20(
            address: address, contractAddress: coinModel.contractAddress);
        return balance;
      case BlockChainModel.binanceSmart:
        final balance = await binanceSmart.getBalanceOfBEP20(
            address: address, contractAddress: coinModel.contractAddress);
        return balance;
      case BlockChainModel.polygon:
        final balance = await polygon.getBalanceOfPERC20(
            address: address, contractAddress: coinModel.contractAddress);
        return balance;
      case BlockChainModel.kardiaChain:
        final balance = await kardiaChain.getBalanceOfKRC20(
            address: address, contractAddress: coinModel.contractAddress);
        return balance;
      default:
        return BigInt.from(0);
    }
  }
}
