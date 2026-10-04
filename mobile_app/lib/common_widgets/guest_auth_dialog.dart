import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class GuestAuthDialog extends StatelessWidget {
  const GuestAuthDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Sign In Required",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            UIHelper.verticalSpace(10.h),
            Text(
              "You need to sign in to access this feature.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            UIHelper.verticalSpace(20.h),
            CustomButton(
              text: "Sign In",
              onTap: () async {
                NavigationService.goBack; // Close the dialog
                await NavigationService.navigateToWithArgs(
                  Routes.login,
                  {'isFromAuthHole': true},
                );
              },
            ),
            UIHelper.verticalSpace(10.h),
            TextButton(
              onPressed: () {
                NavigationService.goBack;
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
