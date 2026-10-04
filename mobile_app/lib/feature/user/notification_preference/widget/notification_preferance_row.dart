import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class NotificationPreferencesRow extends StatefulWidget {
  final String title;
  final String subTitle;
  final bool value;
  final bool? isDevider;

  const NotificationPreferencesRow({
    super.key,
    required this.title,
    required this.value,
    this.isDevider = true,
    required this.subTitle,
  });

  @override
  State<NotificationPreferencesRow> createState() =>
      _NotificationPreferencesRowState();
}

class _NotificationPreferencesRowState
    extends State<NotificationPreferencesRow> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: const Color(0xFF101010),
                fontSize: 12.sp,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            FlutterSwitch(
              width: 40.0,
              height: 20.0,
              toggleSize: 16.0,
              borderRadius: 20.0,
              padding: 2.0,
              activeColor: AppColors.primaryColor.withValues(alpha: 0.40),
              inactiveColor: AppColors.cFFFFFF,
              toggleColor: _value
                  ? AppColors.primaryColor
                  : AppColors.primaryColor.withValues(alpha: 0.50),
              value: _value,
              onToggle: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          ],
        ),
        UIHelper.verticalSpace(4.h),
        Text(
          widget.subTitle,
          style: TextStyle(
            color: const Color(0x99101010),
            fontSize: 12.sp,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        if (widget.isDevider == true)
          Column(
            children: [
              UIHelper.verticalSpace(8.h),
              UIHelper.customDivider(),
              UIHelper.verticalSpace(8.h),
            ],
          ),
      ],
    );
  }
}
