import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBookingButton extends StatelessWidget {
  final String text;
  final Color bgcolor;
  final Color borderColor;
  final TextStyle textStyle;
  final void Function() onTap;

  const CustomBookingButton({
    super.key,
    required this.text,
    required this.bgcolor,
    required this.borderColor,
    required this.textStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(width: 1, color: borderColor),
        ),
        child: Text(text, style: textStyle, textAlign: TextAlign.center),
      ),
    );
  }
}
