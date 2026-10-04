import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/constants/text_font_style.dart';
import 'package:urban_koala/feature/host/mybooking/model/host_booking_list_model.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:intl/intl.dart';
import 'package:urban_koala/common_widgets/custom_profile_image.dart';

class HostBookingDetailDialog extends StatelessWidget {
  final HostBookingListModel booking;

  const HostBookingDetailDialog({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(20.w),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Text(
                  "Booking Details",
                  style: TextFontStyle.text14c202020w500SFPro.copyWith(
                    color: AppColors.c264E71,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              UIHelper.verticalSpace(20.h),

              // User Info
              Row(
                children: [
                  booking.user?.profileImage != null && booking.user!.profileImage!.isNotEmpty
                      ? CustomProfileImage(
                          imageUrl: booking.user!.profileImage!,
                          height: 40.r,
                          width: 40.r,
                        )
                      : CircleAvatar(
                          radius: 20.r,
                          backgroundColor: AppColors.cE9E9E9,
                          child: Icon(Icons.person, color: Colors.grey),
                        ),
                  UIHelper.horizontalSpace(12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.user?.name ?? "Guest User",
                        style: TextFontStyle.text14c202020w500SFPro,
                      ),
                      Text(
                        booking.user?.email ?? "",
                        style: TextFontStyle.text12c4D4D4Dw400SFPro.copyWith(
                          color: const Color(0xFF8A8A8A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              UIHelper.verticalSpace(16.h),
              Divider(color: AppColors.cE9E9E9),
              UIHelper.verticalSpace(16.h),

              // Booking Info
              _buildDetailRow("Booking ID", "#${booking.id}"),
              _buildDetailRow("Invoice ID", booking.invoiceId ?? "N/A"),
              _buildDetailRow(
                  "Status", booking.status?.toUpperCase() ?? "UNKNOWN",
                  valueColor: booking.status == "completed"
                      ? const Color(0xFF264E71)
                      : const Color(0xFFDF7720)),
              _buildDetailRow(
                  "Date",
                  booking.createdAt != null
                      ? DateFormat('dd MMM yyyy').format(booking.createdAt!)
                      : "N/A"),

              UIHelper.verticalSpace(16.h),
              Text("Listing Info",
                  style: TextFontStyle.text14c202020w500SFPro
                      .copyWith(fontWeight: FontWeight.bold)),
              UIHelper.verticalSpace(8.h),
              Text(booking.listing?.title ?? "Unknown Listing",
                  style: TextFontStyle.text14c202020w500SFPro),
              Text(booking.listing?.location ?? "",
                  style: TextFontStyle.text12c4D4D4Dw400SFPro.copyWith(
                    color: const Color(0xFF8A8A8A),
                  )),

              UIHelper.verticalSpace(16.h),
              Text("Slots/Items",
                  style: TextFontStyle.text14c202020w500SFPro
                      .copyWith(fontWeight: FontWeight.bold)),
              UIHelper.verticalSpace(8.h),
              ...booking.commonGroupedItems.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 14.sp, color: AppColors.c264E71),
                      UIHelper.horizontalSpace(6.w),
                      Expanded(
                        child: Text(
                          "${item.name ?? ''} (${item.dates?.length ?? 0} days)",
                          style: TextFontStyle.text12c101010w400Roboto,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              UIHelper.verticalSpace(16.h),
              Divider(color: AppColors.cE9E9E9),
              UIHelper.verticalSpace(16.h),

              // Payment Details
              Text("Payment Summary",
                  style: TextFontStyle.text14c202020w500SFPro
                      .copyWith(fontWeight: FontWeight.bold)),
              UIHelper.verticalSpace(8.h),
              _buildDetailRow("Subtotal", "${booking.subtotal ?? '0.00'} CHF"),
              _buildDetailRow("Platform Cost", "- ${booking.adminComission ?? '0.00'} CHF",
                  valueColor: Colors.red),
              _buildDetailRow("Payment Status", (booking.paymentStatus ?? "unpaid").toUpperCase(),
                  valueColor: booking.paymentStatus == 'paid' ? Colors.green : Colors.orange),
              _buildDetailRow("Total Paid", 
                  "${(booking.paymentStatus == 'paid' ? (booking.totalPaid ?? booking.total) : booking.totalPaid) ?? '0.00'} CHF"),
              if (booking.paymentStatus == 'paid')
                _buildDetailRow("Earnings", "${booking.providerFeeAfterComission ?? '0.00'} CHF",
                    valueColor: Colors.green),

              UIHelper.verticalSpace(24.h),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.c264E71,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    "Close",
                    style: TextFontStyle.text12cFFFFFFw500SFPro.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextFontStyle.text12c4D4D4Dw400SFPro
                  .copyWith(color: const Color(0xFF8A8A8A))),
          Text(
            value,
            style: TextFontStyle.text12c101010w400SFPro.copyWith(
              color: valueColor ?? AppColors.c101010,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
