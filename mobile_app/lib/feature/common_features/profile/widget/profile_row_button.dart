

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class ProfileRowButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final bool? isDeviider;
  final bool? isSpace;
  const ProfileRowButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isDeviider = true,
    this.isSpace = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isSpace == true) UIHelper.verticalSpace(8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF202020),
                    fontSize: 14.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SvgPicture.asset(Assets.icons.arrowRight),
              ],
            ),
          ),
        ),
        if (isDeviider == true)
          Column(
            children: [
              UIHelper.verticalSpace(8.h),
              UIHelper.customDivider(color: const Color(0xFFE9E9E9)),
            ],
          ),
      ],
    );
  }
}
