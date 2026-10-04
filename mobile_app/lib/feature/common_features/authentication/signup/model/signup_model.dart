import 'dart:convert';

class SignUpResponseModel {
  bool? status;
  String? message;
  Data? data;

  SignUpResponseModel({this.status, this.message, this.data});

  factory SignUpResponseModel.fromRawJson(String str) =>
      SignUpResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) =>
      SignUpResponseModel(
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

  Map<String, dynamic> toJson() => {"token": token, "user": user?.toJson()};
}

class User {
  String? name;
  String? email;
  String? role;
  String? lastLoginRole;
  int? id;

  User({this.name, this.email, this.role, this.lastLoginRole, this.id});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    role: json["role"],
    lastLoginRole: json["last_login_role"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "role": role,
    "last_login_role": lastLoginRole,
    "id": id,
  };
}
