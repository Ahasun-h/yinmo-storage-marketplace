import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../common_widgets/custom_toast.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class GetDistanceRx extends RxResponseInt {
  final api = GetDistanceApi.instance;

  GetDistanceRx({required super.empty, required super.dataFetcher});

  ValueStream get fileData => dataFetcher.stream;

  Future<bool> getDistanceData({
    double? lat,
    double? lon,
    int? listingId,
  }) async {
    try {
      Map data = {
        "latitude": lat ?? 45.33,
        "longitude": lon ?? 45.23,
        "listing_id": listingId,
      };
      Map resData = await api.getDistanceData(data);
      return await handleSuccessWithReturn(resData);
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
    if (error.response?.statusCode == 401) {
      Future.delayed(const Duration(milliseconds: 100), () {
        NavigationService.navigateToUntilReplacement(Routes.login);
      });
    }
    try {
      log(error.toString());
      if (error is DioException) {
        message = error.response?.data["message"] ?? "Something went wrong";
        if (error.type == DioExceptionType.connectionError) {
          message = "Check Your Network Connection";
        }
      }
    } catch (e) {
      log(e.toString());
    }
    customToastMessage('Error', message);
    return false;
  }
}
