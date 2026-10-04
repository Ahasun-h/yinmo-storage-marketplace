import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetBookingCancelReasonApi {
  static final GetBookingCancelReasonApi _singleton =
      GetBookingCancelReasonApi._internal();
  GetBookingCancelReasonApi._internal();
  static GetBookingCancelReasonApi get instance => _singleton;

  Future<Map> getBookingCancelReasonData() async {
    try {
      Response response = await getHttp(Endpoints.cancelBookingReason());
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
