import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostBasicInformationApi {
  static final PostBasicInformationApi _singleton =
      PostBasicInformationApi._internal();
  PostBasicInformationApi._internal();
  static PostBasicInformationApi get instance => _singleton;

  Future<Map> postData(Map data) async {
    try {
      Response response = await postHttp(
        Endpoints.stripeSetupStore(),
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
