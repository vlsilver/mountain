import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'history_transaction_coin_controller.dart';

class CoinDetailPage extends GetView<HistoryTransactionCoinController> {
  const CoinDetailPage({
    Key? key,
    required this.coinModel,
  }) : super(key: key);

  final CoinModel coinModel;
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      height: Get.height * 0.85,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spaceNormal),
            AppBarWidget(
                title: 'global_coin_detail'.tr,
                onTap: () {
                  Get.back();
                }),
            const SizedBox(height: AppSizes.spaceNormal),
            Expanded(
              child: _DetailItemWidget(
                coinModel: coinModel,
              ),
            ),
            const SizedBox(height: AppSizes.spaceVeryLarge),
          ],
        ),
      ),
    );
  }
}

class _DetailItemWidget extends GetView<HistoryTransactionCoinController> {
  const _DetailItemWidget({
    Key? key,
    required this.coinModel,
  }) : super(key: key);

  final CoinModel coinModel;
  @override
  Widget build(BuildContext context) {
    return GlobalLayoutBuilderWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 24.0,
            backgroundColor: AppColorTheme.focus,
            child: GlobalAvatarCoinWidget(
              coinModel: coinModel,
              height: 40.0,
              width: 40.0,
            ),
          ),
          const SizedBox(height: AppSizes.spaceNormal),
          _InfomationWdiget(
            title: 'global_network'.tr,
            value: BlockChainModel.getNetwork(coinModel.blockchainId),
          ),
          const SizedBox(height: AppSizes.spaceVerySmall),
          _InfomationWdiget(
            title: 'global_type'.tr,
            value: coinModel.type,
          ),
          const SizedBox(height: AppSizes.spaceVerySmall),
          _InfomationWdiget(
            title: 'name_Str'.tr,
            value: coinModel.name,
          ),
          const SizedBox(height: AppSizes.spaceVerySmall),
          _InfomationWdiget(
            title: 'global_decimal'.tr,
            value: coinModel.decimals.toString(),
          ),
          const SizedBox(height: AppSizes.spaceVerySmall),
          _InfomationWdiget(
            title: 'hintSymbolStr'.tr,
            value: coinModel.symbol,
          ),
          const SizedBox(height: AppSizes.spaceVerySmall),
          coinModel.isToken
              ? _ContractInformation(coinModel: coinModel)
              : const SizedBox(),
          const Expanded(child: SizedBox(height: AppSizes.spaceNormal)),
          coinModel.isToken
              ? GlobalButtonWidget(
                  name: 'global_detail'.tr,
                  type: ButtonType.ACTIVE,
                  onTap: () {
                    controller.handleDetailCoin(
                        coinModel.blockchainId, coinModel.contractAddress);
                  })
              : const SizedBox()
        ],
      ),
    );
  }
}

class _ContractInformation extends GetView<HistoryTransactionCoinController> {
  const _ContractInformation({
    Key? key,
    required this.coinModel,
  }) : super(key: key);

  final CoinModel coinModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'global_contract'.tr,
              style: AppTextTheme.bodyText1.copyWith(
                color: AppColorTheme.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
                onPressed: controller.handleIconCopyContractAddressOntap,
                splashRadius: AppSizes.spaceMedium,
                icon: const Icon(
                  Icons.file_copy_outlined,
                  color: AppColorTheme.accent,
                )),
          ],
        ),
        const SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          coinModel.contractAddress,
          style: AppTextTheme.bodyText1.copyWith(
            color: AppColorTheme.accent,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Divider(color: AppColorTheme.accent60, thickness: 0.5),
      ],
    );
  }
}

class _InfomationWdiget extends StatelessWidget {
  const _InfomationWdiget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.bodyText1.copyWith(
            color: AppColorTheme.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          value,
          style: AppTextTheme.bodyText1.copyWith(
            color: AppColorTheme.accent,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Divider(color: AppColorTheme.accent60, thickness: 0.5),
      ],
    );
  }
}
