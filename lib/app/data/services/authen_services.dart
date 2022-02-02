import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/services/service_repo.dart';
import 'package:base_source/app/routes/routes.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AuthenService extends GetxService {
  late ServiceRepository _repo;
  late String _firstPage;
  late EnumBiometricType _biometricType;

  Future<AuthenService> init() async {
    _repo = ServiceRepository();
    await initialApp();
    _biometricType = await _repo.getAuthenBiometricType();
    return this;
  }

  Future<void> initialApp() async {
    try {
      final isFirstTime = await _repo.checkIsFirstTimeOpenApp();
      final isCreatedWallet = await _repo.checkIsCreatedWallet();

      if (isFirstTime && !isCreatedWallet) {
        _firstPage = AppRoutes.SPLASH;
      } else if (isCreatedWallet) {
        _firstPage = AppRoutes.LOGIN;
      } else if (!isFirstTime && !isCreatedWallet) {
        _firstPage = AppRoutes.CHOICE_SETUP_WALLET;
      }
    } catch (exp) {
      _firstPage = AppRoutes.INITAL_APP_ERROR;
      AppError.handleError(exception: exp);
    }
  }

  String get firstPage => _firstPage;
  bool get biometricTouchID => _biometricType == EnumBiometricType.TOUCH_ID;
  bool get biometricFaceID => _biometricType == EnumBiometricType.FACE_ID;
  bool get biometricUnknow => _biometricType == EnumBiometricType.UNKNOW;
}
