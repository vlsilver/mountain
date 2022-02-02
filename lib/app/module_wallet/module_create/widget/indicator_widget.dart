import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_wallet/module_create/create_wallet/create_wallet_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupIndicatorWidget extends GetView<CreateWalletController> {
  const GroupIndicatorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: controller.tagHeroIndicator,
      child: Container(
        height: AppSizes.spaceMax,
        child: Center(
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 2 * AppSizes.spaceLarge,
                  ),
                  Container(
                    height: AppSizes.sizeGroupIndicatorStepSetupWallet.height,
                    width: AppSizes.sizeGroupIndicatorStepSetupWallet.width,
                    child: Stack(
                      children: [
                        Center(
                            child: Stack(
                          children: [
                            Container(color: Color(0xFFFDFDFD), height: 4.0),
                            _IndicatorSetupLoadingWidgetBuilder()
                          ],
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _IndicatorStepWidgetBuilder(step: 1),
                            _IndicatorStepWidgetBuilder(step: 2),
                            _IndicatorStepWidgetBuilder(step: 3),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.spaceLarge,
                  ),
                  SizedBox(
                    width: AppSizes.spaceLarge,
                    child: _CurrentStepWidgetObx(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndicatorSetupLoadingWidgetBuilder extends StatelessWidget {
  const _IndicatorSetupLoadingWidgetBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateWalletController>(
        id: EnumUpdateCreateWallet.STEP,
        builder: (_) => AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: _.widthIndicatorSetupLoading,
              height: 4.0,
              color: AppColorTheme.textAccent80,
            ));
  }
}

class _CurrentStepWidgetObx extends GetView<CreateWalletController> {
  const _CurrentStepWidgetObx({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${controller.step}/3',
      style: AppTextTheme.bodyText1.copyWith(color: Colors.black),
    );
  }
}

class _IndicatorStepWidgetBuilder extends StatelessWidget {
  final int step;
  const _IndicatorStepWidgetBuilder({
    Key? key,
    required this.step,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateWalletController>(
      id: EnumUpdateCreateWallet.STEP,
      builder: (_) => Container(
        width: 18.0,
        height: 18.0,
        decoration: _.stepIsLoading(step)
            ? BoxDecoration(
                border: Border.all(color: AppColorTheme.textAccent, width: 2.0),
                shape: BoxShape.circle,
                color: Color(0xFFFDFDFD),
              )
            : _.stepSucessed(step)
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColorTheme.textAccent,
                  )
                : BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFDFDFD),
                  ),
      ),
    );
  }
}
