import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class GetNotificationApi {
  static final GetNotificationApi _singleton = GetNotificationApi._internal();
  GetNotificationApi._internal();
  static GetNotificationApi get instance => _singleton;

  Future<Map> get() async {
    try {
      Response response = await getHttp(Endpoints.notificationList());
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
