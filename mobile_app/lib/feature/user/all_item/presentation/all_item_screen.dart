import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/providers/all_providers.dart';

import '../../home/model/map_data_model.dart';

class AllItemScreen extends StatelessWidget {
  final MapDataRes? mapDataRes;
  const AllItemScreen({super.key, this.mapDataRes});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AllProviders>();
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: provider.selectedInfoType),
          Expanded(
            child: ListView.builder(
              itemCount: mapDataRes?.data?.length ?? 0,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(16.sp),
              itemBuilder: (_, index) {
                MapDataModel? mapData = mapDataRes?.data?[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.sp),
                    decoration: ShapeDecoration(
                      color: const Color(0x7FE9E9E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mapData?.title ?? '',
                                    style: TextStyle(
                                      color: const Color(0xFF202020),
                                      fontSize: 14.sp,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  UIHelper.verticalSpace(4.h),
                                  Text(
                                    mapData?.location ?? '',
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
                                  SizedBox(
                                    width: double.infinity,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${mapData?.price ?? ''} CHF',
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: const Color(0xFF001937),
                                          fontSize: 12.sp,
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
                              mapData?.averageRating.toString() ?? '',
                              style: TextStyle(
                                color: const Color(0xFFDF7720),
                                fontSize: 12.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            UIHelper.horizontalSpace(4.w),
                            Text(
                              '(${mapData?.totalReviews.toString() ?? ''})',
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
                                  NavigationService.navigateToWithObject(
                                    Routes.itemDetails,
                                    mapData?.id,
                                  );
                                },
                              ),
                            ),
                            UIHelper.horizontalSpace(16.w),
                            Expanded(
                              child: CustomButton(
                                text: "Book Now",
                                onTap: () {},
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
          ),
        ],
      ),
    );
  }
}
