import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:urban_koala/common_widgets/address_autocomplete_field.dart';
import 'package:urban_koala/common_widgets/platform_map.dart';
import 'package:urban_koala/helpers/location_service.dart';
import 'package:urban_koala/providers/all_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class ListingDetails extends StatefulWidget {
  const ListingDetails({super.key});

  @override
  State<ListingDetails> createState() => _ListingDetailsState();
}

class _ListingDetailsState extends State<ListingDetails> {
  PlatformMapController? mapController;
  bool _isLoadingLocation = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLocation();
  }

  Future<void> _checkPermissionAndLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      if (await LocationService.instance
          // ignore: use_build_context_synchronously
          .checkLocationService(context: context)) {
        if (mounted) {
          setState(() {
            _isLoadingLocation = true;
          });
        }
        await _getCurrentLocation();
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 15));

      _currentPosition = position;
    } catch (e) {
      log("Error getting location: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllProviders>(context);
    String listingTypeText;
    String hintText;
    switch (provider.selectListingType) {
      case 0:
        listingTypeText = "Add Slot";
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
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(
                      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'))
                ],
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
                biasLatitude: provider.lat ?? _currentPosition?.latitude,
                biasLongitude: provider.long ?? _currentPosition?.longitude,
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
                'Select your location on map',
                style: TextStyle(
                  color: const Color(0x99101010),
                  fontSize: 12.sp,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              UIHelper.verticalSpace(4.h),
              SizedBox(
                height: 160.h,
                child: _isLoadingLocation
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.withValues(alpha: 0.4),
                        highlightColor: Colors.grey.withValues(alpha: 0.1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      )
                    : ClipRRect(
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
                              target: _currentPosition != null
                                  ? LatLng(_currentPosition!.latitude,
                                      _currentPosition!.longitude)
                                  : LatLng(
                                      provider.lat ?? 46.81,
                                      provider.long ?? 8.22,
                                    ),
                              zoom: 14, // Better zoom for user location
                            ),
                            myLocationEnabled: true,
                            zoomControlsEnabled: true,
                            mapType: MapType.normal,
                            myLocationButtonEnabled: true,
                            markers: {
                              PlatformMarker(
                                markerId: const MarkerId("selected-location"),
                                position: LatLng(
                                  provider.lat ?? 23.44,
                                  provider.long ?? 90.44,
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
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                onChanged: (value) {
                  if (value.contains(',')) {
                    provider.priceController.text = value.replaceAll(',', '.');
                    provider.priceController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                          offset: provider.priceController.text.length),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  final price = double.tryParse(value.replaceAll(',', '.'));
                  if (price != null && price < 0.0) {
                    return 'Price must be at least 0';
                  }

                  return null;
                },
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
