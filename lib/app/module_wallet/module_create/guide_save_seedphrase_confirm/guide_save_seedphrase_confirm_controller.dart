import 'package:base_source/app/core/utils/random_utils.dart';
import 'package:base_source/app/module_wallet/module_create/create_wallet/create_wallet_controller.dart';
import 'package:base_source/app/routes/routes.dart';

import 'package:get/get.dart';

enum EnumUpdateGuideSaveSeedPhraseConfirm {
  BUTTON,
  CONFIRM_GROUP,
  CHOICE_GROUP
}

class GuideSaveSeedPhraseConfirmController extends GetxController {
  bool isActiveButton = false;
  bool? isCorret;

  bool isCompletedStep = false;

  late final List<String> seedPhrase;
  late final CreateWalletController createWallet;
  int currentIndexItemConfirmActive = 0;
  int numberChoice = 0;
  late List<ConfirmItem> confirmSeedPhrase3 = [];
  late List<ConfirmItem> confirmSeedPhrase5 = [];

  @override
  void onInit() async {
    createWallet = Get.find<CreateWalletController>();
    seedPhrase = createWallet.seedPhrase;
    randomListConfirmSeedPhraseOnce();
    super.onInit();
  }

  void randomListConfirmSeedPhraseOnce() {
    final _listRandom3 = <int>[];
    final _listRandom5 = <int>[];
    confirmSeedPhrase3 = <ConfirmItem>[];
    confirmSeedPhrase5 = <ConfirmItem>[];
    var i = 0;
    while (i < 3) {
      final index = AppRamdom().randomInt(12);
      if (!_listRandom3.contains(index)) {
        _listRandom3.add(index);
        confirmSeedPhrase3.add(
          ConfirmItem(
              value: seedPhrase[index], indexInSeedPhrase: index, index: i),
        );
        i++;
      }
    }
    confirmSeedPhrase5.addAll(confirmSeedPhrase3);
    _listRandom5.addAll(_listRandom3);
    while (confirmSeedPhrase5.length < 5) {
      final index = AppRamdom().randomInt(12);
      if (!_listRandom5.contains(index)) {
        _listRandom5.add(index);
        confirmSeedPhrase5.add(
          ConfirmItem(
            value: seedPhrase[index],
            indexInSeedPhrase: index,
          ),
        );
      }
    }
    confirmSeedPhrase5.shuffle();
  }

  bool isItemActive(int index) => currentIndexItemConfirmActive == index;

  void handleItemConfirmOnTap(int index) {
    if (currentIndexItemConfirmActive != index) {
      final _oldIndex = currentIndexItemConfirmActive;
      currentIndexItemConfirmActive = index;
      update([index, _oldIndex]);
    }
  }

  void handleItemChoiceOnTap(String value) {
    numberChoice++;
    if (value !=
        confirmSeedPhrase3[currentIndexItemConfirmActive].currentValue) {
      confirmSeedPhrase3[currentIndexItemConfirmActive].currentValue = value;
    }
    final _oldIndex = currentIndexItemConfirmActive;
    if (currentIndexItemConfirmActive < 2) {
      currentIndexItemConfirmActive++;
    } else {
      currentIndexItemConfirmActive = 0;
    }

    if (numberChoice >= 3) {
      var _isValidator = true;
      for (var _item in confirmSeedPhrase3) {
        if (!_item.isValidator) {
          _isValidator = false;
          break;
        }
      }
      if (_isValidator && !isActiveButton) {
        isActiveButton = true;
        isCorret = true;
        update([
          _oldIndex,
          currentIndexItemConfirmActive,
          EnumUpdateGuideSaveSeedPhraseConfirm.BUTTON,
          EnumUpdateGuideSaveSeedPhraseConfirm.CONFIRM_GROUP,
        ]);
      } else if (!_isValidator && isActiveButton) {
        isActiveButton = false;
        isCorret = false;
        update([
          _oldIndex,
          currentIndexItemConfirmActive,
          EnumUpdateGuideSaveSeedPhraseConfirm.BUTTON,
          EnumUpdateGuideSaveSeedPhraseConfirm.CONFIRM_GROUP
        ]);
      } else if (!_isValidator && !isActiveButton) {
        isCorret = false;
        update([
          _oldIndex,
          currentIndexItemConfirmActive,
          EnumUpdateGuideSaveSeedPhraseConfirm.CONFIRM_GROUP
        ]);
      } else {
        update([_oldIndex, currentIndexItemConfirmActive]);
      }
    } else {
      update([_oldIndex, currentIndexItemConfirmActive]);
    }
  }

  void handleButtonOnTap() {
    if (!isCompletedStep) {
      isCompletedStep = true;
      randomListConfirmSeedPhraseOnce();
      isCorret = null;
      isActiveButton = false;
      currentIndexItemConfirmActive = 0;
      numberChoice = 0;
      update([
        EnumUpdateGuideSaveSeedPhraseConfirm.CONFIRM_GROUP,
        EnumUpdateGuideSaveSeedPhraseConfirm.BUTTON,
        EnumUpdateGuideSaveSeedPhraseConfirm.CONFIRM_GROUP,
        EnumUpdateGuideSaveSeedPhraseConfirm.CHOICE_GROUP,
      ]);
    } else {
      createWallet.step = 3;
      Get.offAllNamed(AppRoutes.GUIDE_SAVE_SEEDPHRASE_COMPLETE);
    }
  }

  void handleButtonBackAppBarOnTap() {
    Get.back();
  }
}

class ConfirmItem {
  String currentValue;
  final String value;
  final int indexInSeedPhrase;
  final int index;

  ConfirmItem({
    this.currentValue = '',
    required this.value,
    required this.indexInSeedPhrase,
    this.index = 0,
  });

  bool get isValidator => value == currentValue;
}
