import 'package:base_source/app/data/models/local_model/ido_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';

import 'launchpad_controller.dart';
import 'widget/button_define.dart';

class LaunchPadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      extendBody: true,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          const _BannerMoonWidget(),
          SliverToBoxAdapter(
            child: Container(
                padding: const EdgeInsets.all(AppSizes.spaceMedium),
                alignment: Alignment.centerLeft,
                child: Text(
                  'global_launchpad'.tr,
                  style: AppTextTheme.body.copyWith(
                      color: AppColorTheme.textAction,
                      fontWeight: FontWeight.w600),
                )),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _IDOItem(ido: IDOData.fakeData().data[index]),
              childCount: IDOData.fakeData().data.length,
            ),
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
          color: AppColorTheme.white,
        ),
      ),
      backgroundColor: AppColorTheme.appBarAccent,
      title: Text(
        'global_launchpad'.tr,
        style: AppTextTheme.titleAppbar,
      ),
    );
  }
}

class _BannerMoonWidget extends StatelessWidget {
  const _BannerMoonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceSmall, vertical: AppSizes.spaceLarge),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/launchpad/banner_moon.png'),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            children: [
              Text(
                'launch_pad_title'.tr,
                style: AppTextTheme.headline1,
              ),
              SizedBox(height: AppSizes.spaceVerySmall),
              Text(
                'launch_pad_detail'.tr,
                style: AppTextTheme.body.copyWith(fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _IDOItem extends GetView<LaunchPadController> {
  final IDOModel ido;

  const _IDOItem({
    Key? key,
    required this.ido,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LaunchPadController>(
      id: !ido.isFinished ? EnumLaunchPad.IDO_ITEM : ido.index,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.only(
            bottom: AppSizes.spaceLarge,
            right: AppSizes.spaceMedium,
            left: AppSizes.spaceMedium,
          ),
          decoration: BoxDecoration(
            color: AppColorTheme.focus,
            boxShadow: [
              const BoxShadow(
                color: AppColorTheme.black25,
                blurRadius: 2.0,
                offset: Offset(0.0, 1.0), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusNormal),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _IDOBannerWdiget(ido: ido),
                  ido.isFinished
                      ? _IsCompletedWidget()
                      : ido.isSubscription
                          ? _IsSubscritionWidget()
                          : _IsPreparationWidget(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      ido.name,
                      textAlign: TextAlign.start,
                      style: AppTextTheme.bodyText1.copyWith(
                        color: AppColorTheme.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceVerySmall),
                    Text(
                      ido.chainName,
                      textAlign: TextAlign.start,
                      style: AppTextTheme.bodyText1
                          .copyWith(color: AppColorTheme.black50),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: AppSizes.spaceNormal),
                        height: 0.25,
                        child: Divider(color: AppColorTheme.black25)),
                    _InfomationWidget(
                        title: 'launch_pad_total_supply'.tr,
                        value: ido.formatTokenAmountTotalSupplyWithSymbol),
                    _InfomationWidget(
                        title: 'launch_pad_token_offered'.tr,
                        value: ido.formatTokenAmountOfferedWithSymbol),
                    _InfomationWidget(
                        title: 'launch_pad_sale_price'.tr,
                        value: ido.formatRateWithBaseToken),
                    ido.isFinished
                        ? _InfomationWidget(
                            title: 'launch_pad_end_time'.tr,
                            value: ido.timeEndFormat)
                        : _InfomationTimeDelayWidget(ido: ido),
                    const SizedBox(height: AppSizes.spaceMedium),
                    ButtonDefineWidget(
                        onFunction: () {
                          controller.handleButtonViewDetailOnTap(ido);
                        },
                        title: 'launch_pad_view_detail'.tr),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IDOBannerWdiget extends StatelessWidget {
  final IDOModel ido;

  const _IDOBannerWdiget({
    Key? key,
    required this.ido,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ido.imageBanner == null
        ? Container(
            height: 48 * 3,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceNormal),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSizes.spaceNormal)),
                image: DecorationImage(
                    image:
                        AssetImage('assets/launchpad/banner_coin_default.png'),
                    fit: BoxFit.fill)),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  ido.icon,
                  height: 48.0,
                  width: 48.0,
                ),
                const SizedBox(width: AppSizes.spaceMedium),
                Flexible(
                  child: Text(
                    ido.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.headline1,
                  ),
                ),
              ],
            ),
          )
        : Container(
            height: 48 * 3,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizes.spaceNormal)),
                image: DecorationImage(
                    image: NetworkImage(ido.imageBanner!), fit: BoxFit.fill)),
          );
  }
}

class _InfomationWidget extends StatelessWidget {
  final String title, value;

  const _InfomationWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black50),
          ),
          SizedBox(width: AppSizes.spaceMedium),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextTheme.bodyText2.copyWith(
                  color: AppColorTheme.black80, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}

class _IsCompletedWidget extends StatelessWidget {
  const _IsCompletedWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8.0,
      right: 8.0,
      child: Row(
        children: [
          Text(
            'global_completed'.tr,
            style: AppTextTheme.bodyText2
                .copyWith(color: AppColorTheme.toggleableActiveColor),
          ),
          Icon(Icons.check_outlined,
              color: AppColorTheme.toggleableActiveColor, size: 16.0)
        ],
      ),
    );
  }
}

class _IsPreparationWidget extends StatelessWidget {
  const _IsPreparationWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8.0,
      right: 8.0,
      child: Row(
        children: [
          Text(
            'launch_pad_preparation'.tr,
            style: AppTextTheme.bodyText2
                .copyWith(color: AppColorTheme.preparation),
          ),
          Icon(Icons.hourglass_top_outlined,
              color: AppColorTheme.preparation, size: 16.0)
        ],
      ),
    );
  }
}

class _IsSubscritionWidget extends StatelessWidget {
  const _IsSubscritionWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8.0,
      right: 8.0,
      child: Row(
        children: [
          Text(
            'launch_pad_subscription'.tr,
            style: AppTextTheme.bodyText2
                .copyWith(color: AppColorTheme.preparation),
          ),
          Icon(Icons.hourglass_top_outlined,
              color: AppColorTheme.preparation, size: 16.0)
        ],
      ),
    );
  }
}

class _InfomationTimeDelayWidget extends StatelessWidget {
  const _InfomationTimeDelayWidget({
    Key? key,
    required this.ido,
  }) : super(key: key);
  final IDOModel ido;

  @override
  Widget build(BuildContext context) {
    final isSubSctription = ido.isSubscription;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              child: Text(
                isSubSctription
                    ? 'launch_pad_time_delay_to_completed'.tr
                    : 'launch_pad_time_delay_to_subscription'.tr,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: AppTextTheme.bodyText2
                    .copyWith(color: AppColorTheme.black50),
              ),
            ),
            SizedBox(width: AppSizes.spaceMedium),
            _TimeDelayWidget(ido: ido),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSubSctription
                    ? 'launch_pad_end_time'.tr
                    : 'launch_pad_start_time'.tr,
                style: AppTextTheme.bodyText2
                    .copyWith(color: AppColorTheme.black50),
              ),
              SizedBox(width: AppSizes.spaceMedium),
              Flexible(
                child: Text(
                  isSubSctription ? ido.timeEndFormat : ido.timeStartFormat,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.bodyText2.copyWith(
                      color: AppColorTheme.black80,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _TimeDelayWidget extends StatelessWidget {
  const _TimeDelayWidget({
    Key? key,
    required this.ido,
  }) : super(key: key);
  final IDOModel ido;

  @override
  Widget build(BuildContext context) {
    final delayTime = ido.delayTime;
    final date = delayTime.inDays;
    final hour = delayTime.inHours - delayTime.inDays * 24;
    final minute = delayTime.inMinutes - delayTime.inHours * 60 + 1;
    return Row(children: [
      _TimeBoxWidget(time: date.toString()),
      const SizedBox(width: 4.0),
      Text(
        'D',
        style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black),
      ),
      const SizedBox(width: 4.0),
      _TimeBoxWidget(time: hour.toString()),
      const SizedBox(width: 4.0),
      Text('H',
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black)),
      const SizedBox(width: 4.0),
      _TimeBoxWidget(time: minute.toString()),
      const SizedBox(width: 4.0),
      Text('M',
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black))
    ]);
  }
}

class _TimeBoxWidget extends StatelessWidget {
  const _TimeBoxWidget({
    Key? key,
    required this.time,
  }) : super(key: key);

  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: AppColorTheme.preparation),
      child: Text(
        time,
        style: AppTextTheme.bodyText2,
      ),
    );
  }
}
