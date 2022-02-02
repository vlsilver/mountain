import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:flutter/material.dart';

class GlobalAvatarCoinWidget extends StatelessWidget {
  const GlobalAvatarCoinWidget({
    Key? key,
    required this.coinModel,
    this.height,
    this.width,
  }) : super(key: key);

  final CoinModel coinModel;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return coinModel.image.isNotEmpty
        ? Center(
            child: Image.network(
              coinModel.image,
              height: height ?? 32.0,
              width: width ?? 32.0,
              errorBuilder: (_, __, ___) {
                return Image.asset(
                  BlockChainModel.getImageDefault(coinModel.blockchainId),
                  fit: BoxFit.contain,
                  height: height ?? 32.0,
                  width: width ?? 32.0,
                );
              },
            ),
          )
        : Image.asset(
            BlockChainModel.getImageDefault(coinModel.blockchainId),
            fit: BoxFit.contain,
            height: height ?? 32.0,
            width: width ?? 32.0,
          );
  }
}
