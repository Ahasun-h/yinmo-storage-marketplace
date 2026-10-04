import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetStripInfoApi {
  static final GetStripInfoApi _singleton = GetStripInfoApi._internal();
  GetStripInfoApi._internal();
  static GetStripInfoApi get instance => _singleton;

  Future<Map> getData() async {
    try {
      Response response = await getHttp(Endpoints.getStripe());
      if (response.statusCode == 200) {
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