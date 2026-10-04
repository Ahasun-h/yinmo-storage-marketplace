import 'package:cached_network_image_pro/cached_network_image_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class ReviewsView extends StatelessWidget {
  final String image;
  final String name;
  final int rating;
  final String time;
  final String message;
  const ReviewsView({
    super.key,
    required this.image,
    required this.name,
    required this.rating,
    required this.time,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(100.r),
                  child: CachedNetworkImagePro(
                    imgUrl: image,
                    width: 32.h,
                    height: 32.h,
                  ),
                ),
                UIHelper.horizontalSpace(8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: const Color(0xFF202020),
                        fontSize: 12.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    UIHelper.verticalSpace(6.h),
                    Center(
                      child: RatingBarIndicator(
                        unratedColor: Colors.grey,
                        itemSize: 8.w,
                        rating: rating.toDouble(),
                        direction: Axis.horizontal,
                        itemPadding: EdgeInsets.only(right: 5.w),
                        itemBuilder: (context, _) =>
                            SvgPicture.asset(Assets.icons.star),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              time,
              style: TextStyle(
                color: const Color(0xCC202020),
                fontSize: 10.sp,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(12.h),
        Text(
          message,
          style: TextStyle(
            color: const Color(0xFF202020),
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1.33.h,
          ),
        ),
        UIHelper.verticalSpace(12.h),
        UIHelper.customDivider(color: const Color(0xFFE9E9E9), height: 1.h),
      ],
    );
  }
}
