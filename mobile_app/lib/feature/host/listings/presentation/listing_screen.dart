import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/feature/host/listings/model/all_listing_data_model.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../../../../networks/api_access.dart';
import '../../../user/item_details/widget/featurs_view.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  @override
  void initState() {
    getListingListRxOBJ.getListingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: getListingListRxOBJ.fileData,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (!asyncSnapshot.hasError && asyncSnapshot.data != null) {
            ListingListRes listingListRes = ListingListRes.fromJson(
              asyncSnapshot.data,
            );
            if (listingListRes.data == null || listingListRes.data!.isEmpty) {
              return Column(
                children: [
                  CustomAppBar(
                    title: "My Listings",
                    backButton: false,
                    actions: GestureDetector(
                      onTap: () {
                        NavigationService.navigateTo(Routes.addListing);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          UIHelper.horizontalSpace(8.w),
                          SvgPicture.asset(Assets.icons.addListing),
                          UIHelper.horizontalSpace(16.w),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No listings yet',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            UIHelper.verticalSpace(8.h),
                            Text(
                              'You haven’t added any listings. Tap Add Listing to create your first one.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF505050),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            UIHelper.verticalSpace(16.h),
                            SizedBox(
                              width: 140.w,
                              child: CustomButton(
                                onTap: () {
                                  NavigationService.navigateTo(
                                      Routes.addListing);
                                },
                                text: "Add Listing",
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                CustomAppBar(
                  title: "My Listings",
                  backButton: false,
                  actions: GestureDetector(
                    onTap: () {
                      NavigationService.navigateTo(Routes.addListing);
                    },
                    child: Row(
                      children: [
                        Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        UIHelper.horizontalSpace(8.w),
                        SvgPicture.asset(Assets.icons.addListing),
                        UIHelper.horizontalSpace(16.w),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: listingListRes.data?.length ?? 0,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (_, index) {
                      ListingModel listing = listingListRes.data![index];
                      return GestureDetector(
                        onTap: () {
                          NavigationService.navigateToWithObject(
                            Routes.listingDetails,
                            listing.id,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: ShapeDecoration(
                            color: const Color(0x7FE9E9E9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Column(
                            children: [
                              UIHelper.verticalSpace(16.h),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listing.title ?? "",
                                            style: TextStyle(
                                              color: const Color(0xFF202020),
                                              fontSize: 14.sp,
                                              fontFamily: 'SF Pro',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          UIHelper.verticalSpace(4.h),
                                          Text(
                                            listing.location ?? "",
                                            style: TextStyle(
                                              color: const Color(0xFF4D4D4D),
                                              fontSize: 12.sp,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '${listing.price ?? ""} CHF',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF001937),
                                                  fontSize: 16.sp,
                                                  fontFamily: 'SF Pro',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          UIHelper.verticalSpace(4.h),
                                          Text(
                                            'Per Day',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color(0xFF4D4D4D),
                                              fontSize: 12.sp,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              UIHelper.verticalSpace(8.h),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(Assets.icons.star),
                                    UIHelper.horizontalSpace(8.w),
                                    Text(
                                      "${listing.avgRating ?? "0.0"}",
                                      style: TextStyle(
                                        color: const Color(0xFFDF7720),
                                        fontSize: 12.sp,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    UIHelper.horizontalSpace(4.w),
                                    Text(
                                      '(${listing.uniqueUserCount ?? 0})',
                                      style: TextStyle(
                                        color: const Color(0xFF4D4D4D),
                                        fontSize: 12.sp,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              UIHelper.verticalSpace(16.h),
                              if (listing.features?.isNotEmpty ?? false)
                                Padding(
                                  padding: EdgeInsets.only(left: 16.w),
                                  child: SizedBox(
                                    height: 35.h,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: listing.features?.length ?? 0,
                                      physics: BouncingScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (_, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 8.w),
                                          child: FeatursView(
                                            title: listing.features?[index]
                                                    .featureName ??
                                                "",
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              UIHelper.verticalSpace(16.h),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No listings yet',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UIHelper.verticalSpace(8.h),
                    Text(
                      'You haven’t added any listings. Tap Add Listing to create your first one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF505050),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    UIHelper.verticalSpace(16.h),
                    SizedBox(
                      width: 140.w,
                      child: CustomButton(
                        onTap: () {
                          NavigationService.navigateTo(Routes.addListing);
                        },
                        text: "Add Listing",
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
