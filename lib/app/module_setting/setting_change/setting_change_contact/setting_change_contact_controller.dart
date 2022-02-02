import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/module_account/account_controller.dart';
import 'package:base_source/app/module_account/widget/account_edit.dart';
import 'package:base_source/app/module_wallet/module_create_address/create_new_address_controller.dart';
import 'package:base_source/app/module_wallet/module_create_address/create_new_address_page.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_dialog_confirm_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum EnumUpdateSettingContact { NAME, AVATAR, NAME_EDIT }

class SettingChangeContactController extends GetxController {
  final walletController = Get.find<WalletController>();
  final nameController = TextEditingController();
  final focusNode = FocusNode();
  String? isErrorName;

  List<BlockChainModel> get blockChains => walletController.blockChains;

  AddressModel addressDetail = AddressModel.empty();
  final state = Status();

  void handleAddressItemOnTap(AddressModel addressModel) {
    addressDetail = addressModel;
    Get.toNamed(AppRoutes.SETTING_CHANGE_CONTACT_DETAIl);
  }

  bool isAvatarActive(int index) => index == addressDetail.avatar;

  void handleButtonEditOnTap() {
    nameController.clear();
    Get.toNamed(AppRoutes.SETTING_CHANGE_CONTACT_EDIT);
  }

  void handleAvatarOnTap(int index) {
    final oldIndex = addressDetail.avatar;
    addressDetail.avatar = index;
    update([oldIndex, index]);
  }

  void setData({required AddressModel address}) {
    addressDetail = address;
  }

  void handleOnTapScreen() {
    focusNode.unfocus();

    if (isErrorName != null) {
      isErrorName = null;
      update([EnumUpdateSettingContact.NAME_EDIT]);
    }
  }

  void handleOnTapName() {
    if (isErrorName != null) {
      isErrorName = null;
      update([EnumUpdateSettingContact.NAME_EDIT]);
    }
  }

  void handleButtonSaveOnTap() async {
    focusNode.unfocus();

    isErrorName = Validators.validateNameAddress(nameController.text.isNotEmpty
        ? nameController.text
        : addressDetail.name);

    if (isErrorName != null) {
      update([EnumUpdateSettingContact.NAME_EDIT]);
    } else {
      try {
        await state.updateStatus(StateStatus.LOADING);
        if (nameController.text.isNotEmpty) {
          addressDetail.name = nameController.text;
        }
        await walletController.updateAddressModel(addressModel: addressDetail);
        update([
          EnumUpdateSettingContact.AVATAR,
          EnumUpdateSettingContact.NAME,
        ]);
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
        await state.updateStatus(StateStatus.FAILURE,
            showSnackbarError: true, desc: 'edit_information_failure'.tr);
        AppError.handleError(exception: exp);
      }
    }
  }

  void handleIconCopyOntap() async {
    await Clipboard.setData(ClipboardData(text: addressDetail.address));
    await state.updateStatus(StateStatus.SUCCESS,
        showSnackbarSuccess: true,
        isBack: false,
        desc: 'copy_address_success'.tr);
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
    Get.find<AccountController>().setData(address: addressModel);
    nameController.clear();
    isErrorName = null;
    await Get.bottomSheet(AccountEditWidget(), isScrollControlled: true);
    update([addressModel.blockChainId]);
  }
}
