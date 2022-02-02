import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_markets/markets_controller.dart';
import 'package:base_source/app/module_setting/widget/hero_logo_widget.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get.dart';

class MarketsPage extends StatefulWidget {
  const MarketsPage({Key? key}) : super(key: key);

  @override
  _MarketsPageState createState() => _MarketsPageState();
}

class _MarketsPageState extends State<MarketsPage> {
  final controller = Get.find<MarketsController>();

  @override
  void initState() {
    controller.checkInitDataSucces();
    controller.handleSearchWorker();
    super.initState();
  }

  @override
  void deactivate() {
    controller.handleWorkerClose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        backgroundColor: AppColorTheme.backGround2,
        title: Column(
          children: [
            HeroLogoWidget(),
            Text(
              'global_markets'.tr,
              style: AppTextTheme.title,
            ),
          ],
        ),
        elevation: 0.0,
      ),
      backgroundColor: AppColorTheme.backGround2,
      body: InkWell(
        focusNode: controller.focusNode,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          controller.focusNode.unfocus();
        },
        child: GetBuilder<MarketsController>(
          id: EnumUpdateMaketsPage.PAGE,
          builder: (_) {
            if (_.listSearchMarketsResult.isEmpty) {
              return Center(child: CupertinoActivityIndicator());
            }
            return NestedScrollView(
                physics: BouncingScrollPhysics(),
                headerSliverBuilder: (context, isBoxScroll) {
                  return [
                    _SearchWidget(),
                  ];
                },
                body: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Builder(builder: (context) {
                    controller.tabController =
                        DefaultTabController.of(context)!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSizes.spaceMedium),
                        _TabarWidget(),
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: AppColorTheme.focus,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(
                                    AppSizes.borderRadiusVeryLarge),
                              ),
                            ),
                            child: TabBarView(
                                controller: controller.tabController,
                                children: [
                                  _FavouritesWidget(),
                                  _MarketsWidget(),
                                ]),
                          ),
                        ),
                      ],
                    );
                  }),
                ));
          },
        ),
      ),
    );
  }
}

class _TabarWidget extends StatelessWidget {
  const _TabarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceVeryLarge),
      child: TabBar(
          indicatorWeight: 4.0,
          // indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: AppColorTheme.textAction,
          labelColor: AppColorTheme.textAction,
          labelStyle: AppTextTheme.bodyText1.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelColor: AppColorTheme.black60,
          // isScrollable: true,
          onTap: (index) {},
          tabs: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
              child: Text('global_favourite'.tr.toUpperCase()),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
              child: Text('global_markets'.tr.toUpperCase()),
            ),
          ]),
    );
  }
}

class _SearchWidget extends GetView<MarketsController> {
  const _SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: GlobalInputSearchWidget(
        onChange: (value) {
          controller.searchValue.value = value;
        },
        hintText: 'search_coin_pairs'.tr,
        textInputType: TextInputType.text,
        haveBorder: false,
      ),
    );
  }
}

class _MarketsWidget extends StatelessWidget {
  const _MarketsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColorTheme.focus,
          titleSpacing: AppSizes.spaceMedium,
          toolbarHeight: 48.0,
          title: Row(
            children: [
              _NameVolWidget(),
              _LastPriceWidget(),
              _ChgWidget(),
            ],
          ),
        ),
        GetBuilder<MarketsController>(
          id: EnumUpdateMaketsPage.LIST_MARKET,
          builder: (_) {
            final coins = _.listSearchMarketsResult;
            return GetBuilder<WalletController>(
              id: EnumUpdateWallet.CURRENCY_ONLY,
              builder: (walletController) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final coinModel = coins[index];
                    final currency = _.currency;
                    return _CoinPairItemWidget(
                        coinModel: coinModel, index: index, currency: currency);
                  }, childCount: coins.length),
                );
              },
            );
          },
        ),
        SliverToBoxAdapter(child: SizedBox(height: 100.0))
      ],
    );
  }
}

class _ChgWidget extends GetView<MarketsController> {
  const _ChgWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: controller.handleSearch24ChgOnTap,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Text(
            'global_24Chg'.tr,
            style:
                AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black50),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.0, bottom: 1.0),
                child: SvgPicture.asset(
                  'assets/markets/arrow_up.svg',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.0, top: 1.0),
                child: SvgPicture.asset(
                  'assets/markets/arrow_down.svg',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _LastPriceWidget extends GetView<MarketsController> {
  const _LastPriceWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: CupertinoButton(
        onPressed: controller.handleSearchLastPriceOnTap,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            Text(
              'global_last_price'.tr,
              style:
                  AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black50),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 4.0, bottom: 1.0),
                  child: SvgPicture.asset(
                    'assets/markets/arrow_up.svg',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.0, top: 1.0),
                  child: SvgPicture.asset(
                    'assets/markets/arrow_down.svg',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _NameVolWidget extends GetView<MarketsController> {
  const _NameVolWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Row(
        children: [
          CupertinoButton(
            onPressed: controller.handleSearchNameOnTap,
            padding: EdgeInsets.zero,
            minSize: 0.0,
            child: Row(
              children: [
                Text(
                  'global_name'.tr,
                  style: AppTextTheme.bodyText2
                      .copyWith(color: AppColorTheme.black50),
                ),
                SizedBox(width: 4.0),
                SvgPicture.asset(
                  'assets/markets/arrow_down.svg',
                ),
                SizedBox(width: 2.0),
              ],
            ),
          ),
          Text(
            '/ ',
            style:
                AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black50),
          ),
          CupertinoButton(
            onPressed: controller.handleSearchVolOnTap,
            padding: EdgeInsets.zero,
            minSize: 0.0,
            child: Row(
              children: [
                Text(
                  'global_vol'.tr,
                  style: AppTextTheme.bodyText2
                      .copyWith(color: AppColorTheme.black50),
                ),
                SizedBox(width: 4.0),
                SvgPicture.asset(
                  'assets/markets/arrow_down.svg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinPairItemWidget extends GetView<MarketsController> {
  const _CoinPairItemWidget(
      {Key? key,
      required this.coinModel,
      required this.index,
      required this.currency})
      : super(key: key);

  final CoinModel coinModel;
  final int index;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final isFavourite = controller.isFavourite(coinModel.symbol + '/USD');
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 64.0 / Get.width,
      actions: [
        IconSlideAction(
          color: AppColorTheme.backGround2,
          iconWidget: Icon(
            isFavourite ? Icons.star : Icons.star_border,
            color: isFavourite ? AppColorTheme.textAction : null,
          ),
          onTap: () {
            controller.handleFavouriteChangeOnTap(isFavourite, coinModel);
          },
        ),
      ],
      child: CupertinoButton(
        onPressed: () {
          controller.handleCoinPairOnTap(
              coinModel: coinModel, isFavourite: isFavourite);
        },
        padding: const EdgeInsets.only(
          left: AppSizes.spaceMedium,
          right: AppSizes.spaceMedium,
          top: AppSizes.spaceVerySmall,
        ),
        child: Column(
          children: [
            SizedBox(height: AppSizes.spaceSmall),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              coinModel.symbol,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextTheme.bodyText2.copyWith(
                                  fontSize: 13.0,
                                  color: AppColorTheme.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            '/USD',
                            style: AppTextTheme.bodyText2.copyWith(
                                fontSize: 13.0,
                                color: AppColorTheme.black40,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Text(
                        'Vol ' + coinModel.marketVolFormatNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.bodyText2
                            .copyWith(color: AppColorTheme.black40),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSizes.spaceSmall),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coinModel.priceUSDString,
                        style: AppTextTheme.bodyText2.copyWith(
                            fontSize: 13.0,
                            color: coinModel.exchange < 0.0
                                ? AppColorTheme.error
                                : AppColorTheme.containerBlue,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        coinModel.priceCurrencyString,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.bodyText2.copyWith(
                            fontSize: 12.0,
                            color: AppColorTheme.black40,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSizes.spaceSmall),
                SizedBox(
                  width: 69.0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        constraints: BoxConstraints(minWidth: 56.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: AppSizes.spaceVerySmall),
                        decoration: BoxDecoration(
                            color: coinModel.exchange < 0
                                ? AppColorTheme.error
                                : AppColorTheme.containerBlue,
                            borderRadius:
                                BorderRadius.circular(AppSizes.spaceVerySmall)),
                        child: Text(
                          coinModel.ratePercentFormat,
                          textAlign: TextAlign.center,
                          style: AppTextTheme.bodyText1.copyWith(
                              fontSize: 12, color: AppColorTheme.white),
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.spaceNormal),
            Divider(
              thickness: 1.0,
              height: 1.0,
              color: AppColorTheme.black5,
            )
          ],
        ),
      ),
    );
  }
}

class _FavouritesWidget extends StatelessWidget {
  const _FavouritesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColorTheme.focus,
          titleSpacing: AppSizes.spaceMedium,
          toolbarHeight: 48.0,
          title: Row(
            children: [
              _NameVolWidget(),
              _LastPriceWidget(),
              _ChgWidget(),
            ],
          ),
        ),
        GetBuilder<MarketsController>(
          id: EnumUpdateMaketsPage.LIST_FAVOURITE,
          builder: (_) {
            final coins = _.listSearchFavouriteResult;
            return GetBuilder<WalletController>(
              id: EnumUpdateWallet.CURRENCY_ONLY,
              builder: (walletController) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final coinModel = coins[index];
                    final currency = _.currency;
                    return _CoinPairItemWidget(
                        coinModel: coinModel, index: index, currency: currency);
                  }, childCount: coins.length),
                );
              },
            );
          },
        ),
        SliverToBoxAdapter(child: SizedBox(height: 100.0))
      ],
    );
  }
}
