import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetDeleteListingApi {
  static final GetDeleteListingApi _singleton = GetDeleteListingApi._internal();
  GetDeleteListingApi._internal();
  static GetDeleteListingApi get instance => _singleton;

  Future<Map> get(int id) async {
    try {
      Response response = await getHttp(Endpoints.deleteListing(id));
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