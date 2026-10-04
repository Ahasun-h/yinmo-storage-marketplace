import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/background.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Trusted Hosts\nSeamless Booking",
      "subtitle": "Enjoy smooth, reliable bookings with\nverified providers.",
    },
    {
      "title": "Make money from\nyour space",
      "subtitle": "List your parking or storage and bikes\nstart earning today",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        image: Assets.images.onboardingOne.path,
        child: Column(
          children: [
            UIHelper.verticalSpace(60.h),
            // >>>>>>>>>>>>>>>>>>>>>  SKIP BUTTON  >>>>>>>>>>>>>>>>
            if (_currentPage != _onboardingData.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigationService.navigateToUntilReplacement(
                          Routes.login,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: ShapeDecoration(
                          color: AppColors.c011937,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          'Skip',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.cFFFFFF,
                            fontSize: 14.sp,
                            fontFamily: 'Public Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Spacer(),
            SizedBox(
              height: 150.h,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        _onboardingData[index]['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF011937),
                          fontSize: 36.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w600,
                          height: 1.11.h,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Subtitle
                      Text(
                        _onboardingData[index]['subtitle'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xE5011937),
                          fontSize: 14.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 32.h),
            // Next/Get Started button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 90.w),
              child: CustomButton(
                text: _currentPage != _onboardingData.length - 1
                    ? "Continue"
                    : "Get Started",
                borderRadius: 32.r,
                bgColor: const Color(0xFF011937),
                borderColor: const Color(0xFF011937),
                onTap: () {
                  if (_currentPage < _onboardingData.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    NavigationService.navigateToUntilReplacement(Routes.login);
                  }
                },
              ),
            ),
            UIHelper.verticalSpace(32.h),
          ],
        ),
      ),
    );
  }
}
