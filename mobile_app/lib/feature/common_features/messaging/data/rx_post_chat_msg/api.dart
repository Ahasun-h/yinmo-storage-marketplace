import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

class PostChatMsgApi {
  static final PostChatMsgApi singleton = PostChatMsgApi._internal();
  PostChatMsgApi._internal();
  static PostChatMsgApi get instance => singleton;

  Future<Map> postChatMsg(Map data) async {
    try {
      Response response = await postHttp(Endpoints.sendChat(), data);
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
