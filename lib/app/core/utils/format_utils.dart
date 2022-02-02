import 'dart:math';
import 'package:intl/intl.dart';

class AppFormat {
  static final AppFormat _singleton = AppFormat._internal();
  factory AppFormat() => _singleton;
  AppFormat._internal();

  static String formatRoundBrackets({required String value}) {
    return ' ( $value )';
  }

  static String dropHexString({required hexString}) {
    var string = hexString.split('0x')[1];
    if (string.length % 2 != 0) {
      string = '0' + string;
    }
    return string;
  }

  static String addressString(String address) {
    return address.substring(0, 10) +
        '...' +
        address.substring(address.length - 4);
  }

  static String addressStringLarge(String address) {
    return address.substring(0, 20) +
        '...' +
        address.substring(address.length - 4);
  }

  static String addPrefixHexString({required hexString}) {
    return '0x' + hexString;
  }

  static String intToHexString({required int number, bool add = true}) {
    var hexString = number.toRadixString(16);
    if (!add) {
      return hexString;
    }
    if (hexString.length % 2 != 0) {
      hexString = '0' + hexString;
    }
    return hexString;
  }

  static String bigIntToHexString({required BigInt number, bool add = true}) {
    var hexString = number.toRadixString(16);
    if (!add) {
      return hexString;
    }
    if (hexString.length % 2 != 0) {
      hexString = '0' + hexString;
    }
    return hexString;
  }

  static String formatTimeFromTimestamp(int timeStamp) {
    if (timeStamp.toString().length == 13) {
      var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
      var formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(date);
      return formattedDate;
    } else if (timeStamp.toString().length == 10) {
      var date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
      var formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(date);
      return formattedDate;
    } else {
      var date = DateTime.fromMillisecondsSinceEpoch(timeStamp ~/ 1000);
      var formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(date);
      return formattedDate;
    }
  }

  static String formatShareOfPoolWithValue(double value) => value > 1
      ? '100%'
      : value == 0.0
          ? '0.0%'
          : value * 100 < pow(10, -3)
              ? '< 0.001%'
              : (value * 100).toStringAsFixed(3) + '%';
}


// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${this.substring(1)}";
//   }
// }
