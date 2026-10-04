import 'dart:convert';

class LoginResponseModel {
  bool? status;
  String? message;
  Data? data;

  LoginResponseModel({this.status, this.message, this.data});

  factory LoginResponseModel.fromRawJson(String str) =>
      LoginResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
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
  String? token;
  User? user;

  Data({this.token, this.user});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  get access => null;

  Map<String, dynamic> toJson() => {"token": token, "user": user?.toJson()};
}

class User {
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
  String? latitude;
  String? longitude;
  String? status;
  String? lastLoginRole;
  String? deletedAt;

  User({
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

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
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
