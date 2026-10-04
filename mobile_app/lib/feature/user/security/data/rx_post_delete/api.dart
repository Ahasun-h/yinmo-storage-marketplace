import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostAccountDeleteApi {
  static final PostAccountDeleteApi _singleton =
      PostAccountDeleteApi._internal();
  PostAccountDeleteApi._internal();
  static PostAccountDeleteApi get instance => _singleton;

  Future<Map> postAccountDelete() async {
    try {
      Response response = await postHttp(
        Endpoints.deleteAccount(),
      );
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
