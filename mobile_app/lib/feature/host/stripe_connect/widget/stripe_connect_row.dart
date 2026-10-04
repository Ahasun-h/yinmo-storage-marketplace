import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class StripeConnectRow extends StatelessWidget {
  final String icon;
  final String title;
  final String subTitle;
  final bool? isDevider;
  final bool? isIcon;
  final Color? textColor;
  const StripeConnectRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.isDevider = true,
    this.textColor,
    this.isIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (isIcon == true)
              Row(
                children: [
                  SvgPicture.asset(icon),
                  UIHelper.horizontalSpace(12.w),
                ],
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor ?? const Color(0xFF202020),
                      fontSize: 14.sp,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      color: textColor ?? const Color(0xFF101010),
                      fontSize: 12.sp,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.67,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (isDevider == true)
          Column(
            children: [
              UIHelper.verticalSpace(12.h),
              UIHelper.customDivider(),
              UIHelper.verticalSpace(12.h),
            ],
          ),
      ],
    );
  }
}
