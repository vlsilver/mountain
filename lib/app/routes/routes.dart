class AppRoutes {
  static const SPLASH = '/splash';
  static const INITAL_APP_ERROR = '/initial_error';

  static const CHOICE_SETUP_WALLET = '/choice_setup_wallet';
  static const IMPORT_WALLET = '/import_wallet';

  static const LOGIN = '/login';

  static const HOME = '/home';
  static const TakeTour = '/take_tour';

  static const CREATE_WALLET = '/create_wallet';
  static const GUIDE_SAVE_SEEDPHRASE_STEP1 = '/guide_save_seedphrase_step1';
  static const GUIDE_SAVE_SEEDPHRASE_STEP2 = '/guide_save_seedphrase_step2';
  static const GUIDE_SAVE_SEEDPHRASE_STEP3 = '/guide_save_seedphrase_step3';
  static const GUIDE_SAVE_SEEDPHRASE_CONFIRM = '/guide_save_seedphrase_confirm';
  static const GUIDE_SAVE_SEEDPHRASE_COMPLETE =
      '/guide_save_seedphrase_complete';

  //create request recieve coin
  static const REQUEST_RECIEVE_SELECT = '/';
  static const REQUEST_RECIEVE_SIMPLE = '/simple';
  static const REQUEST_RECIEVE_AMOUNT = '/amount';
  static const REQUEST_RECIEVE_COMPLETE = '/complete';

  //create transaction and send it
  static const UPDATE_ADDRESS_SEND = '/';
  static const UPDATE_AMOUNT_SEND = '/update_amount_send';

  //swap transaction
  static const UPDATE_ADDRESS_SWAP = '/';
  static const UPDATE_AMOUNT_SWAP = '/update_amount_swap';

  //add liquidity
  static const LIST_ADD_LIQUIDITY = '/';
  static const UPDATE_ADDRESS_ADD_LIQUIDITY = 'update_address_add_liquidity';
  static const UPDATE_AMOUNT_ADD_LIQUIDITY = 'update_amount_add_liquidity';
  static const REMOVE_ADD_LIQUIDITY = 'remove_add_liquidity';

  //setting
  static const SETTING_CHANGE = '/setting_change';
  static const SETTING_CHANGE_GENERAL = '/setting_change_general';
  static const SETTING_CHANGE_SECURITY = '/setting_change_secutiry';
  static const SETTING_CHANGE_CONTACT = '/setting_change_contact';
  static const SETTING_CHANGE_CONTACT_DETAIl = '/setting_change_contact_detail';
  static const SETTING_CHANGE_CONTACT_EDIT = '/setting_change_contact_edit';
  static const SETTING_HISTORY_TRANSACTION = '/setting_history_transaction';
  static const REVOKE = '/revoke';

  //create transaction and send it
  static const ADD_TOKEN_ADD_ACTIVE = '/';
  static const ADD_TOKEN_INPUT = '/add_token_input';
  static const ADD_TOKEN_SELECT_BLOCK_CHAIN = '/add_token_select_blockchain';
  static const ADD_TOKEN_VIEW = '/add_token_view';

  static const SELECT_COIN_OF_ADDRESS = '/select_coin_of_address';

  static const NOTIFICATION = '/nofitication';

  //launch Pad
  static const LAUNCHPAD = '/launchpad';
}
