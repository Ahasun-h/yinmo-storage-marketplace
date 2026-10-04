import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool? backButton;
  final Widget? actions;
  final Function? onBack;
  const CustomAppBar({
    super.key,
    required this.title,
    this.backButton = true,
    this.actions,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFF0F958F)),
      child: Column(
        children: [
          UIHelper.verticalSpace(52.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  backButton == true
                      ? Row(
                          children: [
                            UIHelper.horizontalSpace(8.w),
                            GestureDetector(
                              onTap: () {
                                onBack?.call();
                                NavigationService.goBack;
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.cFFFFFF,
                                size: 20.sp,
                              ),
                            ),
                            UIHelper.horizontalSpace(4.w),
                          ],
                        )
                      : UIHelper.horizontalSpace(16.w),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              actions ??
                  Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.transparent,
                    size: 25.sp,
                  ),
            ],
          ),
          UIHelper.verticalSpace(12.h),
        ],
      ),
    );
  }
}
