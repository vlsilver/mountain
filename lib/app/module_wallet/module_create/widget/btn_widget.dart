import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/module_wallet/module_create/create_wallet/create_wallet_controller.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonWidget extends GetView<CreateWalletController> {
  const ButtonWidget({
    Key? key,
    this.active = true,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final bool active;
  final Function onTap;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: controller.tagHeroButton,
      child: GlobalButtonWidget(
          name: name,
          type: active ? ButtonType.ACTIVE : ButtonType.DISABLE,
          onTap: () {
            onTap();
          }),
    );
  }
}
