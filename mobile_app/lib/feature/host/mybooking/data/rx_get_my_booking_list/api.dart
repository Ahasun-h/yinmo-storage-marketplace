import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetHostBookingListApi {
  static final GetHostBookingListApi _singleton =
      GetHostBookingListApi._internal();
  GetHostBookingListApi._internal();
  static GetHostBookingListApi get instance => _singleton;

  Future<Map> getMyBookingList() async {
    try {
      Response response = await getHttp(Endpoints.hostBookingList());
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
