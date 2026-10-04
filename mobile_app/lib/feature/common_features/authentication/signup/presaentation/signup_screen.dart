// ignore_for_file: unused_field

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/helpers/url_lunch.dart';
import 'package:urban_koala/networks/api_access.dart';
import 'package:urban_koala/providers/all_providers.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../helpers/di.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  bool _isPasswordVisible = true;
  bool _isConPasswordVisible = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> signupMethod() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        log("Role: ${context.read<AllProviders>().role}");
        await signupRXOBJ
            .signupRX(
          name: nameController.text,
          email: mailController.text,
          password: passController.text.trim(),
          passwordConfirmation: conPassController.text.trim(),
          role: context.read<AllProviders>().role,
        )
            .then((value) {
          if (value) {
            setState(() {
              _isLoading = false;
            });

            postFcmTokenRxOBJ.postFcmToken();
            ToastUtil.showShortToast("Sign up successful");
            final role = appData.read(kKeyUserType);
            log("User Role from Signup: $role");
            if (role == "user") {
              NavigationService.navigateTo(Routes.navigation);
            } else if (role == "service_provider") {
              NavigationService.navigateToUntilReplacement(
                Routes.basicInformation,
              );
            }
          } else {
            setState(() {
              _isLoading = false;
            });
            ToastUtil.showShortToast("Failed to sign up");
          }
        });
      }
    } catch (e) {
      ToastUtil.showShortToast(e.toString());
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mailController.dispose();
    passController.dispose();
    conPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllProviders>(context);
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
                    'Sign Up',
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
                    'Create a new account to get Started and enjoy\nseamless access to our features.',
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
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          provider.roleTabIndex(index: 0);
                          log("Selected Role: ${provider.role}");
                        },
                        text: "As a Guest",
                        bgColor: provider.roleIndex == 0
                            ? AppColors.primaryColor
                            : Color(0xFFE9E9E9),
                        borderColor: provider.roleIndex == 0
                            ? AppColors.primaryColor
                            : Color(0xFFE9E9E9),
                        textColor: provider.roleIndex == 0
                            ? AppColors.cFFFFFF
                            : Color(0xFF202020),
                      ),
                    ),
                    UIHelper.horizontalSpace(12),
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          provider.roleTabIndex(index: 1);
                          log("Selected Role: ${provider.role}");
                        },
                        text: "As a Host",
                        bgColor: provider.roleIndex == 1
                            ? AppColors.primaryColor
                            : Color(0xFFE9E9E9),
                        borderColor: provider.roleIndex == 1
                            ? AppColors.primaryColor
                            : Color(0xFFE9E9E9),
                        textColor: provider.roleIndex == 1
                            ? AppColors.cFFFFFF
                            : Color(0xFF202020),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(32.h),
                CommonTextFormField(
                  controller: nameController,
                  isPrefixIcon: true,
                  prefixIcon: Icon(Icons.person_outline),
                  isBorder: false,
                  fillColor: const Color(0xFFF2F2F2),
                  hintText: "Enter your name",
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    } else {
                      return null;
                    }
                  },
                ),
                UIHelper.verticalSpace(12.h),
                CommonTextFormField(
                  controller: mailController,
                  isPrefixIcon: true,
                  prefixIcon: Icon(Icons.email_outlined),
                  isBorder: false,
                  fillColor: const Color(0xFFF2F2F2),
                  hintText: "Enter email address",
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value ?? "");
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    } else if (!emailValid) {
                      return "Please enter a valid email";
                    } else {
                      return null;
                    }
                  },
                ),
                UIHelper.verticalSpace(12.h),
                CommonTextFormField(
                  controller: passController,
                  isPrefixIcon: true,
                  prefixIcon: Icon(Icons.lock_outline),
                  isBorder: false,
                  fillColor: const Color(0xFFF2F2F2),
                  hintText: "Enter password",
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
                          signupMethod();
                        },
                        text: "Sign Up",
                      ),
                UIHelper.verticalSpace(20.h),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.sp,
                        color: const Color(0xFFE9E9E9),
                      ),
                    ),
                    UIHelper.horizontalSpace(10.w),
                    Text(
                      'Or',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF4D4D4D),
                        fontSize: 14.sp,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    UIHelper.horizontalSpace(10.w),
                    Expanded(
                      child: Divider(
                        thickness: 1.sp,
                        color: const Color(0xFFE9E9E9),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(20.h),
                CustomButton(
                  onTap: () {
                    NavigationService.navigateTo(Routes.navigation);
                  },
                  text: "Explore the App",
                  bgColor: Color(0xFFE9E9E9),
                  borderColor: Color(0xFFE9E9E9),
                  textColor: Color(0xFF202020),
                ),
                UIHelper.verticalSpace(24.h),
                RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'By continuing, you agree to UrbanKoala ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                      ),
                    ),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.sp,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          urlLunch("https://urbankoala.app/terms");
                        },
                    ),
                  ],
                )),
                UIHelper.verticalSpace(24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already on Urbankoala? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigationService.navigateTo(Routes.login);
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
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
