// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/feature/user/booking_form/widget/custom_bottom_btn.dart';
import 'package:urban_koala/feature/user/checkout/widget/pricing_summary.dart';
import 'package:urban_koala/feature/user/checkout/widget/service_details.dart';
import 'package:urban_koala/feature/user/checkout/widget/success_popup.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/common_widgets/guest_auth_dialog.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../../../../networks/api_access.dart';
import '../model/booking_store_model.dart';

class CheckOutScreen extends StatefulWidget {
  final Map<String, dynamic>? jsonData;
  const CheckOutScreen({super.key, this.jsonData});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  BookingStoreRes? currentBookingForm;

  String _formatChf(num? amount) => '${(amount ?? 0).toStringAsFixed(2)} CHF';

  @override
  initState() {
    currentBookingForm = BookingStoreRes.fromJson(
      widget.jsonData != null ? widget.jsonData! : {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: 'Secure Checkout'),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(color: const Color(0xFFF3F3F3)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Summary',
                          style: TextStyle(
                            color: const Color(0xFF202020),
                            fontSize: 16,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                        UIHelper.verticalSpace(12.h),
                        ServiceDetails(
                          name: currentBookingForm?.title ?? "",
                          location: currentBookingForm?.location ?? "",
                          price: _formatChf(currentBookingForm?.total),
                          pricePer: "Per Day",
                          slot: currentBookingForm?.selectedSlots,
                        ),
                        UIHelper.verticalSpace(12.h),
                        PricingSummery(
                          total: currentBookingForm?.total?.toStringAsFixed(2),
                          subTotal:
                              currentBookingForm?.subtotal?.toStringAsFixed(
                                    2,
                                  ) ??
                                  '0.00',
                          extraService: currentBookingForm?.extraServices,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UIHelper.verticalSpace(20.h),
                        Text(
                          'Select Payment Method',
                          style: TextStyle(
                            color: const Color(0xFF202020),
                            fontSize: 16.sp,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        UIHelper.verticalSpace(12.h),
                        Container(
                          padding: EdgeInsets.all(12.sp),
                          decoration: ShapeDecoration(
                            color: const Color(0x0C0F958F),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.w,
                                color: const Color(0xFF0F958F),
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(Assets.icons.stripe),
                                  UIHelper.horizontalSpace(10.w),
                                  Text(
                                    'Strip',
                                    style: TextStyle(
                                      color: const Color(0xFF4D4D4D),
                                      fontSize: 12.sp,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(3.sp),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.w,
                                      color: const Color(0xFF0F958F),
                                    ),
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                ),
                                child: Icon(
                                  Icons.circle,
                                  color: AppColors.primaryColor,
                                  size: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: Theme.of(context).platform == TargetPlatform.android,
        child: CustomBottomNavBtn(
          total: _formatChf(currentBookingForm?.total),
          btnName: "Confirm and Pay",
          onTap: () async {
            if (appData.read(kKeyIsLoggedIn) != true) {
              await showDialog(
                context: context,
                builder: (context) => const GuestAuthDialog(),
              );
              if (appData.read(kKeyIsLoggedIn) != true) return;
            }

            if (currentBookingForm == null) {
              log("Error: currentBookingForm is null");
              return;
            }
            try {
              // Convert BookingStoreRes to JSON
              final jsonData = currentBookingForm?.toJson();
              log("🗒️ Booking Data: $jsonData");
              final jsonString = jsonEncode(jsonData);

              log("📝 Booking Confirmation JSON: $jsonString");

              // STEP 1: Post booking data to API
              log("📤 Posting booking data to API...");
              final isSuccess = await postBookingStoreRxOBJ
                  .post(jsonString)
                  .waitingForFutureWithoutBg();

              log("✅ API Response Success: $isSuccess");

              if (!isSuccess) {
                log("❌ Booking API failed");
                return;
              }

              // STEP 2: Get Client Secret from API response
              final clientSecret = appData.read(kKeyClientSecret);
              log("🔐 CLIENT SECRET: $clientSecret");

              if (clientSecret == null || clientSecret.isEmpty) {
                log("⚠️ Client secret is missing or empty");
                // Show error toast
                return;
              }

              // STEP 3: Initialize and present Stripe payment sheet
              log("💳 Initializing Stripe payment sheet...");

              // Make sure Stripe is properly initialized with publishable key
              await Stripe.instance.initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: clientSecret,
                  merchantDisplayName: 'Testing App',
                  style: ThemeMode.system,
                  allowsDelayedPaymentMethods: true,
                  appearance: PaymentSheetAppearance(
                    colors: PaymentSheetAppearanceColors(
                      primary: AppColors.primaryColor,
                      background: AppColors.cF3F3F3,
                      primaryText: AppColors.c000000,
                      secondaryText: AppColors.c000000,
                      icon: AppColors.c000000,
                    ),
                  ),
                  // Add any additional parameters if needed
                ),
              );

              log("📱 Presenting payment sheet...");
              await Stripe.instance.presentPaymentSheet();

              log("✅ Payment Successful!");

              // Show success popup
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) => const SuccessPopup(),
                );
              }
            } catch (e) {
              log("❌ ERROR: $e");
              // Show error toast to user
            }
          },
        ),
      ),
    );
  }
}
