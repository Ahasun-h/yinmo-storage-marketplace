import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_button.dart';
import 'package:urban_koala/feature/user/home/model/map_data_model.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';

class AllCategoriesBottomSheet extends StatefulWidget {
  const AllCategoriesBottomSheet({super.key});

  @override
  State<AllCategoriesBottomSheet> createState() =>
      _AllCategoriesBottomSheetState();
}

class _AllCategoriesBottomSheetState extends State<AllCategoriesBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch all data by passing an empty string or null depending on API requirement.
      // Assuming empty string returns all data as discussed.
      postMapDataRxOBJ.post(infoType: "");
    });
  }

  Map<String, List<MapDataModel>> groupDataByCategory(List<MapDataModel> data) {
    Map<String, List<MapDataModel>> grouped = {};
    for (var item in data) {
      if (item.listingType != null) {
        if (!grouped.containsKey(item.listingType!)) {
          grouped[item.listingType!] = [];
        }
        grouped[item.listingType!]!.add(item);
      }
    }
    return grouped;
  }

  String _getCategoryTitle(String key) {
    switch (key) {
      case "bike_rent":
        return "Rent Bike";
      case "luggage":
        return "Luggage Store";
      case "parking":
        return "Find Parking";
      default:
        return key.replaceAll("_", " "); // Fallback formatting
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      shouldCloseOnMinExtent: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
          ),
          child: Column(
            children: [
              UIHelper.verticalSpace(8.h),
              Container(
                width: 60.w,
                height: 4.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: const Color(0xFFE9E9E9),
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Text(
                "All Categories",
                style: TextStyle(
                  color: const Color(0xFF001937),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro',
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Expanded(
                child: StreamBuilder(
                  stream: postMapDataRxOBJ.fileData,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!asyncSnapshot.hasError &&
                        asyncSnapshot.data != null) {
                      MapDataRes? mapDataRes = MapDataRes.fromJson(
                        asyncSnapshot.data,
                      );

                      final groupedData =
                          groupDataByCategory(mapDataRes.data ?? []);

                      if (groupedData.isEmpty) {
                        return Center(child: Text("No data found"));
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: groupedData.length,
                        padding: EdgeInsets.only(bottom: 20.h),
                        itemBuilder: (_, index) {
                          String key = groupedData.keys.elementAt(index);
                          List<MapDataModel> items = groupedData[key]!;
                          String title = _getCategoryTitle(key);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: const Color(0xFF001937),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SF Pro',
                                  ),
                                ),
                              ),
                              ...items.map((data) => _buildItemCard(data)),
                              UIHelper.verticalSpace(8.h),
                            ],
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Error: ${asyncSnapshot.error ?? "Unknown error"}',
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemCard(MapDataModel data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: const Color(0x7FE9E9E9),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title ?? '',
                        style: TextStyle(
                          color: const Color(0xFF202020),
                          fontSize: 14.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      UIHelper.verticalSpace(4.h),
                      Text(
                        data.location ?? '',
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${data.price ?? ''} CHF',
                            maxLines: 1,
                            style: TextStyle(
                              color: const Color(0xFF001937),
                              fontSize: 14.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      UIHelper.verticalSpace(4.h),
                      Text(
                        'Per Day',
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
            UIHelper.verticalSpace(8.h),
            Row(
              children: [
                SvgPicture.asset(Assets.icons.star),
                UIHelper.horizontalSpace(8.w),
                Text(
                  data.averageRating?.toString() ?? '0',
                  style: TextStyle(
                    color: const Color(0xFFDF7720),
                    fontSize: 12.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                UIHelper.horizontalSpace(4.w),
                Text(
                  '(${data.totalReviews ?? '0'})',
                  style: TextStyle(
                    color: const Color(0xFF4D4D4D),
                    fontSize: 12.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            UIHelper.verticalSpace(16.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "View Details",
                    textColor: const Color(0xFF001937),
                    bgColor: AppColors.cFFFFFF,
                    borderColor: const Color(0xFFE9E9E9),
                    onTap: () {
                      NavigationService.navigateToWithObject(
                        Routes.itemDetails,
                        data.id,
                      );
                    },
                  ),
                ),
                UIHelper.horizontalSpace(16.w),
                Expanded(
                  child: CustomButton(
                    text: "Book Now",
                    onTap: () {
                      NavigationService.navigateToWithObject(
                        Routes.bookingForm,
                        data.id,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
