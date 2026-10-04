import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/feature/user/notification_preference/widget/notification_preferance_row.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class NotificationPreferanceScreen extends StatefulWidget {
  const NotificationPreferanceScreen({super.key});

  @override
  State<NotificationPreferanceScreen> createState() =>
      _NotificationPreferanceScreenState();
}

class _NotificationPreferanceScreenState
    extends State<NotificationPreferanceScreen> {
  bool bookingReminder = true;
  bool expiryOvertime = true;
  bool email = true;
  bool pushNotifications = true;
  bool sms = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Notification Preferences"),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    UIHelper.verticalSpace(20.h),
                    Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: ShapeDecoration(
                        color: const Color(0x7FE9E9E9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking updates',
                            style: TextStyle(
                              color: const Color(0xFF202020),
                              fontSize: 14.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),
                          UIHelper.verticalSpace(16.h),
                          NotificationPreferencesRow(
                            title: 'Upcoming booking reminder',
                            subTitle: 'Before start time',
                            value: bookingReminder,
                          ),
                          NotificationPreferencesRow(
                            title: 'Expiry and overtime',
                            subTitle: 'When booking time is ending',
                            value: expiryOvertime,
                            isDevider: false,
                          ),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpace(8.h),
                    Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: ShapeDecoration(
                        color: const Color(0x7FE9E9E9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Channels',
                            style: TextStyle(
                              color: const Color(0xFF202020),
                              fontSize: 14.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),
                          UIHelper.verticalSpace(16.h),
                          NotificationPreferencesRow(
                            title: 'Email',
                            subTitle: 'athik.w@example.com',
                            value: email,
                          ),
                          NotificationPreferencesRow(
                            title: 'Push notifications',
                            subTitle: 'On this device',
                            value: pushNotifications,
                          ),
                          NotificationPreferencesRow(
                            title: 'SMS',
                            subTitle: 'For urgent alerts',
                            value: sms,
                            isDevider: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
