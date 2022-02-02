import 'package:base_source/app/core/values/key_values.dart';
import 'package:base_source/app/data/providers/repository.dart';

class LoginRepository extends Repository {
  LoginRepository() : super();

  bool checkIsAcceptBiometric() {
    try {
      final enable = database.read<bool>(AppKeys.ENABLE_BIOMETRIC) ?? false;
      return enable;
    } catch (exp) {
      return false;
    }
  }

  Future<bool> loginWithBiometric({
    required bool biometricState,
  }) async {
    try {
      final result = await device.authenWithBiometrics();
      if (!biometricState) {
        await database.write(AppKeys.ENABLE_BIOMETRIC, biometricState);
      }
      return result;
    } catch (exp) {
      return false;
    }
  }

  Future<bool> confirmBiometric({
    required bool acceptedBiometric,
    required bool biometricState,
  }) async {
    var success = true;
    if (biometricState && !acceptedBiometric) {
      success = await device.authenWithBiometrics();
      if (success) {
        await database.write(AppKeys.ENABLE_BIOMETRIC, biometricState);
      }
    } else if (!biometricState && acceptedBiometric) {
      await database.write(AppKeys.ENABLE_BIOMETRIC, biometricState);
    }
    return success;
  }

  Future<bool> deleteAcceptedBiometric() async {
    try {
      await database.deleteKey(AppKeys.ENABLE_BIOMETRIC);
      return true;
    } catch (exp) {
      return false;
    }
  }

  Future<bool> deteleFavouriteCoinPair(String key) async {
    try {
      await database.deleteKey(key);
      return true;
    } catch (exp) {
      return false;
    }
  }
}
