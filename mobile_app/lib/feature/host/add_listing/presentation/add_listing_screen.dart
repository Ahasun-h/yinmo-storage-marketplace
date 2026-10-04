import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/common_widgets/custom_toast.dart';
import 'package:urban_koala/feature/host/add_listing/widget/listing_type.dart';
import 'package:urban_koala/feature/user/item_details/widget/book_now_button.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:provider/provider.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../networks/api_access.dart';
import '../../../../providers/all_providers.dart';
import '../widget/listing_details.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  static const String _hostDisclaimerText =
      "I certify that I am the legal owner of this property, or that I have obtained explicit written permission from the owner to list this space on Urban Koala. I understand that I am solely responsible for compliance with local regulations and land-use laws.";

  //........... multi image picker start
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  bool _hasAcceptedHostDisclaimer = false;

  // Method to pick multiple images
  Future<void> pickImages() async {
    try {
      final List<XFile> pickedImages = await _picker.pickMultiImage();

      setState(() {
        _selectedImages = pickedImages;
      });
    } catch (e) {
      log("Error picking images: $e");
    }
  }

  //........... multi image picker end

  late AllProviders _allProviders;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _allProviders = Provider.of<AllProviders>(context, listen: false);
  }

  @override
  void dispose() {
    _selectedImages.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _allProviders.clearListingData();
    });

    super.dispose();
  }

  Future<void> _showHostDisclaimerDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Host Certification"),
          content: SingleChildScrollView(
            child: Text(
              _hostDisclaimerText,
              style: TextStyle(
                color: const Color(0xFF202020),
                fontSize: 14.sp,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _submitListing(AllProviders provider) {
    if (!_hasAcceptedHostDisclaimer) {
      customToastMessage(
        "Info",
        "Please certify that you are authorized to publish this listing.",
      );
      return;
    }
    if (provider.titleController.text.isEmpty) {
      customToastMessage("Info", "Please enter title.");
      return;
    }
    if (provider.slotList.isEmpty) {
      customToastMessage("Info", "Please add slot.");
      return;
    }
    if (provider.addressController.text.isEmpty) {
      customToastMessage("Info", "Please enter address.");
      return;
    }
    if (provider.descriptionController.text.isEmpty) {
      customToastMessage("Info", "Please enter description.");
      return;
    }
    if (provider.lat == null || provider.long == null) {
      customToastMessage("Info", "Please select valid location.");
      return;
    }
    if (provider.priceController.text.isEmpty) {
      customToastMessage("Info", "Please enter price.");
      return;
    }
    if ((double.tryParse(provider.priceController.text) ?? 0) <= 0) {
      customToastMessage("Info", "Please enter a valid price.");
      return;
    }
    if (_selectedImages.isEmpty) {
      customToastMessage("Info", "Please select at least one image.");
      return;
    }
    List listingType = ['parking', 'bike_rent', 'luggage'];
    postListingAddRxOBJ
        .postData(
          listingType: listingType[provider.selectListingType],
          title: provider.titleController.text,
          description: provider.descriptionController.text,
          slotNames: provider.slotList,
          location: provider.addressController.text,
          price: provider.priceController.text,
          featureNames: provider.features,
          extraServicePrices: provider.serviceData,
          images: _selectedImages,
          boxNames: provider.selectListingType == 2 ? provider.slotList : null,
          bikeIds: provider.selectListingType == 1 ? provider.slotList : null,
          langitude: provider.long,
          latitude: provider.lat,
        )
        .waitingForFutureWithoutBg()
        .then((value) {
      if (value) {
        customToastMessage("Success", "Successfully Added new Listing");
        provider.clearListingData();
        NavigationService.navigateToWithObject(Routes.hostNavigation, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllProviders>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: "Add New Listing"),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIHelper.verticalSpace(20.h),
                    ListingType(),
                    UIHelper.verticalSpace(16.h),
                    ListingDetails(),
                    UIHelper.verticalSpace(16.h),
                    Text(
                      'Upload Photo',
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                      decoration: ShapeDecoration(
                        color: const Color(0x7FE9E9E9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          if (_selectedImages.isNotEmpty)
                            SizedBox(
                              height: 98.h,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: _selectedImages.length,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          child: Image.file(
                                            width: 98.w,
                                            height: 98.h,
                                            File(_selectedImages[index].path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 4.h,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedImages.removeAt(index);
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            Assets.icons.closered,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          UIHelper.verticalSpace(8.h),
                          GestureDetector(
                            onTap: () {
                              pickImages();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 18.h,
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.w,
                                    color: const Color(0xFFE9E9E9),
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SvgPicture.asset(Assets.icons.uploadImage),
                                  UIHelper.verticalSpace(8.h),
                                  Text(
                                    'Tap to upload Image',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF101010),
                                      fontSize: 12.sp,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                      height: 1.67,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpace(16.h),
                    Text(
                      'Trust & Safety',
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
                        color: _hasAcceptedHostDisclaimer
                            ? AppColors.primaryColor.withValues(alpha: 0.08)
                            : const Color(0x7FE9E9E9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            color: _hasAcceptedHostDisclaimer
                                ? AppColors.primaryColor
                                : const Color(0xFFE9E9E9),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 2.h),
                                child: Checkbox(
                                  value: _hasAcceptedHostDisclaimer,
                                  onChanged: (value) {
                                    setState(() {
                                      _hasAcceptedHostDisclaimer =
                                          value ?? false;
                                    });
                                  },
                                  checkColor: AppColors.cFFFFFF,
                                  activeColor: AppColors.primaryColor,
                                  side: BorderSide(
                                    color: AppColors.primaryColor,
                                    width: 1.5.w,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                              UIHelper.horizontalSpace(8.w),
                              Expanded(
                                child: Text(
                                  _hostDisclaimerText,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: const Color(0xFF202020),
                                    fontSize: 13.sp,
                                    fontFamily: 'SF Pro',
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w400,
                                    height: 1.54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(8.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'You must accept this certification before publishing.',
                                  style: TextStyle(
                                    color: const Color(0x99101010),
                                    fontSize: 12.sp,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: _showHostDisclaimerDialog,
                                child: Text(
                                  'View full text',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 12.sp,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpace(16.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: IgnorePointer(
        ignoring: !_hasAcceptedHostDisclaimer,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _hasAcceptedHostDisclaimer ? 1 : 0.55,
          child: BookNowButton(
            onTap: () {
              _submitListing(provider);
            },
            title: "Publish",
          ),
        ),
      ),
    );
  }
}
