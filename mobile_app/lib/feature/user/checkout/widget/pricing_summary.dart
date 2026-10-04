import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/constants/text_font_style.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../model/booking_store_model.dart';

class PricingSummery extends StatelessWidget {
  final List<ExtraService>? extraService;
  final String? total;
  final String? subTotal;
  const PricingSummery({
    super.key,
    this.total,
    this.subTotal,
    this.extraService,
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
          Text("Pricing Summery", style: TextFontStyle.text14c202020w500SFPro),
          UIHelper.verticalSpace(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal",
                style: TextFontStyle.text12c101010w400SFPro.copyWith(
                  color: AppColors.c101010.withValues(alpha: 0.6),
                ),
              ),
              Text(
                _formatChf(subTotal),
                style: TextFontStyle.text12c101010w400Roboto,
              ),
            ],
          ),
          UIHelper.verticalSpace(8.h),
          UIHelper.customDivider(color: AppColors.cE9E9E9),
          UIHelper.verticalSpace(8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(extraService?.length ?? 0, (index) {
              ExtraService? service = extraService?[index];
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service?.name ?? "",
                        style: TextFontStyle.text12c101010w400SFPro.copyWith(
                          color: AppColors.c101010.withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        _formatChf(service?.price),
                        style: TextFontStyle.text12c101010w400Roboto,
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),
                  UIHelper.customDivider(color: AppColors.cE9E9E9),
                  UIHelper.verticalSpace(8.h),
                ],
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "total",
                style: TextFontStyle.text12c101010w400SFPro.copyWith(
                  color: AppColors.c101010.withValues(alpha: 0.6),
                ),
              ),
              Text(
                _formatChf(total),
                style: TextFontStyle.text12c101010w400Roboto,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatChf(dynamic amount) {
  final value = amount is num
      ? amount.toDouble()
      : double.tryParse(amount?.toString() ?? '') ?? 0;
  return '${value.toStringAsFixed(2)} CHF';
}
