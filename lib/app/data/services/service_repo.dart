import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/core/values/key_values.dart';
import 'package:base_source/app/data/models/local_model/wallet_model.dart';
import 'package:base_source/app/data/providers/repository.dart';
import 'package:local_auth/local_auth.dart';

enum EnumBiometricType { TOUCH_ID, FACE_ID, UNKNOW }

class ServiceRepository extends Repository {
  ServiceRepository() : super();

  Future<bool> checkIsFirstTimeOpenApp() async {
    try {
      final isFirstTime = database.read<bool>(AppKeys.IS_FIRST_TIME) ?? true;
      await database.write(AppKeys.IS_FIRST_TIME, false);
      return isFirstTime;
    } catch (exp) {
      return false;
    }
  }

  Future<bool> checkIsCreatedWallet() async {
    final result = await database.readSecure(TotalWalletModel.key);
    if (result == null) {
      return false;
    } else {
      final totalModel = TotalWalletModel.fromJson(result);
      if (totalModel.active == null) {
        return false;
      } else {
        return true;
      }
    }
  }

  Future<EnumBiometricType> getAuthenBiometricType() async {
    try {
      final canCheck = await device.canCheckBiometric();
      if (canCheck) {
        final results = await device.getAvailableBiometrics();
        if (results.contains(BiometricType.face)) {
          return EnumBiometricType.FACE_ID;
        } else if (results.contains(BiometricType.fingerprint)) {
          return EnumBiometricType.TOUCH_ID;
        } else {
          return EnumBiometricType.UNKNOW;
        }
      } else {
        return EnumBiometricType.UNKNOW;
      }
    } catch (exp) {
      AppError.handleError(exception: exp);
      return EnumBiometricType.UNKNOW;
    }
  }

  bool getSettingTheme() {
    try {
      final setting = database.read<bool>(AppKeys.THEME) ?? true;
      return setting;
    } catch (exp) {
      return true;
    }
  }

  String getSettingLocale() {
    try {
      var setting = database.read<String>(AppKeys.LANGUAGE);
      return setting ?? AppKeys.LANGUAGE_DEFAULT;
    } catch (exp) {
      return AppKeys.LANGUAGE_DEFAULT;
    }
  }

  String getSettingCurrency() {
    try {
      var setting = database.read<String>(AppKeys.CURRENCY);
      return setting ?? AppKeys.CURRENCY_DEFAULT;
    } catch (exp) {
      return AppKeys.CURRENCY_DEFAULT;
    }
  }

  Future<void> saveSetting({
    required String key,
    required dynamic value,
  }) async {
    await database.write(key, value);
  }

  bool getSettingBiometric() {
    try {
      final enable = database.read<bool>(AppKeys.ENABLE_BIOMETRIC) ?? false;
      return enable;
    } catch (exp) {
      return false;
    }
  }
}
