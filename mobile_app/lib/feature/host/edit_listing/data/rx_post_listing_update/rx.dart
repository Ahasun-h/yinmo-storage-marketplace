import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../common_widgets/custom_toast.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class PostListingUpdateRx extends RxResponseInt {
  final api = PostListingUpdateApi.instance;

  String message = "Something went wrong";

  PostListingUpdateRx({required super.empty, required super.dataFetcher});

  ValueStream get fileData => dataFetcher.stream;

  Future<bool> postData({
    required int id,
    String? title,
    String? description,
    String? location,
    String? price,
    double? longitude,
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
      FormData formData = FormData();
      formData.fields.add(MapEntry("title", title ?? ""));
      formData.fields.add(MapEntry("description", description ?? ""));
      formData.fields.add(MapEntry("location", location ?? ""));
      formData.fields.add(MapEntry("price", price ?? ""));
      formData.fields.add(MapEntry("langitude", longitude?.toString() ?? ""));
      formData.fields.add(MapEntry("latitude", latitude?.toString() ?? ""));
      formData.fields.add(MapEntry("listing_type", listingType ?? ""));

      if (slotNames != null) {
        for (var item in slotNames) {
          formData.fields.add(MapEntry("slot_name[]", item));
        }
      }
      if (featureNames != null) {
        for (var item in featureNames) {
          formData.fields.add(MapEntry("feature_name[]", item));
        }
      }
      if (extraServicePrices != null) {
        for (var item in extraServicePrices) {
          formData.fields.add(MapEntry("service_name[]", item["name"]));
          formData.fields.add(MapEntry("extra_service_price[]", item["price"]));
        }
      }
      if (boxNames != null) {
        for (var item in boxNames) {
          formData.fields.add(MapEntry("box_name[]", item));
        }
      }
      if (bikeIds != null) {
        for (var item in bikeIds) {
          formData.fields.add(MapEntry("bike_id[]", item));
        }
      }
      if (images != null) {
        for (var item in images) {
          formData.files.add(MapEntry(
            "images[]",
            await MultipartFile.fromFile(item.path, filename: item.name),
          ));
        }
      }
      log(formData.fields.toString());
      Map resdata = await api.postData(formData, id);
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
        NavigationService.navigateToUntilReplacement(Routes.login);
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
