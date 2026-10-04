// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/constants/text_font_style.dart';
import 'package:urban_koala/feature/user/home/widget/all_categories_bottom_sheet.dart';
import 'package:urban_koala/feature/user/home/widget/item_bottom_sheet.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';
import 'package:urban_koala/providers/all_providers.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onFieldSubmitted;
  final void Function()? notificationTap;
  int selectedIndex;

  HomeAppBar({
    super.key,
    required this.controller,
    this.onFieldSubmitted,
    this.notificationTap,
    required this.selectedIndex,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final Map<String, dynamic> selectType = {
    'Find Parking': "parking",
    'Rent Bike': "bike_rent",
    'Luggage Store': "luggage",
  };
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllProviders>(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFF0F958F)),
      child: Column(
        children: [
          UIHelper.verticalSpace(56.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: CommonTextFormField(
                    controller: widget.controller,
                    isPrefixIcon: true,
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: AppColors.cFFFFFF,
                    ),
                    textInputStyle:
                        TextFontStyle.text12primaryColorw400inter.copyWith(
                      color: AppColors.cFFFFFF,
                    ),
                    fillColor: Colors.white.withValues(alpha: 0.30),
                    hintText: "Search by location",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                    onFieldSubmitted: widget.onFieldSubmitted,
                  ),
                ),
                UIHelper.horizontalSpace(10.w),
                StreamBuilder(
                  stream: notificationRxObj.hasNotification,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (!asyncSnapshot.hasError &&
                        asyncSnapshot.data != null) {
                      bool? hasNotification = asyncSnapshot.data;
                      return GestureDetector(
                        onTap: () {
                          notificationRxObj.clearNotification();
                          widget.notificationTap?.call();
                        },
                        child: Stack(
                          children: [
                            SvgPicture.asset(Assets.icons.notification),
                            if (hasNotification != null && hasNotification)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 8.w,
                                  height: 8.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.cFFFFFF,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(16.h),
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: SizedBox(
              height: 30.h,
              child: ListView.builder(
                itemCount:
                    provider.buttonData.length + 1, // +1 for "All" button
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  if (index < provider.buttonData.length) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () {
                          provider.setInfoType(index);
                          final localContext = context;
                          postMapDataRxOBJ
                              .post(
                                infoType: selectType[provider.selectedInfoType],
                              )
                              .waitingForFutureWithoutBg()
                              .then((value) {
                            if (!mounted) return;
                            // ignore: use_build_context_synchronously
                            showModalBottomSheet(
                              backgroundColor: AppColors.cFFFFFF,
                              // ignore: use_build_context_synchronously
                              context: localContext,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return const ItemBottomSheet();
                              },
                            );
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 6.h,
                          ),
                          decoration: ShapeDecoration(
                            color: provider.selectedInfoTypeIndex == index
                                ? const Color(0xFF001937)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                provider.buttonData[index]["icon"],
                                color: widget.selectedIndex == index
                                    ? AppColors.cFFFFFF
                                    : const Color(0xFF001937),
                              ),
                              UIHelper.horizontalSpace(2.w),
                              Text(
                                provider.buttonData[index]["text"] ?? "N/A",
                                style: TextStyle(
                                  color: widget.selectedIndex == index
                                      ? AppColors.cFFFFFF
                                      : const Color(0xFF001937),
                                  fontSize: 12.sp,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // "All" Button
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () {
                          provider.setInfoType(provider.buttonData.length);
                          showModalBottomSheet(
                            backgroundColor: AppColors.cFFFFFF,
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return const AllCategoriesBottomSheet();
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16
                                .w, // Slightly wider padding for text-only button feel
                            vertical: 6.h,
                          ),
                          decoration: ShapeDecoration(
                            color: provider.selectedInfoTypeIndex ==
                                    provider.buttonData.length
                                ? const Color(0xFF001937)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "All",
                              style: TextStyle(
                                color: provider.selectedInfoTypeIndex ==
                                        provider.buttonData.length
                                    ? AppColors.cFFFFFF
                                    : const Color(0xFF001937),
                                fontSize: 12.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          UIHelper.verticalSpace(12.h),
        ],
      ),
    );
  }
}
