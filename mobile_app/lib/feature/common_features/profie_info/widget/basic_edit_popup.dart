import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../../../../networks/api_access.dart';

class BasicEditPopup extends StatefulWidget {
  const BasicEditPopup({super.key});

  @override
  State<BasicEditPopup> createState() => _BasicEditPopupState();
}

class _BasicEditPopupState extends State<BasicEditPopup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Personal Info',
                  style: TextStyle(
                    color: const Color(0xFF1F1F1F),
                    fontSize: 16.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    NavigationService.goBack;
                  },
                  child: SvgPicture.asset(Assets.icons.closewithcircle),
                ),
              ],
            ),
            UIHelper.verticalSpace(8.h),
            UIHelper.customDivider(color: const Color(0xFFE9E9E9)),
            UIHelper.verticalSpace(16.h),
            Text(
              'Name',
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
              hintText: "Enter your name",
              fillColor: const Color(0xFFF3F3F3),
              isBorder: false,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                  RegExp(
                      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                )
              ],
            ),
            UIHelper.verticalSpace(16.h),
            Text(
              'Contact number',
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
              hintText: "Enter your number",
              fillColor: const Color(0xFFF3F3F3),
              isBorder: false,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
            ),
            UIHelper.verticalSpace(20.h),
            CustomButton(
              onTap: () {
                postProfileUpdateRxOBJ
                    .post(
                      name: nameController.text,
                      contactNumber: numberController.text,
                    )
                    .waitingForFutureWithoutBg()
                    .then((value) {
                  getProfileRxOBJ.get();
                  NavigationService.goBack;
                });
              },
              text: "Save",
            ),
          ],
        ),
      ),
    );
  }
}
