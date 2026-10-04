import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostHelpSupportApi {
  static final PostHelpSupportApi _singleton = PostHelpSupportApi._internal();
  PostHelpSupportApi._internal();
  static PostHelpSupportApi get instance => _singleton;

  Future<Map> post(Map data) async {
    try {
      Response response = await postHttp(Endpoints.supportHelpStore(), data);
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