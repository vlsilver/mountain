import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/module_setting/widget/layout_setting_page.dart';
import 'package:base_source/app/module_wallet/module_notification/notification_controller.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_empty_list_widget.dart';
import 'package:base_source/app/widget_global/global_logo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutSettingDetailWidget(
      title: 'noti_ttile'.tr,
      action: true,
      onTapAction: () {
        controller.handleDeleteAll();
      },
      body: _NotificationsWidget(),
    );
  }
}

class _NotificationsWidget extends StatelessWidget {
  const _NotificationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      id: EnumNotification.LIST_NOTI,
      builder: (_) {
        return GetBuilder<WalletController>(
          id: EnumUpdateWallet.NOTIFICATION,
          builder: (walletController) {
            if (_.notifications.isEmpty) {
              return GlobalEmptyListWidget(title: 'noti_no_nofitication'.tr);
            }
            return ListView.builder(
                itemCount: _.notifications.length,
                itemBuilder: (context, index) {
                  final notification = _.notifications[index];
                  return _NotificationItemWidget(
                    noti: notification,
                    index: index,
                  );
                });
          },
        );
      },
    );
  }
}

class _NotificationItemWidget extends GetView<NotificationController> {
  const _NotificationItemWidget({
    required this.noti,
    required this.index,
    Key? key,
  }) : super(key: key);

  final AddressModel noti;
  final int index;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        controller.handleNotiItemOnTap(index);
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: AppSizes.spaceVerySmall,
            horizontal: AppSizes.spaceMedium),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceSmall, vertical: AppSizes.spaceSmall),
        decoration: BoxDecoration(
            color: AppColorTheme.focus,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            GlobalLogoWidget(height: 28),
            SizedBox(width: AppSizes.spaceMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('noti_new_transaction_des'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText1.copyWith(
                          color: AppColorTheme.accent,
                          fontWeight: FontWeight.w700)),
                  Text(noti.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText2.copyWith(
                          color: AppColorTheme.black,
                          fontWeight: FontWeight.w600)),
                  Text(noti.addressFormat,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.bodyText2
                          .copyWith(color: AppColorTheme.black60)),
                ],
              ),
            ),
            Image.network(
              controller.walletController.wallet
                  .getImageByBlockChainId(noti.blockChainId),
              height: 32.0,
              width: 32.0,
            ),
          ],
        ),
      ),
    );
  }
}
