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
import 'package:urban_koala/providers/all_providers.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final bool isFromAuthHole;
  const LoginScreen({super.key, this.isFromAuthHole = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _isPasswordVisible = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> submitForm() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        await logInRXOBJ
            .logInRX(
          email: mailController.text.trim(),
          password: passController.text.trim(),
        )
            .then((value) async {
          if (value) {
            setState(() {
              _isLoading = false;
            });
            await postFcmTokenRxOBJ.postFcmToken();

            if (appData.read(kKeyUserType) == "user") {
              if (widget.isFromAuthHole) {
                NavigationService.goBack;
              } else {
                NavigationService.navigateTo(Routes.navigation);
              }
            } else {
              if (appData.read(kKeyStatus) == "pending") {
                NavigationService.navigateToUntilReplacement(
                  Routes.basicInformation,
                );
              } else {
                NavigationService.navigateToUntilReplacement(
                  Routes.hostNavigation,
                );
              }
            }

            // logInRXOBJ.getFileData.first.then((onvalue) {
            //   logInRXOBJ
            //   .getFileData
            // if (onvalue["data"]["user"]["role"] == "host") {
            //   NavigationService.navigateTo(Routes.hostNavigation);
            // } else {
            //   NavigationService.navigateTo(Routes.navigation);
            // }
            // });
          } else {
            setState(() {
              _isLoading = false;
            });
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
    mailController.dispose();
    passController.dispose();
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
                UIHelper.verticalSpace(92.h),
                Center(
                  child: Text(
                    'Log In',
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
                    'Enter your email and password to securely access\nyour account and manage your services.',
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
                  textInputAction: TextInputAction.done,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigationService.navigateTo(Routes.forgetPass);
                      },
                      child: Text(
                        'Forgot your password?',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                          height: 1.67,
                        ),
                      ),
                    ),
                  ],
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
                        text: "Sign In",
                      ),
                UIHelper.verticalSpace(12.h),
                CustomButton(
                  onTap: () {
                    NavigationService.navigateTo(Routes.signUp);
                    provider.roleTabIndex(index: 1);
                  },
                  text: "Become a Host",
                  bgColor: const Color(0xFF011937),
                  borderColor: const Color(0xFF011937),
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
                UIHelper.verticalSpace(100.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not on Urbankoala yet? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigationService.navigateTo(Routes.signUp);
                      },
                      child: Text(
                        'Sign up',
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
