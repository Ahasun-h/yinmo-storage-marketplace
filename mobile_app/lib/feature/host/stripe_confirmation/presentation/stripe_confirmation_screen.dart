// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/feature/host/stripe_confirmation/model/strip_confirmation_model.dart';
import 'package:urban_koala/feature/host/stripe_confirmation/widget/stripe_confirmation_popup.dart';
import 'package:urban_koala/feature/host/stripe_confirmation/widget/stripe_confirmation_row.dart';
import 'package:urban_koala/feature/host/stripe_connect/widget/stripe_connect_row.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';

import '../../../user/item_details/widget/book_now_button.dart';

class StripeConfirmationScreen extends StatefulWidget {
  const StripeConfirmationScreen({super.key});

  @override
  State<StripeConfirmationScreen> createState() =>
      _StripeConfirmationScreenState();
}

class _StripeConfirmationScreenState extends State<StripeConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: getStripInfoRxOBJ.fileData,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.c011937),
            );
          } else if (!asyncSnapshot.hasError && asyncSnapshot.data != null) {
            StripConfirmationRes? stripConfirmationRes =
                StripConfirmationRes.fromJson(asyncSnapshot.data);
            StripModel? stripModel = stripConfirmationRes.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: "Stripe Confirmation"),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          UIHelper.verticalSpace(20.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.sp),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF011937),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: StripeConnectRow(
                              icon: Assets.icons.stripeConfirmation,
                              title: "Connected to Stripe",
                              subTitle: "Secure payments made easy with Stripe",
                              isDevider: false,
                              textColor: AppColors.cFFFFFF,
                            ),
                          ),
                          UIHelper.verticalSpace(20.h),
                          Text(
                            'Confirm payout details',
                            style: TextStyle(
                              color: const Color(0xFF202020),
                              fontSize: 14.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                              height: 1.43,
                            ),
                          ),
                          Text(
                            'Review and confirm the information that will\nbe used for deposits.',
                            style: TextStyle(
                              color: const Color(0xFF101010),
                              fontSize: 12.sp,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 1.67,
                            ),
                          ),
                          UIHelper.verticalSpace(12.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.sp),
                            decoration: ShapeDecoration(
                              color: const Color(0x7FE9E9E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Stripe info',
                                  style: TextStyle(
                                    color: const Color(0xFF202020),
                                    fontSize: 12.sp,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                                UIHelper.verticalSpace(16.h),
                                StripConfirmationRow(
                                  title: 'Account holder',
                                  value: stripModel
                                          ?.stripeAccount?.accountHolder ??
                                      '',
                                ),
                                StripConfirmationRow(
                                  title: 'ACC',
                                  value: stripModel
                                          ?.stripeAccount?.accountNumber ??
                                      '',
                                ),
                                StripConfirmationRow(
                                  title: 'Payout schedule',
                                  value: stripModel?.stripeAccount
                                          ?.payoutSchedule?.interval ??
                                      '',
                                ),
                                StripConfirmationRow(
                                  title: 'Tax & identity',
                                  value: 'Verified',
                                  isDevider: false,
                                  isIcon: true,
                                  icon: Assets.icons.verified,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(
                "Something went wrong!",
                style: TextStyle(
                  color: AppColors.c000000,
                  fontSize: 16.sp,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                  height: 1.43,
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BookNowButton(
        title: "Finish Setup",
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return const StripeConfirmationPopup();
            },
          );
        },
      ),
    );
  }
}
