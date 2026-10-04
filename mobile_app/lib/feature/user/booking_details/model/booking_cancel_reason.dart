// To parse this JSON data, do
//
//     final bookingCancelReasonRes = bookingCancelReasonResFromJson(jsonString);

import 'dart:convert';

BookingCancelReasonRes bookingCancelReasonResFromJson(String str) =>
    BookingCancelReasonRes.fromJson(json.decode(str));

String bookingCancelReasonResToJson(BookingCancelReasonRes data) =>
    json.encode(data.toJson());

class BookingCancelReasonRes {
  bool? status;
  String? message;
  List<BookingCancelReason>? data;

  BookingCancelReasonRes({this.status, this.message, this.data});

  factory BookingCancelReasonRes.fromJson(Map<String, dynamic> json) =>
      BookingCancelReasonRes(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<BookingCancelReason>.from(
                json["data"]!.map((x) => BookingCancelReason.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BookingCancelReason {
  int? id;
  String? reason;
  DateTime? createdAt;
  DateTime? updatedAt;

  BookingCancelReason({this.id, this.reason, this.createdAt, this.updatedAt});

  factory BookingCancelReason.fromJson(Map<String, dynamic> json) =>
      BookingCancelReason(
        id: json["id"],
        reason: json["reason"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reason": reason,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
