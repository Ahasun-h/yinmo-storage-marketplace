import 'package:flutter/material.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/networks/api_access.dart';

class LogOutDialouge extends StatefulWidget {
  const LogOutDialouge({super.key});

  @override
  State<LogOutDialouge> createState() => _LogOutDialougeState();
}

class _LogOutDialougeState extends State<LogOutDialouge> {
  bool _isLoading = false;
  @override
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Are you sure you want to log out from your account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF505050),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: SpinKitChasingDots(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : CustomButton(
                          text: 'Yes',
                          bgColor: Colors.white,
                          textColor: AppColors.primaryColor,
                          borderColor: AppColors.primaryColor,
                          borderRadius: 12.r,
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            logoutRxOBJ
                                .logoutRx(
                                    refresh: appData.read(kKeyAccessToken))
                                .then((value) async {
                              if (value) {
                                ToastUtil.showShortToast(
                                    "Logout successfully.");
                                await appData.write(kKeyIsLoggedIn, false);
                                await appData.write(kKeyAccessToken, '');
                                setState(() {
                                  _isLoading = false;
                                });
                                NavigationService.goBack;
                                NavigationService.navigateToReplacement(
                                  Routes.login,
                                );
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                                ToastUtil.showShortToast("Failed to logout.");
                              }
                            });
                          },
                        ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    text: 'No',
                    bgColor: AppColors.primaryColor,
                    textColor: Colors.white,
                    borderColor: AppColors.primaryColor,
                    borderRadius: 12.r,
                    onTap: () {
                      NavigationService.goBack;
                    },
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
