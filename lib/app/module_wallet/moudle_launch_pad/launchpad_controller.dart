import 'dart:async';

import 'package:base_source/app/data/models/local_model/ido_model.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_project/ido_project_controller.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_project/ido_project_page.dart';
import 'package:get/get.dart';

enum EnumLaunchPad { IDO_ITEM }

class LaunchPadController extends GetxController {
  late final Timer _timer;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    _timer = Timer.periodic(Duration(milliseconds: 10000), (t) {
      update([EnumLaunchPad.IDO_ITEM]);
    });
    super.onReady();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  void handleButtonViewDetailOnTap(IDOModel ido) async {
    Get.put(IDOProjectController()).idoModel = ido;
    await Get.to(() => IDOProjectPage());
    await Get.delete<IDOProjectController>();
  }
}
