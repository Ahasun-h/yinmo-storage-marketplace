// common_widget/pinput_field.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/providers/all_providers.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpVerifyField extends StatefulWidget {
  final TextEditingController? controller;

  const OtpVerifyField({super.key, this.controller});

  @override
  State<OtpVerifyField> createState() => _OtpVerifyFieldState();
}

class _OtpVerifyFieldState extends State<OtpVerifyField> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _pinController;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pinController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _pinController.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllProviders>(context);
    const focusedBorderColor = AppColors.primaryColor;
    const fillColor = Color(0xFFF2F2F2);
    // ignore: unused_local_variable
    const borderColor = Color(0xFFF2F2F2);

    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 48.h,
      textStyle: TextStyle(fontSize: 20.sp, color: AppColors.c000000),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Pinput(
            length: 6,
            controller: _pinController,
            focusNode: _focusNode,
            defaultPinTheme: defaultPinTheme,

            separatorBuilder: (_) => SizedBox(width: 12.w),
            // validator: (value) =>
            //     value == '809719' ? null : 'Wrong code, please try again',
            onCompleted: (pin) {
              provider.otp = pin;
              log("OTP: ${provider.otp}");
            },
            cursor: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: 20.w,
                  height: 2.h,
                  color: focusedBorderColor,
                ),
              ],
            ),
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: focusedBorderColor),
              ),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                color: fillColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: focusedBorderColor),
              ),
            ),
            errorPinTheme: defaultPinTheme.copyBorderWith(
              border: Border.all(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
