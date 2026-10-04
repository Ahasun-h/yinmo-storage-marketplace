import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class MarkNotificationReadApi {
  static final MarkNotificationReadApi _singleton =
      MarkNotificationReadApi._internal();
  MarkNotificationReadApi._internal();
  static MarkNotificationReadApi get instance => _singleton;

  Future<Map> markAllRead() async {
    try {
      // Assuming POST based on typical state change operations
      Response response = await getHttp(Endpoints.notificationMarkAllRead());
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
