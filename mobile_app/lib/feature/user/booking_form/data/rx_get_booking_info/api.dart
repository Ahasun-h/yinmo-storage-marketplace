import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetBookingInfoApi {
  static final GetBookingInfoApi _singleton = GetBookingInfoApi._internal();
  GetBookingInfoApi._internal();
  static GetBookingInfoApi get instance => _singleton;

  Future<Map> get(int? listingId) async {
    try {
      Response response = await getHttp(Endpoints.bookingBeforeDataShow(listingId));
      if (response.statusCode == 200) {
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