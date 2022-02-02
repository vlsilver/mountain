import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/asset_values.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/core/values/string_values.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_home/home_controller.dart';
import 'package:base_source/app/module_setting/setting_controller.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_logo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'wallet_controller.dart';
import 'widget/feature_item_widget.dart';

class WalletPage extends GetView<WalletController> {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.handleScrollController();
    return Container(
      decoration: BoxDecoration(
          color: AppColorTheme.accent90,
          image: DecorationImage(
            image: AssetImage(AppAssets.globalBg),
            fit: BoxFit.cover,
          )),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0.0,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSizes.spaceNormal),
            const _AppbarWidget(),
            Expanded(
              child: GetBuilder<WalletController>(
                id: EnumUpdateWallet.PAGE,
                builder: (_) {
                  if (!_.isLoadSuccess) {
                    return Center(child: CupertinoActivityIndicator());
                  }
                  return NestedScrollView(
                      controller: _.scrollController,
                      physics: BouncingScrollPhysics(),
                      headerSliverBuilder: (context, isBoxScroll) {
                        return [
                          SliverAppBar(
                            backgroundColor: Colors.transparent,
                            toolbarHeight: 48.0,
                            centerTitle: true,
                            title: Column(
                              children: [
                                Text(
                                  AppString.globalAppName,
                                  style: AppTextTheme.appName.copyWith(
                                      color: AppColorTheme.white,
                                      height: 1,
                                      fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                                GetBuilder<WalletController>(
                                  id: EnumUpdateWallet.CURRENCY_ONLY,
                                  builder: (_) {
                                    return Text(
                                      _.wallet.currencyString,
                                      maxLines: 1,
                                      style: AppTextTheme.body
                                          .copyWith(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SliverToBoxAdapter(
                              child:
                                  const SizedBox(height: AppSizes.spaceLarge)),
                        ];
                      },
                      body: const _ListDetailCoinWidget());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppbarWidget extends GetView<WalletController> {
  const _AppbarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      id: EnumUpdateWallet.APPBAR,
      builder: (_) {
        final homeController = Get.find<HomeController>();
        final settingController = Get.find<SettingController>();
        return Container(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
          height: 40.0,
          child: Stack(
            children: [
              Visibility(
                visible: _.visibleAppbar,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 0.0,
                  onPressed: () {
                    homeController.handleItemBottomBarOnTap(index: 1);
                  },
                  child: Row(children: [
                    GlobalLogoWidget(type: 1, height: 32.0),
                    SizedBox(width: AppSizes.spaceSmall),
                    Expanded(
                      child: Text(
                        _.wallet.currencyString,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.body.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ]),
                ),
              ),
              Visibility(
                visible: !_.visibleAppbar,
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _.handleIcNotiOnTap,
                    minSize: 0,
                    child: Stack(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: AppColorTheme.white,
                          size: 32.0,
                        ),
                        NotificationWidget()
                      ],
                    )),
              ),
              Visibility(
                visible: !_.visibleAppbar,
                child: Positioned(
                    left: 0.0,
                    right: 0.0,
                    child: GlobalLogoWidget(type: 1, height: 40.0)),
              ),
              Positioned(
                right: 0.0,
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      settingController.logout();
                    },
                    minSize: 0,
                    child: Image.asset(
                      'assets/wallet/ic_logout.png',
                      width: 28.0,
                      height: 28.0,
                    )),
              )
            ],
          ),
        );
      },
    );
  }
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      id: EnumUpdateWallet.NOTIFICATION,
      builder: (_) {
        return _.notiTransactions.isNotEmpty
            ? Positioned(
                top: 0.0,
                right: 0.0,
                child: Container(
                  height: 16.0,
                  width: 16.0,
                  decoration: BoxDecoration(
                      color: AppColorTheme.error, shape: BoxShape.circle),
                  child: Center(
                    child: Text(_.notiTransactions.length.toString(),
                        style: AppTextTheme.caption
                            .copyWith(color: AppColorTheme.white)),
                  ),
                ),
              )
            : SizedBox();
      },
    );
  }
}

class _FeaturesItemWidget extends GetView<WalletController> {
  const _FeaturesItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final featureNames = <String>[
      'receive_str'.tr,
      'generate_token'.tr,
      'global_send'.tr,
      'global_swap'.tr,
    ];
    final spacePadding = (Get.width - 16 - 3 * (Get.width / 2) * .55) / 3;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(featureNames.length, (index) => index)
              .map((index) => CupertinoButton(
                    onPressed: () {
                      controller.handleItemFeatureOnTap(index: index);
                    },
                    padding: EdgeInsets.only(right: spacePadding),
                    child: FeatureItemWidget(
                      color: controller.colorIconList[index],
                      name: featureNames[index],
                      icon: index == 3 ? null : controller.icons[index],
                      svg: index == 3 ? controller.icons[index] : '',
                    ),
                  ))
              .toList()),
    );
  }
}

class _ListDetailCoinWidget extends GetView<WalletController> {
  const _ListDetailCoinWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(top: AppSizes.spaceSmall),
      decoration: BoxDecoration(
          color: AppColorTheme.container,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.borderRadiusVeryLarge))),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: Get.width / 2 * 0.55 + AppSizes.spaceMedium,
            backgroundColor: AppColorTheme.container,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                  padding: const EdgeInsets.only(
                      left: AppSizes.spaceMedium,
                      right: AppSizes.spaceMedium,
                      top: AppSizes.spaceMedium),
                  child: const _FeaturesItemWidget()),
            ),
          ),
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColorTheme.container,
            titleSpacing: AppSizes.spaceMedium,
            toolbarHeight: 64.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'token_list'.tr,
                  style: AppTextTheme.bodyText1.copyWith(
                      color: AppColorTheme.text, fontWeight: FontWeight.w500),
                ),
                CupertinoButton(
                    onPressed: () => controller.handleNewToken(),
                    child: SvgPicture.asset(controller.icAddtoken))
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: GetBuilder<WalletController>(
              id: EnumUpdateWallet.CURRENCY_ACTIVE,
              builder: (_) {
                final coinsActive = _.wallet.allCoinsAtive();
                return ReorderableListView.builder(
                    shrinkWrap: true,
                    buildDefaultDragHandles: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final coinModel = coinsActive[index];
                      return _ItemCoinValueWidget(
                        key: ValueKey(coinModel.id + coinModel.blockchainId),
                        coinModel: coinModel,
                        index: index,
                      );
                    },
                    itemCount: coinsActive.length,
                    onReorder: (int oldindex, int newindex) {
                      final newindexInitial = newindex;
                      _.handleChangePositionCoinActive(
                          oldindex, newindexInitial);
                      if (newindex > oldindex) {
                        newindex -= 1;
                      }
                      final items = coinsActive.removeAt(oldindex);
                      coinsActive.insert(newindex, items);
                    });
              },
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 56.0))
        ],
      ),
    );
  }
}

class _ItemCoinValueWidget extends GetView<WalletController> {
  const _ItemCoinValueWidget({
    Key? key,
    required this.coinModel,
    required this.index,
  }) : super(key: key);

  final CoinModel coinModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.handleCoinItemOnTap(coinModel);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSizes.spaceNormal),
        padding: const EdgeInsets.all(AppSizes.spaceSmall),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              padding: EdgeInsets.all(AppSizes.spaceSmall),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColorTheme.card),
              child: GlobalAvatarCoinWidget(coinModel: coinModel),
            ),
            SizedBox(width: AppSizes.spaceNormal),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: Get.width / 2),
                        child: Text(
                          coinModel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.bodyText1.copyWith(
                              color: AppColorTheme.text,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(width: AppSizes.spaceSmall),
                      Expanded(
                        child: Text(
                          Crypto.numberFormatNumberToken(coinModel.amount),
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.bodyText1.copyWith(
                            color: AppColorTheme.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        ' ' + coinModel.symbol,
                        style: AppTextTheme.bodyText1.copyWith(
                          color: AppColorTheme.text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        coinModel.priceCurrencyString,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.bodyText2
                            .copyWith(color: AppColorTheme.text60),
                      ),
                      Expanded(
                        child: Text(
                          coinModel.ratePercentFormat,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.bodyText2.copyWith(
                              color: coinModel.exchange > 0
                                  ? AppColorTheme.toggleableActiveColor
                                  : AppColorTheme.error),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceVerySmall),
                  Divider(
                    thickness: 1.0,
                    color: AppColorTheme.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
