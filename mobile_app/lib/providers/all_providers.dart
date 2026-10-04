import 'package:flutter/material.dart';
import 'package:urban_koala/feature/host/listing_details/model/listing_details_model.dart';

import '../gen/assets.gen.dart';

final class AllProviders extends ChangeNotifier {
  ////////// OTP verify ///////////
  String otp = "otp";
  ////////// Home Screen ///////////
  int selectedIndex = 0;
  void setSelectedTabIndex({required index}) {
    selectedIndex = index;
    notifyListeners();
  }

  ////////------------------>>>>>>>>OnBoarding Screen
  int _roleIndex = 0;
  int get roleIndex => _roleIndex;
  String role = "user";
  void roleTabIndex({required index}) {
    _roleIndex = index;
    if (index == 0) {
      role = "user";
      notifyListeners();
    } else {
      role = "service_provider";
      notifyListeners();
    }
    notifyListeners();
  }
  ////////------------------>>>>>>>>Add Listing Screen

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController slotController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController featuresController = TextEditingController();
  List<String> slotList = [];
  final FocusNode slotFocusNode = FocusNode();
  List<String> features = [];
  final FocusNode featuresFocusNode = FocusNode();

  List<Map<String, TextEditingController>> extraServices = [];
  void addExtraService(context) {
    if (extraServices.isNotEmpty) {
      final last = extraServices.last;
      if (last["name"]!.text.trim().isEmpty ||
          last["price"]!.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill previous service first")),
        );
        return;
      }
    }
    extraServices.add({
      "name": TextEditingController(),
      "price": TextEditingController(),
    });
    notifyListeners();
  }

  List<Map<String, String>> get serviceData => extraServices
      .where(
        (item) =>
            item["name"]!.text.trim().isNotEmpty &&
            item["price"]!.text.trim().isNotEmpty,
      )
      .map(
        (item) => {
          "name": item["name"]!.text.trim(),
          "price": item["price"]!.text.trim(),
        },
      )
      .toList();
  onSubmitSlot(context, value) {
    if (value.trim().isNotEmpty) {
      slotList.add(value.trim());
      slotController.clear();
      FocusScope.of(context).requestFocus(slotFocusNode);
      notifyListeners();
    }
  }

  void removeSlot(int index) {
    if (index >= 0 && index < slotList.length) {
      slotList.removeAt(index);
      notifyListeners();
    }
  }

  onSubmitFeatures(context, value) {
    if (value.trim().isNotEmpty) {
      features.add(value.trim());
      featuresController.clear();
      FocusScope.of(context).requestFocus(featuresFocusNode);
    }
    notifyListeners();
  }

  void removeFeature(int index) {
    if (index >= 0 && index < features.length) {
      features.removeAt(index);
      notifyListeners();
    }
  }

  int _selectListingType = 0;
  int get selectListingType => _selectListingType;
  void setSelectListingType(int index) {
    _selectListingType = index;
    notifyListeners();
  }

  ListingDetails? _listingDetails;
  ListingDetails? get listingDetails => _listingDetails;
  void setListingDetails(ListingDetails? details) {
    _listingDetails = details;
    notifyListeners();
  }

  double? _lat;
  double? _long;
  double? get lat => _lat;
  double? get long => _long;
  void setLatLong(double? latitude, double? longitude) {
    _lat = latitude;
    _long = longitude;
    notifyListeners();
  }

  //------------------>>>>>>>>map screen, select map info type like bike, luggage, parking
  int selectedInfoTypeIndex = -1;
  void setInfoType(int type) {
    selectedInfoTypeIndex = type;
    notifyListeners();
  }

  final List<Map<String, dynamic>> buttonData = [
    {'icon': Assets.icons.car, 'text': 'Find Parking'},
    {'icon': Assets.icons.bike, 'text': 'Rent Bike'},
    {'icon': Assets.icons.lugaje, 'text': 'Luggage Store'},
  ];
  get selectedInfoType {
    if (selectedInfoTypeIndex >= 0 &&
        selectedInfoTypeIndex < buttonData.length) {
      return buttonData[selectedInfoTypeIndex]['text'];
    }
    return null;
  }

  void clearListingData() {
    titleController.clear();
    descriptionController.clear();
    slotController.clear();
    addressController.clear();
    priceController.clear();
    featuresController.clear();
    slotList.clear();
    features.clear();
    extraServices.clear();
    serviceData.clear();
    _selectListingType = 0;
    _lat = null;
    _long = null;
    notifyListeners();
  }
}
