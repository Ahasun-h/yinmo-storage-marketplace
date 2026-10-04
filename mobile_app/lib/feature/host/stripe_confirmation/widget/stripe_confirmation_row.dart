import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class StripConfirmationRow extends StatelessWidget {
  final String title;
  final String value;
  final String? icon;
  final bool? isIcon;
  final bool? isDevider;
  const StripConfirmationRow({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.isIcon = false,
    this.isDevider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: const Color(0x99101010),
                fontSize: 12.sp,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                if (isIcon == true)
                  Row(
                    children: [
                      SvgPicture.asset(Assets.icons.verified),
                      UIHelper.horizontalSpace(8.w),
                    ],
                  ),
                Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFF101010),
                    fontSize: 12.sp,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (isDevider == true)
          Column(
            children: [
              UIHelper.verticalSpace(8.h),
              UIHelper.customDivider(),
              UIHelper.verticalSpace(8.h),
            ],
          ),
      ],
    );
  }
}
