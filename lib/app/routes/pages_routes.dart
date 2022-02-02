import 'package:base_source/app/module_account/account_binding.dart';
import 'package:base_source/app/module_dashboard/dashboard_binding.dart';
import 'package:base_source/app/module_home/home_binding.dart';
import 'package:base_source/app/module_home/home_page.dart';
import 'package:base_source/app/module_markets/martkets_binding.dart';

import 'package:base_source/app/module_setting/setting_binding.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_contact/pages/setting_change_contact_detail_page.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_contact/pages/setting_change_contact_edit_page.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_contact/pages/setting_change_contact_page.dart';
import 'package:base_source/app/module_setting/setting_change/pages/setting_change_general_page.dart';
import 'package:base_source/app/module_setting/setting_change/pages/setting_change_security_page.dart';
import 'package:base_source/app/module_setting/setting_change/setting_change_binding.dart';
import 'package:base_source/app/module_setting/setting_change/pages/setting_change_adjust_page.dart';
import 'package:base_source/app/module_setting/setting_history_transaction/setting_history_transaction_binding.dart';
import 'package:base_source/app/module_setting/setting_history_transaction/setting_history_transaction_page.dart';
import 'package:base_source/app/module_setting/setting_revoke/pages/revoke_page.dart';
import 'package:base_source/app/module_setting/setting_revoke/revoke_binding.dart';
import 'package:base_source/app/module_splash/choice_setup_wallet/choice_setup_binding.dart';
import 'package:base_source/app/module_splash/choice_setup_wallet/choice_setup_page.dart';
import 'package:base_source/app/module_splash/splash/splash_binding.dart';
import 'package:base_source/app/module_splash/splash/splash_page.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/add_liquidity_binding.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/list_add_liquidity/list_add_liquidity_binding.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/list_add_liquidity/list_add_liquidity_page.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/remove_add_liquidity/remove_add_liquidity_binding.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/remove_add_liquidity/remove_add_liquidity_controller.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/remove_add_liquidity/remove_add_liquidity_page.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/update_address_add_liquidity/update_address_add_liquidity_binding.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/update_address_add_liquidity/update_address_add_liquidity_controller.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/update_address_add_liquidity/update_address_add_liquidity_page.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/update_amount_add_liquidity/update_amount_add_liquidity_binding.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/update_amount_add_liquidity/update_amount_add_liquidity_controller.dart';
import 'package:base_source/app/module_wallet/module_add_liquidity/update_amount_add_liquidity/update_amount_add_liquidity_page.dart';
import 'package:base_source/app/module_wallet/module_add_token/add_token_binding.dart';
import 'package:base_source/app/module_wallet/module_add_token/pages/add_token_active_page.dart';
import 'package:base_source/app/module_wallet/module_add_token/pages/add_token_page.dart';
import 'package:base_source/app/module_wallet/module_add_token/pages/select_blockchain_page.dart';

import 'package:base_source/app/module_wallet/module_create/create_wallet/create_wallet_binding.dart';
import 'package:base_source/app/module_wallet/module_create/create_wallet/create_wallet_page.dart';
import 'package:base_source/app/module_wallet/module_create/guide_save_seedphrase_complete/guide_save_seedphrase_binding.dart';
import 'package:base_source/app/module_wallet/module_create/guide_save_seedphrase_complete/guide_save_seedphrase_page.dart';
import 'package:base_source/app/module_wallet/module_create/guide_save_seedphrase_confirm/guide_save_seedphrase_confirm_binding.dart';
import 'package:base_source/app/module_wallet/module_create/guide_save_seedphrase_confirm/guide_save_seedphrase_confirm_page.dart';
import 'package:base_source/app/module_wallet/module_create/guide_save_seedphrase_step1/guide_save_seedphrase_step1_binding.dart';
import 'package:base_source/app/module_wallet/module_create/guide_save_seedphrase_step1/guide_save_seedphrase_step1_page.dart';
import 'package:base_source/app/module_wallet/module_create/guide_save_seedphrase_step2/guide_save_seedphrase_step2_binding.dart';
import 'package:base_source/app/module_wallet/module_create/guide_save_seedphrase_step2/guide_save_seedphrase_step2_page.dart';
import 'package:base_source/app/module_wallet/module_create/guide_save_seedphrase_step3/guide_save_seedphrase_step3_binding.dart';
import 'package:base_source/app/module_wallet/module_create/guide_save_seedphrase_step3/guide_save_seedphrase_step3_page.dart';
import 'package:base_source/app/module_wallet/module_import_wallet/import_wallet_binding.dart';
import 'package:base_source/app/module_wallet/module_import_wallet/import_wallet_page.dart';
import 'package:base_source/app/module_wallet/module_launch_pad_intro/launch_pad_intro_binding.dart';
import 'package:base_source/app/module_wallet/module_launch_pad_intro/launch_pad_intro_page.dart';
import 'package:base_source/app/module_wallet/module_login/login_binding.dart';
import 'package:base_source/app/module_wallet/module_login/login_page.dart';
import 'package:base_source/app/module_wallet/module_request_receive/pages/input_amount_page.dart';
import 'package:base_source/app/module_wallet/module_request_receive/pages/receive_complete_page.dart';
import 'package:base_source/app/module_wallet/module_request_receive/pages/receive_simple_page.dart';
import 'package:base_source/app/module_wallet/module_request_receive/pages/select_coin_page.dart';
import 'package:base_source/app/module_wallet/module_request_receive/request_recevie_binding.dart';
import 'package:base_source/app/module_wallet/module_send/send_binding.dart';
import 'package:base_source/app/module_wallet/module_send/update_address_send/update_address_send_binding.dart';
import 'package:base_source/app/module_wallet/module_send/update_address_send/update_address_send_page.dart';
import 'package:base_source/app/module_wallet/module_send/update_amount_send/update_amount_send_binding.dart';
import 'package:base_source/app/module_wallet/module_send/update_amount_send/update_amount_send_controller.dart';
import 'package:base_source/app/module_wallet/module_send/update_amount_send/update_amount_send_page.dart';
import 'package:base_source/app/module_wallet/module_swap/swap_binding.dart';
import 'package:base_source/app/module_wallet/module_swap/update_address_swap/update_address_swap_binding.dart';
import 'package:base_source/app/module_wallet/module_swap/update_address_swap/update_address_swap_page.dart';
import 'package:base_source/app/module_wallet/module_swap/update_amount_swap/update_amount_swap_binding.dart';
import 'package:base_source/app/module_wallet/module_swap/update_amount_swap/update_amount_swap_controller.dart';
import 'package:base_source/app/module_wallet/module_swap/update_amount_swap/update_amount_swap_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import 'routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.HOME,
      transitionDuration: Duration(milliseconds: 400),
      bindings: [
        HomeBinding(),
        DashBoardBinding(),
        SettingBinding(),
        AccountBinding(),
        MartketsBinding(),
      ],
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      binding: LoginBinding(),
      page: () => LoginPage(),
    ),
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.INITAL_APP_ERROR,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.CHOICE_SETUP_WALLET,
      page: () => ChoiceSetupPage(),
      binding: ChoiceSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.CREATE_WALLET,
      page: () => CreateWalletPage(),
      binding: CreateWalletBinding(),
    ),
    GetPage(
      name: AppRoutes.GUIDE_SAVE_SEEDPHRASE_STEP1,
      page: () => GuideSaveSeedPhraseStep1Page(),
      binding: GuideSaveSeedPhraseStep1Binding(),
    ),
    GetPage(
      name: AppRoutes.GUIDE_SAVE_SEEDPHRASE_STEP2,
      page: () => GuideSaveSeedPhraseStep2Page(),
      // transition: Transition.noTransition,
      binding: GuideSaveSeedPhraseStep2Binding(),
    ),
    GetPage(
      name: AppRoutes.GUIDE_SAVE_SEEDPHRASE_STEP3,
      page: () => GuideSaveSeedPhraseStep3Page(),
      // transition: Transition.noTransition,
      binding: GuideSaveSeedPhraseStep3Binding(),
    ),
    GetPage(
      name: AppRoutes.GUIDE_SAVE_SEEDPHRASE_CONFIRM,
      page: () => GuideSaveSeedPhraseConfirmPage(),
      // transition: Transition.noTransition,
      binding: GuideSaveSeedPhraseConfirmBinding(),
    ),
    GetPage(
      name: AppRoutes.GUIDE_SAVE_SEEDPHRASE_COMPLETE,
      page: () => GuideSaveSeedPhraseCompletePage(),
      // transition: Transition.noTransition,
      binding: GuideSaveSeedPhraseCompleteBinding(),
    ),
    GetPage(
      name: AppRoutes.IMPORT_WALLET,
      page: () => ImportWalletPage(),
      binding: ImportWalletdBinding(),
    ),
    GetPage(
      name: AppRoutes.SETTING_CHANGE,
      page: () => SettingChangePage(),
      binding: SettingChangeBinding(),
    ),
    GetPage(
      name: AppRoutes.SETTING_CHANGE_GENERAL,
      page: () => SettingChangeGeneralPage(),
    ),
    GetPage(
      name: AppRoutes.SETTING_CHANGE_SECURITY,
      page: () => SettingChangeSecurityPage(),
    ),
    GetPage(
      name: AppRoutes.SETTING_CHANGE_CONTACT,
      page: () => SettingChangeContactPage(),
    ),
    GetPage(
      name: AppRoutes.SETTING_CHANGE_CONTACT_DETAIl,
      page: () => SettingChangeContactDetailPage(),
    ),
    GetPage(
      name: AppRoutes.SETTING_CHANGE_CONTACT_EDIT,
      page: () => SettingChangeContactEditPage(),
    ),
    GetPage(
      name: AppRoutes.SETTING_HISTORY_TRANSACTION,
      binding: SettingHistoryTransactionBinding(),
      page: () => SettingHistoryTransactionPage(),
    ),
    GetPage(
      name: AppRoutes.REVOKE,
      binding: RevokeBinding(),
      page: () => RevokePage(),
    ),
    GetPage(
      name: AppRoutes.LAUNCHPAD,
      page: () => LaunchPadIntroPage(),
      binding: LaunchPadIntroBinding(),
    ),
  ];

  static GetPageRoute<Widget> pageNavigatorSend(
    String name,
    bool isFullScreen,
  ) {
    switch (name) {
      case AppRoutes.UPDATE_ADDRESS_SEND:
        return GetPageRoute(
          page: () => UpdateAddressSendPage(isFullScreen: isFullScreen),
          transition: Transition.noTransition,
          bindings: [
            SendBinding(),
            UpdateAddressSendBinding(),
          ],
        );

      case AppRoutes.UPDATE_AMOUNT_SEND:
        return GetPageRoute(
            page: () => UpdateAmountSendPage(
                  isFullScreen: isFullScreen,
                ),
            binding: UpdateAmountSendBinding(),
            middlewares: [AppGetMiddleware<UpdateAmountSendController>()]);

      default:
        return GetPageRoute(
          page: () => UpdateAddressSendPage(isFullScreen: isFullScreen),
          transition: Transition.noTransition,
          binding: UpdateAddressSendBinding(),
        );
    }
  }

  static GetPageRoute<Widget> pageNavigatorRequestRecieve(String name) {
    switch (name) {
      case AppRoutes.REQUEST_RECIEVE_SELECT:
        return GetPageRoute(
            page: () => SelectCoinPage(),
            binding: RequestRecieveBinding(),
            transition: Transition.noTransition);
      case AppRoutes.REQUEST_RECIEVE_SIMPLE:
        return GetPageRoute(
          page: () => RecieveSimplePage(),
          transition: Transition.downToUp,
        );
      case AppRoutes.REQUEST_RECIEVE_AMOUNT:
        return GetPageRoute(
          page: () => InputAmountPage(),
          transition: Transition.downToUp,
        );
      case AppRoutes.REQUEST_RECIEVE_COMPLETE:
        return GetPageRoute(
          page: () => RecieveCompletePage(),
          transition: Transition.downToUp,
        );
      default:
        return GetPageRoute(
          page: () => SelectCoinPage(),
          binding: RequestRecieveBinding(),
          transition: Transition.downToUp,
        );
    }
  }

  static GetPageRoute<Widget> pageNavigatorAddToken(String name) {
    switch (name) {
      case AppRoutes.ADD_TOKEN_ADD_ACTIVE:
        return GetPageRoute(
            page: () => AddTokenActivePage(),
            binding: AddTokenBinding(),
            transition: Transition.noTransition);
      case AppRoutes.ADD_TOKEN_INPUT:
        return GetPageRoute(
          page: () => AddTokenPage(),
          transition: Transition.downToUp,
        );
      case AppRoutes.ADD_TOKEN_SELECT_BLOCK_CHAIN:
        return GetPageRoute(
          page: () => SelectBlockChainPage(),
          transition: Transition.downToUp,
        );
      case AppRoutes.REQUEST_RECIEVE_AMOUNT:
        return GetPageRoute(
          page: () => InputAmountPage(),
          transition: Transition.downToUp,
        );

      default:
        return GetPageRoute(
          page: () => AddTokenActivePage(),
          transition: Transition.noTransition,
          binding: AddTokenBinding(),
        );
    }
  }

  static GetPageRoute<Widget> pageNavigatorSwap(
    String name,
    bool isFullScreen,
    bool isFast,
  ) {
    switch (name) {
      case AppRoutes.UPDATE_ADDRESS_SWAP:
        return isFast
            ? GetPageRoute(
                page: () => UpdateAmountSwapPage(
                      isFullScreen: isFullScreen,
                      isFast: isFast,
                    ),
                transition: Transition.noTransition,
                bindings: isFullScreen
                    ? [
                        SwapBinding(),
                        UpdateAmountSwapBinding(),
                      ]
                    : [
                        UpdateAmountSwapBinding(),
                      ])
            : GetPageRoute(
                page: () => UpdateAddressSwapPage(
                      isFullScreen: isFullScreen,
                    ),
                transition: Transition.noTransition,
                bindings: isFullScreen
                    ? [
                        SwapBinding(),
                        UpdateAddressSwapBinding(),
                      ]
                    : [
                        UpdateAddressSwapBinding(),
                      ]);

      case AppRoutes.UPDATE_AMOUNT_SWAP:
        return GetPageRoute(
            page: () => UpdateAmountSwapPage(
                  isFullScreen: isFullScreen,
                  isFast: isFast,
                ),
            binding: UpdateAmountSwapBinding(),
            middlewares: [AppGetMiddleware<UpdateAmountSwapController>()]);
      default:
        return GetPageRoute(
          page: () => UpdateAddressSwapPage(
            isFullScreen: isFullScreen,
          ),
          transition: Transition.noTransition,
          bindings: [
            SwapBinding(),
            UpdateAddressSwapBinding(),
          ],
        );
    }
  }

  static GetPageRoute<Widget> pageNavigatorAddLiquidity(
      String name, bool isFullScreen) {
    switch (name) {
      case AppRoutes.LIST_ADD_LIQUIDITY:
        return GetPageRoute(
          page: () => ListAddLiquidityPage(),
          bindings: [
            AddLiquidityBinding(),
            ListAddLiquidBinding(),
          ],
        );
      case AppRoutes.UPDATE_ADDRESS_ADD_LIQUIDITY:
        return GetPageRoute(
            page: () =>
                UpdateAddressAddLiquidityPage(isFullScreen: isFullScreen),
            bindings: [
              UpdateAddressAddLiquidityBinding(),
            ],
            middlewares: [
              AppGetMiddleware<UpdateAddressAddLiquidityController>()
            ]);

      case AppRoutes.UPDATE_AMOUNT_ADD_LIQUIDITY:
        return GetPageRoute(
            page: () =>
                UpdateAmountAddLiquidityPage(isFullScreen: isFullScreen),
            bindings: [
              UpdateAmountAddLiquidityBinding(),
            ],
            middlewares: [
              AppGetMiddleware<UpdateAmountAddLiquidityController>()
            ]);
      case AppRoutes.REMOVE_ADD_LIQUIDITY:
        return GetPageRoute(
            page: () => RemoveAddLiquidityPage(
                  isFullScreen: isFullScreen,
                ),
            bindings: [
              RemoveAddLiquidityBinding(),
            ],
            middlewares: [
              AppGetMiddleware<RemoveAddLiquidityController>()
            ]);

      default:
        return GetPageRoute(
          page: () => ListAddLiquidityPage(),
          bindings: [
            AddLiquidityBinding(),
            ListAddLiquidBinding(),
          ],
        );
    }
  }

  static const NAVIGATOR_KEY_ADD_ACCOUNT = 1;
  static const NAVIGATOR_KEY_SEND = 2;
  static const NAVIGATOR_KEY_REQUEST_RECEIVE = 3;
  static const NAVIGATOR_KEY_ADD_TOKEN = 4;
  static const NAVIGATOR_KEY_SWAP = 5;
  static const NAVIGATOR_KEY_ADD_LIQUIDITY = 6;
}

class AppGetMiddleware<T extends GetxController> extends GetMiddleware {
  @override
  void onPageDispose() async {
    await Get.delete<T>();
    super.onPageDispose();
  }
}
