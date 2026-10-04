import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostBookingStoreApi {
  static final PostBookingStoreApi _singleton = PostBookingStoreApi._internal();
  PostBookingStoreApi._internal();
  static PostBookingStoreApi get instance => _singleton;

  Future<Map> postBookingStore(String data) async {
    try {
      Response response = await postHttp(Endpoints.bookingStore(), data);
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
