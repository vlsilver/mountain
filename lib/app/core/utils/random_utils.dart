import 'dart:math';

class AppRamdom {
  static final AppRamdom _singleton = AppRamdom._internal();
  factory AppRamdom() => _singleton;
  AppRamdom._internal();

  final _random = Random();

  int randomInt(int max) => _random.nextInt(max);
}
