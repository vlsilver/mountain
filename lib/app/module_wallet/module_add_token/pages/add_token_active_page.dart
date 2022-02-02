import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_empty_list_widget.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../add_token_controller.dart';

class AddTokenNavigator extends StatelessWidget {
  const AddTokenNavigator({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.85,
      child: Navigator(
        key: Get.nestedKey(AppPages.NAVIGATOR_KEY_ADD_TOKEN),
        initialRoute: AppRoutes.ADD_TOKEN_ADD_ACTIVE,
        onGenerateRoute: (setting) {
          return AppPages.pageNavigatorAddToken(setting.name!);
        },
      ),
    );
  }
}

class AddTokenActivePage extends GetView<AddTokenController> {
  const AddTokenActivePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.borderRadiusVeryLarge),
      ),
      color: AppColorTheme.white,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusNode: controller.focusNode,
        onTap: () {
          controller.focusNode.unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: AppColorTheme.white,
              child: Column(
                children: [
                  SizedBox(height: AppSizes.spaceSmall),
                  Container(
                    height: AppSizes.sizeIcDragAddAccount.height,
                    width: AppSizes.sizeIcDragAddAccount.width,
                    decoration: BoxDecoration(
                      color: AppColorTheme.disable,
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusVeryLarge),
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceSmall),
                  Row(
                    children: [
                      SizedBox(width: AppSizes.spaceMedium),
                      SizedBox(
                        height: 32.0,
                        width: 32.0,
                        child: IconButton(
                            splashRadius: AppSizes.spaceMedium,
                            padding: EdgeInsets.zero,
                            onPressed: controller.handleIcBackOnTap,
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColorTheme.accent,
                            )),
                      ),
                      Expanded(
                        child: Text(
                          'add_token'.tr,
                          style: AppTextTheme.headline2
                              .copyWith(color: AppColorTheme.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CupertinoButton(
                        onPressed: controller.handleTextActionDoneOnTap,
                        padding: EdgeInsets.zero,
                        minSize: 32.0,
                        child: Text(
                          'global_done'.tr,
                          style: AppTextTheme.bodyText1.copyWith(
                              color: AppColorTheme.accent,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(width: AppSizes.spaceMedium),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceMedium),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: AppSizes.spaceMedium),
                          child: GlobalInputSearchWidget(
                              hintText: 'name_token'.tr,
                              onChange: (value) {
                                controller.searchText.value = value;
                              },
                              textInputType: TextInputType.text,
                              color: AppColorTheme.focus),
                        ),
                      ),
                      CupertinoButton(
                        onPressed: controller.handleTextActionNewToken,
                        padding: EdgeInsets.zero,
                        child: Text(
                          'add_new'.tr,
                          style: AppTextTheme.bodyText1.copyWith(
                              color: AppColorTheme.accent,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(width: AppSizes.spaceMedium)
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        height: AppSizes.spaceMedium,
                        decoration: BoxDecoration(
                          color: AppColorTheme.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0.0, 4.0),
                                blurRadius: 4.0,
                                color: AppColorTheme.black25),
                          ],
                        ),
                      ),
                      Container(
                        height: AppSizes.spaceMedium,
                        color: AppColorTheme.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _CoinsOfWalletWidget(),
            )),
          ],
        ),
      ),
    );
  }
}

class _CoinsOfWalletWidget extends GetView<AddTokenController> {
  const _CoinsOfWalletWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddTokenController>(
      id: EnumAddToken.SEARCH,
      builder: (_) {
        if (_.listSearchResult.isEmpty) {
          return GlobalEmptyListWidget(title: 'global_not_found'.tr);
        }
        return Scrollbar(
          child: ListView.builder(
              itemCount: _.listSearchResult.length,
              itemBuilder: (context, index) {
                final coin = _.listSearchResult[index];
                return _CoinItemWidget(
                  coinModel: coin,
                  index: index,
                );
              }),
        );
      },
    );
  }
}

class _CoinItemWidget extends GetView<AddTokenController> {
  const _CoinItemWidget({
    required this.coinModel,
    required this.index,
    Key? key,
  }) : super(key: key);

  final CoinModel coinModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSizes.spaceVerySmall),
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spaceSmall, vertical: AppSizes.spaceSmall),
      decoration: BoxDecoration(
          color: AppColorTheme.focus,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 56.0,
            width: 56.0,
            padding: EdgeInsets.all(AppSizes.spaceNormal),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppColorTheme.card),
            child: GlobalAvatarCoinWidget(coinModel: coinModel),
          ),
          SizedBox(width: AppSizes.spaceMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(coinModel.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.bodyText1.copyWith(
                                color: AppColorTheme.black,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(width: AppSizes.spaceNormal),
                      Text(coinModel.symbol,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.bodyText1.copyWith(
                              color: AppColorTheme.error,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Text(coinModel.type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.bodyText2
                        .copyWith(color: AppColorTheme.black60)),
              ],
            ),
          ),
          SizedBox(width: AppSizes.spaceMedium),
          GetBuilder<AddTokenController>(
            id: index,
            builder: (_) {
              return CupertinoSwitch(
                  activeColor: AppColorTheme.toggleableActiveColor,
                  trackColor: Colors.black.withOpacity(0.3),
                  value: coinModel.isActive,
                  onChanged: (value) {
                    _.handleSwitchOnTap(index: index, coinModel: coinModel);
                  });
            },
          ),
        ],
      ),
    );
  }
}
