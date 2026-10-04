import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetSingleListDetailsApi {
  static final GetSingleListDetailsApi _singleton = GetSingleListDetailsApi._internal();
  GetSingleListDetailsApi._internal();
  static GetSingleListDetailsApi get instance => _singleton;

  Future<Map> get(int? listId) async {
    try {
      Response response = await getHttp(Endpoints.getGuestListingDetails(listId));
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