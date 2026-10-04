import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../../../../helpers/all_routes.dart';
import '../../../../networks/api_access.dart';
import '../model/booking_cancel_reason.dart';

class CancelationPopup extends StatefulWidget {
  final int? bookingId;
  const CancelationPopup({super.key, this.bookingId});

  @override
  State<CancelationPopup> createState() => _CancelationPopupState();
}

class _CancelationPopupState extends State<CancelationPopup> {
  int selectedIndex = -1;
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getBookingCancelReasonRxOBJ.fetchBookingCancelReason();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: StreamBuilder(
          stream: getBookingCancelReasonRxOBJ.fillData,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            } else if (!asyncSnapshot.hasError && asyncSnapshot.data != null) {
              BookingCancelReasonRes? bookingCancelReasonRes =
                  BookingCancelReasonRes.fromJson(asyncSnapshot.data);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cancelation Request',
                        style: TextStyle(
                          color: const Color(0xFF1F1F1F),
                          fontSize: 16.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          NavigationService.goBack;
                        },
                        child: SvgPicture.asset(Assets.icons.closewithcircle),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),
                  UIHelper.customDivider(color: const Color(0xFFE9E9E9)),
                  UIHelper.verticalSpace(16.h),
                  Text(
                    'Select a reason for cancelation',
                    style: TextStyle(
                      color: const Color(0xFF222328),
                      fontSize: 14,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                    ),
                  ),
                  UIHelper.verticalSpace(16.h),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: bookingCancelReasonRes.data?.length ?? 0,
                    itemBuilder: (_, index) {
                      BookingCancelReason? bookingCancelReason =
                          bookingCancelReasonRes.data?[index];
                      return Row(
                        children: [
                          Checkbox(
                            value: selectedIndex == bookingCancelReason?.id,
                            onChanged: (value) {
                              setState(() {
                                if (selectedIndex == bookingCancelReason?.id) {
                                  selectedIndex = -1;
                                  return;
                                }
                                selectedIndex = bookingCancelReason?.id ?? -1;
                              });
                            },
                            checkColor: AppColors.cFFFFFF,
                            activeColor: AppColors.primaryColor,
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
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                          UIHelper.horizontalSpace(8.w),
                          Expanded(
                            child: Text(
                              bookingCancelReason?.reason ?? '',
                              style: TextStyle(
                                color: const Color(0xFF222328),
                                fontSize: 14.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  UIHelper.verticalSpace(20.h),
                  CommonTextFormField(
                    isPrefixIcon: false,
                    borderRadius: 12.r,
                    controller: reasonController,
                    hintText: "Write here....",
                    hintStyle: TextStyle(
                      color: const Color(0xFF868686),
                      fontSize: 14.sp,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                    maxline: 4,
                  ),
                  UIHelper.verticalSpace(20.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onTap: () {
                            NavigationService.goBack;
                          },
                          text: "Cancel",
                          bgColor: AppColors.cFFFFFF,
                          borderColor: const Color(0xFFE9E9E9),
                          textColor: const Color(0xFF202020),
                        ),
                      ),
                      UIHelper.horizontalSpace(16.w),
                      Expanded(
                        child: CustomButton(
                          onTap: () {
                            postBookingCancleRequestSubmitRxOBJ
                                .post(
                                  rejectId: selectedIndex,
                                  deleteMessage: reasonController.text,
                                  bookingId: widget.bookingId,
                                )
                                .waitingForFutureWithoutBg()
                                .then((value) {
                              if (value) {
                                NavigationService.navigateToWithObject(
                                  Routes.navigation,
                                  1,
                                );
                              }
                            });
                          },
                          text: "Submit Request",
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }
}
