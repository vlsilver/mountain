import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_project/ido_project_controller.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/launchpad_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class IDOProjectPage extends GetView<IDOProjectController> {
  const IDOProjectPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          const _InformationIDOWidget(),
          const _TimeLineWidget(),
          const _AmountDepositWdiget(),
          const _ProjectIntroductionWidget(),
          SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceMax)),
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
        controller.idoModel.name,
        style: AppTextTheme.titleAppbar,
      ),
    );
  }
}

class _ProjectIntroductionWidget extends GetView<IDOProjectController> {
  const _ProjectIntroductionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMedium,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: AppSizes.spaceMedium),
        Text(
          'project_introduction'.tr.toUpperCase(),
          textAlign: TextAlign.start,
          style: AppTextTheme.body.copyWith(
            color: AppColorTheme.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSizes.spaceNormal),
        Text(
          controller.idoModel.desc,
          textAlign: TextAlign.start,
          style: AppTextTheme.bodyText2.copyWith(
            color: AppColorTheme.black80,
          ),
        ),
      ]),
    ));
  }
}

class _AmountDepositWdiget extends StatelessWidget {
  const _AmountDepositWdiget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IDOProjectController>(
      id: EnumIDOProject.AMOUNT,
      builder: (_) {
        return SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: AppSizes.spaceMedium,
                vertical: AppSizes.spaceNormal),
            padding: EdgeInsets.all(AppSizes.spaceSmall),
            decoration: BoxDecoration(
                color: AppColorTheme.focus,
                border:
                    Border.all(color: AppColorTheme.textAction, width: 0.25),
                borderRadius: BorderRadius.circular(AppSizes.spaceNormal)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _InfoOfBaseTokenWidget(
                      title: 'total_base_token'
                          .trParams({'base': _.idoModel.baseCrypto})!,
                      value: _.idoModel.formatTotalAmountBaseToken),
                ),
                SizedBox(width: AppSizes.spaceSmall),
                Expanded(
                  child: _InfoOfBaseTokenWidget(
                      title: 'amount_deposit'.tr,
                      value: _.idoModel.formatAmountDeposited),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoOfBaseTokenWidget extends StatelessWidget {
  const _InfoOfBaseTokenWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style:
              AppTextTheme.bodyText2.copyWith(color: AppColorTheme.textAction),
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: AppTextTheme.bodyText2.copyWith(
              color: AppColorTheme.black, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _InformationIDOWidget extends GetView<IDOProjectController> {
  const _InformationIDOWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMedium,
          vertical: AppSizes.spaceLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                const _IDOBannerWdiget(),
                const _StatusIDOWidget(),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceNormal,
                  vertical: AppSizes.spaceMedium),
              decoration: BoxDecoration(
                color: AppColorTheme.focus,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(AppSizes.borderRadiusNormal),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    controller.idoModel.name,
                    textAlign: TextAlign.start,
                    style: AppTextTheme.bodyText1.copyWith(
                      color: AppColorTheme.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceVerySmall),
                  Text(
                    controller.idoModel.chainName,
                    textAlign: TextAlign.start,
                    style: AppTextTheme.bodyText1
                        .copyWith(color: AppColorTheme.black50),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: AppSizes.spaceNormal),
                      height: 0.25,
                      child: Divider(color: AppColorTheme.black25)),
                  _InfomationWidget(),
                  Container(
                      margin:
                          const EdgeInsets.only(bottom: AppSizes.spaceNormal),
                      height: 0.25,
                      child: Divider(color: AppColorTheme.black25)),
                  const _SocialGroupWidget()
                ],
              ),
            ),
            SizedBox(height: AppSizes.spaceLarge),
          ],
        ),
      ),
    );
  }
}

class _TimeLineWidget extends GetView<IDOProjectController> {
  const _TimeLineWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMedium,
        ),
        child: GetBuilder<LaunchPadController>(
          id: EnumLaunchPad.IDO_ITEM,
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'launch_pad_subscription_timeline'.tr.toUpperCase(),
                  textAlign: TextAlign.start,
                  style: AppTextTheme.body.copyWith(
                    color: AppColorTheme.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppSizes.spaceNormal),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        _StepTimeLineWidget(
                          step: '1',
                          isActive: controller.idoModel.isSubscription,
                        ),
                        SizedBox(height: AppSizes.spaceSmall),
                        Container(
                            height: controller.idoModel.isSubscription
                                ? 188.0
                                : 48.0,
                            width: 1.0,
                            color: AppColorTheme.iconActive)
                      ],
                    ),
                    SizedBox(width: AppSizes.spaceSmall),
                    Expanded(
                      child: const _SubscriptionWidget(),
                    )
                  ],
                ),
                SizedBox(height: AppSizes.spaceMedium),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepTimeLineWidget(
                      step: '2',
                      isActive: controller.idoModel.isFinished,
                    ),
                    SizedBox(width: AppSizes.spaceSmall),
                    Expanded(
                      child: const _FinalDistributionWidget(),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StepTimeLineWidget extends StatelessWidget {
  const _StepTimeLineWidget({
    Key? key,
    required this.step,
    required this.isActive,
  }) : super(key: key);

  final String step;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.0,
      width: 28.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColorTheme.iconActive : AppColorTheme.disable,
      ),
      alignment: Alignment.center,
      child: Text(
        step,
        style: AppTextTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _FinalDistributionWidget extends GetView<IDOProjectController> {
  const _FinalDistributionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'launch_pad_final_period'.tr,
          style: AppTextTheme.bodyText1.copyWith(
              color: AppColorTheme.black, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          controller.idoModel.timeEndFormat,
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black40),
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          'launch_pad_final_detail'.trParams({
            'base': controller.idoModel.baseCrypto,
            'symbol': controller.idoModel.symbol
          })!,
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black40),
        ),
        SizedBox(height: AppSizes.spaceNormal),
        controller.idoModel.isFinished
            ? Container(
                padding: EdgeInsets.all(AppSizes.spaceMedium),
                decoration: BoxDecoration(
                  color: AppColorTheme.focus,
                  border:
                      Border.all(color: AppColorTheme.iconActive, width: 0.25),
                  borderRadius: BorderRadius.circular(AppSizes.spaceSmall),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'launch_pad_title_claim'.trParams({
                        'base': controller.idoModel.baseCrypto,
                        'symbol': controller.idoModel.symbol
                      })!,
                      style: AppTextTheme.bodyText2
                          .copyWith(color: AppColorTheme.black80),
                    ),
                    SizedBox(height: AppSizes.spaceVerySmall),
                    Text(
                      controller.idoModel.formatRateWithBaseToken,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText2.copyWith(
                          color: AppColorTheme.black80,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: AppSizes.spaceMedium),
                    _ButtonSubscriptionWidget(
                      name: 'global_claim'.tr,
                      onTap: () {
                        controller.handleClaimButtonOnTap();
                      },
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ],
    );
  }
}

class _SubscriptionWidget extends GetView<IDOProjectController> {
  const _SubscriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'launch_pad_subscription_period'.tr,
          style: AppTextTheme.bodyText1.copyWith(
              color: AppColorTheme.black, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          controller.idoModel.timeStartFormat,
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black40),
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          'launch_pad_participate'.trParams({
            'base': controller.idoModel.baseCrypto,
            'symbol': controller.idoModel.symbol
          })!,
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black40),
        ),
        SizedBox(height: AppSizes.spaceNormal),
        controller.idoModel.isSubscription
            ? Container(
                padding: EdgeInsets.all(AppSizes.spaceMedium),
                decoration: BoxDecoration(
                  color: AppColorTheme.focus,
                  border:
                      Border.all(color: AppColorTheme.iconActive, width: 0.25),
                  borderRadius: BorderRadius.circular(AppSizes.spaceSmall),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'launch_pad_title_deposit'.trParams({
                        'base': controller.idoModel.baseCrypto,
                        'symbol': controller.idoModel.symbol
                      })!,
                      style: AppTextTheme.bodyText2
                          .copyWith(color: AppColorTheme.black80),
                    ),
                    SizedBox(height: AppSizes.spaceVerySmall),
                    Text(
                      controller.idoModel.formatRateWithBaseToken,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText2.copyWith(
                          color: AppColorTheme.black80,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: AppSizes.spaceMedium),
                    _ButtonSubscriptionWidget(
                      name: 'global_deposit'.tr,
                      onTap: controller.handleDepositButtonOnTap,
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ],
    );
  }
}

class _ButtonSubscriptionWidget extends StatelessWidget {
  const _ButtonSubscriptionWidget({
    Key? key,
    required this.onTap,
    required this.name,
  }) : super(key: key);

  final Function onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        onTap();
      },
      padding: EdgeInsets.zero,
      child: Container(
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceSmall),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5FB2FF),
              Color(0xFF3BA0FF),
              Color(0xFF3887FE),
            ],
            stops: [0.0, 0.5, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          name,
          style: AppTextTheme.body,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _SocialGroupWidget extends GetView<IDOProjectController> {
  const _SocialGroupWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ido = controller.idoModel;
    return Column(
      children: [
        Wrap(
          spacing: AppSizes.spaceLarge,
          alignment: WrapAlignment.center,
          children: [
            _SocialWidget(
              asset: 'assets/global/ic_twitter.svg',
              url: ido.twitter!,
              isHave: ido.isHaveTwitter,
            ),
            _SocialWidget(
              asset: 'assets/global/ic_facebook.svg',
              url: ido.facebook!,
              isHave: ido.isHaveFacebook,
            ),
            _SocialWidget(
              asset: 'assets/global/ic_telegram.svg',
              url: ido.telegram!,
              isHave: ido.isHaveTelegram,
            ),
            _SocialWidget(
              asset: 'assets/global/ic_reddit.svg',
              url: ido.reddit!,
              isHave: ido.isHaveReddit,
            ),
            _SocialWidget(
              asset: 'assets/global/ic_coingecko.svg',
              url: ido.coinGecko!,
              isHave: ido.isHaveCoingecko,
            ),
          ],
        ),
        SizedBox(height: AppSizes.spaceMedium),
        ido.isWebsite
            ? CupertinoButton(
                onPressed: () {
                  controller.handleSocialButtonOnTap(ido.website!);
                },
                minSize: 0.0,
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceMedium,
                    vertical: AppSizes.spaceSmall),
                borderRadius: BorderRadius.circular(AppSizes.spaceSmall),
                color: AppColorTheme.social,
                child: Text(
                  'launch_pad_visit_website'.tr,
                  style: AppTextTheme.bodyText2,
                ),
              )
            : SizedBox(),
      ],
    );
  }
}

class _SocialWidget extends GetView<IDOProjectController> {
  const _SocialWidget({
    Key? key,
    required this.url,
    required this.asset,
    required this.isHave,
  }) : super(key: key);

  final String url;
  final String asset;
  final bool isHave;

  @override
  Widget build(BuildContext context) {
    return isHave
        ? CupertinoButton(
            onPressed: () {
              controller.handleSocialButtonOnTap(url);
            },
            padding: EdgeInsets.zero,
            minSize: 0.0,
            child: SvgPicture.asset(
              asset,
              height: 24.0,
              width: 24.0,
            ),
          )
        : SizedBox();
  }
}

class _StatusIDOWidget extends GetView<IDOProjectController> {
  const _StatusIDOWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LaunchPadController>(
      id: !controller.idoModel.isFinished
          ? EnumLaunchPad.IDO_ITEM
          : controller.idoModel.index,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(AppSizes.spaceSmall),
          decoration: BoxDecoration(
              color: controller.idoModel.isFinished
                  ? AppColorTheme.disable
                  : AppColorTheme.active,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.borderRadiusNormal),
                  bottomRight: Radius.circular(AppSizes.borderRadiusNormal))),
          child: Text(
            controller.idoModel.isFinished
                ? 'global_completed'.tr.toUpperCase()
                : 'launch_pad_register'.tr,
            style: AppTextTheme.bodyText2.copyWith(fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }
}

class _IDOBannerWdiget extends GetView<IDOProjectController> {
  const _IDOBannerWdiget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.idoModel.imageBanner == null
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
                  controller.idoModel.icon,
                  height: 48.0,
                  width: 48.0,
                ),
                const SizedBox(width: AppSizes.spaceMedium),
                Flexible(
                  child: Text(
                    controller.idoModel.name,
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
                    image: NetworkImage(controller.idoModel.imageBanner!),
                    fit: BoxFit.fill)),
          );
  }
}

class _InfomationWidget extends GetView<IDOProjectController> {
  const _InfomationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'launch_pad_sale_price'.tr,
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black50),
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          controller.idoModel.formatRateWithBaseToken,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextTheme.bodyText2.copyWith(
              color: AppColorTheme.black80, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: AppSizes.spaceNormal),
        Text(
          'launch_pad_token_offered'.tr,
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black50),
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          controller.idoModel.formatTokenAmountOfferedWithSymbol,
          textAlign: TextAlign.end,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextTheme.bodyText2.copyWith(
              color: AppColorTheme.black80, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: AppSizes.spaceNormal),
        Text(
          'launch_pad_hard_cap'.tr,
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black50),
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          controller.idoModel.formatMaxBuy,
          textAlign: TextAlign.end,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextTheme.bodyText2.copyWith(
              color: AppColorTheme.black80, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: AppSizes.spaceNormal),
      ],
    );
  }
}
