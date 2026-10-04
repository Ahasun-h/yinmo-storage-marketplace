import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../common_widgets/custom_toast.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class PostListingAddRx extends RxResponseInt {
  final api = PostListingAddApi.instance;

  String message = "Something went wrong";

  PostListingAddRx({required super.empty, required super.dataFetcher});

  ValueStream get fileData => dataFetcher.stream;

  Future<bool> postData({
    String? title,
    String? description,
    String? location,
    String? price,
    double? langitude,
    double? latitude,
    String? listingType,
    List<String>? slotNames,
    List<String>? featureNames,
    List<Map<String, dynamic>>? extraServicePrices,
    List<XFile>? images,
    List<String>? boxNames,
    List<String>? bikeIds,
  }) async {
    try {
      Map<String, dynamic> data = {
        "title": title,
        "description": description,
        "location": location,
        "price": price,
        "langitude": langitude,
        "latitude": latitude,
        "listing_type": listingType,
        if (slotNames != null)
          for (int i = 0; i < slotNames.length; i++)
            "slot_name[$i]": slotNames[i],
        if (featureNames != null)
          for (int i = 0; i < featureNames.length; i++)
            "feature_name[$i]": featureNames[i],
        if (extraServicePrices != null)
          for (int i = 0; i < extraServicePrices.length; i++)
            "service_name[$i]": extraServicePrices[i]["name"],
        if (extraServicePrices != null)
          for (int i = 0; i < extraServicePrices.length; i++)
            "extra_service_price[$i]": extraServicePrices[i]["price"],
        if (images != null)
          for (int i = 0; i < images.length; i++)
            "images[$i]": await MultipartFile.fromFile(
              images[i].path,
              filename: images[i].name,
            ),
        if (boxNames != null)
          for (int i = 0; i < boxNames.length; i++) "box_name[$i]": boxNames[i],
        if (bikeIds != null)
          for (int i = 0; i < bikeIds.length; i++) "bike_id[$i]": bikeIds[i],
      };
      log(data.toString());
      FormData formData = FormData.fromMap(data);
      Map resdata = await api.postData(formData);
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    log(error.toString());
    if (error is DioException) {
      if (error.type == DioExceptionType.badResponse) {
        if (error.response?.statusCode == 401) {
          NavigationService.navigateToUntilReplacement(Routes.login);
        }
      }
      message =
          error.response?.data["message"].toString() ?? "Something went wrong";
      if (error.type == DioExceptionType.connectionError) {
        message = "Check Your Network Connection";
      }
    }
    customToastMessage('Error', message);
    return false;
  }
}
