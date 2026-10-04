import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostItemReviewRetingGetApi {
  static final PostItemReviewRetingGetApi _singleton =
      PostItemReviewRetingGetApi._internal();
  PostItemReviewRetingGetApi._internal();
  static PostItemReviewRetingGetApi get instance => _singleton;

  Future<Map> post(Map data) async {
    try {
      Response response = await postHttp(Endpoints.listingReviewGuest(), data);
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
