// ignore_for_file: unused_field

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/common_widgets/custom_toast.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../../../../networks/api_access.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  final bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _prefillUserData();
    getFaqRxOBJ.get();
  }

  void _prefillUserData() {
    String? name = appData.read(kKeyName);
    String? email = appData.read(kKeyEmail);
    if (name != null) nameController.text = name;
    if (email != null) mailController.text = email;
  }

  @override
  void dispose() {
    nameController.dispose();
    mailController.dispose();
    conPassController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: "Help & Support"),
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
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'We are exited to hear you',
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
                            controller: nameController,
                            isPrefixIcon: false,
                            fillColor: AppColors.cFFFFFF,
                            hintText: "Enter Full Name",
                            keyboardType: TextInputType.name,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(
                                  r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'))
                            ],
                          ),
                          UIHelper.verticalSpace(8.h),
                          Text(
                            'Email or phone',
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
                            controller: mailController,
                            isPrefixIcon: false,
                            fillColor: AppColors.cFFFFFF,
                            hintText: "Enter email or phone",
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          UIHelper.verticalSpace(8.h),
                          Text(
                            'Message',
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
                            controller: conPassController,
                            isPrefixIcon: false,
                            fillColor: AppColors.cFFFFFF,
                            hintText: "Write your message",
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            maxline: 5,
                          ),
                          UIHelper.verticalSpace(24.h),
                          CustomButton(
                            onTap: () {
                              if (nameController.text.isEmpty ||
                                  mailController.text.isEmpty ||
                                  conPassController.text.isEmpty) {
                                customToastMessage(
                                  "Error",
                                  "Please fill all the fields",
                                );
                                return;
                              }
                              postHelpSupportRxOBJ
                                  .post(
                                    fullName: nameController.text,
                                    email: mailController.text,
                                    supportMessage: conPassController.text,
                                  )
                                  .waitingForFutureWithoutBg()
                                  .then((value) {
                                if (value) {
                                  ToastUtil.showShortToast(
                                    "Your message has been sent successfully",
                                  );
                                  NavigationService.goBack;
                                }
                              });
                            },
                            text: "Submit",
                          ),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpace(20.h),
                    // Text(
                    //   'Frequently Asked Question',
                    //   style: TextStyle(
                    //     color: const Color(0xFF111827),
                    //     fontSize: 14.sp,
                    //     fontFamily: 'SF Pro',
                    //     fontWeight: FontWeight.w600,
                    //     height: 1.43,
                    //   ),
                    // ),
                    UIHelper.verticalSpace(16.h),
// StreamBuilder<FaqRes>(
                    //   stream: getFaqRxOBJ.faqList,
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData && snapshot.data?.data != null) {
                    //       List<FaqData> faqs = snapshot.data!.data!;
                    //       return ListView.builder(
                    //         shrinkWrap: true,
                    //         padding: EdgeInsets.zero,
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         itemCount: faqs.length,
                    //         itemBuilder: (context, index) {
                    //           return Padding(
                    //             padding: const EdgeInsets.only(bottom: 20),
                    //             child: Container(
                    //               width: double.infinity,
                    //               decoration: ShapeDecoration(
                    //                 color: const Color(0x7FE9E9E9),
                    //                 shape: RoundedRectangleBorder(
                    //                   side: BorderSide(
                    //                     width: 1.w,
                    //                     color: const Color(0xFFE9E9E9),
                    //                   ),
                    //                   borderRadius: BorderRadius.circular(12.r),
                    //                 ),
                    //               ),
                    //               child: ExpansionTile(
                    //                 expandedAlignment: Alignment.centerLeft,
                    //                 shape: const RoundedRectangleBorder(
                    //                   side: BorderSide.none,
                    //                 ),
                    //                 title: Text(
                    //                   faqs[index].question ?? "",
                    //                   style: TextStyle(
                    //                     color: const Color(0xFF1F1F1F),
                    //                     fontSize: 14.sp,
                    //                     fontFamily: 'SF Pro',
                    //                     fontWeight: FontWeight.w500,
                    //                   ),
                    //                 ),
                    //                 children: [
                    //                   Padding(
                    //                     padding: const EdgeInsets.symmetric(
                    //                       horizontal: 15,
                    //                       vertical: 10,
                    //                     ),
                    //                     child: Text(
                    //                       faqs[index].answer ?? "",
                    //                       style: TextStyle(
                    //                         color: const Color(0xCC101010),
                    //                         fontSize: 12.sp,
                    //                         fontFamily: 'SF Pro',
                    //                         fontWeight: FontWeight.w400,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       );
                    //     } else if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return const Center(
                    //           child: CircularProgressIndicator());
                    //     } else {
                    //       return const SizedBox();
                    //     }
                    //   },
                    // ),
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
