// To parse this JSON data, do
//
//     final singleListInfo = singleListInfoFromJson(jsonString);

import 'dart:convert';

SingleListInfoRes singleListInfoResFromJson(String str) =>
    SingleListInfoRes.fromJson(json.decode(str));

String singleListInfoResToJson(SingleListInfoRes data) => json.encode(data.toJson());

class SingleListInfoRes {
  bool? status;
  String? message;
  SingleListInfo? data;

  SingleListInfoRes({this.status, this.message, this.data});
  factory SingleListInfoRes.fromJson(Map<String, dynamic> json) => SingleListInfoRes(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : SingleListInfo.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class SingleListInfo {
  int? id;
  String? title;
  String? description;
  String? price;
  String? location;
  String? listingType;
  String? latitude;
  String? longitude;
  dynamic avgRating;
  int? uniqueUserCount;
  List<Feature>? features;
  List<Photo>? photos;
  List<dynamic>? reviews;

  SingleListInfo({
    this.id,
    this.title,
    this.description,
    this.price,
    this.location,
    this.listingType,
    this.latitude,
    this.longitude,
    this.avgRating,
    this.uniqueUserCount,
    this.features,
    this.photos,
    this.reviews,
  });

  factory SingleListInfo.fromJson(Map<String, dynamic> json) => SingleListInfo(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    location: json["location"],
    listingType: json["listing_type"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    avgRating: json["avg_rating"],
    uniqueUserCount: json["unique_user_count"],
    features: json["features"] == null
        ? []
        : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
    photos: json["photos"] == null
        ? []
        : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
    reviews: json["reviews"] == null
        ? []
        : List<dynamic>.from(json["reviews"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "price": price,
    "location": location,
    "listing_type": listingType,
    "latitude": latitude,
    "longitude": longitude,
    "avg_rating": avgRating,
    "unique_user_count": uniqueUserCount,
    "features": features == null
        ? []
        : List<dynamic>.from(features!.map((x) => x.toJson())),
    "photos": photos == null
        ? []
        : List<dynamic>.from(photos!.map((x) => x.toJson())),
    "reviews": reviews == null
        ? []
        : List<dynamic>.from(reviews!.map((x) => x)),
  };
}

class Feature {
  int? id;
  int? listingId;
  String? featureName;

  Feature({this.id, this.listingId, this.featureName});

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    id: json["id"],
    listingId: json["listing_id"],
    featureName: json["feature_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_id": listingId,
    "feature_name": featureName,
  };
}

class Photo {
  int? id;
  int? listingId;
  String? image;

  Photo({this.id, this.listingId, this.image});

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    id: json["id"],
    listingId: json["listing_id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_id": listingId,
    "image": image,
  };
}
