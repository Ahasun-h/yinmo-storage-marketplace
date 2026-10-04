// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/constants/text_font_style.dart';
import 'package:urban_koala/feature/user/mybooking/widgets/booking_view_card.dart';
import 'package:urban_koala/feature/user/mybooking/widgets/calender.dart';
import 'package:urban_koala/feature/user/mybooking/widgets/review_popup.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../../../../networks/api_access.dart';
import '../model/my_booking_list_model.dart';

class MybookingScreen extends StatefulWidget {
  const MybookingScreen({super.key});

  @override
  State<MybookingScreen> createState() => _MybookingScreenState();
}

class _MybookingScreenState extends State<MybookingScreen> {
  int selectedIndex = 0;
  List filter = ["All", "Upcoming", "Completed", "Canceled"];
  @override
  void initState() {
    postMyBookingListRxOBJ.post(value: filter[selectedIndex]).then((response) {
      // Redirect to login if token is not present
      final token = appData.read(kKeyAccessToken);
      if (token == null || (token is String && token.trim().isEmpty)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          NavigationService.navigateToUntilReplacement(Routes.login);
        });
        return;
      }
      // Handle successful data retrieval if needed
    }).catchError((error) {
      // Handle errors if needed
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(title: "My Bookings", backButton: false),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: StreamBuilder(
                  stream: postMyBookingListRxOBJ.filleData,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SizedBox(
                        height: 0.6.sh,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (!asyncSnapshot.hasError &&
                        asyncSnapshot.data != null) {
                      MyBookingListRes? myBookingListRes =
                          MyBookingListRes.fromJson(asyncSnapshot.data);
                      return Column(
                        children: [
                          UIHelper.verticalSpace(20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 28.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: filter.length,
                                    itemBuilder: (context, index) {
                                      bool isSelected = selectedIndex == index;
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            postMyBookingListRxOBJ
                                                .post(
                                                  value: filter[index]
                                                      .toLowerCase(),
                                                )
                                                .waitingForFutureWithoutBg();
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(32.r),
                                              color: isSelected
                                                  ? AppColors.c001937
                                                  : AppColors.cE9E9E9,
                                            ),
                                            child: Center(
                                              child: Text(
                                                filter[index],
                                                style: isSelected
                                                    ? TextFontStyle
                                                        .text12cFFFFFFw500SFPro
                                                    : TextFontStyle
                                                        .text12c001937w400SFPro,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CalendarPopupDialog(
                                          myBookingListRes:
                                              myBookingListRes.data);
                                    },
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.c0F958F.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(28.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    child: Text(
                                      "View Calendar",
                                      style:
                                          TextFontStyle.text12c0F958Fw500SFPro,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(20.h),
                          (myBookingListRes.data?.isNotEmpty ?? false)
                              ? ListView.builder(
                                  itemCount: myBookingListRes.data?.length ?? 0,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (_, index) {
                                    MyBookingListModel? myBookingListModel =
                                        myBookingListRes.data?[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 8.h),
                                      child: BookingViewCard(
                                        name: myBookingListModel
                                                ?.listing?.title ??
                                            "",
                                        location: myBookingListModel
                                                ?.listing?.location ??
                                            "",
                                        status:
                                            myBookingListModel?.status ?? "",
                                        statusTextColor:
                                            myBookingListModel?.status ==
                                                    "completed"
                                                ? const Color(0xFF264E71)
                                                : myBookingListModel?.status ==
                                                        "canceled"
                                                    ? const Color(0xFFE21B1B)
                                                    : const Color(0xFFDF7720),
                                        statusBackColor:
                                            myBookingListModel?.status ==
                                                    "completed"
                                                ? const Color(0x33264E71)
                                                : myBookingListModel?.status ==
                                                        "canceled"
                                                    ? const Color(0x33E21B1B)
                                                    : const Color(0x33DF7720),
                                        slot: myBookingListModel
                                            ?.commonGroupedItems,
                                        buttonName:
                                            myBookingListModel?.status ==
                                                    "completed"
                                                ? "Give Feedback"
                                                : "Send Message",
                                        sendMessageTap: () {
                                          if (myBookingListModel?.status ==
                                              "completed") {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ReviewPopup(
                                                  id: myBookingListModel
                                                      ?.listingId,
                                                );
                                              },
                                            );
                                          } else {
                                            String conversationId = (myBookingListModel
                                                            ?.userId ??
                                                        0) <=
                                                    (myBookingListModel
                                                            ?.serviceProviderId ??
                                                        0)
                                                ? "${myBookingListModel?.userId}-${myBookingListModel?.serviceProviderId}"
                                                : "${myBookingListModel?.serviceProviderId}-${myBookingListModel?.userId}";
                                            NavigationService
                                                .navigateToWithArgs(
                                              Routes.messaging,
                                              {
                                                "receiverId": myBookingListModel
                                                    ?.serviceProviderId,
                                                "receiverName":
                                                    myBookingListModel
                                                        ?.serviceProvider?.name,
                                                "reciverImg": myBookingListModel
                                                    ?.serviceProvider
                                                    ?.profileImage,
                                                "myImg": myBookingListModel
                                                    ?.user?.profileImage,
                                                "conversationId": conversationId
                                              },
                                            );
                                          }
                                        },
                                        viewButton:
                                            myBookingListModel?.status ==
                                                    "completed"
                                                ? "Rebook"
                                                : "View Details",
                                        viewDetailsTap: () {
                                          if (myBookingListModel?.status ==
                                              "completed") {
                                            NavigationService
                                                .navigateToWithObject(
                                              Routes.itemDetails,
                                              myBookingListModel?.listing?.id,
                                            );
                                          } else {
                                            NavigationService
                                                .navigateToWithObject(
                                              Routes.bookingDetails,
                                              myBookingListModel,
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                )
                              : Builder(
                                  builder: (context) {
                                    String title = "No bookings found";
                                    String subtitle =
                                        "You don't have any bookings history yet.";

                                    if (selectedIndex == 1) {
                                      // Upcoming
                                      title = "No upcoming bookings";
                                      subtitle =
                                          "You don't have any scheduled bookings at the moment.";
                                    } else if (selectedIndex == 2) {
                                      // Completed
                                      title = "No completed bookings";
                                      subtitle =
                                          "You haven't completed any bookings yet. Your past trips will appear here.";
                                    } else if (selectedIndex == 3) {
                                      // Canceled
                                      title = "No canceled bookings";
                                      subtitle =
                                          "You don't have any canceled bookings.";
                                    }

                                    return SizedBox(
                                      height: 0.7.sh,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              UIHelper.verticalSpace(8.h),
                                              Text(
                                                subtitle,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color:
                                                      const Color(0xFF505050),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No bookings found",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              UIHelper.verticalSpace(8.h),
                              Text(
                                "You don't have any bookings history yet.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF505050),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
