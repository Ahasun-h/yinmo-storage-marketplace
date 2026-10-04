import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class GetFaqApi {
  static final GetFaqApi _singleton = GetFaqApi._internal();
  GetFaqApi._internal();
  static GetFaqApi get instance => _singleton;
  Future<Map> get() async {
    try {
      Response response = await getHttp(Endpoints.faq());
      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        return data;
      } else {
        // Handle non-200 responses if necessary
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (e) {
      throw DataSource.DEFAULT.getFailure();
    }
  }
}
