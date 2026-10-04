// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/widget/otp_verify_widget.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';
import 'package:urban_koala/providers/all_providers.dart';
import 'package:provider/provider.dart';

class VerifyScreen extends StatefulWidget {
  final String email;
  const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  TextEditingController pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int otpDigits = 0;

  Future<void> verifyMethod() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        await forgetPassOtpVerifyRXOBJ
            .forgetPassOtpVerifyRX(
          email: widget.email,
          otp: context.read<AllProviders>().otp,
        )
            .then((value) {
          if (value) {
            setState(() {
              _isLoading = false;
            });
            NavigationService.navigateToWithArgs(Routes.createPass, {
              "email": widget.email,
            });
            ToastUtil.showShortToast("Otp Verify successful");
          } else {
            setState(() {
              _isLoading = false;
            });
            ToastUtil.showShortToast("Failed to Verify");
          }
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ToastUtil.showShortToast(e.toString());
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.verticalSpace(52.h),
                GestureDetector(
                  onTap: () {
                    NavigationService.goBack;
                  },
                  child: Icon(Icons.keyboard_arrow_left, size: 30.sp),
                ),
                UIHelper.verticalSpace(20.h),
                Center(
                  child: Text(
                    'Code Verification',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF202020),
                      fontSize: 24.sp,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                ),
                UIHelper.verticalSpace(4.h),
                Center(
                  child: Text(
                    'Enter your email address to receive a reset link and\nregain access to your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0x99101010),
                      fontSize: 12.sp,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
                UIHelper.verticalSpace(32.h),
                Center(child: OtpVerifyField(controller: pinController)),
                UIHelper.verticalSpace(24.h),
                _isLoading
                    ? Center(
                        child: const SpinKitChasingDots(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : CustomButton(
                        onTap: () {
                          verifyMethod();
                        },
                        text: "Verify",
                      ),
                UIHelper.verticalSpace(40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
