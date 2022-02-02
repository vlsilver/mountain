import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create_token/create_token_controller.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:base_source/app/widget_global/global_layout_builder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../wallet_controller.dart';

class CreateTokenPage extends GetView<CreateTokenController> {
  const CreateTokenPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      color: AppColorTheme.white,
      child: InkWell(
        focusNode: controller.focusNode,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          controller.handleScreenOnTap();
        },
        child: GlobalLayoutBuilderWidget(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.spaceNormal),
                AppBarWidget(
                    title: 'create_token'.tr,
                    onTap: () {
                      Get.back();
                    }),
                const SizedBox(height: AppSizes.spaceNormal),
                const _NetworkWidget(),
                const SizedBox(height: AppSizes.spaceNormal),
                const _InputAddressSendWidget(),
                const SizedBox(height: AppSizes.spaceNormal),
                GetBuilder<CreateTokenController>(
                  id: EnumUpdateCreateToken.TOKEN_NAME,
                  builder: (_) {
                    return GlobalInputWidget(
                      onChange: _.handleInputNameOnChange,
                      hintText: 'name_token'.tr,
                      textInputType: TextInputType.text,
                      color: AppColorTheme.card,
                      errorText: _.errorName,
                      maxLength: 30,
                    );
                  },
                ),
                const SizedBox(height: AppSizes.spaceNormal),
                GetBuilder<CreateTokenController>(
                  id: EnumUpdateCreateToken.SYMBOL,
                  builder: (_) {
                    return GlobalInputWidget(
                      onChange: controller.handleInputSymbolOnChange,
                      hintText: 'token_symbol'.tr,
                      textInputType: TextInputType.text,
                      errorText: _.errorSymbol,
                      color: AppColorTheme.card,
                      maxLength: 30,
                    );
                  },
                ),
                const SizedBox(height: AppSizes.spaceNormal),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: controller.calculatorsStr
                      .map((element) => _CalculatorAmountWidget(title: element))
                      .toList(),
                ),
                const SizedBox(height: AppSizes.spaceVerySmall),
                GetBuilder<CreateTokenController>(
                  id: EnumUpdateCreateToken.TOTAL,
                  builder: (_) {
                    return GlobalInputWidget(
                      controller: _.totalController,
                      hintText: 'hinetotalValueStr'.tr,
                      textInputType: const TextInputType.numberWithOptions(),
                      color: AppColorTheme.card,
                      errorText: _.errorTotal,
                    );
                  },
                ),
                GestureDetector(
                  onTap: controller.handleAvatarOnTap,
                  child: Container(
                    height: Get.width * 1 / 3,
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.only(
                        top: AppSizes.spaceMedium,
                        bottom: AppSizes.spaceVerySmall),
                    decoration: BoxDecoration(
                        color: AppColorTheme.card,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColorTheme.black25, width: 0.5)),
                    child: GetBuilder<CreateTokenController>(
                      id: EnumUpdateCreateToken.AVATAR,
                      builder: (_) {
                        if (_.file == null) {
                          return const Icon(
                            Icons.photo,
                            color: AppColorTheme.black60,
                            size: 32.0,
                          );
                        } else {
                          return Image.file(
                            _.file!,
                            filterQuality: FilterQuality.low,
                            fit: BoxFit.contain,
                          );
                        }
                      },
                    ),
                  ),
                ),
                Text(
                  'avatarStr'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bodyText2
                      .copyWith(color: AppColorTheme.black),
                ),
                const Expanded(child: SizedBox(height: AppSizes.spaceMedium)),
                GetBuilder<CreateTokenController>(
                  id: EnumUpdateCreateToken.BUTTON,
                  builder: (_) {
                    return GlobalButtonWidget(
                        name: 'global_create'.tr,
                        type: _.isActiveButton
                            ? ButtonType.ACTIVE
                            : ButtonType.DISABLE,
                        onTap: () {
                          controller.handleCalculatorFeeCreateToken();
                        });
                  },
                ),
                const SizedBox(height: AppSizes.spaceVeryLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NetworkWidget extends StatelessWidget {
  const _NetworkWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateTokenController>(
      id: EnumUpdateCreateToken.NETWORK,
      builder: (_) {
        return Row(
          children: [
            const Icon(
              Icons.circle,
              color: AppColorTheme.toggleableActiveColor,
              size: 10.0,
            ),
            const SizedBox(width: AppSizes.spaceNormal),
            Expanded(
                child: Text(
              _.blockChainModelActive.network,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextTheme.bodyText1.copyWith(
                  color: AppColorTheme.black, fontWeight: FontWeight.w600),
            )),
          ],
        );
      },
    );
  }
}

class _CalculatorAmountWidget extends GetView<CreateTokenController> {
  const _CalculatorAmountWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleTextSetTotalOnTap(title);
      },
      borderRadius: BorderRadius.circular(4.0),
      minSize: 24,
      color: AppColorTheme.card,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceVerySmall),
      child: Text(
        title,
        style: AppTextTheme.bodyText2.copyWith(
          color: AppColorTheme.highlight,
        ),
      ),
    );
  }
}

class _InputAddressSendWidget extends GetView<CreateTokenController> {
  const _InputAddressSendWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.handleInputAddressSendOnTap();
      },
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spaceNormal),
        height: 56.0,
        decoration: BoxDecoration(
            color: AppColorTheme.card,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('global_creator'.tr,
                      style: AppTextTheme.bodyText2
                          .copyWith(color: AppColorTheme.black60)),
                  Flexible(
                      child: GetBuilder<CreateTokenController>(
                          id: EnumUpdateCreateToken.CREATOR,
                          builder: (_) {
                            return GetBuilder<WalletController>(
                              id: EnumUpdateWallet.CURRENCY_ACTIVE,
                              builder: (walletController) {
                                return Text.rich(
                                  TextSpan(
                                      text: _.addressModelActive.name,
                                      style: AppTextTheme.bodyText1.copyWith(
                                          color: AppColorTheme.black,
                                          fontWeight: FontWeight.w600),
                                      children: [
                                        TextSpan(
                                          text: _.addressModelActive
                                              .currencyStringWithRoundBracks,
                                          style: AppTextTheme.bodyText1
                                              .copyWith(
                                                  color: AppColorTheme.error,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            );
                          }))
                ],
              ),
            ),
            const SizedBox(
              height: 32.0,
              width: 32.0,
              child: SizedBox(
                height: 32.0,
                width: 32.0,
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: AppColorTheme.accent,
                  size: 32.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
