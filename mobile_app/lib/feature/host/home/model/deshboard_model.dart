// To parse this JSON data, do
//
//     final deshboardDataRes = deshboardDataResFromJson(jsonString);

import 'dart:convert';

DeshboardDataRes deshboardDataResFromJson(String str) =>
    DeshboardDataRes.fromJson(json.decode(str));

String deshboardDataResToJson(DeshboardDataRes data) =>
    json.encode(data.toJson());

class DeshboardDataRes {
  String? filter;
  int? totalBooking;
  double? totalEarning;
  List<RecentActivity>? recentActivity;

  DeshboardDataRes({
    this.filter,
    this.totalBooking,
    this.totalEarning,
    this.recentActivity,
  });

  factory DeshboardDataRes.fromJson(Map<String, dynamic> json) =>
      DeshboardDataRes(
        filter: json["filter"],
        totalBooking: json["total_booking"],
        totalEarning: double.tryParse(json["total_earning"]?.toString() ?? '0'),
        recentActivity: json["recent_activity"] == null
            ? []
            : List<RecentActivity>.from(
                json["recent_activity"]!.map((x) => RecentActivity.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "filter": filter,
    "total_booking": totalBooking,
    "total_earning": totalEarning,
    "recent_activity": recentActivity == null
        ? []
        : List<dynamic>.from(recentActivity!.map((x) => x.toJson())),
  };
}

class RecentActivity {
  int? id;
  int? userId;
  String? title;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  RecentActivity({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) => RecentActivity(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
