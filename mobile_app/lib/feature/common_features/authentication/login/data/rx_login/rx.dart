import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/feature/common_features/authentication/login/data/rx_login/api.dart';
import 'package:urban_koala/feature/common_features/authentication/login/model/login_response_model.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/networks/dio/dio.dart';
import 'package:urban_koala/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';

final class LogInRX extends RxResponseInt<LoginResponseModel> {
  final api = LogInApi.instance;

  LogInRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> logInRX({
    required String email,
    required String password,
  }) async {
    try {
      LoginResponseModel data = await api.logInApi(
        email: email,
        password: password,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      handleErrorWithReturn(error);
      return false;
    }
  }

  @override
  handleSuccessWithReturn(LoginResponseModel data) {
    appData.write(kKeyAccessToken, data.data?.token);
    appData.write(kKeyUserID, data.data?.user?.id);
    appData.write(kKeyStatus, data.data?.user?.status);
    appData.write(kKeyUserType, data.data?.user?.lastLoginRole);
    appData.write(kKeyName, data.data?.user?.name);
    appData.write(kKeyEmail, data.data?.user?.email);
    appData.write(kKeyIsLoggedIn, true);
    String token = appData.read(kKeyAccessToken);
    DioSingleton.instance.update(token);
    dataFetcher.sink.add(data);
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 422) {
        ToastUtil.showShortToast(error.response?.data["message"] ?? "Error");
      } else {
        ToastUtil.showShortToast(error.response?.data["message"] ?? "Error");
      }
    } else {
      ToastUtil.showShortToast("An unexpected error occurred.");
    }
    log(error.toString());
    dataFetcher.sink.addError(error);
  }
}
