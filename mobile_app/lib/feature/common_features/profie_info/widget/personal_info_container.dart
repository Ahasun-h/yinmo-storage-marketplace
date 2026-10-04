import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class PersonalInfoContainer extends StatelessWidget {
  final String dateOfBirth;
  final String gender;
  final String address;
  final void Function()? onTap;
  const PersonalInfoContainer({
    super.key,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: ShapeDecoration(
        color: const Color(0x7FE9E9E9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal Info',
                style: TextStyle(
                  color: const Color(0xFF202020),
                  fontSize: 14.sp,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: SvgPicture.asset(Assets.icons.edit),
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),
          Text(
            'Date of Birth',
            style: TextStyle(
              color: const Color(0x99101010),
              fontSize: 12.sp,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          UIHelper.verticalSpace(4.h),
          Text(
            dateOfBirth,
            style: TextStyle(
              color: const Color(0xFF101010),
              fontSize: 12.sp,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          UIHelper.verticalSpace(8.h),
          UIHelper.customDivider(color: const Color(0xFFE9E9E9)),
          UIHelper.verticalSpace(8.h),
          Text(
            'Gender',
            style: TextStyle(
              color: const Color(0x99101010),
              fontSize: 12.sp,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          UIHelper.verticalSpace(4.h),
          Text(
            gender,
            style: TextStyle(
              color: const Color(0xFF101010),
              fontSize: 12.sp,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          UIHelper.verticalSpace(8.h),
          UIHelper.customDivider(color: const Color(0xFFE9E9E9)),
          UIHelper.verticalSpace(8.h),
          Text(
            'Address',
            style: TextStyle(
              color: const Color(0x99101010),
              fontSize: 12.sp,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          UIHelper.verticalSpace(4.h),
          Text(
            address,
            style: TextStyle(
              color: const Color(0xFF101010),
              fontSize: 12.sp,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}
