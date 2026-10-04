import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetConversationApi {
  static final GetConversationApi _singleton = GetConversationApi._internal();
  GetConversationApi._internal();
  static GetConversationApi get instance => _singleton;

  Future<Map> getfunctionNameData(String? id) async {
    try {
      Response response = await getHttp(Endpoints.getConversation(id));
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
