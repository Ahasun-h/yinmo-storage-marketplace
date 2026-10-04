import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/constants/text_font_style.dart';
import 'package:urban_koala/feature/user/mybooking/widgets/custom_booking_button.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../model/my_booking_list_model.dart';

class BookingViewCard extends StatelessWidget {
  final String name;
  final String location;
  final String status;
  final Color statusTextColor;
  final Color statusBackColor;
  final String? viewButton;
  final List<CommonGroupedItem>? slot;

  final String? buttonName;
  final void Function() sendMessageTap;
  final void Function() viewDetailsTap;
  const BookingViewCard({
    super.key,
    required this.name,
    required this.location,
    required this.status,
    required this.statusTextColor,
    required this.statusBackColor,
    required this.slot,
    required this.sendMessageTap,
    required this.viewDetailsTap,
    this.buttonName,
    this.viewButton,
  });

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
          Text(location, style: TextFontStyle.text12c4D4D4Dw400SFPro),
          UIHelper.verticalSpace(10.h),
          Wrap(
            // spacing: 12.w,
            // runSpacing: 6.h,
            children: List.generate(slot?.length ?? 0, (index) {
              CommonGroupedItem? slotItem = slot?[index];
              return Container(
                margin: EdgeInsets.only(
                  bottom: index < (slot?.length ?? 0) - 1 ? 8.h : 0,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.cFFFFFF,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Slot - ",
                          style: TextFontStyle.text12c101010w400SFPro.copyWith(
                            color: AppColors.c101010.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          slotItem?.name ?? "",
                          style: TextFontStyle.text12c101010w400Roboto,
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(8.h),
                    Text(
                      slotItem?.dates
                              ?.map(
                                (e) =>
                                    e.date
                                        ?.toIso8601String()
                                        .split("T")
                                        .first ??
                                    "",
                              )
                              .join(", ") ??
                          "",
                      style: TextFontStyle.text12c101010w400Roboto,
                    ),
                  ],
                ),
              );
            }),
          ),
          UIHelper.verticalSpace(6.h),
          Row(
            children: [
              Expanded(
                child: CustomBookingButton(
                  text: buttonName ?? 'Send Message',
                  bgcolor: AppColors.cFFFFFF,
                  borderColor: AppColors.cE9E9E9,
                  textStyle: TextFontStyle.text12c001937w500SFPro,
                  onTap: sendMessageTap,
                ),
              ),
              UIHelper.horizontalSpace(16.w),
              Expanded(
                child: CustomBookingButton(
                  text: viewButton ?? 'View Details',
                  bgcolor: AppColors.c0F958F,
                  borderColor: AppColors.c0F958F,
                  textStyle: TextFontStyle.text12cFFFFFFw500SFPro,
                  onTap: viewDetailsTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
