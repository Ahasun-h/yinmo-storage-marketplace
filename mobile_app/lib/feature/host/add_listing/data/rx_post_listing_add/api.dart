import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostListingAddApi {
  static final PostListingAddApi _singleton = PostListingAddApi._internal();
  PostListingAddApi._internal();
  static PostListingAddApi get instance => _singleton;

  Future<Map> postData(FormData data) async {
    try {
      Response response = await postHttp(Endpoints.addListing(), data);
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