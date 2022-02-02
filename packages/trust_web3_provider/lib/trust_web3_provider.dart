
import 'dart:async';

import 'package:flutter/services.dart';

class TrustWeb3Provider {
  static const MethodChannel _channel =
      const MethodChannel('trust_web3_provider');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
