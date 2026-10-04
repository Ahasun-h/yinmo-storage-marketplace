// ignore_for_file: unused_import

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:urban_koala/feature/common_features/authentication/signup/model/signup_model.dart';
import 'package:urban_koala/networks/dio/dio.dart';
import 'package:urban_koala/networks/endpoints.dart';
import 'package:urban_koala/networks/exception_handler/data_source.dart';

final class SignupApi {
  static final SignupApi _singleton = SignupApi._internal();
  SignupApi._internal();
  static SignupApi get instance => _singleton;

  Future<SignUpResponseModel> signupApi({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "role": role,
      };

      Response response = await postHttp(Endpoints.signUp(), data);

      if (response.statusCode == 200) {
        final data = SignUpResponseModel.fromJson(response.data);
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
