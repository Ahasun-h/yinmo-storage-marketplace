import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:urban_koala/networks/dio/dio.dart';
import 'package:urban_koala/networks/endpoints.dart';
import 'package:urban_koala/networks/exception_handler/data_source.dart';

final class CreatePassApi {
  static final CreatePassApi _singleton = CreatePassApi._internal();
  CreatePassApi._internal();
  static CreatePassApi get instance => _singleton;

  Future<Map> createPassApi({
    required String newPassword,
    required String confirmPassword,
    required String email,
    required String token,
  }) async {
    try {
      FormData data = FormData.fromMap({
        "password": newPassword,
        "password_confirmation": confirmPassword,
        "email": email,
        "reset_password_token": token,
      });

      Response response = await postHttp(Endpoints.resetPassword(), data);

      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
