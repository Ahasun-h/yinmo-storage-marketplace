import 'dart:convert';

NotificationRes notificationResFromJson(String str) =>
    NotificationRes.fromJson(json.decode(str));

String notificationResToJson(NotificationRes data) =>
    json.encode(data.toJson());

class NotificationRes {
  bool? status;
  String? message;
  List<NotificationData>? data;

  NotificationRes({this.status, this.message, this.data});

  factory NotificationRes.fromJson(Map<String, dynamic> json) =>
      NotificationRes(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<NotificationData>.from(
                json["data"]!.map((x) => NotificationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class NotificationData {
  int? id;
  String? title;
  String? message;
  bool? isRead;
  int? userId;
  String? notificationType;
  dynamic createdAt;
  String? updatedAt;

  Map<String, dynamic>? data;

  NotificationData({
    this.id,
    this.title,
    this.message,
    this.isRead,
    this.userId,
    this.notificationType,
    this.createdAt,
    this.updatedAt,
    this.data,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        isRead: json["is_read"],
        userId: json["user_id"],
        notificationType: json["notification_type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        data: json["data"] is String
            ? jsonDecode(json["data"])
            : json["data"], // Handle stringified JSON if necessary
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "is_read": isRead,
        "user_id": userId,
        "notification_type": notificationType,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
