// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/feature/host/stripe_connect/widget/stripe_connect_row.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../../../../networks/api_access.dart';
import '../model/deshboard_model.dart';

class HostHomeScreen extends StatefulWidget {
  const HostHomeScreen({super.key});

  @override
  State<HostHomeScreen> createState() => _HostHomeScreenState();
}

class _HostHomeScreenState extends State<HostHomeScreen> {
  List items = ["Last 7 days", "Last 15 days", "Last 30 days"];
  String selectedItem = "Last 7 days";
  @override
  void initState() {
    postDeshboardDataRxOBJ.post(filterData: selectedItem);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: postDeshboardDataRxOBJ.fileData,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          } else if (!asyncSnapshot.hasError && asyncSnapshot.data != null) {
            DeshboardDataRes deshboardData = DeshboardDataRes.fromJson(
              asyncSnapshot.data,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: "Host Overview",
                  backButton: false,
                  actions: Row(
                    children: [
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
                                NavigationService.navigateTo(
                                    Routes.notificationList);
                              },
                              child: Stack(
                                children: [
                                  SvgPicture.asset(Assets.icons.notification),
                                  if (hasNotification != null &&
                                      hasNotification)
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
                      UIHelper.horizontalSpace(16.w),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.verticalSpace(20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Overview',
                                style: TextStyle(
                                  color: const Color(0xFF202020),
                                  fontSize: 14.sp,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                height: 35.h,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color(0x330F958F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.r),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    style: TextStyle(
                                      color: const Color(0xFF101010),
                                      fontSize: 12.sp,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF001937),
                                    ),
                                    value: selectedItem,
                                    items: items.map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedItem = value;
                                          postDeshboardDataRxOBJ.post(
                                            filterData: selectedItem,
                                          );
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(12.h),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    NavigationService.navigateTo(
                                        Routes.hostBooking);
                                  },
                                  child: OverViewContainer(
                                    value: '${deshboardData.totalBooking ?? 0}',
                                    title: 'Bookings',
                                  ),
                                ),
                              ),
                              UIHelper.horizontalSpace(12.w),
                              Expanded(
                                child: OverViewContainer(
                                  value: '${(deshboardData.totalEarning ?? 0).toStringAsFixed(2)} CHF',
                                  title: 'Earnings',
                                ),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(20.h),
                          CustomButton(
                            onTap: () {
                              NavigationService.navigateTo(Routes.addListing);
                            },
                            text: "Add new Listing",
                          ),
                          UIHelper.verticalSpace(29.h),
                          Text(
                            'Recent Activity',
                            style: TextStyle(
                              color: const Color(0xFF202020),
                              fontSize: 14.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                              height: 1.43,
                            ),
                          ),
                          UIHelper.verticalSpace(12.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.sp),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF3F3F3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: (deshboardData.recentActivity?.isEmpty ??
                                    true)
                                ? Center(
                                    child: Text(
                                      "No Activity",
                                      style: TextStyle(
                                        color: const Color(0xFF202020),
                                        fontSize: 14.sp,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount:
                                        deshboardData.recentActivity?.length ??
                                            0,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (_, index) {
                                      RecentActivity? activity =
                                          deshboardData.recentActivity?[index];
                                      return StripeConnectRow(
                                        icon: Assets.icons.arrowLeft,
                                        title: activity?.title ?? "",
                                        subTitle: activity?.description ?? "",
                                        isIcon: false,
                                        isDevider: index ==
                                                deshboardData.recentActivity!
                                                        .length -
                                                    1
                                            ? false
                                            : true,
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(
                'No Data Available',
                style: TextStyle(
                  color: const Color(0xFF202020),
                  fontSize: 16.sp,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class OverViewContainer extends StatelessWidget {
  final String value;
  final String title;
  const OverViewContainer({
    super.key,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: ShapeDecoration(
        color: const Color(0x7FE9E9E9),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: const Color(0xFFE9E9E9)),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF0F958F),
              fontSize: 20.sp,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          UIHelper.verticalSpace(8.h),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF6A6A6A),
              fontSize: 14.sp,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }
}
