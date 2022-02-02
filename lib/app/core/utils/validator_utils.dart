import 'package:get/get.dart';

class Validators {
  static String? validatePassword(String? value) {
    // var pattern =
    //     r'^(?=(.*[0-9]))(?=.*[\!@#$%^&*()\\[\]{}\-_+=~`|:;"<>,./?])(?=.*[a-z])(?=(.*[A-Z]))(?=(.*)).{4,}$';
    // var regex = RegExp(pattern);
    return value == null || value.isEmpty ? 'error_password_format'.tr : null;
  }

  static String? validateTokenName(String? value) {
    var pattern = r"^[a-zA-Z0-9]+(([',. -][a-zA-Z0-91])?[a-zA-Z]*)*$";
    var regex = RegExp(pattern);
    return !regex.hasMatch(value ?? '') ? 'error_token_name_format'.tr : null;
  }

  static String? validateNameAddress(String? value) {
    var pattern = r"^[a-zA-Z0-9]+(([',. -][a-zA-Z0-91])?[a-zA-Z]*)*$";
    var regex = RegExp(pattern);
    return !regex.hasMatch(value ?? '') ? 'error_address_name_format'.tr : null;
  }

  static String? validateSymbol(String? value) {
    var pattern = r'^[a-zA-Z0-9]{1,15}$';
    var regex = RegExp(pattern);
    return !regex.hasMatch(value ?? '') ? 'error_symbol_format'.tr : null;
  }

  static String? validateAmount(String? value) {
    if (value != null && value.isNotEmpty) {
      try {
        double.parse(value.replaceAll(',', '.'));
        return null;
      } catch (exp) {
        return 'error_amount_format'.tr;
      }
    } else {
      return null;
    }
  }

  static String? validateMnemonic(String? value) {
    if (value == null) {
      return 'error_empty'.tr;
    }
    if (value.isEmpty) {
      return 'error_empty'.tr;
    }
  }

  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null) {
      return 'error_empty'.tr;
    }
    return confirmPassword.isEmpty
        ? 'error_empty'.tr
        : (confirmPassword != password
            ? 'error_confirm_password_format'.tr
            : null);
  }
}
