// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, library_private_types_in_public_api, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:urban_koala/common_widgets/custom_navigation_item.dart';
import 'package:urban_koala/feature/common_features/chat_list/presentation/chat_list_screen.dart';
import 'package:urban_koala/feature/user/home/presentation/home_screen.dart';
import 'package:urban_koala/feature/user/mybooking/presentation/mybooking_screen.dart';
import 'package:urban_koala/feature/common_features/profile/presentation/profile_screen.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/helper_methods.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/common_widgets/guest_auth_dialog.dart';

class NavigationScreen extends StatefulWidget {
  final int? pageNum;
  const NavigationScreen({super.key, this.pageNum});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MybookingScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.pageNum ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        showMaterialDialog(context);
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: Theme.of(context).platform == TargetPlatform.android,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(48.r),
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                top: 12.h,
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33202020),
                    blurRadius: 20,
                    offset: Offset(0, -12),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomNavigationItem(
                      onTap: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      ontapColor: _currentIndex == 0
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      lebel: _currentIndex == 0 ? "Home".tr : "",
                      icon: _currentIndex == 0
                          ? Assets.icons.home1
                          : Assets.icons.home,
                    ),
                    CustomNavigationItem(
                      onTap: () async {
                        if (appData.read(kKeyIsLoggedIn) == true) {
                          setState(() {
                            _currentIndex = 1;
                          });
                        } else {
                          await showDialog(
                            context: context,
                            builder: (context) => const GuestAuthDialog(),
                          ).then((_) {
                            if (appData.read(kKeyIsLoggedIn) == true) {
                              setState(() {
                                _currentIndex = 1;
                              });
                            }
                          });
                        }
                      },
                      ontapColor: _currentIndex == 1
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      lebel: _currentIndex == 1 ? "My Bookings".tr : "",
                      icon: _currentIndex == 1
                          ? Assets.icons.myBookings1
                          : Assets.icons.myBookings,
                    ),
                    CustomNavigationItem(
                      onTap: () async {
                        if (appData.read(kKeyIsLoggedIn) == true) {
                          setState(() {
                            _currentIndex = 2;
                          });
                        } else {
                          await showDialog(
                            context: context,
                            builder: (context) => const GuestAuthDialog(),
                          ).then((_) {
                            if (appData.read(kKeyIsLoggedIn) == true) {
                              setState(() {
                                _currentIndex = 2;
                              });
                            }
                          });
                        }
                      },
                      ontapColor: _currentIndex == 2
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      lebel: _currentIndex == 2 ? "Messages".tr : "",
                      icon: _currentIndex == 2
                          ? Assets.icons.message1
                          : Assets.icons.message,
                    ),
                    CustomNavigationItem(
                      onTap: () async {
                        if (appData.read(kKeyIsLoggedIn) == true) {
                          setState(() {
                            _currentIndex = 3;
                          });
                        } else {
                          await showDialog(
                            context: context,
                            builder: (context) => const GuestAuthDialog(),
                          ).then((_) {
                            if (appData.read(kKeyIsLoggedIn) == true) {
                              setState(() {
                                _currentIndex = 3;
                              });
                            }
                          });
                        }
                      },
                      ontapColor: _currentIndex == 3
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      lebel: _currentIndex == 3 ? "Account".tr : "",
                      icon: _currentIndex == 3
                          ? Assets.icons.profile1
                          : Assets.icons.profile,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
