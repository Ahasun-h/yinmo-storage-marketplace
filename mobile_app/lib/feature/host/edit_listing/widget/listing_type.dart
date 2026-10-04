import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:provider/provider.dart';

import '../../../../providers/all_providers.dart';

class ListingType extends StatefulWidget {
  const ListingType({super.key});

  @override
  State<ListingType> createState() => _ListingTypeState();
}

class _ListingTypeState extends State<ListingType> {
  final List<String> buttonData = ['Parkings', 'Bike', 'Luggage Store'];
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllProviders>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select listing type',
          style: TextStyle(
            color: const Color(0xFF202020),
            fontSize: 14.sp,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
            height: 1.43,
          ),
        ),
        UIHelper.verticalSpace(12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.sp),
          decoration: ShapeDecoration(
            color: const Color(0x7FE9E9E9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Row(
            children: List.generate(buttonData.length, (index) {
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => provider.setSelectListingType(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 12.w,
                          ),
                          decoration: ShapeDecoration(
                            color: provider.selectListingType == index
                                ? const Color(0xFF001937)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            buttonData[index],
                            style: TextStyle(
                              color: provider.selectListingType == index
                                  ? AppColors.cFFFFFF
                                  : const Color(0xFF001937),
                              fontSize: 12.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index < buttonData.length - 1) SizedBox(width: 8.w),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
