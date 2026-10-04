import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:urban_koala/networks/dio/dio.dart';
import 'package:urban_koala/networks/endpoints.dart';
import 'package:urban_koala/networks/exception_handler/data_source.dart';

final class ForgetPassApi {
  static final ForgetPassApi _singleton = ForgetPassApi._internal();
  ForgetPassApi._internal();
  static ForgetPassApi get instance => _singleton;

  Future<Map> forgetPassApi({required String email}) async {
    try {
      FormData data = FormData.fromMap({"email": email});

      Response response = await postHttp(Endpoints.forgetPassword(), data);

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
