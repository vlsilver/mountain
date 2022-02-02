// import 'package:base_source/app/core/values/size_values.dart';
// import 'package:flutter/material.dart';
//
// class CoinProfile extends StatelessWidget {
//   const CoinProfile({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Container(
//         child: Row(
//           children: [
//             Container(
//               height: 56.0,
//               width: 56.0,
//               padding: EdgeInsets.all(AppSizes.spaceNormal),
//               decoration: BoxDecoration(shape: BoxShape.circle, color: AppColorTheme.card),
//               child: Image.network(
//                 coinModel.image,
//                 height: 32,
//                 width: 32,
//               ),
//             ),
//             SizedBox(
//               width: AppSizes.spaceNormal,
//             ),
//             Container(
//               decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.white))),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   fit: FlexFit.tight,
//                   child: Column(
//                     children: [
//                       Text(
//                         coinModel.name,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black90, fontWeight: FontWeight.w600),
//                       ),
//                       Text(
//                         coinModel.priceCurrencyString,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: AppTextTheme.bodyText1.copyWith(color: AppColorTheme.black90),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Spacer(),
//                 Flexible(
//                   fit: FlexFit.tight,
//                   child: Column(
//                     children: [
//                       Text(
//                         coinModel.valueWithSymbolString,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: AppTextTheme.headline2.copyWith(color: AppColorTheme.black),
//                       ),
//                       Container(
//                         height: 24.0,
//                         width: 64.0,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                             color: coinModel.exchange > 0 ? AppColorTheme.toggleableActiveColor : AppColorTheme.error,
//                             borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium)),
//                         child: Text(
//                           coinModel.ratePercentFormat,
//                           style: AppTextTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
