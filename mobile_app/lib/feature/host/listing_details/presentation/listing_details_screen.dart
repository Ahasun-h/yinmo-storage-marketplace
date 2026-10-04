import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/common_widgets/item_details_widget.dart';

import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/helpers/all_routes.dart';

import '../../../../networks/api_access.dart';

class ListingDetailsScreen extends StatefulWidget {
  final int listingId;
  const ListingDetailsScreen({super.key, required this.listingId});

  @override
  State<ListingDetailsScreen> createState() => _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends State<ListingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    getItemDetailsRxOBJ.get(widget.listingId);
    postItemReviewRetingGetRxOBJ.post(value: widget.listingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ItemDetailsWidget(itemId: widget.listingId),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: 12.h,
            left: 16.w,
            right: 16.w,
            bottom: 24.h,
          ),
          decoration: BoxDecoration(color: const Color(0xFF109590)),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 24.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Delete Listing",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              UIHelper.verticalSpace(12.h),
                              Text(
                                "Are you sure you want to delete this listing? This action cannot be undone. All associated data will be permanently removed.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF505050),
                                ),
                              ),
                              UIHelper.verticalSpace(24.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      text: "Cancel",
                                      bgColor: Colors.white,
                                      textColor: AppColors.primaryColor,
                                      borderColor: AppColors.primaryColor,
                                      borderRadius: 12.r,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  UIHelper.horizontalSpace(12.w),
                                  Expanded(
                                    child: CustomButton(
                                      text: "Delete",
                                      bgColor: Colors.red,
                                      textColor: Colors.white,
                                      borderColor: Colors.red,
                                      borderRadius: 12.r,
                                      onTap: () {
                                        Navigator.pop(context);
                                        getDeleteListingRxOBJ
                                            .get(widget.listingId)
                                            .waitingForFutureWithoutBg()
                                            .then((value) {
                                          getListingListRxOBJ.getListingData();
                                          NavigationService.goBack;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: SvgPicture.asset(Assets.icons.deleteIcon),
                ),
              ),
              UIHelper.horizontalSpace(10.w),
              Expanded(
                child: CustomButton(
                  text: "Edit",
                  bgColor: AppColors.cFFFFFF,
                  textColor: AppColors.primaryColor,
                  borderColor: AppColors.cFFFFFF,
                  borderRadius: 16.r,
                  onTap: () {
                    NavigationService.navigateToWithObject(
                      Routes.editListing,
                      widget.listingId,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
