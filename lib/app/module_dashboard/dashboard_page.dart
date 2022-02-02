import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/core/values/string_values.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_logo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'component/feature_component.dart';
import 'dashboard_controller.dart';

class DashBoardPage extends GetView<DashBoardController> {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColorTheme.accent90,
          image: DecorationImage(
            image: AssetImage(AppAssets.globalBg),
            fit: BoxFit.cover,
          )),
      child: Scaffold(
        appBar: _buildAppbar(),
        backgroundColor: Colors.transparent,
        body: GetBuilder<WalletController>(
            id: EnumUpdateWallet.PAGE,
            builder: (_) {
              if (!_.isLoadSuccess) {
                return Center(child: CupertinoActivityIndicator());
              }
              return NestedScrollView(
                physics: BouncingScrollPhysics(),
                headerSliverBuilder: (context, isBoxScroll) {
                  return [
                    SliverAppBar(
                      centerTitle: true,
                      title: const _DashOverGlad(),
                      backgroundColor: Colors.transparent,
                      toolbarHeight: 150,
                    ),
                  ];
                },
                body: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceMedium,
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/dashboard/dashboard.png'))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppSizes.spaceMax + AppSizes.spaceMedium,
                      ),
                      Expanded(
                        child: CustomScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  const _DashMoreInfo(),
                                  SizedBox(
                                    height: AppSizes.spaceVeryLarge,
                                  ),
                                  const _DashBoardFeature(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      elevation: 0.0,
      toolbarHeight: 80.0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Column(
        children: [
          GlobalLogoWidget(type: 1, height: 40.0),
          Text(
            AppString.globalAppName,
            style: AppTextTheme.appName
                .copyWith(color: AppColorTheme.white, fontSize: 24),
          )
        ],
      ),
    );
  }
}

class _DashBoardFeature extends StatelessWidget {
  const _DashBoardFeature({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'dash_new_features'.tr,
          style: AppTextTheme.balance.copyWith(color: AppColorTheme.black),
        ),
        const SizedBox(height: AppSizes.spaceMedium),
        const _DashFeature(),
        const SizedBox(height: 100.0),
      ],
    );
  }
}

class _DashOverGlad extends GetView<DashBoardController> {
  const _DashOverGlad({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.spaceNormal,
        horizontal: AppSizes.spaceMedium,
      ),
      child: Column(
        children: [
          Text(
            'glad_'.tr,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: AppTextTheme.headline2.copyWith(
              color: AppColorTheme.white,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          Text(
            'dash_features'.tr,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: AppTextTheme.bodyText2.copyWith(),
          ),
          const SizedBox(height: AppSizes.spaceMedium),
          CupertinoButton(
            onPressed: () {
              controller.handleOnTapOpenlink();
            },
            minSize: 0.0,
            padding: EdgeInsets.zero,
            child: Container(
              height: 40.0,
              width: 200.0,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  shadows: [
                    const BoxShadow(
                      color: AppColorTheme.black25,
                      blurRadius: 2.0,
                      offset: Offset(0.0, 2.0),
                    )
                  ],
                  gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [
                        0.0,
                        0.3,
                        1.0
                      ],
                      colors: [
                        Color(0xffF7AD15),
                        Color(0xffF7AD15),
                        Color(0xffFACF0C),
                      ])),
              child: Text(
                'dash_website'.tr,
                style: AppTextTheme.bodyText2,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceMedium),
        ],
      ),
    );
  }
}

class _DashMoreInfo extends GetView<DashBoardController> {
  const _DashMoreInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'dash_balance'.tr,
              style: AppTextTheme.balance.copyWith(
                color: AppColorTheme.black,
              ),
            ),
            const _WalletBalanceWidget(),
          ],
        ),
        SizedBox(height: AppSizes.spaceNormal),
        Text.rich(
          TextSpan(text: 'dash_hint_1'.tr, children: [
            TextSpan(
                text: 'dash_receive'.tr,
                style: AppTextTheme.bodyText2
                    .copyWith(color: AppColorTheme.textAction),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    controller.handleTextRecieveOnTap();
                  }),
            TextSpan(text: 'dash_hint_2'.tr),
            TextSpan(
                text: 'dash_send'.tr,
                style: AppTextTheme.bodyText2
                    .copyWith(color: AppColorTheme.textAction),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    controller.handleTextSendOnTap();
                  }),
            TextSpan(text: 'dash_hint_3'.tr)
          ]),
          textAlign: TextAlign.left,
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black60),
        ),
      ],
    );
  }
}

class _WalletBalanceWidget extends StatelessWidget {
  const _WalletBalanceWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      id: EnumUpdateWallet.CURRENCY_ACTIVE,
      builder: (_) {
        return Text(
          _.wallet.currencyString,
          style: AppTextTheme.balance.copyWith(
            color: AppColorTheme.textAction,
          ),
        );
      },
    );
  }
}

class _DashFeature extends GetView<DashBoardController> {
  const _DashFeature({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.spaceMedium,
      runSpacing: AppSizes.spaceMedium,
      alignment: WrapAlignment.center,
      children: [
        FeatureComponent(
            onFunction: () => controller.handleSwapOnTap(),
            imagePath: 'assets/global/ic_swap.svg',
            text: 'global_swap'.tr),
        FeatureComponent(
            onFunction: () => controller.handleAddLiquidityOnTap(),
            imagePath: 'assets/global/ic_liquidity.svg',
            text: 'global_liquidity'.tr),
        FeatureComponent(
            onFunction: () => controller.handleLaunchPadOnTap(),
            imagePath: 'assets/global/ic_launchpad.svg',
            text: 'global_launchpad'.tr),
      ],
    );
  }
}
