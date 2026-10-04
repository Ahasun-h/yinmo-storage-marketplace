import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import '../../../../../../common_widgets/custom_toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../model/faq_model.dart';
import 'api.dart';

final class GetFaqRx extends RxResponseInt<FaqRes> {
  // Renamed from GetFaqResRx
  final api = GetFaqApi.instance;

  String message = "Something went wrong";

  GetFaqRx({required super.empty, required super.dataFetcher});

  ValueStream<FaqRes> get faqList => dataFetcher.stream;

  Future<bool> get() async {
    try {
      Map resdata = await api.get();
      FaqRes data = FaqRes.fromJson(Map<String, dynamic>.from(resdata));
      handleSuccessWithReturn(data);
      return true;
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
      if (error.response?.statusCode == 401) {
        NavigationService.navigateTo(Routes.login);
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
