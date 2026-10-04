// To parse this JSON data, do
//
//     final mapDataRes = mapDataResFromJson(jsonString);

import 'dart:convert';

MapDataRes mapDataResFromJson(String str) =>
    MapDataRes.fromJson(json.decode(str));

String mapDataResToJson(MapDataRes data) => json.encode(data.toJson());

class MapDataRes {
  bool? status;
  String? message;
  List<MapDataModel>? data;

  MapDataRes({this.status, this.message, this.data});

  factory MapDataRes.fromJson(Map<String, dynamic> json) => MapDataRes(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<MapDataModel>.from(
            json["data"]!.map((x) => MapDataModel.fromJson(x)),
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

class MapDataModel {
  int? id;
  int? userId;
  String? title;
  String? description;
  String? location;
  double? latitude;
  double? longitude;
  String? price;
  String? listingType;
  String? status;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? distance;
  double? averageRating;
  int? totalReviews;
  List<Feature>? features;
  List<dynamic>? photos;

  MapDataModel({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.location,
    this.latitude,
    this.longitude,
    this.price,
    this.listingType,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.distance,
    this.averageRating,
    this.totalReviews,
    this.features,
    this.photos,
  });

  factory MapDataModel.fromJson(Map<String, dynamic> json) => MapDataModel(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    location: json["location"],
    latitude: double.parse(json["latitude"].toString()),
    longitude: double.parse(json["longitude"].toString()),
    price: json["price"],
    listingType: json["listing_type"],
    status: json["status"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    distance: json["distance"]?.toDouble(),
    averageRating: double.parse(json["average_rating"].toString()),
    totalReviews: json["total_reviews"],
    features: json["features"] == null
        ? []
        : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
    photos: json["photos"] == null
        ? []
        : List<dynamic>.from(json["photos"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "description": description,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "price": price,
    "listing_type": listingType,
    "status": status,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "distance": distance,
    "average_rating": averageRating,
    "total_reviews": totalReviews,
    "features": features == null
        ? []
        : List<dynamic>.from(features!.map((x) => x.toJson())),
    "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x)),
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
