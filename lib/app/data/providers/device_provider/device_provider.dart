import 'package:get/get_connect.dart';
import 'package:local_auth/local_auth.dart';

class DeviceProvider extends GetConnect {
  final _localAuth = LocalAuthentication();

  Future<bool> canCheckBiometric() async {
    final canCheck = await _localAuth.canCheckBiometrics;
    return canCheck;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    final listBiometrics = await _localAuth.getAvailableBiometrics();
    return listBiometrics;
  }

  Future<bool> authenWithBiometrics() async {
    try {
      final isAuthen = await _localAuth.authenticate(
        localizedReason: 'Wallet Mobile',
      );
      return isAuthen;
    } catch (exp) {
      throw 'Error Biometric';
    }
  }
}
