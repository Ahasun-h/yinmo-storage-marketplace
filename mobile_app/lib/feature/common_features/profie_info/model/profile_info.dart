// To parse this JSON data, do
//
//     final profileInfo = profileInfoFromJson(jsonString);

import 'dart:convert';

ProfileInfo profileInfoFromJson(String str) =>
    ProfileInfo.fromJson(json.decode(str));

String profileInfoToJson(ProfileInfo data) => json.encode(data.toJson());

class ProfileInfo {
  bool? status;
  String? message;
  ProfileDataModel? data;

  ProfileInfo({this.status, this.message, this.data});

  factory ProfileInfo.fromJson(Map<String, dynamic> json) => ProfileInfo(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : ProfileDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class ProfileDataModel {
  int? id;
  String? name;
  dynamic username;
  dynamic lastName;
  String? email;
  dynamic phone;
  dynamic coverImage;
  String? profileImage;
  dynamic address;
  DateTime? dob;
  dynamic gender;
  String? role;
  bool? isAgree;
  String? blockStatus;
  dynamic latitude;
  dynamic longitude;
  String? status;
  String? lastLoginRole;
  dynamic deletedAt;

  ProfileDataModel({
    this.id,
    this.name,
    this.username,
    this.lastName,
    this.email,
    this.phone,
    this.coverImage,
    this.profileImage,
    this.address,
    this.dob,
    this.gender,
    this.role,
    this.isAgree,
    this.blockStatus,
    this.latitude,
    this.longitude,
    this.status,
    this.lastLoginRole,
    this.deletedAt,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) => ProfileDataModel(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    coverImage: json["cover_image"],
    profileImage: json["profile_image"],
    address: json["address"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    gender: json["gender"],
    role: json["role"],
    isAgree: json["is_agree"],
    blockStatus: json["block_status"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    status: json["status"],
    lastLoginRole: json["last_login_role"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "cover_image": coverImage,
    "profile_image": profileImage,
    "address": address,
    "dob": dob,
    "gender": gender,
    "role": role,
    "is_agree": isAgree,
    "block_status": blockStatus,
    "latitude": latitude,
    "longitude": longitude,
    "status": status,
    "last_login_role": lastLoginRole,
    "deleted_at": deletedAt,
  };
}
