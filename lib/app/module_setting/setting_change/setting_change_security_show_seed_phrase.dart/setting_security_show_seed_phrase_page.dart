import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_security_show_seed_phrase.dart/setting_sercurity_show_seed_phrase_controller.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SettingSecurityShowSeedPhrasePage
    extends GetView<SettingSecurityShowSeedPhraseController> {
  const SettingSecurityShowSeedPhrasePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      child: InkWell(
        focusNode: controller.focusNode,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          controller.step == 1 ? controller.handleScreenOnTap() : null;
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSizes.spaceNormal),
              Text(
                'rootphasePass'.tr,
                style:
                    AppTextTheme.headline2.copyWith(color: AppColorTheme.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.spaceMedium),
              Text(
                'rootphase_desc'.tr,
                style: AppTextTheme.bodyText2
                    .copyWith(color: AppColorTheme.black, fontSize: 13),
              ),
              SizedBox(height: AppSizes.spaceSmall),
              Text.rich(TextSpan(
                  text: 'not_desc'.tr,
                  style: AppTextTheme.bodyText1.copyWith(
                      color: AppColorTheme.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                  children: [
                    TextSpan(
                        text: 'not_descV1'.tr,
                        style: AppTextTheme.bodyText1
                            .copyWith(color: AppColorTheme.black, fontSize: 13))
                  ])),
              SizedBox(height: AppSizes.spaceMedium),
              Expanded(
                child: GetBuilder<SettingSecurityShowSeedPhraseController>(
                  id: EnumUpdateSettingSecurityShowSeedPhrase.FORM,
                  builder: (_) {
                    return _.step == 1
                        ? _InputPasswordWidget()
                        : _GroupTabarBarWidget();
                  },
                ),
              ),
              SizedBox(height: AppSizes.spaceMedium),
              GetBuilder<SettingSecurityShowSeedPhraseController>(
                id: EnumUpdateSettingSecurityShowSeedPhrase.BUTTON,
                builder: (_) {
                  return GlobalButtonWidget(
                      name: _.step == 1 ? 'global_btn_continue'.tr : 'closeS'.tr,
                      type: _.isActiveButton
                          ? ButtonType.ACTIVE
                          : ButtonType.DISABLE,
                      onTap: () {
                        controller.handleButtonConitnueOnTap();
                      });
                },
              ),
              SizedBox(height: AppSizes.spaceVeryLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputPasswordWidget
    extends GetView<SettingSecurityShowSeedPhraseController> {
  const _InputPasswordWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        controller.handleOnChangeInput();
      },
      key: controller.formKey,
      child: GetBuilder<SettingSecurityShowSeedPhraseController>(
        id: EnumUpdateSettingSecurityShowSeedPhrase.INPUT_TEXT,
        builder: (_) {
          return GlobalInputSecurityWidget(
              controller: _.passwordController,
              validator: _.validatorPassword,
              onTap: _.handleInputOnTap,
              security: _.security,
              hintText: 'enter_pass'.tr,
              color: AppColorTheme.backGround,
              onTapIcEye: _.handleIconEyeOnTap);
        },
      ),
    );
  }
}

class _GroupTabarBarWidget extends StatelessWidget {
  const _GroupTabarBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          _GroupTabarWidget(),
          SizedBox(height: AppSizes.spaceLarge),
          _GroupTabViewWidget()
        ],
      ),
    );
  }
}

class _GroupTabViewWidget
    extends GetView<SettingSecurityShowSeedPhraseController> {
  const _GroupTabViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(children: [
        Container(
          padding: EdgeInsets.all(AppSizes.spaceMedium),
          decoration: BoxDecoration(
              color: AppColorTheme.backGround,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'root_pass'.tr,
                    style: AppTextTheme.bodyText1
                        .copyWith(color: AppColorTheme.black),
                  ),
                  IconButton(
                    onPressed: controller.handleIconCopyOntap,
                    icon: Icon(
                      Icons.file_copy_outlined,
                      color: AppColorTheme.accent,
                    ),
                  )
                ],
              ),
              SizedBox(height: AppSizes.spaceSmall),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceMedium),
                child: Text(
                  controller.menemonic,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.headline2
                      .copyWith(color: AppColorTheme.accent),
                ),
              )
            ],
          ),
        ),
        Container(
            alignment: Alignment.center,
            child: QrImage(
              data: controller.menemonic,
              gapless: false,
              errorStateBuilder: (cxt, err) {
                return Container(
                  child: Center(
                    child: Text(
                      'Uh oh! Something went wrong...',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ))
      ]),
    );
  }
}

class _GroupTabarWidget
    extends GetView<SettingSecurityShowSeedPhraseController> {
  const _GroupTabarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
        indicatorWeight: 3.0,
        indicatorColor: AppColorTheme.accent,
        labelColor: AppColorTheme.accent,
        labelStyle: AppTextTheme.bodyText1.copyWith(fontSize: 18),
        unselectedLabelColor: AppColorTheme.black60,
        onTap: (index) {},
        tabs: [
          Text('docs'.tr),
          Text('qr_'.tr),
        ]);
  }
}
