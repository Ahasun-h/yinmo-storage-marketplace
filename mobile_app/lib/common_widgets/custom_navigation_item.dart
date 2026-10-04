import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class CustomNavigationItem extends StatelessWidget {
  final void Function() onTap;
  final Color ontapColor;
  final String lebel;
  final String icon;
  const CustomNavigationItem({
    super.key,
    required this.onTap,
    required this.ontapColor,
    required this.lebel,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: ShapeDecoration(
          color: ontapColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            UIHelper.horizontalSpace(4.w),
            Text(
              lebel,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
