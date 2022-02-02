import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/module_setting/setting_change/setting_security_show_password/setting_sercurity_show_privatekey_controller.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SettingSecurityShowPrivateKeyPage
    extends GetView<SettingSecurityShowPrivateKeyController> {
  const SettingSecurityShowPrivateKeyPage({Key? key}) : super(key: key);
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
                'showPrivate'.tr,
                style:
                    AppTextTheme.headline2.copyWith(color: AppColorTheme.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.spaceMedium),
              GetBuilder<SettingSecurityShowPrivateKeyController>(
                id: EnumUpdateSettingSecurityShowPrivateKey.TITLE,
                builder: (_) {
                  return Text(
                    _.step == 2 ? 'selectAddress'.tr : 'privateKey'.tr,
                    style: AppTextTheme.bodyText1
                        .copyWith(color: AppColorTheme.black, fontSize: 13),
                  );
                },
              ),
              SizedBox(height: AppSizes.spaceMedium),
              Expanded(
                child: GetBuilder<SettingSecurityShowPrivateKeyController>(
                  id: EnumUpdateSettingSecurityShowPrivateKey.FORM,
                  builder: (_) {
                    return _.step == 1
                        ? _InputPasswordWidget()
                        : _.step == 2
                            ? _AddresssOfWalletWidget()
                            : _GroupTabarBarWidget();
                  },
                ),
              ),
              SizedBox(height: AppSizes.spaceMedium),
              GetBuilder<SettingSecurityShowPrivateKeyController>(
                id: EnumUpdateSettingSecurityShowPrivateKey.BUTTON,
                builder: (_) {
                  return _.step == 2
                      ? SizedBox()
                      : GlobalButtonWidget(
                          name: !(_.step == 3)
                              ? 'global_btn_continue'.tr
                              : 'key_close'.tr,
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
    extends GetView<SettingSecurityShowPrivateKeyController> {
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
      child: GetBuilder<SettingSecurityShowPrivateKeyController>(
        id: EnumUpdateSettingSecurityShowPrivateKey.INPUT_TEXT,
        builder: (_) {
          return GlobalInputSecurityWidget(
              controller: _.passwordController,
              validator: _.validatorPassword,
              onTap: _.handleInputOnTap,
              security: _.security,
              hintText: 'enterPass'.tr,
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
    extends GetView<SettingSecurityShowPrivateKeyController> {
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
                    'root_key'.tr,
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
                  controller.privateKey,
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
              data: controller.privateKey,
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
    extends GetView<SettingSecurityShowPrivateKeyController> {
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
          Text('doc_key'.tr),
          Text('qr_key'.tr),
        ]);
  }
}

class _AddresssOfWalletWidget
    extends GetView<SettingSecurityShowPrivateKeyController> {
  const _AddresssOfWalletWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: controller.blockChains.length,
        itemBuilder: (context, index) {
          final blockChain = controller.blockChains[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blockChain.network,
                style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.accent, fontWeight: FontWeight.bold),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: blockChain.addresss.map((address) {
                    return _AddressItemWidget(
                      indexOfCoin: blockChain.index,
                      addressModel: address,
                    );
                  }).toList()),
              SizedBox(height: AppSizes.spaceNormal),
            ],
          );
        });
  }
}

class _AddressItemWidget
    extends GetView<SettingSecurityShowPrivateKeyController> {
  const _AddressItemWidget({
    required this.addressModel,
    required this.indexOfCoin,
    Key? key,
  }) : super(key: key);

  final AddressModel addressModel;
  final int indexOfCoin;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleButtonConitnueOnTap(addressModel: addressModel);
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSizes.spaceVerySmall),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceSmall, vertical: AppSizes.spaceSmall),
        height: 52.0,
        decoration: BoxDecoration(
            color: AppColorTheme.card60,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(addressModel.avatarAddress),
            SizedBox(width: AppSizes.spaceMedium),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(addressModel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.bodyText2.copyWith(
                        color: AppColorTheme.black,
                        fontWeight: FontWeight.w600)),
                Text(addressModel.addressFormat,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.bodyText2
                        .copyWith(color: AppColorTheme.black60)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
