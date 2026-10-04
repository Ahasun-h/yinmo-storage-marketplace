import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetSingleBookingGuestApi {
  static final GetSingleBookingGuestApi _singleton =
      GetSingleBookingGuestApi._internal();
  GetSingleBookingGuestApi._internal();
  static GetSingleBookingGuestApi get instance => _singleton;

  Future<Map> getSingleBooking(String id) async {
    try {
      Response response = await getHttp(Endpoints.bookingSummary(id));
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
