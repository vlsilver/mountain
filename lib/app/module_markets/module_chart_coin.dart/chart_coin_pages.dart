import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:k_chart/chart_translations.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:popover/popover.dart';

import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_markets/module_chart_coin.dart/chart_coin_controller.dart';
import 'package:base_source/app/widget_global/global_error_widget.dart';
import 'package:base_source/app/widget_global/global_logo_widget.dart';

class KChartCoinPage extends StatefulWidget {
  KChartCoinPage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<KChartCoinPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChartCoinController>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColorTheme.focus,
      appBar: AppBar(
        toolbarHeight: 80.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          splashRadius: AppSizes.spaceMedium,
          iconSize: 24.0,
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 24.0,
            color: AppColorTheme.accent,
          ),
        ),
        backgroundColor: AppColorTheme.backGround2,
        title: Column(
          children: [
            GlobalLogoWidget(),
            SizedBox(height: AppSizes.spaceVerySmall),
            Text(
              controller.coinModel.symbol + '/USD',
              style: AppTextTheme.body.copyWith(
                color: AppColorTheme.textAction,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<ChartCoinController>(
        id: EnumUpdateChartPage.LOAD_DATA,
        builder: (_) {
          if (_.status == StateStatus.INITIAL) {
            return Center(child: CupertinoActivityIndicator());
          } else if (_.status == StateStatus.FAILURE) {
            return GlobalErrorWidget(title: 'not_found_data'.tr);
          }
          return Column(
            children: [
              const SizedBox(height: AppSizes.spaceLarge),
              const _GroupInfomationWidget(),
              const SizedBox(height: AppSizes.spaceNormal),
              const _GroupTimeActiveWidget(),
              const SizedBox(height: AppSizes.spaceMedium),
              const _GroupChartWidget(),
            ],
          );
        },
      ),
    );
  }
}

class _GroupTimeActiveWidget extends GetView<ChartCoinController> {
  const _GroupTimeActiveWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
      child: Row(
        children: [
          GetBuilder<ChartCoinController>(
            id: EnumUpdateChartPage.TIME_ACITVE,
            builder: (_) {
              return Row(
                  children: _.listTimeActive.map((time) {
                final isActive = time == _.timeActive;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSizes.spaceSmall),
                  child: CupertinoButton(
                    onPressed: () {
                      _.handleChangeTimeActiveOnTap(time);
                    },
                    borderRadius: isActive ? BorderRadius.circular(4.0) : null,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceNormal,
                        vertical: AppSizes.spaceVerySmall),
                    minSize: 0.0,
                    color:
                        isActive ? AppColorTheme.accent20 : Colors.transparent,
                    child: Text(time,
                        style: AppTextTheme.bodyText2.copyWith(
                            color: AppColorTheme.black50,
                            fontWeight: FontWeight.w700)),
                  ),
                );
              }).toList());
            },
          ),
          GestureDetector(
            onTap: () {
              controller.handleClickShowMore();
              showPopover(
                  context: context,
                  transitionDuration: const Duration(milliseconds: 150),
                  barrierColor: Colors.transparent,
                  shadow: [],
                  bodyBuilder: (context) => const _SelectTimeActive(),
                  onPop: () {
                    controller.handleClickShowMore();
                  },
                  direction: PopoverDirection.bottom,
                  arrowHeight: 0,
                  arrowWidth: 0,
                  width: Get.width);
            },
            child: const _ButtonMoreWidget(),
          ),
          Expanded(child: SizedBox()),
          IconButton(
            splashColor: AppColorTheme.accent20,
            splashRadius: AppSizes.spaceNormal,
            onPressed: controller.handleFavouriteChangeOnTap,
            icon: GetBuilder<ChartCoinController>(
              id: EnumUpdateChartPage.STAR,
              builder: (_) {
                return Icon(
                  controller.isFavourite ? Icons.star : Icons.star_border,
                  color:
                      controller.isFavourite ? AppColorTheme.textAction : null,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ButtonMoreWidget extends StatelessWidget {
  const _ButtonMoreWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChartCoinController>(
      id: EnumUpdateChartPage.SHOW_MORE,
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spaceNormal,
              vertical: AppSizes.spaceVerySmall),
          decoration: BoxDecoration(
            color: _.isShowMore ? AppColorTheme.accent20 : null,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            children: [
              Text(
                'global_more'.tr,
                style: AppTextTheme.bodyText2.copyWith(
                    color: AppColorTheme.black50, fontWeight: FontWeight.w700),
              ),
              Icon(_.isShowMore ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: AppColorTheme.black)
            ],
          ),
        );
      },
    );
  }
}

class _SelectTimeActive extends GetView<ChartCoinController> {
  const _SelectTimeActive({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: AppSizes.spaceLarge,
          right: AppSizes.spaceLarge,
          bottom: AppSizes.spaceSmall,
          top: AppSizes.spaceVerySmall),
      padding: const EdgeInsets.all(AppSizes.spaceMedium),
      decoration: BoxDecoration(
          color: AppColorTheme.focus,
          boxShadow: [
            BoxShadow(
                color: AppColorTheme.black25,
                blurRadius: 5.0,
                offset: Offset(0.0, 1.0))
          ],
          borderRadius: BorderRadius.circular(8.0)),
      child: Wrap(
          runSpacing: 12.0,
          spacing: 12.0,
          children: controller.listTimeAllBinance
              .map((time) => CupertinoButton(
                    onPressed: () {
                      Get.back();
                      controller.handleClickShowMore();
                      controller.handleChangeTimeActiveOnTap(time);
                    },
                    minSize: 0.0,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: (Get.width - 116) / 4,
                      height: 32.0,
                      decoration: BoxDecoration(
                          color: time == controller.timeActive
                              ? AppColorTheme.accent20
                              : null,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                              color: AppColorTheme.black, width: 0.25)),
                      alignment: Alignment.center,
                      child: Text(
                        time,
                        style: AppTextTheme.bodyText2
                            .copyWith(color: AppColorTheme.black),
                      ),
                    ),
                  ))
              .toList()),
    );
  }
}

class _GroupChartWidget extends StatelessWidget {
  const _GroupChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chartStyle = ChartStyle();
    var chartColors = ChartColors()
      ..infoWindowNormalColor = AppColorTheme.textAction80
      ..infoWindowTitleColor = AppColorTheme.black60
      ..selectFillColor = AppColorTheme.focus
      ..defaultTextColor = AppColorTheme.black
      ..dColor = AppColorTheme.accent
      ..dnColor = AppColorTheme.error
      ..upColor = AppColorTheme.toggleableActiveColor
      ..ma5Color = AppColorTheme.highlight
      ..ma10Color = Colors.blue
      ..ma30Color = Colors.purple
      ..maxColor = AppColorTheme.toggleableActiveColor
      ..minColor = AppColorTheme.error
      ..nowPriceDnColor = AppColorTheme.error
      ..nowPriceUpColor = AppColorTheme.toggleableActiveColor
      ..nowPriceTextColor = AppColorTheme.black60
      ..hCrossColor = AppColorTheme.black25
      ..crossTextColor = AppColorTheme.textAction80
      ..volColor = AppColorTheme.textAction;

    return GetBuilder<ChartCoinController>(
      id: EnumUpdateChartPage.STREAM_DATA,
      builder: (_) {
        chartColors.gridColor = Colors.transparent;
        return Container(
          height: Get.height - 320.0,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceSmall),
          child: KChartWidget(
            _.dataChart,
            chartStyle,
            chartColors,
            isLine: false,
            mainState: MainState.MA,
            volHidden: false,
            secondaryState: SecondaryState.NONE,
            fixedLength: 1,
            timeFormat: TimeFormat.YEAR_MONTH_DAY,
            translations: kChartTranslations,
            showNowPrice: true,
            isChinese: false,
            hideGrid: false,
            maDayList: [5, 10, 30],
            bgColor: [AppColorTheme.focus, AppColorTheme.focus],
          ),
        );
      },
    );
  }
}

class _GroupInfomationWidget extends StatelessWidget {
  const _GroupInfomationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
      child: GetBuilder<ChartCoinController>(
        id: EnumUpdateChartPage.INFORMATION,
        builder: (_) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Crypto.currencyUSDFormater.format(_.lastPrice),
                      style: AppTextTheme.headline2.copyWith(
                          color: _.priceChangePercent < 0
                              ? AppColorTheme.error
                              : AppColorTheme.toggleableActiveColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: AppSizes.spaceVerySmall),
                    Row(
                      children: [
                        SvgPicture.asset('assets/global/ic_equal.svg'),
                        Text(
                          ' ' + _.coinModel.priceCurrencyString,
                          style: AppTextTheme.bodyText1
                              .copyWith(color: AppColorTheme.black60),
                        ),
                        SizedBox(width: AppSizes.spaceVerySmall),
                        Text(
                          Crypto.rateFormat(_.priceChangePercent),
                          style: AppTextTheme.bodyText1.copyWith(
                              color: _.coinModel.exchange < 0.0
                                  ? AppColorTheme.error
                                  : AppColorTheme.containerBlue),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        '24h_vol'.tr + ' ',
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.black60),
                      ),
                      Text(
                        Crypto.numberFormatNumberToken(_.quoteVolume),
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.textAction),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceVerySmall),
                  Row(
                    children: [
                      Text(
                        '24h_high'.tr + ' ',
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.black60),
                      ),
                      Text(
                        Crypto.numberFormatNumberToken(_.highPrice),
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.textAction),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceVerySmall),
                  Row(
                    children: [
                      Text(
                        '24h_low'.tr + ' ',
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.black60),
                      ),
                      Text(
                        Crypto.numberFormatNumberToken(_.lowPrice),
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.textAction),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
