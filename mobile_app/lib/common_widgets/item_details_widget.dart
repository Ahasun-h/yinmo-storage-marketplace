import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urban_koala/common_widgets/platform_map.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/feature/host/listing_details/model/listing_details_model.dart';
import 'package:urban_koala/feature/host/listing_details/model/review_rating_model.dart';
import 'package:urban_koala/feature/host/listing_details/widget/review_bar_row.dart';
import 'package:urban_koala/feature/user/home/widget/custom_marker.dart';
import 'package:urban_koala/feature/user/home/widget/custom_view_all.dart';
import 'package:urban_koala/feature/user/item_details/widget/featurs_view.dart';
import 'package:urban_koala/feature/user/item_details/widget/item_info_container.dart';
import 'package:urban_koala/feature/user/item_details/widget/reviews_view.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/helpers/location_service.dart';
import 'package:urban_koala/helpers/time_converter.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';
import 'package:rxdart/rxdart.dart';

class ItemDetailsWidget extends StatefulWidget {
  final int? itemId;
  const ItemDetailsWidget({super.key, required this.itemId});

  @override
  State<ItemDetailsWidget> createState() => _ItemDetailsWidgetState();
}

class _ItemDetailsWidgetState extends State<ItemDetailsWidget>
    with WidgetsBindingObserver {
// List<Review>? reviews = []; Remove this line as we will use local variable
  List<String> starLabels = [
    "5 stars",
    "4 stars",
    "3 stars",
    "2 stars",
    "1 stars",
  ];

  final List<Map<String, dynamic>> starButtonData = [
    {'icon': Assets.icons.starMini, 'text': 'All'},
    {'icon': Assets.icons.starMini, 'text': '5'},
    {'icon': Assets.icons.starMini, 'text': '4'},
    {'icon': Assets.icons.starMini, 'text': '3'},
    {'icon': Assets.icons.starMini, 'text': '2'},
    {'icon': Assets.icons.starMini, 'text': '1'},
  ];
  int selectedIndex = 0;
  final Map<int, PlatformBitmapDescriptor> _defaultIconsCache = {};
  Set<PlatformMarker> markers = {};
  Stream<List<dynamic>>? _stream;
  ValueNotifier<String?> distanceNotifier = ValueNotifier<String?>(null);
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.resumed) {
      if (LocationService.instance.isLocationPermissionGranted ||
          distanceNotifier.value == null ||
          distanceNotifier.value!.isEmpty) {
        getDistanceRxOBJ
            .getDistanceData(
                lat: appData.read(kKeySelectedLat),
                lon: appData.read(kKeySelectedLng),
                listingId: widget.itemId)
            .then((value) {
          if (value) {
            getDistanceRxOBJ.fileData.listen((event) {
              distanceNotifier.value = event["data"]["durationText"];
            });
          }
        });
      } else {
        distanceNotifier.value = "";
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (LocationService.instance.isLocationPermissionGranted) {
      getDistanceRxOBJ
          .getDistanceData(
              lat: appData.read(kKeySelectedLat),
              lon: appData.read(kKeySelectedLng),
              listingId: widget.itemId)
          .then((value) {
        if (value) {
          getDistanceRxOBJ.fileData.listen((event) {
            distanceNotifier.value = event["data"]["durationText"] ??
                "We could not calculate the walking distance";
          });
        }
      });
    } else {
      distanceNotifier.value = "";
    }

    _stream = Rx.combineLatest2(
      getItemDetailsRxOBJ.fileData,
      postItemReviewRetingGetRxOBJ.fileData,
      (a, b) => [a, b],
    );
  }

  Future<void> _createMarkers(ListingDetails data) async {
    if (!mounted) return;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final markerId = data.id ?? 0;

    if (markers.any((element) => element.markerId.value == '$markerId')) {
      return;
    }

    PlatformBitmapDescriptor icon;

    if (_defaultIconsCache.containsKey(markerId)) {
      icon = _defaultIconsCache[markerId]!;
    } else {
      final bytes = await widgetToBytes(CustomMarker(
        type: data.listingType,
        rating: data.avgRating ?? "0.0",
      ));
      icon = PlatformBitmapDescriptor.fromBytes(
        bytes,
        imagePixelRatio: pixelRatio,
      );

      _defaultIconsCache[markerId] = icon;
    }

    markers.add(
      PlatformMarker(
        markerId: MarkerId('$markerId'),
        position: LatLng(data.latitude ?? 0, data.longitude ?? 0),
        icon: icon,
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _stream ??= Rx.combineLatest2(
      getItemDetailsRxOBJ.fileData,
      postItemReviewRetingGetRxOBJ.fileData,
      (a, b) => [a, b],
    );
    return StreamBuilder(
      stream: _stream,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!asyncSnapshot.hasError && asyncSnapshot.data != null) {
          ListingDetailsRes? listingDetailsRes = ListingDetailsRes.fromJson(
            asyncSnapshot.data?[0],
          );
          ReviewRatingRes? reviewRatingRes = ReviewRatingRes.fromJson(
            asyncSnapshot.data?[1],
          );
          // Initial Load/Data Stream Update: Load markers asynchronously.
          if (listingDetailsRes.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _createMarkers(listingDetailsRes.data!);
              _createMarkers(listingDetailsRes.data!);
              // reviews = reviewRatingRes.data?.reviews ?? []; // Remove this line
            });
          }

          List<Review> filteredReviews = [];
          if (reviewRatingRes.data?.reviews != null) {
            if (selectedIndex == 0) {
              filteredReviews = reviewRatingRes.data!.reviews!;
            } else {
              int targetRating = 6 - selectedIndex;
              filteredReviews = reviewRatingRes.data!.reviews!.where((element) {
                return (double.tryParse("${element.rating}") ?? 0).round() ==
                    targetRating;
              }).toList();
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(title: 'Listing Details', backButton: true),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ItemInfoContainer(
                        image:
                            "${listingDetailsRes.data?.photos != null && listingDetailsRes.data!.photos!.isNotEmpty ? listingDetailsRes.data!.photos![0].image : ""}",
                        name: listingDetailsRes.data?.title ?? "",
                        price: '${listingDetailsRes.data?.price ?? 0} CHF',
                        location: listingDetailsRes.data?.location ?? "",
                        rating: double.tryParse(
                                    "${listingDetailsRes.data?.avgRating ?? 0}")
                                ?.toStringAsFixed(1) ??
                            "0.0",
                        ratingCount:
                            '(${listingDetailsRes.data?.uniqueUserCount ?? 0})',
                        featurs: Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: SizedBox(
                            height: 35.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  listingDetailsRes.data?.features?.length ?? 0,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: FeatursView(
                                    title: listingDetailsRes.data
                                            ?.features?[index].featureName ??
                                        "",
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      UIHelper.verticalSpace(20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About this space',
                              style: TextStyle(
                                color: const Color(0xFF202020),
                                fontSize: 16.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                                height: 1.50.h,
                              ),
                            ),
                            UIHelper.verticalSpace(8.h),
                            Text(
                              listingDetailsRes.data?.description ?? "",
                              style: TextStyle(
                                color: const Color(0xFF4D4D4D),
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 1.33.h,
                              ),
                            ),
                            UIHelper.verticalSpace(16.h),
                            CustomViewAll(
                              title: 'Location',
                              onTap: () {
                                // NavigationService.navigateTo(Routes.allItem);
                              },
                            ),
                            UIHelper.verticalSpace(12.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: SizedBox(
                                height: 200.h,
                                child: PlatformMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      listingDetailsRes.data?.latitude ?? 0.0,
                                      listingDetailsRes.data?.longitude ?? 0.0,
                                    ),
                                    zoom: 10,
                                  ),

                                  zoomControlsEnabled: false,
                                  mapType: MapType.normal,
                                  myLocationButtonEnabled: false,
                                  // Use the markers from the ValueNotifier
                                  markers: markers,
                                ),
                              ),
                            ),
                            UIHelper.verticalSpace(12.h),
                            ValueListenableBuilder(
                                valueListenable: distanceNotifier,
                                builder: (context, value, child) {
                                  if (distanceNotifier.value == null) {
                                    return RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: const Color(0xFF4D4D4D),
                                          fontSize: 12.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          height: 1.33.h,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Please ',
                                          ),
                                          TextSpan(
                                            text: 'Turn on ',
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 4, 148, 148),
                                              fontSize: 12.sp,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              height: 1.33.h,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Geolocator
                                                    .openLocationSettings();
                                              },
                                          ),
                                          TextSpan(
                                            text:
                                                'your location to see how long it will take to get there',
                                            style: TextStyle(
                                              color: const Color(0xFF4D4D4D),
                                              fontSize: 12.sp,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              height: 1.33.h,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Text(
                                    '${distanceNotifier.value} walk to ${listingDetailsRes.data?.location ?? ""}',
                                    style: TextStyle(
                                      color: const Color(0xFF4D4D4D),
                                      fontSize: 12.sp,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.33.h,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      UIHelper.verticalSpace(20.h),
                      Container(
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reviews',
                              style: TextStyle(
                                color: const Color(0xFF202020),
                                fontSize: 16.sp,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                                height: 1.50.h,
                              ),
                            ),
                            UIHelper.verticalSpace(8.h),
                            UIHelper.customDivider(
                              color: const Color(0xFFE9E9E9),
                              height: 1.h,
                            ),
                            UIHelper.verticalSpace(8.h),
                            Center(
                              child: Text(
                                double.tryParse(
                                            "${listingDetailsRes.data?.avgRating ?? 0}")
                                        ?.toStringAsFixed(1) ??
                                    "0.0",
                                style: TextStyle(
                                  color: const Color(0xFF202020),
                                  fontSize: 24.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50.h,
                                ),
                              ),
                            ),
                            UIHelper.verticalSpace(4.h),
                            Center(
                              child: RatingBarIndicator(
                                unratedColor: Colors.grey,
                                itemSize: 18.w,
                                rating: double.parse(
                                  "${listingDetailsRes.data?.avgRating ?? 0}",
                                ),
                                direction: Axis.horizontal,
                                itemPadding: EdgeInsets.only(right: 5.w),
                                itemBuilder: (context, _) =>
                                    SvgPicture.asset(Assets.icons.star),
                              ),
                            ),
                            UIHelper.verticalSpace(12.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Builder(builder: (context) {
                                int fiveStar =
                                    reviewRatingRes.data?.fiveStar ?? 0;
                                int fourStar =
                                    reviewRatingRes.data?.fourStar ?? 0;
                                int threeStar =
                                    reviewRatingRes.data?.threeStar ?? 0;
                                int twoStar =
                                    reviewRatingRes.data?.twoStar ?? 0;
                                int oneStar =
                                    reviewRatingRes.data?.oneStar ?? 0;

                                int totalReviews = fiveStar +
                                    fourStar +
                                    threeStar +
                                    twoStar +
                                    oneStar;

                                return Column(
                                  children: [
                                    reviewBarRow(
                                      title: starLabels[0],
                                      percentage: totalReviews > 0
                                          ? fiveStar / totalReviews
                                          : 0.0,
                                      count: fiveStar,
                                    ),
                                    reviewBarRow(
                                      title: starLabels[1],
                                      percentage: totalReviews > 0
                                          ? fourStar / totalReviews
                                          : 0.0,
                                      count: fourStar,
                                    ),
                                    reviewBarRow(
                                      title: starLabels[2],
                                      percentage: totalReviews > 0
                                          ? threeStar / totalReviews
                                          : 0.0,
                                      count: threeStar,
                                    ),
                                    reviewBarRow(
                                      title: starLabels[3],
                                      percentage: totalReviews > 0
                                          ? twoStar / totalReviews
                                          : 0.0,
                                      count: twoStar,
                                    ),
                                    reviewBarRow(
                                      title: starLabels[4],
                                      percentage: totalReviews > 0
                                          ? oneStar / totalReviews
                                          : 0.0,
                                      count: oneStar,
                                    ),
                                  ],
                                );
                              }),
                            ),
                            UIHelper.verticalSpace(16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(starButtonData.length, (
                                index,
                              ) {
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: selectedIndex == index
                                              ? AppColors.primaryColor
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1.w,
                                              color: const Color(0xFFE9E9E9),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              starButtonData[index]["text"] ??
                                                  "N/A",
                                              style: TextStyle(
                                                color: selectedIndex == index
                                                    ? AppColors.cFFFFFF
                                                    : const Color(0xFF001937),
                                                fontSize: 12.sp,
                                                fontFamily: 'SF Pro',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            UIHelper.horizontalSpace(4.w),
                                            SvgPicture.asset(
                                              starButtonData[index]["icon"],
                                              colorFilter: ColorFilter.mode(
                                                selectedIndex == index
                                                    ? AppColors.cFFFFFF
                                                    : Color(0xffDF7720),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (index < starButtonData.length - 1)
                                      UIHelper.horizontalSpace(8.w),
                                  ],
                                );
                              }),
                            ),
                            UIHelper.verticalSpace(16.h),
                            ListView.builder(
                              itemCount: filteredReviews.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (_, index) {
                                Review? review = filteredReviews[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: ReviewsView(
                                    image: review.user?.profileImage ?? "",
                                    name: review.user?.name ?? '',
                                    rating: review.rating ?? 0,
                                    time: TimeConverter.timeAgo(review.createdAt
                                            ?.toIso8601String()) ??
                                        "",
                                    message: review.comment ?? "",
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(child: Text('Error loading data'));
        }
      },
    );
  }
}
