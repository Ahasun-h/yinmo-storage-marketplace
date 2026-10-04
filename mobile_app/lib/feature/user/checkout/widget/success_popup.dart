import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/navigation_screen.dart';

class SuccessPopup extends StatefulWidget {
  const SuccessPopup({super.key});

  @override
  State<SuccessPopup> createState() => _SuccessPopupState();
}

class _SuccessPopupState extends State<SuccessPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [SvgPicture.asset(Assets.icons.closewithcircle)],
            ),
            UIHelper.verticalSpace(16.h),
            SvgPicture.asset(Assets.icons.paysuccess),
            UIHelper.verticalSpace(20.h),
            Text(
              'Booking Confirmed',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF202020),
                fontSize: 16.sp,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
              ),
            ),
            UIHelper.verticalSpace(4.h),
            Text(
              'Your parking spot is reserved. A receipt was\nsent to your email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF4D4D4D),
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            UIHelper.verticalSpace(24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      NavigationService.navigateTo(Routes.navigation);
                    },
                    text: "Back to Home",
                    bgColor: AppColors.cFFFFFF,
                    borderColor: const Color(0xFFE9E9E9),
                    textColor: AppColors.primaryColor,
                  ),
                ),
                UIHelper.horizontalSpace(16.w),
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationScreen(pageNum: 1),
                        ),
                      );
                    },
                    text: "My bookings",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
