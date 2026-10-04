// To parse this JSON data, do
//
//     final slotBookingDateRes = slotBookingDateResFromJson(jsonString);

import 'dart:convert';

SlotBookingDateRes slotBookingDateResFromJson(String str) =>
    SlotBookingDateRes.fromJson(json.decode(str));

String slotBookingDateResToJson(SlotBookingDateRes data) =>
    json.encode(data.toJson());

class SlotBookingDateRes {
  bool? status;
  String? message;
  List<SlotBookingDate>? data;

  SlotBookingDateRes({this.status, this.message, this.data});

  factory SlotBookingDateRes.fromJson(Map<String, dynamic> json) =>
      SlotBookingDateRes(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SlotBookingDate>.from(
                json["data"]!.map((x) => SlotBookingDate.fromJson(x)),
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

class SlotBookingDate {
  int? id;
  int? listingId;
  int? slotId;
  DateTime? slotDate;
  int? bookingId;
  DateTime? createdAt;
  DateTime? updatedAt;

  SlotBookingDate({
    this.id,
    this.listingId,
    this.slotId,
    this.slotDate,
    this.bookingId,
    this.createdAt,
    this.updatedAt,
  });

  factory SlotBookingDate.fromJson(Map<String, dynamic> json) =>
      SlotBookingDate(
        id: json["id"],
        listingId: json["listing_id"],
        slotId: json["slot_id"],
        slotDate: json["slot_date"] == null
            ? null
            : DateTime.parse(json["slot_date"]),
        bookingId: json["booking_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_id": listingId,
    "slot_id": slotId,
    "slot_date": slotDate?.toIso8601String(),
    "booking_id": bookingId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
