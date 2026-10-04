import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetListingListApi {
  static final GetListingListApi _singleton = GetListingListApi._internal();
  GetListingListApi._internal();
  static GetListingListApi get instance => _singleton;

  Future<Map> get() async {
    try {
      Response response = await getHttp(Endpoints.allListProvider());
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