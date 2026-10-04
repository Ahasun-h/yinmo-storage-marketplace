import 'package:cached_network_image_pro/cached_network_image_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../../../../networks/api_access.dart';
import '../model/single_list_details_model.dart';

class SingleItemBottomSheet extends StatefulWidget {
  final int? listId;

  const SingleItemBottomSheet({super.key, this.listId});

  @override
  State<SingleItemBottomSheet> createState() => _SingleItemBottomSheetState();
}

class _SingleItemBottomSheetState extends State<SingleItemBottomSheet> {
  @override
  void initState() {
    getSingleListDetailsRxOBJ.get(widget.listId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.4,
      expand: false,
      shouldCloseOnMinExtent: false,
      builder: (context, scrollController) {
        return StreamBuilder(
          stream: getSingleListDetailsRxOBJ.fileData,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!asyncSnapshot.hasError && asyncSnapshot.data != null) {
              SingleListInfoRes? singleListInfoRes = SingleListInfoRes.fromJson(
                asyncSnapshot.data,
              );
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                child: Column(
                  children: [
                    UIHelper.verticalSpace(8.h),
                    Container(
                      width: 60.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: const Color(0xFFE9E9E9),
                      ),
                    ),
                    UIHelper.verticalSpace(24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  singleListInfoRes.data?.title ?? '',
                                  style: TextStyle(
                                    color: const Color(0xFF202020),
                                    fontSize: 16.sp,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                UIHelper.verticalSpace(4.h),
                                Text(
                                  singleListInfoRes.data?.location ?? '',
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
                          UIHelper.horizontalSpace(12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${singleListInfoRes.data?.price ?? ''} CHF',
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: const Color(0xFF001937),
                                        fontSize: 14.sp,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
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
                            double.tryParse(singleListInfoRes.data?.avgRating
                                            ?.toString() ??
                                        "0")
                                    ?.toStringAsFixed(1) ??
                                "0.0",
                            style: TextStyle(
                              color: const Color(0xFFDF7720),
                              fontSize: 12.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          UIHelper.horizontalSpace(4.w),
                          Text(
                            '(${singleListInfoRes.data?.uniqueUserCount ?? '0'})',
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
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: SizedBox(
                        height: 80.h,
                        child: ListView.builder(
                          itemCount:
                              singleListInfoRes.data?.photos?.length ?? 0,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            String imgUrl =
                                singleListInfoRes.data?.photos?[index].image ??
                                    '';
                            return Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(
                                  12.r,
                                ),
                                child: CachedNetworkImagePro(
                                  imgUrl: imgUrl,
                                  width: 100.w,
                                  height: 80.h,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    UIHelper.verticalSpace(16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "View Details",
                              textColor: const Color(0xFF001937),
                              bgColor: AppColors.cFFFFFF,
                              borderColor: const Color(0xFFE9E9E9),
                              onTap: () {
                                NavigationService.navigateToWithObject(
                                  Routes.itemDetails,
                                  singleListInfoRes.data?.id,
                                );
                              },
                            ),
                          ),
                          UIHelper.horizontalSpace(16.w),
                          Expanded(
                            child: CustomButton(
                              text: "Book Now",
                              onTap: () {
                                NavigationService.navigateToWithObject(
                                  Routes.bookingForm,
                                  singleListInfoRes.data?.id,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Error: ${asyncSnapshot.error}'));
            }
          },
        );
      },
    );
  }
}
