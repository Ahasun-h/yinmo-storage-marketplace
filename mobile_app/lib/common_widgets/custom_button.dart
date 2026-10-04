import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:urban_koala/constants/text_font_style.dart';

import '../gen/colors.gen.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? borderColor;
  final Color? bgColor;
  final Color? textColor;
  final double? borderRadius;
  final double? height;
  final double? paddingVertical;
  final void Function()? onTap;
  final double? fontSize;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.fontSize,
    this.height,
    this.borderColor = AppColors.primaryColor,
    this.bgColor = AppColors.primaryColor,
    this.textColor = AppColors.cFFFFFF,
    this.paddingVertical,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 48.h,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(width: 1.w, color: borderColor!),
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 12.h),
          child: Center(
            child: Text(
              text.tr,
              style: TextFontStyle.textStyle16cFFFFFFSFPro600.copyWith(
                fontSize: fontSize?.sp ?? 16.sp,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
