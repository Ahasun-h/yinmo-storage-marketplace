import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostBookingDateApi {
  static final PostBookingDateApi _singleton = PostBookingDateApi._internal();
  PostBookingDateApi._internal();
  static PostBookingDateApi get instance => _singleton;

  Future<Map> postBookingDate(Map data) async {
    try {
      Response response = await postHttp(Endpoints.bookingDate(), data);
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
