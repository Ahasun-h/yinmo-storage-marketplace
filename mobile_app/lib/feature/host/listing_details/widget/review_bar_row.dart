import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';

Widget reviewBarRow({
  required String title,
  required double percentage,
  required int count,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xFF3C4249),
              fontSize: 12.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        UIHelper.horizontalSpace(12.w),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.cFFFFFF,
            borderRadius: BorderRadius.circular(10.r),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            minHeight: 8.h,
          ),
        ),
        UIHelper.horizontalSpace(12.w),
        SizedBox(
          width: 30.w,
          child: Text(
            "$count",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    ),
  );
}
