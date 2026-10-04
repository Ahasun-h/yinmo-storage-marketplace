// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/constants/text_font_style.dart';
import 'package:urban_koala/feature/host/mybooking/model/host_booking_list_model.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/di.dart';
import '../../../../networks/api_access.dart';
import 'widget/host_booking_card.dart';
import 'widget/host_booking_detail_dialog.dart';

class HostBookingScreen extends StatefulWidget {
  const HostBookingScreen({super.key});

  @override
  State<HostBookingScreen> createState() => _HostBookingScreenState();
}

class _HostBookingScreenState extends State<HostBookingScreen> {
  @override
  void initState() {
    getHostBookingListRxOBJ.getBookingList().then((response) {
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
          const CustomAppBar(
            title: "My Bookings",
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: StreamBuilder(
                  stream: getHostBookingListRxOBJ.filleData,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SizedBox(
                        height: 0.6.sh,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (!asyncSnapshot.hasError &&
                        asyncSnapshot.data != null) {
                      HostBookingListRes? hostBookingListRes =
                          HostBookingListRes.fromJson(
                              asyncSnapshot.data as Map<String, dynamic>);
                      return Column(
                        children: [
                          UIHelper.verticalSpace(20.h),
                          ListView.builder(
                            itemCount: hostBookingListRes.data?.length ?? 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, index) {
                              HostBookingListModel? hostBookingListModel =
                                  hostBookingListRes.data?[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: InkWell(
                                  onTap: () {
                                    if (hostBookingListModel != null) {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            HostBookingDetailDialog(
                                          booking: hostBookingListModel,
                                        ),
                                      );
                                    }
                                  },
                                  child: HostBookingViewCard(
                                    name:
                                        hostBookingListModel?.user?.name ?? "",
                                    location: hostBookingListModel
                                            ?.providerFeeAfterComission ??
                                        "",
                                    status: hostBookingListModel?.status ?? "",
                                    statusTextColor:
                                        hostBookingListModel?.status ==
                                                "completed"
                                            ? const Color(0xFF264E71)
                                            : const Color(0xFFDF7720),
                                    statusBackColor:
                                        hostBookingListModel?.status ==
                                                "completed"
                                            ? const Color(0x33264E71)
                                            : const Color(0x33DF7720),
                                    slot: hostBookingListModel
                                        ?.commonGroupedItems,
                                    listingType: hostBookingListModel
                                        ?.listing?.listingType,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          "No bookings found.",
                          style: TextFontStyle.text10c001937w500SFPro,
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
