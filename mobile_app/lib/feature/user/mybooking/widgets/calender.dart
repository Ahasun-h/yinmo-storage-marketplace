import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:urban_koala/feature/user/mybooking/model/my_booking_list_model.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class CalendarPopupDialog extends StatefulWidget {
  final List<MyBookingListModel>? myBookingListRes;
  const CalendarPopupDialog({super.key, this.myBookingListRes});

  @override
  State<CalendarPopupDialog> createState() => _CalendarPopupDialogState();
}

class _CalendarPopupDialogState extends State<CalendarPopupDialog> {
  DateTime _focusedMonth = DateTime.now();
  final List<DateTime> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    _extractBookedDates();
  }

  void _extractBookedDates() {
    _selectedDates.clear();
    if (widget.myBookingListRes != null) {
      for (var booking in widget.myBookingListRes!) {
        for (var groupedItem in booking.commonGroupedItems) {
          if (groupedItem.dates != null) {
            for (var dateItem in groupedItem.dates!) {
              if (dateItem.date != null) {
                _selectedDates.add(dateItem.date!);
              }
            }
          }
        }
      }
    }
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

    return Dialog(
      insetPadding: EdgeInsets.all(16.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Bookings',
                  style: TextStyle(
                    color: const Color(0xFF202020),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _focusedMonth = DateTime(
                            _focusedMonth.year,
                            _focusedMonth.month - 1,
                            1,
                          );
                        });
                      },
                      icon: Icon(
                        Icons.chevron_left,
                        color: const Color(0xFF001937),
                      ),
                    ),
                    Text(
                      DateFormat('MMM yyyy').format(_focusedMonth),
                      style: TextStyle(
                        color: const Color(0xFF001937),
                        fontSize: 14.sp,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _focusedMonth = DateTime(
                            _focusedMonth.year,
                            _focusedMonth.month + 1,
                            1,
                          );
                        });
                      },
                      icon: Icon(
                        Icons.chevron_right,
                        color: const Color(0xFF001937),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            UIHelper.verticalSpace(12.h),
            UIHelper.verticalSpace(12.h),
            UIHelper.customDivider(color: const Color(0xFFE9E9E9), height: 1.h),
            UIHelper.verticalSpace(12.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: daysInMonth + firstWeekday,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                if (index < firstWeekday) {
                  return const SizedBox.shrink();
                }

                final day = index - firstWeekday + 1;
                final date = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month,
                  day,
                );

                bool isSelected = _selectedDates.any(
                  (d) => DateUtils.isSameDay(d, date),
                );

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedDates.removeWhere(
                          (d) => DateUtils.isSameDay(d, date),
                        );
                      } else {
                        _selectedDates.add(date);
                      }
                    });
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                      color: isSelected
                          ? AppColors.primaryColor
                          : const Color(0x7FE9E9E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$day",
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.cFFFFFF
                            : const Color(0xFF001937),
                        fontSize: 10.sp,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
            UIHelper.verticalSpace(12.h),
            UIHelper.customDivider(color: const Color(0xFFE9E9E9), height: 1.h),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: Text(
                  'Close Calender',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF001937),
                    fontSize: 12.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
