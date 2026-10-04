import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostProfileImageApi {
  static final PostProfileImageApi _singleton = PostProfileImageApi._internal();
  PostProfileImageApi._internal();
  static PostProfileImageApi get instance => _singleton;

  Future<Map> post(FormData data) async {
    try {
      Response response = await postHttp(Endpoints.updateProfileImage(), data);
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