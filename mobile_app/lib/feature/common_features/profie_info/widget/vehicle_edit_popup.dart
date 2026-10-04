import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';

class VehicleEditPopup extends StatefulWidget {
  const VehicleEditPopup({super.key});

  @override
  State<VehicleEditPopup> createState() => _VehicleEditPopupState();
}

class _VehicleEditPopupState extends State<VehicleEditPopup> {
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  @override
  void dispose() {
    vehicleNameController.dispose();
    licensePlateController.dispose();
    vehicleModelController.dispose();
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
              'Vehicle Type',
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
              controller: vehicleNameController,
              isPrefixIcon: false,
              hintText: "Vehicle Type",
              fillColor: const Color(0xFFF3F3F3),
              isBorder: false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            UIHelper.verticalSpace(16.h),
            Text(
              'License Plate Number',
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
              controller: licensePlateController,
              isPrefixIcon: false,
              hintText: "Enter License Plate Number",
              fillColor: const Color(0xFFF3F3F3),
              isBorder: false,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            UIHelper.verticalSpace(16.h),
            Text(
              'Vehicle Model',
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
              controller: vehicleModelController,
              isPrefixIcon: false,
              hintText: "Enter Vehicle Model",
              fillColor: const Color(0xFFF3F3F3),
              isBorder: false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            UIHelper.verticalSpace(20.h),
            CustomButton(
                onTap: () {
                  postVehicleUpdateRxOBJ
                      .post(
                        vehicleName: vehicleNameController.text,
                        licencePlateNumber: licensePlateController.text,
                        vehicleModel: vehicleModelController.text,
                      )
                      .waitingForFutureWithoutBg()
                      .then((value) {
                    if (value) {
                      getVehicleInfoRxOBJ.get();
                      NavigationService.goBack();
                    }
                  });
                },
                text: "Save"),
          ],
        ),
      ),
    );
  }
}
