import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/module_wallet/widget/appbar_title_widget.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_empty_list_widget.dart';
import 'package:base_source/app/widget_global/global_input_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../request_receive_controller.dart';

class ReceiveNavigatorPage extends StatelessWidget {
  const ReceiveNavigatorPage(
      {this.initialPage = AppRoutes.REQUEST_RECIEVE_SELECT, Key? key})
      : super(key: key);

  final String initialPage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.85,
      child: Navigator(
        key: Get.nestedKey(AppPages.NAVIGATOR_KEY_REQUEST_RECEIVE),
        initialRoute: initialPage,
        onGenerateRoute: (setting) {
          return AppPages.pageNavigatorRequestRecieve(setting.name!);
        },
      ),
    );
  }
}

class SelectCoinPage extends GetView<RequestRecieveController> {
  const SelectCoinPage({
    Key? key,
    this.isBack = false,
    this.idBack,
  }) : super(key: key);

  final bool isBack;
  final int? idBack;

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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceLarge),
                    child: AppBarWidget(
                        title: 'select_token'.tr,
                        onTap: () {
                          Get.back();
                        }),
                  ),
                  SizedBox(height: AppSizes.spaceMedium),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: AppSizes.spaceMedium),
                    child: GlobalInputSearchWidget(
                        hintText: 'search_token'.tr,
                        onChange: (value) {
                          controller.searchText.value = value;
                        },
                        textInputType: TextInputType.text,
                        color: AppColorTheme.focus),
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
              child: _CoinsOfWalletWidget(
                isBack: isBack,
                idBack: idBack,
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _CoinsOfWalletWidget extends GetView<RequestRecieveController> {
  const _CoinsOfWalletWidget({
    Key? key,
    required this.isBack,
    required this.idBack,
  }) : super(key: key);

  final bool isBack;
  final int? idBack;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestRecieveController>(
      id: EnumRequestReceive.SEARCH,
      builder: (_) {
        if (_.coinsSearch.isEmpty) {
          return GlobalEmptyListWidget(title: 'global_not_found'.tr);
        }
        return Scrollbar(
          child: ListView.builder(
              itemCount: _.coinsSearch.length,
              itemBuilder: (context, index) {
                final coin = _.coinsSearch[index];
                return _CoinItemWidget(
                  coinModel: coin,
                  isBack: isBack,
                  idBack: idBack,
                );
              }),
        );
      },
    );
  }
}

class _CoinItemWidget extends GetView<RequestRecieveController> {
  const _CoinItemWidget({
    required this.coinModel,
    required this.isBack,
    required this.idBack,
    Key? key,
  }) : super(key: key);

  final CoinModel coinModel;
  final bool isBack;
  final int? idBack;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleCoinItemOnTap(coinModel, isBack, idBack);
      },
      padding: EdgeInsets.zero,
      child: Container(
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
                child: GlobalAvatarCoinWidget(coinModel: coinModel)),
            SizedBox(width: AppSizes.spaceMedium),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(coinModel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.bodyText1.copyWith(
                        color: AppColorTheme.black,
                        fontWeight: FontWeight.w600)),
                Text(coinModel.type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.bodyText2
                        .copyWith(color: AppColorTheme.black60)),
              ],
            ),
            // SizedBox(width: AppSizes.spaceSmall),
            // Expanded(
            //   child: Text(coinModel.valueWithSymbolString,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       textAlign: TextAlign.right,
            //       style: AppTextTheme.bodyText1.copyWith(
            //           color: AppColorTheme.black, fontWeight: FontWeight.w600)),
            // ),
          ],
        ),
      ),
    );
  }
}
