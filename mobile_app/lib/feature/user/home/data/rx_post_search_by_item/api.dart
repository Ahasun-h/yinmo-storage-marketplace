import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostSearchByItemApi {
  static final PostSearchByItemApi _singleton = PostSearchByItemApi._internal();
  PostSearchByItemApi._internal();
  static PostSearchByItemApi get instance => _singleton;

  Future<Map> postSearchByItem(Map data) async {
    try {
      Response response = await postHttp(Endpoints.searchListing(), data);
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
