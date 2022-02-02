import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/services/setting_services.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_password/setting_change_password_controller.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_password/setting_change_password_page.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_security_show_seed_phrase.dart/setting_security_show_seed_phrase_page.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_security_show_seed_phrase.dart/setting_sercurity_show_seed_phrase_controller.dart';
import 'package:base_source/app/module_setting/setting_change/setting_security_show_password/setting_security_show_privatekey_page.dart';
import 'package:base_source/app/module_setting/setting_change/setting_security_show_password/setting_sercurity_show_privatekey_controller.dart';
import 'package:base_source/app/module_setting/setting_change/widget/select_currency.dart';
import 'package:base_source/app/module_setting/setting_change/widget/select_language.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:get/get.dart';

import 'setting_change_contact/setting_change_contact_controller.dart';

enum EnumUpdateSettingChange { CURRENCY, LANGUAGE, SWITCH_TOUCH_ID }

class SettingChangeController extends GetxController {
  final settingService = Get.find<SettingService>();
  final state = Status();
  late Currency currencyActive;
  late Language languageActive;
  late bool biometricState;

  final walletController = Get.find<WalletController>();

  @override
  void onInit() {
    biometricState = settingService.biometric;
    currencyActive = settingService.currencys
        .firstWhere((element) => element.locale == settingService.currency);
    languageActive = settingService.languages
        .firstWhere((element) => element.language == settingService.language);
    super.onInit();
  }

  void handleSwitchTouchIdOnChange() async {
    biometricState = !biometricState;
    update([EnumUpdateSettingChange.SWITCH_TOUCH_ID]);
    await settingService.changeBiometric(enable: biometricState);
  }

  List<Currency> get currencys => settingService.currencys;

  List<Language> get languages => settingService.languages;

  bool isCurrency(String locale) => locale == settingService.currency;

  bool isLanguage(String language) => language == settingService.language;

  List<BlockChainModel> get blockChains => walletController.blockChains;

  void handleItemSettingOnTap(int index) async {
    switch (index) {
      case 0:
        await Get.toNamed(AppRoutes.SETTING_CHANGE_GENERAL);
        break;
      case 1:
        await Get.toNamed(AppRoutes.SETTING_CHANGE_SECURITY);
        break;
      case 2:
        Get.put(SettingChangeContactController());
        await Get.toNamed(AppRoutes.SETTING_CHANGE_CONTACT);
        await Get.delete<SettingChangeContactController>();
        break;
      default:
    }
  }

  void handleBoxSelectCurrencyOnTap() async {
    await Get.bottomSheet(SelectCurrencyWidget(), isScrollControlled: true);
  }

  void handleBoxSelectLanguageOnTap() async {
    await Get.bottomSheet(SelectLanguageWidget(), isScrollControlled: true);
  }

  void handleBoxCurencyItemOnTap(Currency currency) async {
    if (currency.locale != settingService.currency) {
      final oldCurrency = settingService.currency;
      currencyActive = currency;
      try {
        await state.updateStatus(StateStatus.LOADING);
        await settingService.changeCurrency(locale: currency.locale);
        update(
            [currency.locale, oldCurrency, EnumUpdateSettingChange.CURRENCY]);
        Get.back();
        Get.back();
        Get.snackbar(
          'success_'.tr,
          'change_currency_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING,
          colorText: AppColorTheme.toggleableActiveColor,
          backgroundColor: AppColorTheme.backGround,
          duration: Duration(milliseconds: 1000),
        );
      } catch (exp) {
        await state.updateStatus(StateStatus.FAILURE,
            showSnackbarError: true, desc: 'change_currency_failure'.tr);
        AppError.handleError(exception: exp);
      }
    }
  }

  void handleBoxLanguageItemOnTap(Language language) async {
    if (language.language != settingService.language) {
      final oldLanguage = settingService.currency;
      languageActive = language;
      try {
        await state.updateStatus(StateStatus.LOADING);
        await settingService.changeLanguage(language.language);
        update(
            [language.language, oldLanguage, EnumUpdateSettingChange.LANGUAGE]);
        await Future.delayed(Duration(seconds: 1));
        // ignore: unawaited_futures
        state.updateStatus(StateStatus.SUCCESS,
            showSnackbarSuccess: true,
            desc: 'change_language_success'.tr,
            title: 'success_'.tr);
        Get.back();
      } catch (exp) {
        await state.updateStatus(StateStatus.FAILURE,
            showSnackbarError: true,
            desc: 'change_language_failure'.tr,
            title: 'global_error'.tr);
        await state.updateStatus(StateStatus.FAILURE);
        AppError.handleError(exception: exp);
      }
    }
  }

  void handleButtonShowSeedPhraseOnTap() async {
    Get.put(SettingSecurityShowSeedPhraseController());
    await Get.bottomSheet(SettingSecurityShowSeedPhrasePage(),
        isScrollControlled: true);
    await Get.delete<SettingSecurityShowSeedPhraseController>();
  }

  void handleButtonChangePasswordOnTap() async {
    Get.put(SettingChangePasswordController());
    await Get.bottomSheet(SettingChangePasswordPage(),
        isScrollControlled: true);
    await Get.delete<SettingChangePasswordController>();
  }

  void handleButtonChangeShowPrivateKeyOnTap() async {
    Get.put(SettingSecurityShowPrivateKeyController());
    await Get.bottomSheet(SettingSecurityShowPrivateKeyPage(),
        isScrollControlled: true);
    await Get.delete<SettingSecurityShowPrivateKeyController>();
  }
}
