import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/common_widgets/custom_toast.dart';
import 'package:urban_koala/feature/host/listing_details/model/listing_details_model.dart';
import 'package:urban_koala/feature/user/item_details/widget/book_now_button.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/loading_helper.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:provider/provider.dart';
import '../widget/listing_details_screen.dart';
import '../../../../networks/api_access.dart';
import '../../../../providers/all_providers.dart';

class EditListingScreen extends StatefulWidget {
  final int listingId;
  const EditListingScreen({super.key, required this.listingId});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  //........... multi image picker start
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];

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

  @override
  void initState() {
    getListingDetailsRxOBJ.get(widget.listingId).then((value) {
      if (!mounted) return;
      if (value) {
        ListingDetailsRes data = ListingDetailsRes.fromJson(
          getListingDetailsRxOBJ.fileData.value,
        );
        final provider = Provider.of<AllProviders>(context, listen: false);
        provider.titleController.text = data.data?.title ?? '';
        provider.descriptionController.text = data.data?.description ?? '';
        provider.addressController.text = data.data?.location ?? '';
        provider.priceController.text = data.data?.price.toString() ?? '';
        provider.setSelectListingType(data.data?.listingType == "parking"
            ? 0
            : data.data?.listingType == "bike_rent"
                ? 1
                : 2);
        provider.features =
            data.data?.features?.map((e) => e.featureName ?? '').toList() ?? [];
        if (data.data?.listingType == "parking") {
          provider.slotList =
              data.data?.slot?.map((e) => e.slotName ?? '').toList() ?? [];
        } else if (data.data?.listingType == "bike_rent") {
          provider.slotList =
              data.data?.bikeIds?.map((e) => e.bikeId ?? '').toList() ?? [];
        } else {
          provider.slotList =
              data.data?.boxes?.map((e) => e.boxName ?? '').toList() ?? [];
        }
        provider.setLatLong(
          data.data?.latitude ?? 0.0,
          data.data?.longitude ?? 0.0,
        );
        provider.setListingDetails(data.data);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllProviders>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: "Edit Listing"),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    UIHelper.verticalSpace(20.h),
                    ListingDetailsWidget(),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BookNowButton(
        onTap: () {
          if (provider.titleController.text.isEmpty ||
              provider.descriptionController.text.isEmpty ||
              provider.addressController.text.isEmpty ||
              provider.priceController.text.isEmpty) {
            customToastMessage("Error", "Please fill all the required fields.");
            return;
          }

          List listingType = ['parking', 'bike_rent', 'luggage'];
          postListingUpdateRxOBJ
              .postData(
                id: widget.listingId,
                listingType: listingType[provider.selectListingType],
                title: provider.titleController.text,
                description: provider.descriptionController.text,
                slotNames:
                    provider.selectListingType == 0 ? provider.slotList : null,
                location: provider.addressController.text,
                price: provider.priceController.text,
                featureNames: provider.features,
                extraServicePrices: provider.serviceData,
                images: _selectedImages,
                boxNames:
                    provider.selectListingType == 2 ? provider.slotList : null,
                bikeIds:
                    provider.selectListingType == 1 ? provider.slotList : null,
                longitude: provider.long,
                latitude: provider.lat,
              )
              .waitingForFutureWithoutBg()
              .then((value) {
            if (value) {
              customToastMessage(
                "Success",
                "Successfully Updated Listing",
              );
              NavigationService.navigateToWithObject(
                Routes.hostNavigation,
                1,
              );
            }
          });
          // Navigator.of(context).pop();
        },
        title: "Update",
      ),
    );
  }
}
