import 'package:cached_network_image_pro/cached_network_image_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class ItemInfoContainer extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String location;
  final String rating;
  final String ratingCount;
  final Widget featurs;
  const ItemInfoContainer({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.location,
    required this.rating,
    required this.ratingCount,
    required this.featurs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0x7FE9E9E9)),
      child: Column(
        children: [
          UIHelper.verticalSpace(16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12.r),
              child: CachedNetworkImagePro(
                imgUrl: image,
                width: double.infinity,
                height: 160.h,
              ),
            ),
          ),
          UIHelper.verticalSpace(16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: const Color(0xFF202020),
                          fontSize: 14.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      UIHelper.verticalSpace(4.h),
                      Text(
                        location,
                        style: TextStyle(
                          color: const Color(0xFF4D4D4D),
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          color: const Color(0xFF001937),
                          fontSize: 14.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      UIHelper.verticalSpace(4.h),
                      Text(
                        'Per Day',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF4D4D4D),
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                SvgPicture.asset(Assets.icons.star),
                UIHelper.horizontalSpace(8.w),
                Text(
                  rating,
                  style: TextStyle(
                    color: const Color(0xFFDF7720),
                    fontSize: 12.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                UIHelper.horizontalSpace(4.w),
                Text(
                  ratingCount,
                  style: TextStyle(
                    color: const Color(0xFF4D4D4D),
                    fontSize: 12.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(16.h),
          featurs,
          UIHelper.verticalSpace(16.h),
        ],
      ),
    );
  }
}
