import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/networks/dio/dio.dart';
import 'package:urban_koala/networks/endpoints.dart';
import 'package:urban_koala/networks/exception_handler/data_source.dart';

final class UpdatePasswordApi {
  static final UpdatePasswordApi _singleton = UpdatePasswordApi._internal();
  UpdatePasswordApi._internal();
  static UpdatePasswordApi get instance => _singleton;

  Future<Map> updatePasswordApi({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': passwordConfirmation,
      });
      Response response = await postHttp(Endpoints.changePassword(), data);
      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        ToastUtil.showShortToast("Password Updated Successfully");
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
