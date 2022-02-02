import 'package:base_source/app/core/values/key_values.dart';
import 'package:base_source/app/data/providers/crypto_provider/binance_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/bitcoin_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/ethereum_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/kardiachain_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/pi_testnet_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/polygon_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/stellar_provider.dart';
import 'package:base_source/app/data/providers/crypto_provider/tron_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:base_source/app/core/theme/app_theme.dart';
import 'package:base_source/app/data/providers/db_provider/db_provider.dart';
import 'package:base_source/app/data/services/service_repo.dart';

class SettingService extends GetxService {
  late final ServiceRepository _repo;
  bool _isLightMode = true;
  String language = 'en';
  String currency = 'en_US';
  bool biometric = false;
  String abiERC20BEP20 = '';
  String abiNewTokenBSC = '';
  String abiSwapERC20BEP20 = '';
  String abiSwapKRC20 = '';
  String abiFactory = '';
  String abiLPToken = '';
  String abiLaunchPad = '';

  Future<SettingService> init() async {
    await Get.putAsync<DatabaseProvider>(() => DatabaseProvider().init());
    Get.lazyPut(() => BitcoinProvider());
    Get.lazyPut(() => EthereumProvider());
    Get.lazyPut(() => BinanceSmartProvider());
    Get.lazyPut(() => PolygonProvider());
    Get.lazyPut(() => KardiaChainProvider());
    Get.lazyPut(() => TronProvider());
    Get.lazyPut(() => StellarChainProvider());
    Get.lazyPut(() => PiTestNetProvider());
    _repo = ServiceRepository();
    _isLightMode = _repo.getSettingTheme();
    language = _repo.getSettingLocale();
    currency = _repo.getSettingCurrency();
    biometric = _repo.getSettingBiometric();

    abiERC20BEP20 =
        await rootBundle.loadString('assets/json/abi_erc20_bep20.json');
    abiNewTokenBSC =
        await rootBundle.loadString('assets/json/abi_new_token_bsc.json');
    abiSwapERC20BEP20 =
        await rootBundle.loadString('assets/json/abi_swap_erc20_bep20.json');
    abiSwapKRC20 =
        await rootBundle.loadString('assets/json/abi_swap_krc20.json');
    abiFactory = await rootBundle.loadString('assets/json/abi_factory.json');
    abiLPToken = await rootBundle.loadString('assets/json/abi_lp_token.json');
    abiLaunchPad =
        await rootBundle.loadString('assets/json/abi_launch_pad.json');

    return this;
  }

  ThemeData get theme => _isLightMode ? AppTheme.lightMode : AppTheme.darkMode;
  Locale get locale => Locale(language);

  void changeTheme() =>
      Get.changeTheme(!_isLightMode ? AppTheme.lightMode : AppTheme.darkMode);

  Future<void> changeLanguage(String languageCode) async {
    Get.updateLocale(Locale(languageCode));
    language = languageCode;
    await _repo.saveSetting(
      key: AppKeys.LANGUAGE,
      value: languageCode,
    );
  }

  Future<void> changeCurrency({required String locale}) async {
    currency = locale;
    await _repo.saveSetting(
      key: AppKeys.CURRENCY,
      value: locale,
    );
  }

  Future<void> changeBiometric({required bool enable}) async {
    biometric = enable;
    await _repo.saveSetting(
      key: AppKeys.ENABLE_BIOMETRIC,
      value: enable,
    );
  }

  Currency get currencyActive =>
      currencys.firstWhere((element) => element.locale == currency);

  List<Currency> currencys = [
    Currency(
      locale: 'en_US',
      currency: 'USD',
      currencyDesc: 'United State Dollar',
    ),
    Currency(
      locale: 'en_AU',
      currency: 'AUD',
      currencyDesc: 'Australian dollar',
    ),
    Currency(
      locale: 'pt_BR',
      currency: 'BRL',
      currencyDesc: 'Brazilian real',
    ),
    Currency(
      locale: 'en_CA',
      currency: 'CAD',
      currencyDesc: 'Canadian dollar',
    ),
    Currency(
      locale: 'zh_CN',
      currency: 'CNY',
      currencyDesc: 'Chinese yuan',
    ),
    Currency(
      locale: 'cs',
      currency: 'CZK',
      currencyDesc: 'Czech korunan',
    ),
    Currency(
      locale: 'da_DK',
      currency: 'DKK',
      currencyDesc: 'Danish krone',
    ),
    Currency(
      locale: 'eu_ES',
      currency: 'EUR',
      currencyDesc: 'Euro',
    ),
    Currency(
      locale: 'en_HK',
      currency: 'HKD',
      currencyDesc: 'Hong Kong dollar',
    ),
    Currency(
      locale: 'hu_HU',
      currency: 'HUF',
      currencyDesc: 'Hungarian forint',
    ),
    Currency(
      locale: 'id_ID',
      currency: 'IDR',
      currencyDesc: 'Indonesian rupiah',
    ),
    Currency(
      locale: 'he_IL',
      currency: 'ILS',
      currencyDesc: 'Israeli new shekel',
    ),
    Currency(
      locale: 'hi_IN',
      currency: 'INR',
      currencyDesc: 'Indian rupee',
    ),
    Currency(
      locale: 'ja_JP',
      currency: 'JPY',
      currencyDesc: 'Japanese yen',
    ),
    Currency(
      locale: 'ko_KP',
      currency: 'KRW',
      currencyDesc: 'South Korean won',
    ),
    Currency(
      locale: 'es_MX',
      currency: 'MXN',
      currencyDesc: 'Mexican peso',
    ),
    Currency(
      locale: 'ms_MY',
      currency: 'MYR',
      currencyDesc: 'Malaysian ringgit',
    ),
    Currency(
      locale: 'en_NZ',
      currency: 'NZD',
      currencyDesc: 'New Zealand dollar',
    ),
    Currency(
      locale: 'tl_PH',
      currency: 'PHP',
      currencyDesc: 'Philippine peso',
    ),
    Currency(
      locale: 'pl_PL',
      currency: 'PHP',
      currencyDesc: 'Polish złoty',
    ),
    Currency(
      locale: 'ru_RU',
      currency: 'RUB',
      currencyDesc: 'Russian ruble',
    ),
    Currency(
      locale: 'sv',
      currency: 'SEK',
      currencyDesc: 'Swedish krona',
    ),
    Currency(
      locale: 'en_SG',
      currency: 'SGD',
      currencyDesc: 'Singapore dollar',
    ),
    Currency(
      locale: 'th_TH',
      currency: 'THB',
      currencyDesc: 'Thai baht',
    ),
    Currency(
      locale: 'tr_TR',
      currency: 'TRY',
      currencyDesc: 'Turkish lira',
    ),
    Currency(
      locale: 'vi',
      currency: 'VND',
      currencyDesc: 'Việt Nam Đồng',
    ),
  ];
  List<Language> languages = [
    Language(
      language: 'en',
      languageDesc: 'English',
    ),
    Language(
      language: 'es',
      languageDesc: 'Spanish',
    ),
    Language(
      language: 'pt',
      languageDesc: 'Portuguese',
    ),
    Language(
      language: 'vi',
      languageDesc: 'Vietnames',
    ),
  ];
}

class Currency {
  final String locale;
  final String currency;
  final String currencyDesc;
  Currency({
    required this.currencyDesc,
    required this.locale,
    required this.currency,
  });

  String get currencySelectFormat => currency + ' - ' + currencyDesc;
}

class Language {
  final String language;
  final String languageDesc;
  Language({
    required this.language,
    required this.languageDesc,
  });
}
