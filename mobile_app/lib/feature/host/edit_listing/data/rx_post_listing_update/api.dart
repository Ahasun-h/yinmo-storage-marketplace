import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';

class PostListingUpdateApi {
  static final PostListingUpdateApi _singleton =
      PostListingUpdateApi._internal();
  PostListingUpdateApi._internal();
  static PostListingUpdateApi get instance => _singleton;

  Future<Map> postData(FormData data, int id) async {
    try {
      Response response = await postHttp(Endpoints.updateListing(id), data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
