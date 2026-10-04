import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetSingleBookingHostApi {
  static final GetSingleBookingHostApi _singleton =
      GetSingleBookingHostApi._internal();
  GetSingleBookingHostApi._internal();
  static GetSingleBookingHostApi get instance => _singleton;

  Future<Map> getSingleBooking(String id) async {
    try {
      Response response = await getHttp(Endpoints.singleBooking(id));
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
