import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../common_widgets/custom_toast.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class PostBookingDownlaodRx extends RxResponseInt {
  final api = PostBookingDownlaodApi.instance;

  String message = "Something went wrong";

  PostBookingDownlaodRx({required super.empty, required super.dataFetcher});

  ValueStream get filleData => dataFetcher.stream;

  Future<dynamic> postBookingDownlaod({
    List? value,
  }) async {
    try {
      Map<String, dynamic> data = {
        for (var i = 0; i < value!.length; i++) "ids[$i]": value[i]
      };

      var resdata = await api.postBookingDownlaod(data);
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    log(error.toString());
    if (error is DioException) {
      message =
          error.response?.data["message"].toString() ?? "Something went wrong";
      if (error.type == DioExceptionType.connectionError) {
        message = "Check Your Network Connection";
      }
    }
    customToastMessage('Error', message);
    return null;
  }
}
