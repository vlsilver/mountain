import 'package:base_source/app/core/controller/state.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/utils/error_utils.dart';
import 'package:base_source/app/data/models/local_model/ido_model.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_claim_confirm_page.dart/ido_claim_confirm_controller.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_claim_confirm_page.dart/ido_claim_select_address.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_deposit.dart/ido_deposit_controller.dart';
import 'package:base_source/app/module_wallet/moudle_launch_pad/ido_deposit.dart/ido_deposit_page.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

enum EnumIDOProject { AMOUNT }

class IDOProjectController extends GetxController {
  late final IDOModel idoModel;
  final state = Status();

  void handleSocialButtonOnTap(String url) async {
    try {
      await state.updateStatus(StateStatus.LOADING);
      if (await canLaunch(url)) {
        await state.updateStatus(StateStatus.SUCCESS);
        await launch(
          url,
          forceSafariVC: true,
          forceWebView: true,
          enableJavaScript: true,
        );
      } else {
        throw Exception();
      }
    } catch (exp) {
      await state.updateStatus(StateStatus.FAILURE,
          showSnackbarError: true, desc: 'request_failure'.tr);
      AppError.handleError(exception: exp);
    }
  }

  void handleDepositButtonOnTap() async {
    Get.put(IDODepositController());
    await Get.bottomSheet(IDODepositPage(), isScrollControlled: true);
    await Get.delete<IDODepositController>();
  }

  void handleClaimButtonOnTap() async {
    Get.put(IDOClaimController());
    await Get.bottomSheet(IDOClaimSelectAddress(), isScrollControlled: true);
    await Get.delete<IDOClaimController>();
  }
}
