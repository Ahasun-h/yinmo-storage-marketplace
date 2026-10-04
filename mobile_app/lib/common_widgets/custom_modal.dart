import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../helpers/ui_helpers.dart';
import '../../../../common_widgets/custom_button.dart';

void customModal(
  BuildContext context,
  String message,
  void Function() onConfirm,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UIHelper.verticalSpace(16.h),

              // Text content
              Text(
                "Are you sure to $message?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.h),

              // Buttons row
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // CustomButton(
                  //   text: 'Cancel',
                  //   borderRadius: 16.r,
                  //   onTap: () => Navigator.pop(context),
                  // ),
                  UIHelper.verticalSpace(12.h),
                  CustomButton(
                    text: message,
                    borderRadius: 16.r,
                    onTap: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
