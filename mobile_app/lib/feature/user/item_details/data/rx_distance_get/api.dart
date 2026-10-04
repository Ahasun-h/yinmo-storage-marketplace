import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetDistanceApi {
  static final GetDistanceApi _singleton = GetDistanceApi._internal();
  GetDistanceApi._internal();
  static GetDistanceApi get instance => _singleton;

  Future<Map> getDistanceData(Map data) async {
    try {
      Response response = await postHttp(
        Endpoints.getDistance(),
        data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
