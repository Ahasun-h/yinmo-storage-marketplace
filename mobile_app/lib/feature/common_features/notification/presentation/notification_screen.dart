import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_koala/common_widgets/guest_auth_dialog.dart';
import 'package:urban_koala/feature/common_features/notification/model/notification_model.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/networks/api_access.dart'; // To access global instances

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    handleGetNotification();
  }

  handleGetNotification() async {
    if (appData.read(kKeyIsLoggedIn) == true) {
      getNotificationRxOBJ.get();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          builder: (context) => const GuestAuthDialog(),
        ).then((_) {
          if (appData.read(kKeyIsLoggedIn) == true) {
            getNotificationRxOBJ.get();
          }
        });
      });
    }
  }

  Future<void> _handleMarkAllRead() async {
    // Show loading or just create optimism?
    // User said: "mark as read button thakbe jeta call korle ... then success howar por all notification get er api ta call hobe"
    bool success = await markNotificationReadRxOBJ.markAllRead();
    if (success) {
      getNotificationRxOBJ.get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => NavigationService.goBack,
        ),
        actions: [
          TextButton(
            onPressed: _handleMarkAllRead,
            child: Text(
              "Mark all as Read",
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: StreamBuilder<NotificationRes>(
        stream: getNotificationRxOBJ.notificationList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }

          if (snapshot.hasData) {
            final data = snapshot.data?.data;
            if (data == null || data.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "You're all caught up! No new notifications.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF505050),
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await getNotificationRxOBJ.get();
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final notification = data[index];
                  return GestureDetector(
                      onTap: () {
                        String title = (notification.title ?? "").toLowerCase();

                        // Payment / Info Popup
                        if (title.contains('transfer') ||
                            title.contains('money') ||
                            title.contains('stripe') ||
                            title.contains('payment') ||
                            title.contains('payout')) {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: EdgeInsets.symmetric(
                                  horizontal: 20.w), // Wider padding
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24.w, vertical: 24.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon Header
                                    Container(
                                      height: 64.w,
                                      width: 64.w,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEBF4FF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.receipt_long_rounded,
                                          color: AppColors.primaryColor,
                                          size: 32.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    // Title
                                    Text(
                                      notification.title ?? "Details",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    // Divider
                                    Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: Colors.grey.withValues(alpha: 0.2),
                                    ),
                                    SizedBox(height: 16.h),
                                    // Body / Message
                                    Text(
                                      notification.message ?? "",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF4D4D4D),
                                        height: 1.5,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    // Close Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14.h),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          "Close",
                                          style: GoogleFonts.outfit(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          return;
                        }

                        // Booking Navigation logic
                        bool isBookingNotification =
                            (notification.data != null &&
                                notification.data?['booking_id'] != null);
                        bool isTitleBooking = title.contains('booking');
                        String userType = appData.read(kKeyUserType) ??
                            "user"; // Default to user if null

                        if (isBookingNotification || isTitleBooking) {
                          String bookingId = notification.data != null
                              ? notification.data!['booking_id'].toString()
                              : "";

                          if (userType == "service_provider") {
                            // Host navigation - Always go to booking list if it's a booking notification
                            // The host booking screen doesn't take args currently, so this is safe.
                            NavigationService.navigateTo(Routes.hostBooking);
                          } else {
                            // Guest navigation
                            // Guests need a specific ID to view details.
                            if (bookingId.isNotEmpty && bookingId != "null") {
                              NavigationService.navigateToWithArgs(
                                Routes.bookingDetails,
                                {"bookingId": bookingId},
                              );
                            }
                          }
                        }
                      },
                      child: NotificationCard(notification: notification));
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationData notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final bool isRead = notification.isRead == true;
    // Light blue background from image for unread
    final Color unreadColor = const Color(0xFFEBF4FF);
    final Color readColor =
        Colors.white; // Or AppColors.cF3F3F3 if white is too plain
    final Color blueIcon = const Color(0xFF006CFF);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isRead ? readColor : unreadColor,
        borderRadius: BorderRadius.circular(16.r),
        border: isRead ? Border.all(color: Colors.grey.shade200) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.notifications_outlined, // Placeholder icon
                    color: blueIcon,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title ?? "Notification",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.message ?? "",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Time
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              _timeAgo(notification.updatedAt),
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(String? dateString) {
    if (dateString == null) return "";
    try {
      final DateTime date = DateTime.parse(dateString);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(date);

      if (difference.inSeconds < 60) {
        return "Just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
      } else {
        // Fallback to simple date
        return "${date.day}/${date.month}/${date.year}";
      }
    } catch (e) {
      return "";
    }
  }
}
