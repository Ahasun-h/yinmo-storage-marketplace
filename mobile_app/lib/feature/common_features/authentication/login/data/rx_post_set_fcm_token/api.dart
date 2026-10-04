import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:urban_koala/networks/dio/dio.dart';
import 'package:urban_koala/networks/endpoints.dart';
import 'package:urban_koala/networks/exception_handler/data_source.dart';

final class PostFcmTokenApi {
  static final PostFcmTokenApi _singleton = PostFcmTokenApi._internal();
  PostFcmTokenApi._internal();
  static PostFcmTokenApi get instance => _singleton;

  Future<Map> postFcmToken(Map data) async {
    try {
      Response response = await postHttp(Endpoints.fcmToken(), data);
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
