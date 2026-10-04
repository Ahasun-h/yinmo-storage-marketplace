// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/feature/common_features/authentication/signup/data/rx_signup/api.dart';
import 'package:urban_koala/feature/common_features/authentication/signup/model/signup_model.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/networks/dio/dio.dart';
import 'package:urban_koala/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';

final class SignupRX extends RxResponseInt<SignUpResponseModel> {
  final api = SignupApi.instance;

  SignupRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> signupRX({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    try {
      SignUpResponseModel data = await api.signupApi(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      handleErrorWithReturn(error);
      return false;
    }
  }

  @override
  handleSuccessWithReturn(SignUpResponseModel data) {
    appData.write(kKeyAccessToken, data.data?.token);
    appData.write(kKeyUserID, data.data?.user?.id);
    appData.write(kKeyIsLoggedIn, true);
    appData.write(kKeyUserType, data.data?.user?.lastLoginRole);
    appData.write(kKeyName, data.data?.user?.name);
    appData.write(kKeyEmail, data.data?.user?.email);
    String token = appData.read(kKeyAccessToken);
    DioSingleton.instance.update(token);
    dataFetcher.sink.add(data);
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      if (error.response!.statusCode == 400) {
        ToastUtil.showShortToast(error.response!.data["error"]);
      } else {
        ToastUtil.showShortToast(error.response!.data["message"]);
      }
    }
    log(error.toString());
    dataFetcher.sink.addError(error);
    return false;
  }
}
