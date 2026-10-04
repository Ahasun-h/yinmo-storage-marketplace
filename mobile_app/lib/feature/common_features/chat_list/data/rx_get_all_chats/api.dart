import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetAllChatsApi {
  static final GetAllChatsApi _singleton = GetAllChatsApi._internal();
  GetAllChatsApi._internal();
  static GetAllChatsApi get instance => _singleton;

  Future<Map> getAllChatData() async {
    try {
      Response response = await getHttp(Endpoints.getChatList());
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
