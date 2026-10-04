import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:urban_koala/common_widgets/custom_toast.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/networks/rx_base.dart';
import 'api.dart';

final class PostFcmTokenRx extends RxResponseInt {
  final api = PostFcmTokenApi.instance;

  String message = "Something went wrong";

  PostFcmTokenRx({required super.empty, required super.dataFetcher});

  ValueStream get filleData => dataFetcher.stream;

  Future<bool> postFcmToken() async {
    try {
      Map<String, dynamic> data = {
        "fcm_token": appData.read(kKeyFCMToken),
      };

      Map resdata = await api.postFcmToken(data);
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
