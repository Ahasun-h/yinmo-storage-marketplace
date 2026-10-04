import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class CustomBottomNavBtn extends StatelessWidget {
  final String total;
  final String btnName;
  final void Function() onTap;
  const CustomBottomNavBtn({
    super.key,
    required this.total,
    required this.onTap,
    required this.btnName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      padding: EdgeInsets.only(
        top: 12.h,
        left: 16.w,
        right: 16.w,
        bottom: 24.h,
      ),
      decoration: BoxDecoration(color: const Color(0xFF109590)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total',
            style: TextStyle(
              color: const Color(0xFFE9E9E9),
              fontSize: 12.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            total,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
            ),
          ),
          UIHelper.verticalSpace(10.h),
          CustomButton(
            text: btnName,
            bgColor: AppColors.cFFFFFF,
            textColor: AppColors.primaryColor,
            borderColor: AppColors.cFFFFFF,
            borderRadius: 16.r,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
