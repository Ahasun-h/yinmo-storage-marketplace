import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/constants/text_font_style.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../model/booking_store_model.dart';

class ServiceDetails extends StatelessWidget {
  final String name;
  final String location;
  final String price;
  final String pricePer;
  final List<SelectedSlotModel>? slot;

  const ServiceDetails({
    super.key,
    required this.name,
    required this.location,
    required this.price,
    required this.pricePer,
    required this.slot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: const Color(0xFFE9E9E9)),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextFontStyle.text14c202020w500SFPro),
                    UIHelper.verticalSpace(4.h),
                    Text(location, style: TextFontStyle.text12c4D4D4Dw400SFPro),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        color: const Color(0xFF001937),
                        fontSize: 14.sp,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UIHelper.verticalSpace(4.h),
                    Text(
                      pricePer,
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
          UIHelper.verticalSpace(16.h),
          Text("Booking Info", style: TextFontStyle.text12c001937w400SFPro),
          UIHelper.verticalSpace(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: List.generate(slot?.length ?? 0, (index) {
              SelectedSlotModel? slotItem = slot?[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.cF3F3F3,
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
                      slotItem?.dates?.join(", ") ?? "",
                      style: TextFontStyle.text12c101010w400Roboto,
                    ),
                  ],
                ),
              );
            }),
          ),
          UIHelper.verticalSpace(8.h),
        ],
      ),
    );
  }
}
