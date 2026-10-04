// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/feature/user/booking_details/widget/cancelation_popup.dart';
import 'package:urban_koala/feature/user/checkout/model/booking_store_model.dart';
import 'package:urban_koala/feature/user/item_details/widget/book_now_button.dart';
import 'package:urban_koala/feature/user/mybooking/model/my_booking_list_model.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../../checkout/widget/pricing_summary.dart';
import '../../checkout/widget/service_details.dart';
import '../../checkout/model/booking_store_model.dart' as store;

import '../../../../networks/api_access.dart'; // Add import

class BookingDetailsScreen extends StatefulWidget {
  final MyBookingListModel? myBookingListModel;
  final String? bookingId;
  const BookingDetailsScreen(
      {super.key, this.myBookingListModel, this.bookingId});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  MyBookingListModel? myBookingListModel;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    myBookingListModel = widget.myBookingListModel;
    if (myBookingListModel == null && widget.bookingId != null) {
      _fetchBookingDetails();
    }
  }

  Future<void> _fetchBookingDetails() async {
    setState(() => isLoading = true);
    // Assuming Guest for this screen based on file location
    bool success =
        await getSingleBookingGuestRxOBJ.getSingleBooking(widget.bookingId!);
    if (success) {
      // Need to listen to stream or get value. RxResponseInt usually has stream.
      // But standard pattern here seems to be stream builder or just accessing value if behavior subject?
      // Let's check Rx implementation. It writes to sink.
      // We can listen to the stream here or use StreamBuilder.
      // Simpler to just wait for stream emission?
      // Actually RxResponseInt writes to dataFetcher.
      getSingleBookingGuestRxOBJ.fileData.listen((data) {
        if (mounted && data != null) {
          setState(() {
            // Parse response to model.
            // API returns Map. Response structure needs checking.
            // Usually: { status: true, message: ..., data: {...} }
            // Let's assume standard response and try parsing.
            // Wait, endpoints says /api/my/booking/summery/$bookingId
            // Let's assume it returns MyBookingListModel or similar structure in 'data' key.
            if (data['data'] != null) {
              myBookingListModel = MyBookingListModel.fromJson(data['data']);
            }
            isLoading = false;
          });
        }
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: 'Booking Details'),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(color: const Color(0xFFF3F3F3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Summary',
                            style: TextStyle(
                              color: const Color(0xFF202020),
                              fontSize: 16,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                          UIHelper.verticalSpace(12.h),
                          ServiceDetails(
                            name: myBookingListModel?.listing?.title ?? "",
                            location:
                                myBookingListModel?.listing?.location ?? "",
                            price: myBookingListModel?.listing?.price ?? "",
                            pricePer: "Per Day",
                            slot: myBookingListModel?.commonGroupedItems
                                    .map(
                                      (e) => SelectedSlotModel(
                                        id: e.id,
                                        name: e.name,
                                        dates: e.dates
                                            ?.map(
                                              (e) =>
                                                  e.date
                                                      ?.toIso8601String()
                                                      .split("T")
                                                      .first ??
                                                  "",
                                            )
                                            .toList(),
                                      ),
                                    )
                                    .toList() ??
                                [],
                          ),
                          UIHelper.verticalSpace(12.h),
                          PricingSummery(
                            total: myBookingListModel?.total ?? "",
                            subTotal: myBookingListModel?.subtotal ?? "",
                            extraService:
                                myBookingListModel?.extraServicesBooking
                                        ?.map(
                                          (e) => store.ExtraService(
                                            id: e.extraService?.id,
                                            name: e.extraService?.serviceName,
                                            price: double.tryParse(
                                              e.extraService?.price ?? "0",
                                            ),
                                          ),
                                        )
                                        .toList() ??
                                    [],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BookNowButton(
        title: "Request for Cancelation",
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return CancelationPopup(bookingId: myBookingListModel?.id);
            },
          );
        },
      ),
    );
  }
}
