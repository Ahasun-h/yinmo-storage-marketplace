import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/gen/colors.gen.dart';

class BookNowButton extends StatelessWidget {
  final String? title;
  final void Function() onTap;
  const BookNowButton({super.key, required this.onTap, this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: Theme.of(context).platform == TargetPlatform.android,
      child: Container(
        padding: EdgeInsets.only(
          top: 12.h,
          left: 16.w,
          right: 16.w,
          bottom: 24.h,
        ),
        decoration: BoxDecoration(color: const Color(0xFF109590)),
        child: CustomButton(
          text: title ?? "Book Now",
          bgColor: AppColors.cFFFFFF,
          textColor: AppColors.primaryColor,
          borderColor: AppColors.cFFFFFF,
          borderRadius: 16.r,
          onTap: onTap,
        ),
      ),
    );
  }
}
