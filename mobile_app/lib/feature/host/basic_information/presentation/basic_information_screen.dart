// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/feature/user/item_details/widget/book_now_button.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/helpers/di.dart';
import '../../../../networks/api_access.dart';

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  State<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
  @override
  void initState() {
    super.initState();
    // Pre-fill from cache if available
    nameController.text = appData.read(kKeyName) ?? "";
    emailController.text = appData.read(kKeyEmail) ?? "";

    var phone = appData.read(kPhone);
    if (phone != null && phone != "null") {
      numberController.text = phone;
    } else {
      numberController.text = "";
    }

    var address = appData.read(kKeyAddress);
    if (address != null && address != "null") {
      addressController.text = address;
    } else {
      addressController.text = "";
    }

    // Fetch fresh data from API
    getProfileRxOBJ.get().then((success) {
      if (success && mounted) {
        setState(() {
          nameController.text = appData.read(kKeyName) ?? "";
          emailController.text = appData.read(kKeyEmail) ?? "";

          var phoneApi = appData.read(kPhone);
          if (phoneApi != null && phoneApi != "null") {
            numberController.text = phoneApi;
          } else {
            numberController.text = "";
          }

          var addressApi = appData.read(kKeyAddress);
          if (addressApi != null && addressApi != "null") {
            addressController.text = addressApi;
          } else {
            addressController.text = "";
          }
        });
      }
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    numberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _showExitHostFlowDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Do you want to cancel becoming a host?",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          CustomButton(
            text: "No",
            onTap: () {
              Navigator.of(context).pop(false);
            },
            borderRadius: 30.r,
          ),
          UIHelper.verticalSpace(16.h),
          CustomButton(
            text: "Yes",
            onTap: () {
              postSwitchAccountRxOBJ
                  .postSwitchAccount(value: "user")
                  .waitingForFutureWithoutBg()
                  .then((success) {
                if (success) {
                  NavigationService.navigateToUntilReplacement(
                    Routes.navigation,
                  );
                }
              });
            },
            borderRadius: 30.r,
            borderColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        _showExitHostFlowDialog(context);
      },
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(
              title: "Become a Host",
              backButton: true,
              onBack: () {
                postSwitchAccountRxOBJ
                    .postSwitchAccount(value: "user")
                    .waitingForFutureWithoutBg()
                    .then((success) {
                  if (success) {
                    NavigationService.navigateToUntilReplacement(
                      Routes.navigation,
                    );
                  }
                });
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      UIHelper.verticalSpace(20.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 20.h,
                        ),
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
                              'Basic Information',
                              style: TextStyle(
                                color: const Color(0xFF202020),
                                fontSize: 14.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                              ),
                            ),
                            UIHelper.verticalSpace(16.h),
                            Text(
                              'Full Name',
                              style: TextStyle(
                                color: const Color(0x99101010),
                                fontSize: 12.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            UIHelper.verticalSpace(4.h),
                            CommonTextFormField(
                              readOnly: true,
                              controller: nameController,
                              isPrefixIcon: false,
                              hintText: "Not Provided",
                              fillColor: AppColors.cFFFFFF,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                            ),
                            UIHelper.verticalSpace(8.h),
                            Text(
                              'Email',
                              style: TextStyle(
                                color: const Color(0x99101010),
                                fontSize: 12.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            UIHelper.verticalSpace(4.h),
                            CommonTextFormField(
                              readOnly: true,
                              controller: emailController,
                              isPrefixIcon: false,
                              hintText: "Not Provided",
                              fillColor: AppColors.cFFFFFF,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            UIHelper.verticalSpace(8.h),
                            Text(
                              'Contact Number',
                              style: TextStyle(
                                color: const Color(0x99101010),
                                fontSize: 12.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            UIHelper.verticalSpace(4.h),
                            CommonTextFormField(
                              controller: numberController,
                              isPrefixIcon: false,
                              hintText: "Not Provided",
                              fillColor: AppColors.cFFFFFF,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                            ),
                            UIHelper.verticalSpace(8.h),
                            Text(
                              'Address',
                              style: TextStyle(
                                color: const Color(0x99101010),
                                fontSize: 12.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            UIHelper.verticalSpace(4.h),
                            CommonTextFormField(
                              controller: addressController,
                              isPrefixIcon: false,
                              hintText: "Not Provided",
                              fillColor: AppColors.cFFFFFF,
                              keyboardType: TextInputType.streetAddress,
                              textInputAction: TextInputAction.done,
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
        bottomNavigationBar: BookNowButton(
          title: "Continue",
          onTap: () {
            postBasicInformationRxOBJ
                .post(
                  address: addressController.text,
                  phone: numberController.text,
                  accountHolder: nameController.text,
                )
                .waitingForFutureWithoutBg()
                .then((value) {
              if (value) {
                NavigationService.navigateTo(Routes.stripeConnect);
              }
            });
          },
        ),
      ),
    );
  }
}
