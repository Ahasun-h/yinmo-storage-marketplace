// ignore_for_file: deprecated_member_use, prefer_final_fields

import 'dart:convert';
import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/common_widgets/custom_toast.dart';
import 'package:urban_koala/feature/user/booking_form/widget/custom_bottom_btn.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import '../../../../networks/api_access.dart';
import '../model/booking_form_model.dart';
import '../model/slot_booking_date.dart';

class BookingFormScreen extends StatefulWidget {
  final int? itemId;
  const BookingFormScreen({super.key, this.itemId});
  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  static const int _calendarColumnCount = 7;
  static const double _calendarCrossSpacing = 8;
  static const double _calendarMainSpacing = 8;
  static const double _calendarDayAspectRatio = 1.3125;
  static const Color _weekdayHeaderColor = Color(0xFF264E71);
  static const Color _weekendHeaderColor = Color(0xFFD7E4F4);
  static const Color _weekendTextColor = Color(0xFF264E71);
  static const Color _defaultDateColor = Color(0xFFDBDDE0);
  static const Color _weekendColumnColor = Color(0xFFE8EFF8);
  static const Color _weekendDateColor = Color(0xFFDDE8F6);
  static const Color _weekendBorderColor = Color(0xFFB6C8DE);

  final List<String> carTypes = ['Select a car type', 'HUB', 'SUB'];
  int selectedSlot = -1;
  DateTime _focusedMonth = DateTime.now();
  List<DateTime> _bookedDates = [];
  StreamSubscription? _bookingDateSubscription;
  List<DateTime> _selectedDates = [];
  Map<int, List<DateTime>> _slotWiseSelectedDates = {};

  final List<String> weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  Set<Extraservice?> selectedServices = {};
  BookingForm? _currentBookingForm;

  @override
  void initState() {
    getBookingInfoRxOBJ.get(widget.itemId);
    super.initState();
  }

  @override
  void dispose() {
    _bookingDateSubscription?.cancel();
    super.dispose();
  }

  String _formatChf(dynamic amount) {
    final value = amount is num
        ? amount.toDouble()
        : double.tryParse(amount?.toString() ?? '') ?? 0;
    return '${value.toStringAsFixed(2)} CHF';
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  bool _isWeekendHeader(int index) {
    return index == 0 || index == weekdays.length - 1;
  }

  double _getCalendarCellHeight(double cellWidth) {
    return cellWidth / _calendarDayAspectRatio;
  }

  double _getWeekendColumnPanelHeight({
    required int columnIndex,
    required int firstWeekday,
    required int daysInMonth,
    required double headerHeight,
    required double headerGridSpacing,
    required double cellHeight,
    required double mainSpacing,
  }) {
    int? lastOccupiedRow;

    for (int day = daysInMonth; day >= 1; day--) {
      final gridIndex = firstWeekday + day - 1;
      if (gridIndex % _calendarColumnCount == columnIndex) {
        lastOccupiedRow = gridIndex ~/ _calendarColumnCount;
        break;
      }
    }

    if (lastOccupiedRow == null) {
      return headerHeight;
    }

    final occupiedGridHeight =
        ((lastOccupiedRow + 1) * cellHeight) + (lastOccupiedRow * mainSpacing);

    return headerHeight + headerGridSpacing + occupiedGridHeight;
  }

  Map<String, dynamic> convertBookingDataForApi(BookingForm? bookingForm) {
    // Convert slots (flattened for API) and also prepare detailed selected slots
    List<Map<String, dynamic>> slots = [];
    List<Map<String, dynamic>> selectedSlotsDetails = [];
    _slotWiseSelectedDates.forEach((slotId, dates) {
      for (var d in dates) {
        if (bookingForm?.listingType == "luggage") {
          slots.add({
            "box_id": slotId,
            "box_date": d.toIso8601String().split("T").first,
          });
        } else if (bookingForm?.listingType == "bike_rent") {
          slots.add({
            "bike_id": slotId,
            "bike_date": d.toIso8601String().split("T").first,
          });
        } else if (bookingForm?.listingType == "parking") {
          slots.add({
            "slot_id": slotId,
            "slot_date": d.toIso8601String().split("T").first,
          });
        }
      }

      // build detailed info for UI/checkout: id, name and selected dates
      String name = "";
      try {
        // try slots
        if (bookingForm?.slot != null) {
          final f = bookingForm!.slot!.firstWhere(
            (s) => s.id == slotId,
            orElse: () => Slot(id: slotId, slotName: ""),
          );
          name = f.slotName ?? "";
        }
      } catch (_) {}

      if (name.isEmpty) {
        try {
          if (bookingForm?.bikeIds != null) {
            final f = bookingForm!.bikeIds!.firstWhere(
              (b) => b.id == slotId,
              orElse: () => BikeId(id: slotId, bikeId: ""),
            );
            name = f.bikeId ?? "";
          }
        } catch (_) {}
      }

      if (name.isEmpty) {
        try {
          if (bookingForm?.boxes != null) {
            final f = bookingForm!.boxes!.firstWhere(
              (b) => b.id == slotId,
              orElse: () => BoxItem(id: slotId, boxName: ""),
            );
            name = f.boxName ?? "";
          }
        } catch (_) {}
      }

      selectedSlotsDetails.add({
        "id": slotId,
        "name": name,
        "dates":
            dates.map((d) => d.toIso8601String().split("T").first).toList(),
      });
    });

    // Convert extra services with id, name and price
    List<Map<String, dynamic>> extraServices = [];
    double extraServicesTotal = 0;
    for (var service in selectedServices) {
      if (service != null) {
        double price = double.tryParse(service.price ?? "0") ?? 0;
        extraServices.add({
          "id": service.id,
          "name": service.serviceName ?? "",
          "price": price,
          "total_price": price,
        });
        extraServicesTotal += price;
      }
    }

    // Calculate subtotal (slots count * price per slot) and total (subtotal + extras)
    double slotPrice = double.tryParse(bookingForm?.price ?? "0") ?? 0;
    double subtotal =
        double.parse((slots.length * slotPrice).toStringAsFixed(2));
    double total = double.parse(
      (subtotal + extraServicesTotal).toStringAsFixed(2),
    ); // You can add taxes/fees here if needed
    var retunData = {
      "listing_id": bookingForm?.id,
      "user_id": bookingForm?.userId,
      "title": bookingForm?.title,
      "location": bookingForm?.location,
      "listing_type": bookingForm?.listingType,
      "total": total,
      "subtotal": subtotal,
      "selected_slots": selectedSlotsDetails,
      "extra_services": extraServices,
    };
    if (bookingForm?.listingType == "parking") {
      retunData["slots"] = slots;
    } else if (bookingForm?.listingType == "luggage") {
      retunData["boxes"] = slots;
    } else if (bookingForm?.listingType == "bike_rent") {
      retunData["bikes"] = slots;
    }
    return retunData;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );

    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );

    final firstWeekday = (firstDayOfMonth.weekday % 7);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: StreamBuilder(
        stream: getBookingInfoRxOBJ.fileData,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!asyncSnapshot.hasError && asyncSnapshot.data != null) {
            BookingFormRes bookingFormRes = BookingFormRes.fromJson(
              asyncSnapshot.data,
            );
            BookingForm? bookingForm = bookingFormRes.data;
            _currentBookingForm = bookingForm;
            List<CommonItem>? commonList = getCommonList(bookingForm);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: 'Booking Form'),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(16.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getSelectName(bookingForm?.listingType ?? ""),
                            style: TextStyle(
                              color: const Color(0xFF202020),
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          UIHelper.verticalSpace(8.h),
                          Wrap(
                            spacing: 8.w, // Horizontal spacing between items
                            runSpacing: 8.h, // Vertical spacing between items
                            children: List.generate(commonList?.length ?? 0, (
                              index,
                            ) {
                              CommonItem? slot = commonList?[index];

                              return GestureDetector(
                                onTap: () {
                                  postBookingDateRxOBJ
                                      .postBookingDate(
                                        listingId: slot?.listingId,
                                        slotId: slot?.id,
                                      )
                                      .waitingForFutureWithoutBg()
                                      .then((value) {
                                    if (value) {
                                      setState(() {
                                        selectedSlot = index;
                                        // যদি new slot হয় → date list empty সেট হবে
                                        _selectedDates =
                                            _slotWiseSelectedDates[slot!.id] ??
                                                [];
                                      });

                                      _bookingDateSubscription?.cancel();
                                      _bookingDateSubscription =
                                          postBookingDateRxOBJ.filleData
                                              .listen((
                                        event,
                                      ) {
                                        if (event != null) {
                                          SlotBookingDateRes
                                              slotBookingDateRes =
                                              SlotBookingDateRes.fromJson(
                                            event,
                                          );
                                          log(
                                            slotBookingDateRes.toString(),
                                          );
                                          if (slotBookingDateRes.data != null) {
                                            setState(() {
                                              _bookedDates =
                                                  slotBookingDateRes.data!
                                                      .map(
                                                        (e) => e.slotDate!,
                                                      )
                                                      .toList();
                                            });
                                          }
                                        }
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: 32.h,
                                    minWidth: 62.2.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedSlot == index
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: const Color(0xFFE9E9E9),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 8.h,
                                    ),
                                    child: Text(
                                      slot?.name ?? "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: selectedSlot == index
                                            ? AppColors.cFFFFFF
                                            : const Color(0xFF264E71),
                                        fontSize: 10.sp,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          UIHelper.verticalSpace(20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Availability',
                                style: TextStyle(
                                  color: const Color(0xFF202020),
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 12.w,
                                    height: 12.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFE6057),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  UIHelper.horizontalSpace(4.w),
                                  Text(
                                    "Booked",
                                    style: TextStyle(
                                      color: const Color(0xFF202020),
                                      fontSize: 10.sp,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  UIHelper.horizontalSpace(12.w),
                                  Container(
                                    width: 12.w,
                                    height: 12.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0x7FE9E9E9),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  UIHelper.horizontalSpace(4.w),
                                  Text(
                                    "Available",
                                    style: TextStyle(
                                      color: const Color(0xFF202020),
                                      fontSize: 10.sp,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                splashRadius: 20.r,
                                onPressed: () {
                                  // Prevent going back past current month if desired, or allow freely.
                                  // User instruction: "month change korar akta option dew"
                                  // Requirement: "Booking Date >= Today". So checking if previous month is strictly past is good UX.
                                  final now = DateTime.now();
                                  final prevMonth = DateTime(
                                    _focusedMonth.year,
                                    _focusedMonth.month - 1,
                                  );
                                  // allow going back only if we are not already in a month before current month
                                  // Actually, if we are in next month, we can go back.
                                  // If we are in current month, going back -> past month (mostly disabled).
                                  if (prevMonth.isBefore(
                                    DateTime(now.year, now.month),
                                  )) {
                                    ToastUtil.showShortToast(
                                      "Cannot book in past months",
                                    );
                                    return;
                                  }

                                  setState(() {
                                    _focusedMonth = prevMonth;
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: 18.sp,
                                  color: const Color(0xFF202020),
                                ),
                              ),
                              Text(
                                "${_getMonthName(_focusedMonth.month)} ${_focusedMonth.year}",
                                style: TextStyle(
                                  color: const Color(0xFF202020),
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                splashRadius: 20.r,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  setState(() {
                                    _focusedMonth = DateTime(
                                      _focusedMonth.year,
                                      _focusedMonth.month + 1,
                                    );
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18.sp,
                                  color: const Color(0xFF202020),
                                ),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(12.h),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final headerHeight = 32.h;
                              final headerGridSpacing = 10.h;
                              final crossSpacing = _calendarCrossSpacing.w;
                              final mainSpacing = _calendarMainSpacing.h;
                              final columnWidth = (constraints.maxWidth -
                                      (crossSpacing *
                                          (_calendarColumnCount - 1))) /
                                  _calendarColumnCount;
                              final cellHeight =
                                  _getCalendarCellHeight(columnWidth);
                              final rowCount = ((daysInMonth + firstWeekday) /
                                      _calendarColumnCount)
                                  .ceil();
                              final gridHeight = (cellHeight * rowCount) +
                                  (mainSpacing * (rowCount - 1));
                              final calendarHeight =
                                  headerHeight + headerGridSpacing + gridHeight;
                              final weekendPanelHeights = <int, double>{
                                0: _getWeekendColumnPanelHeight(
                                  columnIndex: 0,
                                  firstWeekday: firstWeekday,
                                  daysInMonth: daysInMonth,
                                  headerHeight: headerHeight,
                                  headerGridSpacing: headerGridSpacing,
                                  cellHeight: cellHeight,
                                  mainSpacing: mainSpacing,
                                ),
                                _calendarColumnCount - 1:
                                    _getWeekendColumnPanelHeight(
                                  columnIndex: _calendarColumnCount - 1,
                                  firstWeekday: firstWeekday,
                                  daysInMonth: daysInMonth,
                                  headerHeight: headerHeight,
                                  headerGridSpacing: headerGridSpacing,
                                  cellHeight: cellHeight,
                                  mainSpacing: mainSpacing,
                                ),
                              };

                              return SizedBox(
                                height: calendarHeight,
                                child: Stack(
                                  children: [
                                    ...weekendPanelHeights.entries.map((entry) {
                                      final columnIndex = entry.key;
                                      final panelHeight = entry.value;
                                      final leftPosition = columnIndex *
                                          (columnWidth + crossSpacing);
                                      return Positioned(
                                        left: leftPosition,
                                        top: 0,
                                        height: panelHeight,
                                        child: Container(
                                          width: columnWidth,
                                          decoration: BoxDecoration(
                                            color: _weekendColumnColor,
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                            border: Border.all(
                                              color: _weekendBorderColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                    Column(
                                      children: [
                                        Row(
                                          children: weekdays
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            final index = entry.key;
                                            final day = entry.value;
                                            final isWeekendHeader =
                                                _isWeekendHeader(index);

                                            return Padding(
                                              padding: EdgeInsets.only(
                                                right:
                                                    index == weekdays.length - 1
                                                        ? 0
                                                        : crossSpacing,
                                              ),
                                              child: SizedBox(
                                                width: columnWidth,
                                                height: headerHeight,
                                                child: Container(
                                                  decoration: ShapeDecoration(
                                                    color: isWeekendHeader
                                                        ? _weekendHeaderColor
                                                        : _weekdayHeaderColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      day,
                                                      style: TextStyle(
                                                        color: isWeekendHeader
                                                            ? _weekendTextColor
                                                            : Colors.white,
                                                        fontSize: 10.sp,
                                                        fontFamily: 'SF Pro',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(height: headerGridSpacing),
                                        SizedBox(
                                          height: gridHeight,
                                          child: GridView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                daysInMonth + firstWeekday,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  _calendarColumnCount,
                                              crossAxisSpacing: crossSpacing,
                                              mainAxisSpacing: mainSpacing,
                                              childAspectRatio:
                                                  _calendarDayAspectRatio,
                                            ),
                                            itemBuilder: (context, index) {
                                              if (index < firstWeekday) {
                                                return const SizedBox.shrink();
                                              }

                                              final day =
                                                  index - firstWeekday + 1;
                                              final date = DateTime(
                                                _focusedMonth.year,
                                                _focusedMonth.month,
                                                day,
                                              );
                                              final isWeekend =
                                                  _isWeekend(date);

                                              bool isSelected =
                                                  _selectedDates.any(
                                                (d) => DateUtils.isSameDay(
                                                    d, date),
                                              );

                                              bool isbooked = _bookedDates.any(
                                                (e) => DateUtils.isSameDay(
                                                    e, date),
                                              );

                                              // Check if date is in the past (before today)
                                              // We compare with today's date at midnight to include "today" as selectable if needed,
                                              // or strictly > today. Requirement: "Booking Date >= Today".
                                              final now = DateTime.now();
                                              final today = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                              );
                                              bool isPast =
                                                  date.isBefore(today);

                                              return GestureDetector(
                                                onTap: isbooked
                                                    ? () {
                                                        // ToastUtil.showShortToast(
                                                        //   "Already Booked",
                                                        // );
                                                      }
                                                    : isPast
                                                        ? () {
                                                            // Click korle kichu hobe na (Nothing happens on click)
                                                          }
                                                        : () {
                                                            if (selectedSlot ==
                                                                -1) {
                                                              ToastUtil
                                                                  .showShortToast(
                                                                "Please select a slot first",
                                                              );
                                                              return;
                                                            }

                                                            final slotId =
                                                                commonList?[
                                                                        selectedSlot]
                                                                    .id;

                                                            setState(() {
                                                              // slotWise map-এ list নাই → একটি list তৈরি করে দিচ্ছি
                                                              _slotWiseSelectedDates
                                                                  .putIfAbsent(
                                                                slotId!,
                                                                () => [],
                                                              );

                                                              final list =
                                                                  _slotWiseSelectedDates[
                                                                      slotId]!;

                                                              bool isSelected =
                                                                  list.any(
                                                                (d) => DateUtils
                                                                    .isSameDay(
                                                                  d,
                                                                  date,
                                                                ),
                                                              );

                                                              if (isSelected) {
                                                                list.removeWhere(
                                                                  (d) => DateUtils
                                                                      .isSameDay(
                                                                    d,
                                                                    date,
                                                                  ),
                                                                );
                                                              } else {
                                                                list.add(date);
                                                              }

                                                              // UI update এর জন্য current slot-এর dates reload করে দিচ্ছি
                                                              _selectedDates =
                                                                  List.from(
                                                                list,
                                                              );
                                                            });
                                                          },
                                                child: Opacity(
                                                  opacity: isPast ? 0.3 : 1.0,
                                                  child: Container(
                                                    decoration: ShapeDecoration(
                                                      color: isSelected
                                                          ? AppColors
                                                              .primaryColor
                                                          : isbooked
                                                              ? const Color(
                                                                  0xFFFE6057,
                                                                )
                                                              : isWeekend
                                                                  ? _weekendDateColor
                                                                  : _defaultDateColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          8,
                                                        ),
                                                      ),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "$day",
                                                      style: TextStyle(
                                                        color: isSelected ||
                                                                isbooked
                                                            ? AppColors.cFFFFFF
                                                            : isWeekend
                                                                ? _weekendTextColor
                                                                : const Color(
                                                                    0xFF001937,
                                                                  ),
                                                        fontSize: 10.sp,
                                                        fontFamily: 'SF Pro',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          UIHelper.verticalSpace(20.h),
                          Text(
                            'Extras',
                            style: TextStyle(
                              color: const Color(0xFF202020),
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          UIHelper.verticalSpace(12.h),
                          ListView.builder(
                            itemCount: bookingForm?.extraservices?.length ?? 0,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              Extraservice? service =
                                  bookingForm?.extraservices?[index];

                              final isChecked = selectedServices.any(
                                (item) => item?.id == service?.id,
                              );

                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8.sp),
                                  decoration: ShapeDecoration(
                                    color: isChecked
                                        ? AppColors.primaryColor.withOpacity(
                                            0.1,
                                          )
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      side: BorderSide(
                                        color: isChecked
                                            ? AppColors.primaryColor
                                            : const Color(0xFFE9E9E9),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isChecked) {
                                          selectedServices.removeWhere(
                                            (item) => item?.id == service?.id,
                                          );
                                        } else {
                                          if (service != null) {
                                            selectedServices.add(service);
                                          }
                                        }
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: isChecked,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (isChecked) {
                                                    selectedServices
                                                        .removeWhere(
                                                      (item) =>
                                                          item?.id ==
                                                          service?.id,
                                                    );
                                                  } else {
                                                    if (service != null) {
                                                      selectedServices.add(
                                                        service,
                                                      );
                                                    }
                                                  }
                                                });
                                              },
                                              checkColor: AppColors.cFFFFFF,
                                              activeColor:
                                                  AppColors.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(4.r),
                                                ),
                                              ),
                                              side: BorderSide(
                                                color: AppColors.primaryColor,
                                                width: 1.5.w,
                                              ),
                                              splashRadius: 1.r,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity:
                                                  VisualDensity.compact,
                                            ),
                                            UIHelper.horizontalSpace(8.w),
                                            Text(
                                              service?.serviceName ?? "",
                                              style: TextStyle(
                                                color: const Color(0xFF202020),
                                                fontSize: 12.sp,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          _formatChf(service?.price),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: const Color(0xFF202020),
                                            fontSize: 12.sp,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
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
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("No Data Found"));
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: Theme.of(context).platform == TargetPlatform.android,
        child: CustomBottomNavBtn(
          total: _formatChf(
              convertBookingDataForApi(_currentBookingForm)["total"]),
          btnName: "Proceed to Pay",
          onTap: () {
            if (_slotWiseSelectedDates.entries
                .any((element) => element.value.isEmpty)) {
              customToastMessage("Info", "Please select at least one slot");
              return;
            }
            final data = convertBookingDataForApi(_currentBookingForm);
            NavigationService.navigateToWithObject(Routes.checkOut, data);

            log("Booking Data = ${JsonEncoder().convert(data)}");
          },
        ),
      ),
    );
  }
}

String getSelectName(String? type) {
  if (type == "luggage") {
    return "Select a box";
  } else if (type == "bike_rent") {
    return "Select a bike";
  } else if (type == "parking") {
    return "Select a slot";
  } else {
    return "Select a slot";
  }
}

String _getMonthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return months[month - 1];
}
