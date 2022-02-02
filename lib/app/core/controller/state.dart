import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/widget_global/global_dialog_noti_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Status {
  StateStatus status;
  Status({this.status = StateStatus.INITIAL});

  bool get isInitial => status == StateStatus.INITIAL;
  bool get isLoading => status == StateStatus.LOADING;
  bool get isSuccess => status == StateStatus.SUCCESS;
  bool get isFailure => status == StateStatus.FAILURE;

  Future<void> updateStatus(
    StateStatus updateStatus, {
    String? title,
    String? desc,
    bool showSnackbarError = false,
    bool showSnackbarSuccess = false,
    bool showDialogSuccess = false,
    bool showDialogError = false,
    bool isBack = true,
  }) async {
    status = updateStatus;
    if (isLoading) {
      // ignore: unawaited_futures
      Get.dialog(
          Theme(
              data: ThemeData(
                  cupertinoOverrideTheme:
                      CupertinoThemeData(brightness: Brightness.dark)),
              child: CupertinoActivityIndicator(
                radius: 16.0,
              )),
          transitionDuration: Duration(milliseconds: 200));
    } else if (isSuccess) {
      await Future.delayed(Duration(milliseconds: 200));
      isBack ? Get.back() : null;
      try {
        if (Get.isDialogOpen!) {
          Get.back();
        }
      } catch (exp) {}
      if (showSnackbarSuccess) {
        Get.snackbar(
          'success_'.tr,
          desc ?? 'request_succ'.tr,
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING,
          colorText: AppColorTheme.toggleableActiveColor,
          backgroundColor: AppColorTheme.backGround,
          duration: Duration(milliseconds: 1000),
        );
      } else if (showDialogSuccess) {
        await Get.dialog(
            GlobalDialogNotiWidget(
              title: title!,
              desc: desc!,
              error: false,
            ),
            // barrierDismissible: false,
            transitionDuration: Duration(milliseconds: 200));
      }
      await Future.delayed(Duration(milliseconds: 200));
    } else if (isFailure) {
      await Future.delayed(Duration(milliseconds: 200));
      isBack ? Get.back() : null;
      try {
        if (Get.isDialogOpen!) {
          Get.back();
        }
      } catch (exp) {}
      if (showSnackbarError) {
        Get.snackbar('errorStr'.tr, desc ?? 'request_failure'.tr,
            snackPosition: SnackPosition.BOTTOM,
            snackStyle: SnackStyle.FLOATING,
            colorText: AppColorTheme.error,
            backgroundColor: AppColorTheme.backGround,
            duration: Duration(milliseconds: 1500));
      } else if (showDialogError) {
        await Get.dialog(
            GlobalDialogNotiWidget(
              title: title!,
              desc: desc!,
              error: true,
            ),
            // barrierDismissible: false,
            transitionDuration: Duration(milliseconds: 200));
      }
    }
  }

  static void hideSnackBarDialogBottomsheet() {
    if (Get.isDialogOpen != null && Get.isDialogOpen!) {
      Get.back();
    }
    if (Get.isSnackbarOpen != null && Get.isSnackbarOpen!) {
      Get.back();
    }
    if (Get.isBottomSheetOpen != null && Get.isBottomSheetOpen!) {
      Get.back();
    }
  }
}
