import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_add_liquidity_list.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_controller.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/list_add_liquidity/list_add_liquidity_controller.dart';
import 'package:base_source/app/routes/pages_routes.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_empty_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddLiquidityNavigatorPage extends StatelessWidget {
  const AddLiquidityNavigatorPage({
    Key? key,
    required this.isFullScreen,
  }) : super(key: key);

  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? Navigator(
            key: Get.nestedKey(AppPages.NAVIGATOR_KEY_ADD_LIQUIDITY),
            initialRoute: AppRoutes.LIST_ADD_LIQUIDITY,
            onGenerateRoute: (setting) {
              return AppPages.pageNavigatorAddLiquidity(
                  setting.name!, isFullScreen);
            },
          )
        : GlobalBottomSheetLayoutWidget(
            color: AppColorTheme.backGround2,
            child: Navigator(
              key: Get.nestedKey(AppPages.NAVIGATOR_KEY_ADD_LIQUIDITY),
              initialRoute: AppRoutes.UPDATE_ADDRESS_ADD_LIQUIDITY,
              onGenerateRoute: (setting) {
                return AppPages.pageNavigatorAddLiquidity(
                    setting.name!, isFullScreen);
              },
            ),
          );
  }
}

class ListAddLiquidityPage extends GetView<ListAddLiquidityController> {
  const ListAddLiquidityPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorTheme.focus,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.spaceMedium,
            right: AppSizes.spaceMedium,
            top: AppSizes.spaceNormal,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'add_liquidity_list'.tr,
                    style: AppTextTheme.bodyText1
                        .copyWith(color: AppColorTheme.black),
                  ),
                  CupertinoButton(
                    onPressed: controller.handleAddLiquidityTextOnTap,
                    padding: EdgeInsets.zero,
                    child: Text(
                      'add_liquidity_add'.tr,
                      style: AppTextTheme.bodyText1.copyWith(
                          color: AppColorTheme.textAccent,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              SizedBox(height: AppSizes.spaceNormal),
              Expanded(
                child: GetBuilder<AddLiquidityController>(
                  id: EnumAddLiquidity.LIST_DATA,
                  builder: (_) {
                    final data = _.addLiquidityList;
                    return data.isEmpty
                        ? GlobalEmptyListWidget(title: 'add_liquidity_empty'.tr)
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              if (index == data.length) {
                                return SizedBox(height: 48.0);
                              }
                              return ItemAddLiquidityWidget(
                                addLiquidityModel: data[index],
                              );
                            });
                  },
                ),
              )
            ],
          ),
        ));
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
        'global_liquidity'.tr,
        style: AppTextTheme.titleAppbar,
      ),
    );
  }
}

class ItemAddLiquidityWidget extends GetView<AddLiquidityController> {
  const ItemAddLiquidityWidget({
    Key? key,
    required this.addLiquidityModel,
  }) : super(key: key);
  final AddLiquidityModel addLiquidityModel;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleShowDetailAddliquidity(addLiquidityModel);
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSizes.spaceSmall),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            border: Border.all(
              color: AppColorTheme.textAction,
              width: 0.25,
            )),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMedium,
          vertical: AppSizes.spaceNormal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ItemNormalWidget(addLiquidityModel: addLiquidityModel),
          ],
        ),
      ),
    );
  }
}

class _ItemNormalWidget extends StatelessWidget {
  const _ItemNormalWidget({
    Key? key,
    required this.addLiquidityModel,
  }) : super(key: key);

  final AddLiquidityModel addLiquidityModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlobalAvatarCoinWidget(
          coinModel: addLiquidityModel.tokenA,
          height: 32.0,
          width: 32.0,
        ),
        const SizedBox(width: AppSizes.spaceSmall),
        GlobalAvatarCoinWidget(
          coinModel: addLiquidityModel.tokenB,
          height: 32.0,
          width: 32.0,
        ),
        const SizedBox(width: AppSizes.spaceNormal),
        Expanded(
          child: Text(
              addLiquidityModel.tokenA.symbol +
                  '/' +
                  addLiquidityModel.tokenB.symbol,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextTheme.bodyText1.copyWith(
                  color: AppColorTheme.black, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: AppSizes.spaceSmall),
        Text(
          BlockChainModel.getNameRouterApprove(addLiquidityModel.blockChainId),
          style: AppTextTheme.bodyText1.copyWith(
              color: AppColorTheme.black, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
