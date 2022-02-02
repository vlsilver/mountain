import 'package:base_source/app/core/theme/color_theme.dart';
import 'package:base_source/app/core/theme/text_theme.dart';
import 'package:base_source/app/core/utils/enum_utils.dart';
import 'package:base_source/app/core/values/size_values.dart';
import 'package:base_source/app/data/models/local_model/address_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/models/local_model/transaction_model.dart';
import 'package:base_source/app/widget_global/global_avatar_coin_widget.dart';
import 'package:base_source/app/widget_global/global_bottomsheet_layout_widget.dart';
import 'package:base_source/app/widget_global/global_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionFullInformationWidget extends StatelessWidget {
  const TransactionFullInformationWidget({
    Key? key,
    required this.transaction,
    required this.addressModel,
    required this.coinModel,
    required this.onTap,
  }) : super(key: key);
  final TransactionData transaction;
  final AddressModel addressModel;
  final CoinModel coinModel;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GlobalBottomSheetLayoutWidget(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLarge),
        child: Column(
          children: [
            SizedBox(height: AppSizes.spaceNormal),
            Text(
              (transaction.isSender(addressModel: addressModel)
                      ? 'global_send'.tr
                      : 'global_recieve'.tr) +
                  ' ${coinModel.symbol}',
              style: AppTextTheme.headline2.copyWith(
                  color: AppColorTheme.black, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: AppSizes.spaceNormal),
            GlobalAvatarCoinWidget(
                coinModel: coinModel, height: 64.0, width: 64.0),
            SizedBox(height: AppSizes.spaceVeryLarge),
            Row(children: [
              Text(
                'global_status'.tr,
                style: AppTextTheme.bodyText1.copyWith(
                  color: AppColorTheme.black60,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                  child: transaction.isPending
                      ? Text(
                          'global_pending'.tr,
                          textAlign: TextAlign.right,
                          style: AppTextTheme.bodyText2.copyWith(
                            color: AppColorTheme.highlight,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : transaction.isFailure
                          ? Text(
                              'global_canceled'.tr,
                              textAlign: TextAlign.right,
                              style: AppTextTheme.bodyText1.copyWith(
                                color: AppColorTheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
                              'global_confirmed'.tr,
                              textAlign: TextAlign.right,
                              style: AppTextTheme.bodyText1.copyWith(
                                color: AppColorTheme.toggleableActiveColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ))
            ]),
            SizedBox(height: AppSizes.spaceSmall),
            Row(children: [
              Text(
                'global_time'.tr,
                style: AppTextTheme.bodyText1.copyWith(
                  color: AppColorTheme.black60,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  transaction.time(),
                  textAlign: TextAlign.right,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ]),
            SizedBox(height: AppSizes.spaceSmall),
            Row(children: [
              Text(
                'global_from'.tr,
                style: AppTextTheme.bodyText1.copyWith(
                  color: AppColorTheme.black60,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  AddressModel.addressFormatWithValue(transaction.from),
                  textAlign: TextAlign.right,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.black60,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ]),
            SizedBox(height: AppSizes.spaceSmall),
            Row(children: [
              Text(
                'global_to'.tr,
                style: AppTextTheme.bodyText1.copyWith(
                  color: AppColorTheme.black60,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  AddressModel.addressFormatWithValue(transaction.to),
                  textAlign: TextAlign.right,
                  style: AppTextTheme.bodyText1.copyWith(
                    color: AppColorTheme.black60,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ]),
            SizedBox(height: AppSizes.spaceLarge),
            Container(
              padding: EdgeInsets.all(AppSizes.spaceLarge),
              decoration: BoxDecoration(
                  color: AppColorTheme.card,
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusSmall)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('global_amount'.tr,
                          style: AppTextTheme.bodyText1
                              .copyWith(color: AppColorTheme.black60)),
                      SizedBox(width: AppSizes.spaceNormal),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      transaction.valueFormatString(coinModel),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      maxLines: 1,
                                      style: AppTextTheme.bodyText1.copyWith(
                                        color: AppColorTheme.black80,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' ' + coinModel.symbol,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: AppTextTheme.bodyText1
                                        .copyWith(color: AppColorTheme.black80),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '-',
                              textAlign: TextAlign.end,
                              style: AppTextTheme.bodyText1
                                  .copyWith(color: AppColorTheme.black80),
                            ),
                            Text(
                              transaction
                                  .valueFormatCurrencyByCoinModel(coinModel),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: AppTextTheme.bodyText1
                                  .copyWith(color: AppColorTheme.black80),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceNormal),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('global_fee_network'.tr,
                          style: AppTextTheme.bodyText1
                              .copyWith(color: AppColorTheme.black60)),
                      SizedBox(width: AppSizes.spaceSmall),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                transaction
                                    .feeFormatStringByCoinModel(coinModel),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: AppTextTheme.bodyText1
                                    .copyWith(color: AppColorTheme.black80),
                              ),
                            ),
                            Text(
                              '-',
                              textAlign: TextAlign.end,
                              style: AppTextTheme.bodyText1
                                  .copyWith(color: AppColorTheme.black80),
                            ),
                            Text(
                              transaction
                                  .feeFormatCurrencyByCoinModel(coinModel),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: AppTextTheme.bodyText1
                                  .copyWith(color: AppColorTheme.black80),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceNormal),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'global_total'.tr,
                        style: AppTextTheme.bodyText1.copyWith(
                            color: AppColorTheme.error,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: AppSizes.spaceNormal),
                      Expanded(
                        child: Text(
                          transaction.totalFormatCurrencyByCoinModel(coinModel),
                          textAlign: TextAlign.end,
                          style: AppTextTheme.bodyText1.copyWith(
                              color: AppColorTheme.error,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox(height: AppSizes.spaceMedium)),
            GlobalButtonWidget(
                name: 'global_detail'.tr,
                type: ButtonType.ACTIVE,
                onTap: () {
                  onTap();
                }),
            SizedBox(height: AppSizes.spaceVeryLarge),
          ],
        ),
      ),
    );
  }
}
