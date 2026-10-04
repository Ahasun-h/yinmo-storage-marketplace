// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';

class PersonalEditPopup extends StatefulWidget {
  const PersonalEditPopup({super.key});

  @override
  State<PersonalEditPopup> createState() => _PersonalEditPopupState();
}

class _PersonalEditPopupState extends State<PersonalEditPopup> {
  TextEditingController addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final DateTime _selectedDateTime = DateTime.now();
  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    // if (pickedDate != null) {
    //   await showDatePicker(
    //     context: context,
    //     initialDate: _selectedDateTime,
    //     firstDate: DateTime(2000),
    //     lastDate: DateTime(2100),
    //   );
    // }
    if (pickedDate != null) {
      // setState(() {
      _dateController.text = DateFormat('dd, MMM yyyy').format(pickedDate);
      // });
    }
  }

  String selectedGender = 'Select gender';

  final List<String> genders = ['Select gender', 'Male', 'Female', 'Others'];

  @override
  void dispose() {
    addressController.dispose();
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
              'Date of Birth',
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
              controller: _dateController,
              isPrefixIcon: false,
              fillColor: const Color(0xFFF3F3F3),
              isBorder: false,
              hintText: "DD/MM/YYYY",
              textInputAction: TextInputAction.next,
              onTap: () {
                setState(() {
                  _selectDateTime();
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select Date & Time";
                }
                return null;
              },
            ),
            UIHelper.verticalSpace(16.h),
            Text(
              'Gender',
              style: TextStyle(
                color: const Color(0x99101010),
                fontSize: 12.sp,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            UIHelper.verticalSpace(4.h),
            Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                color: const Color(0xFFF3F3F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: DropdownButton<String>(
                    value: selectedGender,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: TextStyle(
                      color: const Color(0xFF101010),
                      fontSize: 12.sp,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                    underline: const SizedBox(),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue!;
                      });
                    },
                    items: genders.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            UIHelper.verticalSpace(16.h),
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
              hintText: "Enter your Address",
              fillColor: const Color(0xFFF3F3F3),
              isBorder: false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            UIHelper.verticalSpace(20.h),
            CustomButton(
              onTap: () {
                postProfileUpdateRxOBJ
                    .post(
                      address: addressController.text,
                      date: _dateController.text.isNotEmpty
                          ? DateFormat('yyyy-MM-dd').format(
                              DateFormat(
                                'dd, MMM yyyy',
                              ).parse(_dateController.text),
                            )
                          : "",
                      gender: selectedGender,
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
