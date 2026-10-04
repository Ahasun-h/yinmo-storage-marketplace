// To parse this JSON data, do
//
//     final reviewRatingRes = reviewRatingResFromJson(jsonString);

import 'dart:convert';

ReviewRatingRes reviewRatingResFromJson(String str) =>
    ReviewRatingRes.fromJson(json.decode(str));

String reviewRatingResToJson(ReviewRatingRes data) =>
    json.encode(data.toJson());

class ReviewRatingRes {
  bool? status;
  String? message;
  ReviewRating? data;

  ReviewRatingRes({this.status, this.message, this.data});

  factory ReviewRatingRes.fromJson(Map<String, dynamic> json) =>
      ReviewRatingRes(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ReviewRating.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ReviewRating {
  int? fiveStar;
  int? fourStar;
  int? threeStar;
  int? twoStar;
  int? oneStar;
  double? avgRating;
  List<Review>? reviews;

  ReviewRating({
    this.fiveStar,
    this.fourStar,
    this.threeStar,
    this.twoStar,
    this.oneStar,
    this.avgRating,
    this.reviews,
  });

  factory ReviewRating.fromJson(Map<String, dynamic> json) => ReviewRating(
        fiveStar: json["fiveStar"],
        fourStar: json["fourStar"],
        threeStar: json["threeStar"],
        twoStar: json["twoStar"],
        oneStar: json["oneStar"],
        avgRating: json["avgRating"]?.toDouble(),
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "fiveStar": fiveStar,
        "fourStar": fourStar,
        "threeStar": threeStar,
        "twoStar": twoStar,
        "oneStar": oneStar,
        "avgRating": avgRating,
        "reviews": reviews == null
            ? []
            : List<Review>.from(reviews!.map((x) => x.toJson())),
      };
}

class Review {
  int? id;
  int? userId;
  int? listingId;
  int? rating;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  Review({
    this.id,
    this.userId,
    this.listingId,
    this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        userId: json["user_id"],
        listingId: json["listing_id"],
        rating: json["rating"],
        comment: json["comment"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "listing_id": listingId,
        "rating": rating,
        "comment": comment,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class User {
  int? id;
  String? name;
  dynamic username;
  dynamic lastName;
  String? email;
  dynamic phone;
  dynamic coverImage;
  String? profileImage;
  dynamic address;
  dynamic dob;
  dynamic gender;
  String? role;
  bool? isAgree;
  String? blockStatus;
  dynamic latitude;
  dynamic longitude;
  String? status;
  String? lastLoginRole;
  dynamic deletedAt;

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
