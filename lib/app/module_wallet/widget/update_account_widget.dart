// import 'package:base_source/app/core/theme/color_theme.dart';
// import 'package:base_source/app/core/theme/text_theme.dart';
// import 'package:base_source/app/core/values/size_values.dart';
// import 'package:base_source/app/data/models/local_model/address_model.dart';
// import 'package:base_source/app/data/models/local_model/net_work_model.dart';
// import 'package:base_source/app/module_account/account_controller.dart';
// import 'package:base_source/app/module_wallet/wallet_controller.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';

// class UpdateAccountWidget extends StatelessWidget {
//   const UpdateAccountWidget({
//     Key? key,
//     required this.scrollController,
//   }) : super(key: key);

//   final ScrollController scrollController;

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<WalletController>(
//       id: EnumUpdateWallet.COIN,
//       builder: (_) {
//         final coins = _.networksSort();
//         return ListView.builder(
//             itemCount: coins.length,
//             controller: scrollController,
//             physics: BouncingScrollPhysics(),
//             itemBuilder: (context, index) {
//               return _ListViewAddressWidget(
//                 coinModel: coins[index],
//               );
//             });
//       },
//     );
//   }
// }

// class _ListViewAddressWidget extends GetView<WalletController> {
//   const _ListViewAddressWidget({
//     Key? key,
//     required this.coinModel,
//   }) : super(key: key);

//   final BlockChainModel coinModel;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(width: AppSizes.spaceMedium),
//             Container(
//               height: 8.0,
//               width: 8.0,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: controller.isCoinActive(index: coinModel.index)
//                     ? AppColorTheme.toggleableActiveColor
//                     : AppColorTheme.highlight,
//               ),
//             ),
//             SizedBox(width: AppSizes.spaceNormal),
//             Text(
//               'coinModel.crypto.networkModel',
//               style: AppTextTheme.bodyText1.copyWith(
//                   color: AppColorTheme.accent, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         GetBuilder<WalletController>(
//           id: EnumUpdateWallet.COIN_ADDRESS,
//           builder: (_) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: coinModel.addresss.map((address) {
//                 final isSelected = _.isAddressActive(index: address.index) &&
//                     _.isCoinActive(index: coinModel.index);
//                 return _AddressItemWidget(
//                   indexOfCoin: coinModel.index,
//                   addressModel: address,
//                   isSelected: isSelected,
//                 );
//               }).toList(),
//             );
//           },
//         ),
//         SizedBox(height: AppSizes.spaceNormal),
//       ],
//     );
//   }
// }

// class _AddressItemWidget extends GetView<AccountController> {
//   const _AddressItemWidget({
//     required this.addressModel,
//     required this.indexOfCoin,
//     required this.isSelected,
//     Key? key,
//   }) : super(key: key);

//   final AddressModel addressModel;
//   final int indexOfCoin;
//   final bool? isSelected;

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoButton(
//       onPressed: () {
//         controller.handleItemAddressOnTap(
//             indexOfAdress: addressModel.index, indexOfCoin: indexOfCoin);
//       },
//       padding: EdgeInsets.zero,
//       child: Container(
//         margin: EdgeInsets.symmetric(
//             horizontal: AppSizes.spaceMedium,
//             vertical: AppSizes.spaceVerySmall),
//         padding: EdgeInsets.symmetric(
//             horizontal: AppSizes.spaceMedium, vertical: AppSizes.spaceSmall),
//         height: 72.0,
//         decoration: BoxDecoration(
//             color: AppColorTheme.focus80,
//             borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall)),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SvgPicture.asset(addressModel.avatarAddress()),
//             SizedBox(width: AppSizes.spaceMedium),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(addressModel.name,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: AppTextTheme.bodyText2.copyWith(
//                         color: AppColorTheme.black,
//                         fontWeight: FontWeight.w600)),
//                 Text(addressModel.addressFormat,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: AppTextTheme.bodyText2
//                         .copyWith(color: AppColorTheme.black60)),
//                 Text(
//                   'addressModel.surPlus',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: AppTextTheme.bodyText2
//                       .copyWith(color: AppColorTheme.error),
//                 )
//               ],
//             ),
//             Expanded(child: SizedBox()),
//             isSelected == null
//                 ? SizedBox.shrink()
//                 : isSelected!
//                     ? Icon(
//                         Icons.check_circle_outline,
//                         color: AppColorTheme.toggleableActiveColor,
//                       )
//                     : SizedBox.shrink()
//           ],
//         ),
//       ),
//     );
//   }
// }
