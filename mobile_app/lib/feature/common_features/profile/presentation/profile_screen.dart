import 'dart:io';

import 'package:cached_network_image_pro/cached_network_image_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/feature/common_features/profie_info/model/profile_info.dart';
import 'package:urban_koala/feature/common_features/profile/widget/log_out_dialouge.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/helper_methods.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/helpers/url_lunch.dart';
import 'package:urban_koala/networks/api_access.dart';
import 'package:urban_koala/networks/endpoints.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../widget/profile_row_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _selectedProfileImage;

  //......... profile image picker
  Future<void> _pickProfileImage() async {
    final pickedFile = await pickImage();
    if (pickedFile != null) {
      setState(() {
        _selectedProfileImage = pickedFile;
        postProfileImageRxOBJ
            .post(imageFile: _selectedProfileImage)
            .waitingForFutureWithoutBg()
            .then((success) {
          if (success) {
            getProfileRxOBJ.get();
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getProfileRxOBJ.get().then((response) {
      // Redirect to login if token is not present
      final token = appData.read(kKeyAccessToken);
      if (token == null || (token is String && token.trim().isEmpty)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          NavigationService.navigateToUntilReplacement(Routes.login);
        });
        return;
      }
      // Handle successful data retrieval if needed
    }).catchError((error) {
      // Handle errors if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<AllProviders>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: getProfileRxOBJ.fileData,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!asyncSnapshot.hasError && asyncSnapshot.data != null) {
            ProfileInfo? profileInfo = ProfileInfo.fromJson(asyncSnapshot.data);
            String? profileImage = profileInfo.data?.profileImage;
            if (profileImage != null && profileImage.startsWith('http')) {
              profileImage = profileInfo.data?.profileImage;
            } else {
              profileImage = '$url/$profileImage';
            }
            return Column(
              children: [
                CustomAppBar(title: "Profile & settings", backButton: false),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          UIHelper.verticalSpace(20.h),
                          Center(
                            child: Stack(
                              alignment: AlignmentGeometry.bottomRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(150.r),
                                  child: _selectedProfileImage == null
                                      ? CachedNetworkImagePro(
                                          imgUrl: "$profileImage",
                                          width: 80.h,
                                          height: 80.h,
                                        )
                                      : Image.file(
                                          File(_selectedProfileImage!.path),
                                          width: 80.w,
                                          height: 80.w,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 6.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      _pickProfileImage();
                                    },
                                    child: SvgPicture.asset(
                                      Assets.icons.edipProfileImage,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          UIHelper.verticalSpace(8.h),
                          Text(
                            profileInfo.data?.name ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF101010),
                              fontSize: 16.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            profileInfo.data?.email ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xB2101010),
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          UIHelper.verticalSpace(12.h),
                          GestureDetector(
                            onTap: () {
                              if (profileInfo.data?.lastLoginRole ==
                                  "service_provider") {
                                postSwitchAccountRxOBJ
                                    .postSwitchAccount(value: "user")
                                    .waitingForFutureWithoutBg()
                                    .then((success) {
                                  if (success) {
                                    NavigationService
                                        .navigateToUntilReplacement(
                                      Routes.navigation,
                                    );
                                  }
                                });
                              } else {
                                postSwitchAccountRxOBJ
                                    .postSwitchAccount(
                                      value: "service_provider",
                                    )
                                    .waitingForFutureWithoutBg()
                                    .then((success) {
                                  if (success) {
                                    if (appData.read(kKeyStatus) == "pending") {
                                      NavigationService
                                          .navigateToUntilReplacement(
                                        Routes.basicInformation,
                                      );
                                    } else {
                                      NavigationService
                                          .navigateToUntilReplacement(
                                        Routes.hostNavigation,
                                      );
                                    }
                                  }
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: ShapeDecoration(
                                color: profileInfo.data?.lastLoginRole ==
                                        "service_provider"
                                    ? Color(0xFF001937)
                                    : const Color(0xFF0F958F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                              ),
                              child: Text(
                                profileInfo.data?.lastLoginRole ==
                                        "service_provider"
                                    ? 'Change to Guest'
                                    : 'Change to Host',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          UIHelper.verticalSpace(32.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.sp),
                            decoration: ShapeDecoration(
                              color: const Color(0x7FE9E9E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Column(
                              children: [
                                ProfileRowButton(
                                  title: 'Profile Information',
                                  onTap: () {
                                    NavigationService.navigateTo(
                                      Routes.profileInfo,
                                    );
                                  },
                                  isSpace: false,
                                ),
                                ProfileRowButton(
                                  title: 'Security',
                                  isDeviider: true,
                                  onTap: () {
                                    NavigationService.navigateTo(
                                      Routes.security,
                                    );
                                  },
                                ),
                                ProfileRowButton(
                                  title:
                                      profileInfo.data?.lastLoginRole == "user"
                                          ? 'Payments & Billings'
                                          : 'My Bookings',
                                  onTap: () {
                                    NavigationService.navigateTo(
                                      profileInfo.data?.lastLoginRole == "user"
                                          ? Routes.paymentsBillings
                                          : Routes.hostBooking,
                                    );
                                  },
                                  isDeviider: false,
                                ),
                              ],
                            ),
                          ),
                          UIHelper.verticalSpace(8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.sp),
                            decoration: ShapeDecoration(
                              color: const Color(0x7FE9E9E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Column(
                              children: [
                                ProfileRowButton(
                                  title: 'Help & Support',
                                  onTap: () {
                                    NavigationService.navigateTo(
                                      Routes.helpSupport,
                                    );
                                  },
                                  isSpace: false,
                                ),
                                ProfileRowButton(
                                  title: 'Terms & Conditions',
                                  onTap: () {
                                    urlLunch("https://urbankoala.app/terms");
                                  },
                                ),
                                ProfileRowButton(
                                  title: 'Privacy Policy',
                                  onTap: () {
                                    urlLunch("https://urbankoala.app/privacy");
                                  },
                                  isDeviider: false,
                                ),
                              ],
                            ),
                          ),
                          UIHelper.verticalSpace(8.h),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const LogOutDialouge();
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.sp),
                              decoration: ShapeDecoration(
                                color: const Color(0x19FF0000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: const Color(0xFFFF0000),
                                      fontSize: 14.sp,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SvgPicture.asset(Assets.icons.logout),
                                ],
                              ),
                            ),
                          ),
                          UIHelper.verticalSpace(40.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No Data Found'));
          }
        },
      ),
    );
  }
}
