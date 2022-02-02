import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_contact/pages/setting_change_contact_detail_page.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_contact/setting_change_contact_controller.dart';
import 'package:base_source/app/module_wallet/module_create_address/create_new_address_controller.dart';
import 'package:base_source/app/module_wallet/module_create_address/create_new_address_page.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_dialog_confirm_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

import 'widget/account_edit.dart';

enum EnumAccountPage { NAME_EDIT }

class AccountController extends GetxController {
  final status = Status();
  final walletController = Get.find<WalletController>();
  final nameController = TextEditingController();
  AddressModel addressEdit = AddressModel.empty();
  final focusNode = FocusNode();

  String? isErrorName;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setData({required AddressModel address}) {
    addressEdit = address;
  }

  void handleButtonCreateNewAddressOnTap(String id) async {
    final createnewAddressController = Get.put(CreateNewAddressController());
    createnewAddressController.blockChainId = id;
    await Get.bottomSheet(
        GlobalBottomSheetLayoutWidget(
            height: Get.height * 0.85,
            child: CreateNewAddressPage(
              tab: 0,
              isBack: false,
            )),
        isScrollControlled: true);
    update([id]);
    await Get.delete<CreateNewAddressController>();
  }

  void handleDeleteAddressOnTap(AddressModel addressModel) async {
    await Get.dialog(
        GlobalDialogConfirmWidget(
            title: 'delete_address'.tr,
            desc: 'delete_address_detail'.tr,
            onTap: () async {
              await walletController.deleteAddress(
                  address: addressModel.address,
                  blockChainId: addressModel.blockChainId);
              Get.back();
            }),
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 200));
    update([addressModel.blockChainId]);
  }

  void handleEditAccountOnTap(AddressModel addressModel) async {
    addressEdit = addressModel.copyWith();
    nameController.clear();
    await Get.bottomSheet(AccountEditWidget(), isScrollControlled: true);
  }

  void handleAvatarOnTap({required int avatarIndex}) {
    final oldIndex = addressEdit.avatar;
    if (oldIndex != avatarIndex) {
      addressEdit.avatar = avatarIndex;
      update([oldIndex, avatarIndex]);
    }
  }

  void handleOnTapName() {
    if (isErrorName != null) {
      isErrorName = null;
      update([EnumAccountPage.NAME_EDIT]);
    }
  }

  void handleOnTapScreen() {
    focusNode.unfocus();

    if (isErrorName != null) {
      isErrorName = null;
      update([EnumAccountPage.NAME_EDIT]);
    }
  }

  void handleButtonSaveOnTap() async {
    focusNode.unfocus();
    isErrorName = Validators.validateNameAddress(nameController.text.isNotEmpty
        ? nameController.text
        : addressEdit.name);
    if (isErrorName != null) {
      update([EnumAccountPage.NAME_EDIT]);
    } else {
      try {
        await status.updateStatus(StateStatus.LOADING);
        if (nameController.text.isNotEmpty) {
          addressEdit.name = nameController.text;
        }
        await walletController.updateAddressModel(addressModel: addressEdit);
        update([addressEdit.blockChainId]);
        Get.back();
        Get.back();
        Get.snackbar(
          'success_'.tr,
          'edit_information_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING,
          colorText: AppColorTheme.toggleableActiveColor,
          backgroundColor: AppColorTheme.backGround,
          duration: Duration(milliseconds: 1000),
        );
      } catch (exp) {
        await status.updateStatus(StateStatus.FAILURE,
            showSnackbarError: true, desc: 'edit_information_failure'.tr);
        AppError.handleError(exception: exp);
      }
    }
  }

  void handleButtonCancelOnTap() async {
    Get.back();
  }

  void handleItemOntap(AddressModel addressModel) async {
    final settingChange = Get.put(SettingChangeContactController());
    settingChange.setData(address: addressModel);
    await Get.to(() => SettingChangeContactDetailPage());
    update([addressModel.blockChainId]);
    await Get.delete<SettingChangeContactController>();
  }

  bool isAvatarActive(int index) => index == addressEdit.avatar;
}
