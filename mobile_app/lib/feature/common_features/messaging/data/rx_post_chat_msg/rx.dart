import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/networks/rx_base.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../common_widgets/custom_toast.dart';
import '../../../../../constants/app_constants.dart';
import '../../model/chat_message_model.dart';
import 'api.dart';

class PostChatMsgRx extends RxResponseInt {
  final api = PostChatMsgApi.instance;
  ValueStream get fileData => dataFetcher.stream;
  PostChatMsgRx({required super.empty, required super.dataFetcher});

  Future<bool> postChatMsg({String? message, int? receiverId}) async {
    try {
      Map data = {"receiver_id": receiverId, "message": message};
      final resData = await api.postChatMsg(data);
      return handleSuccessWithReturn(resData);
    } catch (e) {
      return handleErrorWithReturn(e);
    }
  }

  @override
  handleSuccessWithReturn(data) {
    dataFetcher.sink.add(data);
    ChatMessageRes chatMessageRes = ChatMessageRes.fromJson(data);
    appData.write(kkeyConversationId, chatMessageRes.data?.conversationId);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    log(error.toString());
    if (error.response?.statusCode == 401) {
      Future.delayed(const Duration(milliseconds: 100), () {
        NavigationService.navigateToUntilReplacement(Routes.login);
      });
    }
    if (error is DioException) {
      message =
          error.response?.data["message"].toString() ?? "Something went wrong";
      if (error.type == DioExceptionType.connectionError) {
        message = "Check Your Network Connection";
      }
    }
    customToastMessage('Error', message);
    return false;
  }
}
