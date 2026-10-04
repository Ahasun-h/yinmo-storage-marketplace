import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/feature/user/home/widget/custom_view_all.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';

import '../model/map_data_model.dart';
import 'package:provider/provider.dart';
import 'package:urban_koala/providers/all_providers.dart';

class ItemBottomSheet extends StatefulWidget {
  const ItemBottomSheet({super.key});

  @override
  State<ItemBottomSheet> createState() => _ItemBottomSheetState();
}

class _ItemBottomSheetState extends State<ItemBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllProviders>(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      expand: false,
      shouldCloseOnMinExtent: false,
      builder: (context, scrollController) {
        return StreamBuilder(
          stream: postMapDataRxOBJ.fileData,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (!asyncSnapshot.hasError && asyncSnapshot.data != null) {
              MapDataRes? mapDataRes = MapDataRes.fromJson(asyncSnapshot.data);
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                child: SingleChildScrollView(
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
                      UIHelper.verticalSpace(12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomViewAll(
                          title: provider.selectedInfoType ?? "All Items",
                          onTap: () {
                            NavigationService.navigateToWithObject(
                              Routes.allItem,
                              mapDataRes,
                            );
                          },
                        ),
                      ),
                      UIHelper.verticalSpace(12.h),
                      UIHelper.customDivider(
                        height: 1.h,
                        color: Color(0xFFE9E9E9),
                      ),
                      ListView.builder(
                        itemCount: mapDataRes.data?.length ?? 0,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (_, index) {
                          MapDataModel? data = mapDataRes.data?[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.sp),
                              decoration: BoxDecoration(
                                color: const Color(0x7FE9E9E9),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data?.title ?? '',
                                              style: TextStyle(
                                                color: const Color(0xFF202020),
                                                fontSize: 14.sp,
                                                fontFamily: 'SF Pro',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            UIHelper.verticalSpace(4.h),
                                            Text(
                                              data?.location ?? '',
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  '${data?.price ?? ''} CHF',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF001937),
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
                                  UIHelper.verticalSpace(8.h),
                                  Row(
                                    children: [
                                      SvgPicture.asset(Assets.icons.star),
                                      UIHelper.horizontalSpace(8.w),
                                      Text(
                                        data?.averageRating.toString() ?? '0',
                                        style: TextStyle(
                                          color: const Color(0xFFDF7720),
                                          fontSize: 12.sp,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      UIHelper.horizontalSpace(4.w),
                                      Text(
                                        '(${data?.totalReviews ?? '0'})',
                                        style: TextStyle(
                                          color: const Color(0xFF4D4D4D),
                                          fontSize: 12.sp,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  UIHelper.verticalSpace(16.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          text: "View Details",
                                          textColor: const Color(0xFF001937),
                                          bgColor: AppColors.cFFFFFF,
                                          borderColor: const Color(0xFFE9E9E9),
                                          onTap: () {
                                            NavigationService
                                                .navigateToWithObject(
                                              Routes.itemDetails,
                                              data?.id,
                                            );
                                          },
                                        ),
                                      ),
                                      UIHelper.horizontalSpace(16.w),
                                      Expanded(
                                        child: CustomButton(
                                          text: "Book Now",
                                          onTap: () {
                                            NavigationService
                                                .navigateToWithObject(
                                              Routes.bookingForm,
                                              data?.id,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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
