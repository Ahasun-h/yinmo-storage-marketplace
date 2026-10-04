import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../../../../networks/api_access.dart';

class ReviewPopup extends StatefulWidget {
  final int? id;
  const ReviewPopup({super.key, this.id});

  @override
  State<ReviewPopup> createState() => _ReviewPopupState();
}

class _ReviewPopupState extends State<ReviewPopup> {
  double rating = 3;
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Give a ratings on your Booking',
                  style: TextStyle(
                    color: const Color(0xFF1F1F1F),
                    fontSize: 16.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    NavigationService.goBack;
                  },
                  child: SvgPicture.asset(Assets.icons.closewithcircle),
                ),
              ],
            ),
            UIHelper.verticalSpace(20.h),
            Text(
              'Add Ratings',
              style: TextStyle(
                color: const Color(0xFF202020),
                fontSize: 14.sp,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
            UIHelper.verticalSpace(10.h),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              itemSize: 18.w,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
              itemBuilder: (context, _) => SvgPicture.asset(Assets.icons.star),
              onRatingUpdate: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            UIHelper.verticalSpace(20.h),
            Text(
              'Comment (Optional)',
              style: TextStyle(
                color: const Color(0xFF202020),
                fontSize: 14,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
                height: 1.43,
              ),
            ),
            UIHelper.verticalSpace(20.h),
            CommonTextFormField(
              isPrefixIcon: false,
              borderRadius: 12.r,
              controller: commentController,
              hintText: "Write your comment..",
              hintStyle: TextStyle(
                color: const Color(0xFF868686),
                fontSize: 14.sp,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
              maxline: 5,
            ),
            UIHelper.verticalSpace(30.h),
            CustomButton(
              onTap: () {
                postReviewRxOBJ
                    .post(
                      listingId: widget.id,
                      rating: rating,
                      comment: commentController.text,
                    )
                    .waitingForFutureWithoutBg()
                    .then((value) {
                  if (value) {
                    NavigationService.goBack;
                  }
                });
              },
              text: "Submit",
            ),
          ],
        ),
      ),
    );
  }
}
