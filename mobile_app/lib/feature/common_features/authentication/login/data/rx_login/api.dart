// ignore_for_file: unused_import

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:urban_koala/feature/common_features/authentication/login/model/login_response_model.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/networks/dio/dio.dart';
import 'package:urban_koala/networks/endpoints.dart';
import 'package:urban_koala/networks/exception_handler/data_source.dart';

final class LogInApi {
  static final LogInApi _singleton = LogInApi._internal();
  LogInApi._internal();
  static LogInApi get instance => _singleton;

  Future<LoginResponseModel> logInApi({
    required String email,
    required String password,
  }) async {
    try {
      Map data = {"email": email, "password": password};

      Response response = await postHttp(Endpoints.logIn(), data);

      if (response.statusCode == 200) {
        final data = LoginResponseModel.fromJson((response.data));
        ToastUtil.showShortToast("Sign In Successfull");
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
