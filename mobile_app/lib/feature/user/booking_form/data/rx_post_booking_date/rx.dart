import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../common_widgets/custom_toast.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class PostBookingDateRx extends RxResponseInt {
  final api = PostBookingDateApi.instance;

  String message = "Something went wrong";

  PostBookingDateRx({required super.empty, required super.dataFetcher});

  ValueStream get filleData => dataFetcher.stream;

  Future<bool> postBookingDate({int? listingId, int? slotId}) async {
    try {
      Map<String, dynamic> data = {"listing_id": listingId, "slot_id": slotId};
      Map resdata = await api.postBookingDate(data);
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
    if (error.response?.statusCode == 401) {
      Future.delayed(const Duration(milliseconds: 100), () {
        NavigationService.navigateToUntilReplacement(Routes.login);
      });
    }
    if (error is DioException) {
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
