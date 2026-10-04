import 'dart:convert';

class OtpVerifyModel {
  bool? status;
  String? message;
  Data? data;

  OtpVerifyModel({this.status, this.message, this.data});

  factory OtpVerifyModel.fromRawJson(String str) =>
      OtpVerifyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtpVerifyModel.fromJson(Map<String, dynamic> json) => OtpVerifyModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? name;
  String? username;
  String? lastName;
  String? email;
  String? phone;
  String? coverImage;
  String? profileImage;
  String? address;
  String? dob;
  String? gender;
  String? role;
  bool? isAgree;
  String? blockStatus;
  String? resetPasswordToken;
  String? latitude;
  String? longitude;
  String? status;
  String? lastLoginRole;
  String? deletedAt;

  Data({
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
    this.resetPasswordToken,
    this.latitude,
    this.longitude,
    this.status,
    this.lastLoginRole,
    this.deletedAt,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        coverImage: json["cover_image"],
        profileImage: json["profile_image"],
        address: json["address"],
        dob: json["dob"],
        gender: json["gender"],
        role: json["role"],
        isAgree: json["is_agree"],
        blockStatus: json["block_status"],
        resetPasswordToken: json["reset_password_token"],
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
        "reset_password_token": resetPasswordToken,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "last_login_role": lastLoginRole,
        "deleted_at": deletedAt,
      };
}
