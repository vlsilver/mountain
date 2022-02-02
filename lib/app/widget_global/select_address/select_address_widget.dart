import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_wallet/module_create_address/create_new_address_controller.dart';
import 'package:base_source/app/module_wallet/module_create_address/create_new_address_page.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SelectAddressWidget extends StatefulWidget {
  const SelectAddressWidget({
    required this.blockChains,
    required this.addressModel,
    this.isFavourite = false,
    this.height,
    this.add = true,
    Key? key,
  }) : super(key: key);

  final List<BlockChainModel> blockChains;
  final AddressModel addressModel;
  final double? height;
  final bool add;
  final bool isFavourite;

  @override
  _SelectAddressWidgetState createState() => _SelectAddressWidgetState();
}

class _SelectAddressWidgetState extends State<SelectAddressWidget> {
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
        height: widget.height ?? Get.height * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSizes.spaceSmall),
            Row(
              children: [
                SizedBox(
                  height: 48.0,
                  width: 48.0,
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColorTheme.accent,
                      )),
                ),
                Expanded(
                  child: Text(
                    'select_address'.tr,
                    style: AppTextTheme.headline2
                        .copyWith(color: AppColorTheme.accent),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 32.0,
                  child: widget.add
                      ? CupertinoButton(
                          onPressed: handleButtonCreateNewAddressOnTap,
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          child: Icon(
                            Icons.add_rounded,
                            size: 32,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 16.0)
              ],
            ),
            const SizedBox(height: AppSizes.spaceSmall),
            Expanded(
                child: ListView.builder(
              itemCount: widget.blockChains.length,
              itemBuilder: (context, index) {
                final blockChain = widget.blockChains[index];
                final addresss = widget.isFavourite
                    ? blockChain.addresssFavourite
                    : blockChain.addresss;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: AppColorTheme.accent20,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.spaceSmall,
                          horizontal: AppSizes.spaceLarge),
                      child: Text(
                        blockChain.network,
                        style: AppTextTheme.bodyText1.copyWith(
                          color: AppColorTheme.containerActive,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: addresss
                          .map((address) => _AddressItemWidget(
                                addressModel: address,
                                index: index,
                                isSelected: address.address ==
                                        widget.addressModel.address &&
                                    blockChain.id ==
                                        widget.addressModel.blockChainId,
                              ))
                          .toList(),
                    )
                  ],
                );
              },
            )),
          ],
        ));
  }

  void handleButtonCreateNewAddressOnTap() async {
    final createnewAddressController = Get.put(CreateNewAddressController());
    if (widget.addressModel.address != '') {
      createnewAddressController.blockChainId =
          widget.addressModel.blockChainId;
    } else {
      createnewAddressController.blockChainId = widget.blockChains[0].id;
    }
    await Get.bottomSheet(
        GlobalBottomSheetLayoutWidget(
            height: widget.height == null
                ? Get.height * 0.8
                : widget.height! * 0.95,
            child: CreateNewAddressPage(
              tab: 0,
              isBack: false,
            )),
        isScrollControlled: true);
    setState(() {});
    await Get.delete<CreateNewAddressController>();
  }
}

class _AddressItemWidget extends StatelessWidget {
  const _AddressItemWidget({
    required this.addressModel,
    required this.isSelected,
    required this.index,
    Key? key,
  }) : super(key: key);

  final AddressModel addressModel;
  final bool? isSelected;
  final int index;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        Get.back<AddressModel>(result: addressModel);
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceVerySmall, vertical: AppSizes.spaceSmall),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceMedium, vertical: AppSizes.spaceSmall),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(addressModel.avatarAddress),
            SizedBox(width: AppSizes.spaceMedium),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(addressModel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.bodyText2.copyWith(
                              color: AppColorTheme.black,
                              fontWeight: FontWeight.w600)),
                      Flexible(
                        child: Text(addressModel.addreesFormatWithRoundBrackets,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.bodyText2
                                .copyWith(color: AppColorTheme.black60)),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Text(
                      addressModel.surPlus,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText2
                          .copyWith(color: AppColorTheme.error),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: AppSizes.spaceNormal),
            isSelected == null
                ? SizedBox.shrink()
                : isSelected!
                    ? Icon(
                        Icons.check_circle_outline,
                        color: AppColorTheme.toggleableActiveColor,
                      )
                    : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
