import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/feature/common_features/profie_info/widget/basic_edit_popup.dart';
import 'package:urban_koala/feature/common_features/profie_info/widget/besic_info_container.dart';
import 'package:urban_koala/feature/common_features/profie_info/widget/personal_edit_popup.dart';
import 'package:urban_koala/feature/common_features/profie_info/widget/personal_info_container.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';

import '../model/profile_info.dart';

class ProfileInfoScreeen extends StatefulWidget {
  const ProfileInfoScreeen({super.key});

  @override
  State<ProfileInfoScreeen> createState() => _ProfileInfoScreeenState();
}

class _ProfileInfoScreeenState extends State<ProfileInfoScreeen> {
  @override
  void initState() {
    getProfileRxOBJ.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: getProfileRxOBJ.fileData,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                color: Colors.blue,
              ),
            );
          } else if (!asyncSnapshot.hasError && asyncSnapshot.data != null) {
            ProfileInfo? profileInfo = ProfileInfo.fromJson(asyncSnapshot.data);
            return Column(
              children: [
                CustomAppBar(title: "Profile Information"),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          UIHelper.verticalSpace(20.h),
                          BesicInfoContainer(
                            name: profileInfo.data?.name ?? 'Add Name',
                            number: profileInfo.data?.phone ?? 'Add Number',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const BasicEditPopup();
                                },
                              );
                            },
                          ),
                          UIHelper.verticalSpace(8.h),
                          PersonalInfoContainer(
                            dateOfBirth: profileInfo.data?.dob != null
                                ? DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(profileInfo.data!.dob!)
                                : "DD/MM/YYYY",
                            gender: profileInfo.data?.gender ?? 'Add Gender',
                            address: profileInfo.data?.address ?? 'Add Address',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const PersonalEditPopup();
                                },
                              );
                            },
                          ),
                          UIHelper.verticalSpace(8.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text("No Data Found"));
          }
        },
      ),
    );
  }
}
