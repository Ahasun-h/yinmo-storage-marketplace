// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  TextEditingController currentPassController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  bool _iCurrentsPasswordVisible = true;
  bool _isPasswordVisible = true;
  bool _isConPasswordVisible = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> submitForm() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        final success = await updatePasswordRXOBJ.updatePasswordRX(
          currentPassword: currentPassController.text.trim(),
          newPassword: passController.text.trim(),
          passwordConfirmation: conPassController.text.trim(),
        );
        if (success) {
          setState(() {
            _isLoading = false;
          });
          NavigationService.goBack;
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ToastUtil.showShortToast("$error");
    }
  }

  @override
  void dispose() {
    currentPassController.dispose();
    passController.dispose();
    conPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomAppBar(title: "Security"),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      UIHelper.verticalSpace(20.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 20.h,
                        ),
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
                              'Change Password',
                              style: TextStyle(
                                color: const Color(0xFF202020),
                                fontSize: 16.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                            UIHelper.verticalSpace(16.h),
                            Text(
                              'Current Password',
                              style: TextStyle(
                                color: const Color(0x99101010),
                                fontSize: 12.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            UIHelper.verticalSpace(4.h),
                            CommonTextFormField(
                              controller: currentPassController,
                              isPrefixIcon: true,
                              prefixIcon: Icon(Icons.lock_outline),
                              isBorder: false,
                              fillColor: AppColors.cFFFFFF,
                              hintText: "Enter Current Password",
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              obscureText: _iCurrentsPasswordVisible,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _iCurrentsPasswordVisible =
                                        !_iCurrentsPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  !_iCurrentsPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xff637381),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 8) {
                                  return "Enter Minimum 8 Digit";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            UIHelper.verticalSpace(8.h),
                            Text(
                              'New Password',
                              style: TextStyle(
                                color: const Color(0x99101010),
                                fontSize: 12.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            UIHelper.verticalSpace(4.h),
                            CommonTextFormField(
                              controller: passController,
                              isPrefixIcon: true,
                              prefixIcon: Icon(Icons.lock_outline),
                              isBorder: false,
                              fillColor: AppColors.cFFFFFF,
                              hintText: "Enter New Password",
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              obscureText: _isPasswordVisible,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  !_isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xff637381),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 8) {
                                  return "Enter Minimum 8 Digit";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            UIHelper.verticalSpace(8.h),
                            Text(
                              'Confirm Password',
                              style: TextStyle(
                                color: const Color(0x99101010),
                                fontSize: 12.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            UIHelper.verticalSpace(4.h),
                            CommonTextFormField(
                              controller: conPassController,
                              isPrefixIcon: true,
                              prefixIcon: Icon(Icons.lock_outline),
                              isBorder: false,
                              fillColor: AppColors.cFFFFFF,
                              hintText: "Enter Confirm Password",
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              obscureText: _isConPasswordVisible,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isConPasswordVisible =
                                        !_isConPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  !_isConPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xff637381),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 8) {
                                  return "Enter Minimum 8 Digit";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            UIHelper.verticalSpace(24.h),
                            _isLoading
                                ? Center(
                                    child: const SpinKitChasingDots(
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                : CustomButton(
                                    onTap: () {
                                      submitForm();
                                    },
                                    text: "Update Password",
                                  ),
                          ],
                        ),
                      ),
                      UIHelper.verticalSpace(20.h),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 24.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Delete Account",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    UIHelper.verticalSpace(12.h),
                                    Text(
                                      "Are you sure you want to delete your account?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: const Color(0xFF505050),
                                      ),
                                    ),
                                    UIHelper.verticalSpace(24.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            text: "No",
                                            bgColor: Colors.white,
                                            textColor: AppColors.primaryColor,
                                            borderColor: AppColors.primaryColor,
                                            borderRadius: 12.r,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                        UIHelper.horizontalSpace(12.w),
                                        Expanded(
                                          child: CustomButton(
                                            text: "Yes",
                                            bgColor: Colors.red,
                                            textColor: Colors.white,
                                            borderColor: Colors.red,
                                            borderRadius: 12.r,
                                            onTap: () {
                                              Navigator.pop(context);
                                              postAccountDeleteRxOBJ
                                                  .postAccountDelete()
                                                  .waitingForFutureWithoutBg()
                                                  .then((value) {
                                                if (value) {
                                                  NavigationService
                                                      .navigateToUntilReplacement(
                                                          Routes.login);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.sp),
                          decoration: ShapeDecoration(
                            color: const Color(0x19FF0000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delete Account',
                                style: TextStyle(
                                  color: const Color(0xFFFF0000),
                                  fontSize: 14.sp,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SvgPicture.asset(Assets.icons.logout),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
