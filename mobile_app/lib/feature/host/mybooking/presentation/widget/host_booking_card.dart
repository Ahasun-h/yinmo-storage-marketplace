import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/constants/text_font_style.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:intl/intl.dart';

import '../../model/host_booking_list_model.dart';

class HostBookingViewCard extends StatelessWidget {
  final String name;
  final String location;
  final String status;
  final Color statusTextColor;
  final Color statusBackColor;
  final String? viewButton;
  final List<CommonGroupedItem>? slot;
  final String? listingType; // Added this

  final String? buttonName;
  const HostBookingViewCard({
    super.key,
    required this.name,
    required this.location,
    required this.status,
    required this.statusTextColor,
    required this.statusBackColor,
    required this.slot,
    this.listingType, // Added this
    this.buttonName,
    this.viewButton,
  });

  String _getItemLabel() {
    if (listingType == 'parking') return "Slot";
    if (listingType == 'luggage') return "Box";
    if (listingType == 'bike_rent') return "Bike";
    return "Unit";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.cE9E9E9.withValues(alpha: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextFontStyle.text14c202020w500SFPro),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: statusBackColor,
                ),
                child: Text(
                  status,
                  style: TextFontStyle.text10cDF7720w400SFPro.copyWith(
                    color: statusTextColor,
                  ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(4.h),
          Text(location.isEmpty ? "" : "$location CHF",
              style: TextFontStyle.text12c4D4D4Dw400SFPro),
          UIHelper.verticalSpace(12.h),

          // Enhanced Item/Date Display
          if (slot?.isNotEmpty ?? false)
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.cFFFFFF,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.cE9E9E9),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 16.sp, color: AppColors.c264E71),
                  UIHelper.horizontalSpace(8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: "${_getItemLabel()}: ",
                              style: TextFontStyle.text12c101010w400Roboto
                                  .copyWith(
                                      color: AppColors.c4D4D4D,
                                      fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              text: slot!.first.name ?? "",
                              style: TextFontStyle.text12c101010w400Roboto
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp),
                            ),
                            if (slot!.length > 1)
                              TextSpan(
                                text: "  (+${slot!.length - 1} more)",
                                style: TextFontStyle.text10cDF7720w400SFPro
                                    .copyWith(
                                        color: AppColors.c264E71,
                                        fontWeight: FontWeight.w600),
                              ),
                          ]),
                        ),
                        if ((slot!.first.dates?.isNotEmpty ?? false) &&
                            slot!.first.dates!.first.date != null)
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Text(
                              DateFormat('dd MMM yyyy')
                                  .format(slot!.first.dates!.first.date!),
                              style: TextFontStyle.text12c101010w400Roboto
                                  .copyWith(color: AppColors.c202020),
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
