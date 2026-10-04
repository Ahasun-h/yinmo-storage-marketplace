import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeatursView extends StatelessWidget {
  final String title;
  const FeatursView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: const Color(0xFFE9E9E9)),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF001937),
          fontSize: 12.sp,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
