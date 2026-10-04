// To parse this JSON data, do
//
//     final vehicleInfo = vehicleInfoFromJson(jsonString);

import 'dart:convert';

VehicleInfo vehicleInfoFromJson(String str) =>
    VehicleInfo.fromJson(json.decode(str));

String vehicleInfoToJson(VehicleInfo data) => json.encode(data.toJson());

class VehicleInfo {
  bool? status;
  String? message;
  List<VehicleModel>? data;

  VehicleInfo({this.status, this.message, this.data});

  factory VehicleInfo.fromJson(Map<String, dynamic> json) => VehicleInfo(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<VehicleModel>.from(json["data"]!.map((x) => VehicleModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class VehicleModel {
  int? id;
  int? userId;
  String? vehicleName;
  String? vehicleModel;
  String? licencePlateNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  VehicleModel({
    this.id,
    this.userId,
    this.vehicleName,
    this.vehicleModel,
    this.licencePlateNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    id: json["id"],
    userId: json["user_id"],
    vehicleName: json["vehicle_name"],
    vehicleModel: json["vehicle_model"],
    licencePlateNumber: json["licence_plate_number"],
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
    "vehicle_name": vehicleName,
    "vehicle_model": vehicleModel,
    "licence_plate_number": licencePlateNumber,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
