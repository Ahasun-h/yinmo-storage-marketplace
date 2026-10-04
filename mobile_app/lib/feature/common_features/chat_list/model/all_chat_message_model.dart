// To parse this JSON data, do
//
//     final allChatListRes = allChatListResFromJson(jsonString);

import 'dart:convert';

AllChatListRes allChatListResFromJson(String str) =>
    AllChatListRes.fromJson(json.decode(str));

String allChatListResToJson(AllChatListRes data) => json.encode(data.toJson());

class AllChatListRes {
  bool? status;
  String? message;
  List<ChatModel>? data;

  AllChatListRes({
    this.status,
    this.message,
    this.data,
  });

  factory AllChatListRes.fromJson(Map<String, dynamic> json) => AllChatListRes(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ChatModel>.from(
                json["data"]!.map((x) => ChatModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ChatModel {
  int? chatId;
  String? conversationId;
  String? latestTime;
  String? message;
  String? userName;
  int? receiverId;
  String? userImage;
  String? myImage;
  String? chatImage;
  String? imageId;
  String? fileUrl;
  int? unreadCount;

  ChatModel({
    this.chatId,
    this.conversationId,
    this.latestTime,
    this.message,
    this.userName,
    this.receiverId,
    this.userImage,
    this.myImage,
    this.chatImage,
    this.imageId,
    this.fileUrl,
    this.unreadCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        chatId: json["chat_id"],
        conversationId: json["conversation_id"],
        latestTime: json["latest_time"],
        message: json["message"],
        userName: json["user_name"],
        receiverId: json["receiver_id"],
        userImage: json["user_image"],
        myImage: json["my_image"],
        chatImage: json["chat_image"],
        imageId: json["image_id"],
        fileUrl: json["file_url"],
        unreadCount: json["unread_count"],
      );

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "conversation_id": conversationId,
        "latest_time": latestTime,
        "message": message,
        "user_name": userName,
        "receiver_id": receiverId,
        "user_image": userImage,
        "my_image": myImage,
        "chat_image": chatImage,
        "image_id": imageId,
        "file_url": fileUrl,
        "unread_count": unreadCount,
      };
}
