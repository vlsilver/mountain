import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/utils/validator_utils.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

enum EnumUpdateAddressSaveFavourite { ADDRESS_SAVE, BUTTON_SAVE }

class SaveAddressFavouriteController extends GetxController {
  final FocusNode focusNodeSave =
      FocusNode(debugLabel: 'Save_Address_Favourite');
  final _walletController = Get.find<WalletController>();
  final saveController = TextEditingController();
  String? isErrorAddressSave;
  bool isActiveButtonSave = false;
  final status = Status();

  late final blockChainId;
  late final address;

  @override
  void onReady() {
    handleListenSaveTextEditControler();
    super.onReady();
  }

  @override
  void onClose() {
    saveController.removeListener(() {});
    super.onClose();
  }

  void handleInitData(
    String addressSelect,
    String blockChainIdSelect,
  ) {
    blockChainId = blockChainIdSelect;
    address = addressSelect;
  }

  void handleListenSaveTextEditControler() {
    saveController.addListener(() {
      if (saveController.text.isNotEmpty && !isActiveButtonSave) {
        isActiveButtonSave = true;
        update([EnumUpdateAddressSaveFavourite.BUTTON_SAVE]);
      } else if (saveController.text.isEmpty && isActiveButtonSave) {
        isActiveButtonSave = false;
        update([EnumUpdateAddressSaveFavourite.BUTTON_SAVE]);
      }
    });
  }

  void handleOnTapScreenAddressSave() {
    focusNodeSave.unfocus();
    if (isErrorAddressSave != null) {
      isErrorAddressSave = null;
      update([EnumUpdateAddressSaveFavourite.ADDRESS_SAVE]);
    }
  }

  void handleOnTapAddressSave() {
    if (isErrorAddressSave != null) {
      isErrorAddressSave = null;
      update([EnumUpdateAddressSaveFavourite.ADDRESS_SAVE]);
    }
  }

  void handleButtonCancelOnTap() {
    Get.back();
  }

  void handleButtonSaveOnTap() async {
    try {
      focusNodeSave.unfocus();
      isErrorAddressSave = Validators.validateNameAddress(saveController.text);
      if (isErrorAddressSave == null) {
        await status.updateStatus(StateStatus.LOADING);
        await _walletController.createNewAddressFavourite(
          name: saveController.text,
          address: address,
          blockChainId: blockChainId,
        );
        await status.updateStatus(StateStatus.SUCCESS);
        Get.back();
      } else {
        update([EnumUpdateAddressSaveFavourite.ADDRESS_SAVE]);
      }
    } catch (exp) {
      await status.updateStatus(StateStatus.FAILURE);
      AppError.handleError(exception: exp);
    }
  }
}
