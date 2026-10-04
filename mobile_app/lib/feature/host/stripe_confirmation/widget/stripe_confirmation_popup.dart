import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class StripeConfirmationPopup extends StatefulWidget {
  const StripeConfirmationPopup({super.key});

  @override
  State<StripeConfirmationPopup> createState() =>
      _StripeConfirmationPopupState();
}

class _StripeConfirmationPopupState extends State<StripeConfirmationPopup> {
  @override
  void initState() {
    goNext();
    super.initState();
  }

  void goNext() async {
    await Future.delayed(Duration(seconds: 2));
    NavigationService.navigateTo(Routes.hostNavigation);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(Assets.icons.paysuccess),
              UIHelper.verticalSpace(20.h),
              Text(
                'Account Setup Finished',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF202020),
                  fontSize: 16.sp,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
              UIHelper.verticalSpace(4.h),
              Text(
                'Your account has been successfully set up and\nconnected to Stripe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF4D4D4D),
                  fontSize: 12.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
