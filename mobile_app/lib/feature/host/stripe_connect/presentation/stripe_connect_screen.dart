import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/feature/host/stripe_connect/widget/stripe_connect_row.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/helpers/url_lunch.dart';

import '../../../../networks/api_access.dart';
import '../../../user/item_details/widget/book_now_button.dart';

class StripeConnectScreen extends StatefulWidget {
  const StripeConnectScreen({super.key});

  @override
  State<StripeConnectScreen> createState() => _StripeConnectScreenState();
}

class _StripeConnectScreenState extends State<StripeConnectScreen>
    with WidgetsBindingObserver {
  bool _isRedirectingToStripe = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isRedirectingToStripe) {
      _isRedirectingToStripe = false;
      getStripInfoRxOBJ.getData().waitingForFutureWithoutBg().then((value) {
        if (value) {
          NavigationService.navigateTo(Routes.stripeConfirmation);
        } else {
          NavigationService.navigateToUntilReplacement(Routes.basicInformation);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: "Connect Stripe"),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    UIHelper.verticalSpace(20.h),
                    Text(
                      'Verify identity for payouts',
                      style: TextStyle(
                        color: const Color(0xFF202020),
                        fontSize: 14.sp,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w600,
                        height: 1.43,
                      ),
                    ),
                    UIHelper.verticalSpace(4.h),
                    Text(
                      'Next we\'ll connect your account with Stripe\nexpress so you can get paid.',
                      style: TextStyle(
                        color: const Color(0xFF101010),
                        fontSize: 14.sp,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                      ),
                    ),
                    UIHelper.verticalSpace(20.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.sp),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF3F3F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          StripeConnectRow(
                            icon: Assets.icons.secureVerification,
                            title: "Secure verification",
                            subTitle:
                                "Your data is encrypted and handled by Stripe.",
                          ),
                          StripeConnectRow(
                            icon: Assets.icons.yourInfoIsEncrypted,
                            title: "Your info is encrypted",
                            subTitle:
                                "Only Stripe stores your sensitive data. We will never see your bank numbers.",
                          ),
                          StripeConnectRow(
                            icon: Assets.icons.fastPayouts,
                            title: "Fast payouts",
                            subTitle:
                                "Choose bank account and payout schedule.",
                          ),
                          StripeConnectRow(
                            icon: Assets.icons.stripeTermsAccepted,
                            title: "Stripe terms accepted",
                            subTitle:
                                "You can update bank details anytime in Stripe.",
                            isDevider: false,
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
      ),
      bottomNavigationBar: BookNowButton(
        title: "Continue to Stripe",
        onTap: () {
          try {
            _isRedirectingToStripe = true;
            urlLunch(appData.read(kKeyOnboardingUrl));
          } catch (e) {
            log('errroor $e');
            _isRedirectingToStripe = false;
          }
        },
      ),
    );
  }
}
