// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';

class CreatePassScreen extends StatefulWidget {
  final String email;
  const CreatePassScreen({super.key, required this.email});

  @override
  State<CreatePassScreen> createState() => _CreatePassScreenState();
}

class _CreatePassScreenState extends State<CreatePassScreen> {
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  bool _isPasswordVisible = true;
  bool _isConPasswordVisible = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> submitMethod() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        await createPassRXOBJ
            .createPassRX(
          newPassword: passController.text.trim(),
          confirmPassword: conPassController.text.trim(),
          email: widget.email,
          token: appData.read(resetPassToken),
        )
            .then((value) {
          if (value) {
            setState(() {
              _isLoading = false;
            });
            ToastUtil.showShortToast("Change password successful");
            NavigationService.navigateTo(Routes.login);
          } else {
            setState(() {
              _isLoading = false;
            });
            ToastUtil.showShortToast("Failed to Change password");
          }
        });
      }
    } catch (e) {
      ToastUtil.showShortToast(e.toString());
    }
  }

  @override
  void dispose() {
    passController.dispose();
    conPassController.dispose();
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
                    'Create Password',
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
                    'Create a new password and regain access\nto your account.',
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
                CommonTextFormField(
                  controller: passController,
                  isPrefixIcon: true,
                  prefixIcon: Icon(Icons.lock_outline),
                  isBorder: false,
                  fillColor: const Color(0xFFF2F2F2),
                  hintText: "Create password",
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
                    if (value == null || value.isEmpty || value.length < 8) {
                      return "Enter Minimum 8 Digit";
                    } else {
                      return null;
                    }
                  },
                ),
                UIHelper.verticalSpace(12.h),
                CommonTextFormField(
                  controller: conPassController,
                  isPrefixIcon: true,
                  prefixIcon: Icon(Icons.lock_outline),
                  isBorder: false,
                  fillColor: const Color(0xFFF2F2F2),
                  hintText: "Confirm Password",
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  obscureText: _isConPasswordVisible,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isConPasswordVisible = !_isConPasswordVisible;
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
                    if (value == null || value.isEmpty || value.length < 8) {
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
                          submitMethod();
                        },
                        text: "Update Password",
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
