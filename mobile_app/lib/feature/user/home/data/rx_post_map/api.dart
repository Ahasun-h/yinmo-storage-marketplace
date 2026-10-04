import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostMapDataApi {
  static final PostMapDataApi _singleton = PostMapDataApi._internal();
  PostMapDataApi._internal();
  static PostMapDataApi get instance => _singleton;

  Future<Map> post(FormData data) async {
    try {
      Response response = await postHttp(Endpoints.typeListSearch(), data);
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