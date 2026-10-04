// To parse this JSON data, do
//
//     final listingListRes = listingListResFromJson(jsonString);

import 'dart:convert';

ListingListRes listingListResFromJson(String str) =>
    ListingListRes.fromJson(json.decode(str));

String listingListResToJson(ListingListRes data) => json.encode(data.toJson());

class ListingListRes {
  bool? status;
  String? message;
  List<ListingModel>? data;

  ListingListRes({this.status, this.message, this.data});

  factory ListingListRes.fromJson(Map<String, dynamic> json) => ListingListRes(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<ListingModel>.from(json["data"]!.map((x) => ListingModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ListingModel {
  int? id;
  String? title;
  String? description;
  String? price;
  String? location;
  String? listingType;
  List<Feature>? features;
  int? avgRating;
  int? uniqueUserCount;

  ListingModel({
    this.id,
    this.title,
    this.description,
    this.price,
    this.location,
    this.listingType,
    this.features,
    this.avgRating,
    this.uniqueUserCount,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) => ListingModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    location: json["location"],
    listingType: json["listing_type"],
    features: json["features"] == null
        ? []
        : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
    avgRating: json["avg_rating"],
    uniqueUserCount: json["unique_user_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "price": price,
    "location": location,
    "listing_type": listingType,
    "features": features == null
        ? []
        : List<dynamic>.from(features!.map((x) => x.toJson())),
    "avg_rating": avgRating,
    "unique_user_count": uniqueUserCount,
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
