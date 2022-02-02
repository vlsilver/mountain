import 'package:get/get.dart';

class AppError extends Error {
  static String handleError({required dynamic exception}) {
    print('---------------------exception---------------------');
    print(exception);
    print('---------------------exception----------------------');
    return exception.toString();
  }
}

class LoginException implements Exception {
  const LoginException({required this.statusCode});

  final int? statusCode;
  String error() {
    switch (statusCode ?? 1000) {
      case 400:
        return 'error_not_found_account'.tr;
      case 404:
        return 'error_not_found_account'.tr;
      case 1000:
        return 'error_disconnect'.tr;
      default:
        return 'error_unknow'.tr;
    }
  }
}

class LoadDataException implements Exception {}
