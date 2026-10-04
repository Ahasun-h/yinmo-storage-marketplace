import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../common_widgets/custom_toast.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class GetStripInfoRx extends RxResponseInt {
  final api = GetStripInfoApi.instance;

  String message = "Something went wrong";

  GetStripInfoRx({required super.empty, required super.dataFetcher});

  ValueStream get fileData => dataFetcher.stream;

  Future<bool> getData() async {
    try {
      Map resdata = await api.getData();
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    appData.write(kKeyStatus, "approved");
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    log(error.toString());
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        Future.delayed(const Duration(milliseconds: 100), () {
          NavigationService.navigateToUntilReplacement(Routes.login);
        });
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
