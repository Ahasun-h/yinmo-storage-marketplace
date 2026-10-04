import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../common_widgets/custom_toast.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class PostBasicInformationRx extends RxResponseInt {
  final api = PostBasicInformationApi.instance;

  String message = "Something went wrong";

  PostBasicInformationRx({required super.empty, required super.dataFetcher});

  ValueStream get fileData => dataFetcher.stream;

  Future<bool> post({
    String? phone,
    String? address,
    String? accountHolder,
  }) async {
    try {
      Map<String, dynamic> data = {
        "phone": phone,
        "address": address,
        "Account_holder": accountHolder,
      };

      Map resdata = await api.postData(data);
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    appData.write(kKeyOnboardingUrl, data["data"]["onboarding_url"]);
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
