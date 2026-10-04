import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../common_widgets/custom_toast.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../helpers/di.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class PostSwitchAccountRx extends RxResponseInt {
  final api = PostSwitchAccountApi.instance;

  String message = "Something went wrong";

  PostSwitchAccountRx({required super.empty, required super.dataFetcher});

  ValueStream get filleData => dataFetcher.stream;

  Future<bool> postSwitchAccount({String? value}) async {
    try {
      Map<String, dynamic> data = {"role": value};

      Map resdata = await api.postSwitchAccountApi(data);
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    // this api has some issue need to fix later . issue from backend
    if (data['data'] is Map && data['data'].containsKey('status')) {
      appData.write(kKeyStatus, data['data']["status"]);
    }
    appData.write(kKeyAccessToken, data["data"]["token"]);
    appData.write(
      kKeyUserType,
      data["data"]["account_info"]["last_login_role"],
    );
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
