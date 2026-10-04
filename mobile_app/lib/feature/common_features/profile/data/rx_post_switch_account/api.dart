import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostSwitchAccountApi {
  static final PostSwitchAccountApi _singleton =
      PostSwitchAccountApi._internal();
  PostSwitchAccountApi._internal();
  static PostSwitchAccountApi get instance => _singleton;

  Future<Map> postSwitchAccountApi(Map data) async {
    try {
      Response response = await postHttp(Endpoints.switchAccount(), data);
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
