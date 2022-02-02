import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trust_web3_provider/trust_web3_provider.dart';

void main() {
  const MethodChannel channel = MethodChannel('trust_web3_provider');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await TrustWeb3Provider.platformVersion, '42');
  });
}
