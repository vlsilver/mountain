import 'dart:collection';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import 'en_transition.dart';
import 'es_transaction.dart';
import 'pt_transaction.dart';
import 'vi_transition.dart';

class AppTranslation extends Translations {
  static final fallbackLocale = Locale('en', 'US');
  static final langs = LinkedHashMap.from({
    'en': 'English',
    'es': 'Spanish',
    'pt': 'Portuguese',
    'vi': 'Vietnames',
  });

  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'es': es,
        'pt': pt,
        'vi': vi,
      };
  static final locales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('pt', 'PT'),
    Locale('vi', 'VN'),
  ];

  static final langCodes = [
    'en',
    'es',
    'pt',
    'vi',
  ];
}
