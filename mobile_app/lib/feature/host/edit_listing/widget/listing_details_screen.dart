import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urban_koala/common_widgets/address_autocomplete_field.dart';
import 'package:urban_koala/common_widgets/platform_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/location_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:provider/provider.dart';
import '../../../../providers/all_providers.dart';

class ListingDetailsWidget extends StatefulWidget {
  const ListingDetailsWidget({super.key});

  @override
  State<ListingDetailsWidget> createState() => _ListingDetailsWidgetState();
}

class _ListingDetailsWidgetState extends State<ListingDetailsWidget> {
  PlatformMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllProviders>(context);
    String listingTypeText;
    String hintText;
    switch (provider.selectListingType) {
      case 0:
        listingTypeText = "Slot";
        hintText = "e.g. parking field nr 14";
        break;
      case 1:
        listingTypeText = "Bike Id";
        hintText = "Add Bike Id";
        break;
      case 2:
        listingTypeText = "Add Box/Store";
        hintText = "Add Box/Store Name";
        break;
      default:
        listingTypeText = "";
        hintText = "";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Input Listing Details',
          style: TextStyle(
            color: const Color(0xFF202020),
            fontSize: 14.sp,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
            height: 1.43,
          ),
        ),
        UIHelper.verticalSpace(8.h),
        Container(
          padding: EdgeInsets.all(16.sp),
          decoration: ShapeDecoration(
            color: const Color(0x7FE9E9E9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
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
                controller: provider.titleController,
                isPrefixIcon: false,
                hintText: "Enter a title",
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              UIHelper.verticalSpace(8.h),
              Text(
                'Description',
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
                controller: provider.descriptionController,
                isPrefixIcon: false,
                hintText: "Enter a Description",
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              UIHelper.verticalSpace(8.h),
              Text(
                listingTypeText,
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
                controller: provider.slotController,
                isPrefixIcon: false,
                hintText: hintText,
                keyboardType: TextInputType.text,
                focusNode: provider.slotFocusNode,
                onFieldSubmitted: (value) =>
                    provider.onSubmitSlot(context, value),
                suffixIcon: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    provider.onSubmitSlot(
                        context, provider.slotController.text);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: const Color(0xFF109590),
                            fontSize: 14.sp,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              UIHelper.verticalSpace(8.h),
              if (provider.slotList.isNotEmpty)
                SizedBox(
                  height: 30.h,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    itemCount: provider.slotList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                provider.slotList[index],
                                style: TextStyle(
                                  color: const Color(0xFF101010),
                                  fontSize: 10.sp,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              UIHelper.horizontalSpace(8.w),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  provider.removeSlot(index);
                                },
                                child: SvgPicture.asset(
                                  Assets.icons.closewithCircleBorder,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              UIHelper.verticalSpace(8.h),
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
              AddressAutocompleteField(
                controller: provider.addressController,
                hintText: "Enter an address",
                biasLatitude: provider.lat,
                biasLongitude: provider.long,
                onAddressSelected: (address, latLng) async {
                  if (latLng == null) return;
                  provider.setLatLong(latLng.latitude, latLng.longitude);
                  if (mapController != null) {
                    await mapController!.animateCamera(
                      PlatformCameraUpdate.newLatLngZoom(
                        latLng,
                        14,
                      ),
                    );
                  }
                },
              ),
              UIHelper.verticalSpace(8.h),
              Text(
                'Select your map location',
                style: TextStyle(
                  color: const Color(0x99101010),
                  fontSize: 12.sp,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              UIHelper.verticalSpace(4.h),
              // map container
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  height: 200.h,
                  child: PlatformMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    gestureRecognizers: {
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        provider.lat ?? 0.0,
                        provider.long ?? 0.0,
                      ),
                      zoom: 10,
                    ),
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    markers: {
                      PlatformMarker(
                        markerId: const MarkerId("selected-location"),
                        position: LatLng(
                          provider.lat ?? 0.0,
                          provider.long ?? 0.0,
                        ),
                        icon: PlatformBitmapDescriptor.defaultMarker(),
                      ),
                    },
                    onTap: (argument) async {
                      provider.setLatLong(
                          argument.latitude, argument.longitude);
                      var address = await letLonToAddress(
                          argument.latitude, argument.longitude);
                      if (address != null) {
                        provider.addressController.text = address;
                      }
                    },
                  ),
                ),
              ),
              UIHelper.verticalSpace(8.h),
              Text(
                'Price',
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
                controller: provider.priceController,
                isPrefixIcon: true,
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CHF',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF101010),
                        fontSize: 12.sp,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        'Per Day',
                        style: TextStyle(
                          color: const Color(0xFF101010),
                          fontSize: 12.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                hintText: "Enter a price",
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              UIHelper.verticalSpace(8.h),
              Text(
                'Features',
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
                controller: provider.featuresController,
                isPrefixIcon: false,
                hintText: "Add Features",
                keyboardType: TextInputType.text,
                focusNode: provider.featuresFocusNode,
                onFieldSubmitted: (value) =>
                    provider.onSubmitFeatures(context, value),
                suffixIcon: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    provider.onSubmitFeatures(
                        context, provider.featuresController.text);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: const Color(0xFF109590),
                            fontSize: 14.sp,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              UIHelper.verticalSpace(8.h),
              if (provider.features.isNotEmpty)
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: List.generate(provider.features.length, (index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            provider.features[index],
                            style: TextStyle(
                              color: const Color(0xFF101010),
                              fontSize: 10.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          UIHelper.horizontalSpace(8.w),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              provider.removeFeature(index);
                            },
                            child: SvgPicture.asset(
                              Assets.icons.closewithCircleBorder,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              UIHelper.verticalSpace(8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Extra Services',
                    style: TextStyle(
                      color: const Color(0x99101010),
                      fontSize: 12.sp,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => provider.addExtraService(context),
                    child: Row(
                      children: [
                        SvgPicture.asset(Assets.icons.addPrimaryColor),
                        UIHelper.horizontalSpace(8.w),
                        Text(
                          'Add',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFF109590),
                            fontSize: 16,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(8.h),
              // Dynamically render added fields
              ...provider.extraServices.map((service) {
                final nameController = service["name"]!;
                final priceController = service["price"]!;

                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CommonTextFormField(
                          controller: nameController,
                          isPrefixIcon: false,
                          hintText: "Name",
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      UIHelper.horizontalSpace(8.w),
                      Expanded(
                        flex: 2,
                        child: CommonTextFormField(
                          controller: priceController,
                          isPrefixIcon: false,
                          hintText: "Price",
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CHF',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF101010),
                                  fontSize: 12.sp,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
