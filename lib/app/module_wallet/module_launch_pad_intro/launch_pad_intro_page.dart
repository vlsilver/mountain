import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';

class LaunchPadIntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColorTheme.focus,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          const _BannerMoonWidget(),
          const _WhyIsGroupWidget(),
          const _WhyUseGroupWidget(),
          const _HowUseGroupWidget(),
          const _TimeLineWidget(),
          const _WhyChoiceGroupWidget(),
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

class _WhyChoiceGroupWidget extends StatelessWidget {
  const _WhyChoiceGroupWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: AppSizes.spaceMedium),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
            child: Text(
              'launch_pad_intro_why_choose'.tr,
              style: AppTextTheme.body.copyWith(
                  color: AppColorTheme.introTitle, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: AppSizes.spaceMedium),
          Container(
            color: AppColorTheme.introBg,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceMedium,
                vertical: AppSizes.spaceLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ItemWhyChooseWidget(
                  title: 'launch_pad_intro_title1'.tr,
                  desc: 'launch_pad_intro_desc1'.tr,
                ),
                _ItemWhyChooseWidget(
                  title: 'launch_pad_intro_title2'.tr,
                  desc: 'launch_pad_intro_desc2'.tr,
                ),
                _ItemWhyChooseWidget(
                  title: 'launch_pad_intro_title3'.tr,
                  desc: 'launch_pad_intro_desc3'.tr,
                ),
                _ItemWhyChooseWidget(
                  title: 'launch_pad_intro_title4'.tr,
                  desc: 'launch_pad_intro_desc4'.tr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemWhyChooseWidget extends StatelessWidget {
  const _ItemWhyChooseWidget({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.spaceNormal),
      margin: EdgeInsets.symmetric(vertical: AppSizes.spaceSmall),
      decoration: BoxDecoration(
          color: AppColorTheme.focus,
          borderRadius: BorderRadius.circular(AppSizes.spaceNormal)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextTheme.bodyText1.copyWith(
                height: 1.5,
                color: AppColorTheme.introTitle,
                fontWeight: FontWeight.w400),
          ),
          Text(
            desc,
            style: AppTextTheme.bodyText2.copyWith(
                height: 1.5,
                color: AppColorTheme.black80,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class _WhyUseGroupWidget extends StatelessWidget {
  const _WhyUseGroupWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text(
            //   'launch_pad_intro_why_use_title'.tr,
            //   style: AppTextTheme.body.copyWith(
            //       color: AppColorTheme.introTitle, fontWeight: FontWeight.w600),
            // ),
            // SizedBox(height: AppSizes.spaceMedium),
            // Text(
            //   'launch_pad_intro_why_use_desc'.tr,
            //   style: AppTextTheme.bodyText2.copyWith(
            //       height: 1.5,
            //       color: AppColorTheme.black80,
            //       fontWeight: FontWeight.w400),
            // ),
            Image.asset(
              'assets/launchpad/launch_pad_contact.png',
              height: Get.width / 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _HowUseGroupWidget extends StatelessWidget {
  const _HowUseGroupWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'launch_pad_intro_why_use_title'.tr,
              style: AppTextTheme.body.copyWith(
                  color: AppColorTheme.introTitle, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: AppSizes.spaceMedium),
            Text(
              'launch_pad_intro_how_use_desc'.tr,
              style: AppTextTheme.bodyText2.copyWith(
                  height: 1.5,
                  color: AppColorTheme.black80,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhyIsGroupWidget extends StatelessWidget {
  const _WhyIsGroupWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text(
            //   'launch_pad_intro_why_is_title'.tr,
            //   style: AppTextTheme.body.copyWith(
            //       color: AppColorTheme.introTitle, fontWeight: FontWeight.w600),
            // ),
            // SizedBox(height: AppSizes.spaceMedium),
            // Text(
            //   'launch_pad_intro_why_is_desc'.tr,
            //   style: AppTextTheme.bodyText2.copyWith(
            //       height: 1.5,
            //       color: AppColorTheme.black80,
            //       fontWeight: FontWeight.w400),
            // ),
            // SizedBox(height: AppSizes.spaceMedium),
            // Image.asset(
            //   'assets/launchpad/launch_pad_arrow.png',
            //   height: Get.width / 2,
            // ),
          ],
        ),
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
                textAlign: TextAlign.center,
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

class _TimeLineWidget extends StatelessWidget {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      _StepTimeLineWidget(
                        step: '1',
                        isActive: true,
                      ),
                      SizedBox(height: AppSizes.spaceSmall),
                      Container(width: 1.0, color: AppColorTheme.iconActive)
                    ],
                  ),
                  SizedBox(width: AppSizes.spaceSmall),
                  Expanded(child: const _SubscriptionWidget())
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StepTimeLineWidget(
                    step: '2',
                    isActive: true,
                  ),
                  SizedBox(width: AppSizes.spaceSmall),
                  Expanded(
                    child: const _FinalDistributionWidget(),
                  )
                ],
              ),
            ],
          )),
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

class _FinalDistributionWidget extends StatelessWidget {
  const _FinalDistributionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'launch_pad_intro_final_period'.tr,
          style: AppTextTheme.bodyText1.copyWith(
              color: AppColorTheme.black, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          'launch_pad_intro_final_detail'.tr,
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black60),
        ),
        SizedBox(height: AppSizes.spaceNormal),
      ],
    );
  }
}

class _SubscriptionWidget extends StatelessWidget {
  const _SubscriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'launch_pad_intro_subscription_period'.tr,
          style: AppTextTheme.bodyText1.copyWith(
              color: AppColorTheme.black, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: AppSizes.spaceVerySmall),
        Text(
          'launch_pad_intro_participate'.tr,
          style: AppTextTheme.bodyText2.copyWith(color: AppColorTheme.black60),
        ),
        SizedBox(height: AppSizes.spaceNormal),
      ],
    );
  }
}
