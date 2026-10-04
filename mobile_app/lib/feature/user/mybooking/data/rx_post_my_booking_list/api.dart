import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostMyBookingListApi {
  static final PostMyBookingListApi _singleton =
      PostMyBookingListApi._internal();
  PostMyBookingListApi._internal();
  static PostMyBookingListApi get instance => _singleton;

  Future<Map> postMyBookingList(Map data) async {
    try {
      Response response = await postHttp(Endpoints.myBookingList(), data);
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
