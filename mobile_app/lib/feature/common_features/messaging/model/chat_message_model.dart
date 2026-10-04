import 'dart:convert';

ChatMessageRes chatMessageResFromJson(String str) =>
    ChatMessageRes.fromJson(json.decode(str));
String chatMessageResToJson(ChatMessageRes data) => json.encode(data.toJson());

class ChatMessageRes {
  bool? status;
  String? message;
  Data? data;
  ChatMessageRes({this.status, this.message, this.data});
  factory ChatMessageRes.fromJson(Map<String, dynamic> json) => ChatMessageRes(
    status: json["status"] as bool?, // Ensure safe casting
    message: json["message"] as String?,
    // 💡 সংশোধন: json["data"] যদি একটি Map হয় (অর্থাৎ ডেটা আছে), তবেই Data.fromJson কল করুন।
    // অন্যথায় null সেট করুন।
    data: json["data"] is Map ? Data.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? senderId;
  int? receiverId;
  String? message;
  String? conversationId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  dynamic imageUrl;
  dynamic imageId;
  dynamic fileUrl;
  dynamic chatimage;

  Data({
    this.senderId,
    this.receiverId,
    this.message,
    this.conversationId,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.imageUrl,
    this.imageId,
    this.fileUrl,
    this.chatimage,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(dynamic value) {
      if (value is String && value.isNotEmpty) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    return Data(
      senderId: json["sender_id"] as int?,
      receiverId: json["receiver_id"] as int?,
      message: json["message"] as String?,
      conversationId: json["conversation_id"] as String?,

      updatedAt: parseDateTime(json["updated_at"]),
      createdAt: parseDateTime(json["created_at"]),

      id: json["id"] as int?,

      imageUrl: json["image_url"],
      imageId: json["image_id"],
      fileUrl: json["file_url"],
      chatimage: json["chatimage"],
    );
  }

  Map<String, dynamic> toJson() => {
    "sender_id": senderId,
    "receiver_id": receiverId,
    "message": message,
    "conversation_id": conversationId,

    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),

    "id": id,
    "image_url": imageUrl,
    "image_id": imageId,
    "file_url": fileUrl,
    "chatimage": chatimage,
  };
}
