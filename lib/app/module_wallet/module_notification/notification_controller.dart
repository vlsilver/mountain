import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/module_setting/setting_history_transaction/setting_history_transaction_controller.dart';
import 'package:base_source/app/module_setting/setting_history_transaction/setting_history_transaction_page.dart';
import 'package:base_source/app/module_wallet/wallet_controller.dart';
import 'package:get/get.dart';

enum EnumNotification { LIST_NOTI }

class NotificationController extends GetxController {
  final walletController = Get.find<WalletController>();

  List<AddressModel> get notifications => walletController.notiTransactions;

  void handleNotiItemOnTap(int index) async {
    Get.put(SettingHistoryTransactionController(
        addressModel: notifications[index]));
    notifications.removeAt(index);
    await Get.to(() => SettingHistoryTransactionPage());
    await Get.delete<SettingHistoryTransactionController>();
    walletController.update([EnumUpdateWallet.NOTIFICATION]);
    update([EnumNotification.LIST_NOTI]);
  }

  void handleDeleteAll() async {
    walletController.notiTransactions = <AddressModel>[];
    walletController.update([EnumUpdateWallet.NOTIFICATION]);
    update([EnumNotification.LIST_NOTI]);
  }
}
