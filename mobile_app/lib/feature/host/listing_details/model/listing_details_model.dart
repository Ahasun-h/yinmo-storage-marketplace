// To parse this JSON data, do
//
//     final listingDetailsRes = listingDetailsResFromJson(jsonString);

import 'dart:convert';

import 'package:urban_koala/feature/host/listing_details/model/review_rating_model.dart';

import '../../../user/booking_form/model/booking_form_model.dart';

ListingDetailsRes listingDetailsResFromJson(String str) =>
    ListingDetailsRes.fromJson(json.decode(str));

String listingDetailsResToJson(ListingDetailsRes data) =>
    json.encode(data.toJson());

class ListingDetailsRes {
  bool? status;
  String? message;
  ListingDetails? data;

  ListingDetailsRes({this.status, this.message, this.data});

  factory ListingDetailsRes.fromJson(Map<String, dynamic> json) =>
      ListingDetailsRes(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : ListingDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ListingDetails {
  int? id;
  String? title;
  String? description;
  String? price;
  String? location;
  String? listingType;
  double? latitude;
  double? longitude;
  dynamic avgRating;
  List<Slot>? slot;
  List<Extraservice>? extraservices;
  List<BoxItem>? boxes;
  List<BikeId>? bikeIds;
  int? uniqueUserCount;
  List<Feature>? features;
  List<Photo>? photos;
  List<Review>? reviews;

  ListingDetails({
    this.id,
    this.title,
    this.description,
    this.price,
    this.location,
    this.listingType,
    this.latitude,
    this.longitude,
    this.avgRating,
    this.slot,
    this.boxes,
    this.bikeIds,
    this.extraservices,
    this.uniqueUserCount,
    this.features,
    this.photos,
    this.reviews,
  });

  factory ListingDetails.fromJson(Map<String, dynamic> json) => ListingDetails(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      location: json["location"],
      listingType: json["listing_type"],
      latitude: double.parse(json["latitude"].toString()),
      longitude: double.parse(json["longitude"].toString()),
      avgRating: json["avg_rating"],
      slot: json["slot"] == null
          ? []
          : List<Slot>.from(json["slot"]!.map((x) => Slot.fromJson(x))),
      boxes: json["boxes"] == null
          ? []
          : List<BoxItem>.from(json["boxes"]!.map((x) => BoxItem.fromJson(x))),
      bikeIds: json["bike_ids"] == null
          ? []
          : List<BikeId>.from(json["bike_ids"]!.map((x) => BikeId.fromJson(x))),
      uniqueUserCount: json["unique_user_count"],
      features: json["features"] == null
          ? []
          : List<Feature>.from(
              json["features"]!.map((x) => Feature.fromJson(x))),
      photos: json["photos"] == null
          ? []
          : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
      reviews: json["reviews"] == null
          ? []
          : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
      extraservices: json["extraservices"] == null
          ? []
          : List<Extraservice>.from(
              json["extraservices"]!.map((x) => Extraservice.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "location": location,
        "listing_type": listingType,
        "latitude": double.parse(latitude.toString()),
        "longitude": double.parse(longitude.toString()),
        "avg_rating": avgRating,
        "unique_user_count": uniqueUserCount,
        "boxes": boxes == null
            ? []
            : List<BoxItem>.from(boxes!.map((x) => x.toJson())),
        "bike_ids": bikeIds == null
            ? []
            : List<BikeId>.from(bikeIds!.map((x) => x.toJson())),
        "features": features == null
            ? []
            : List<Feature>.from(features!.map((x) => x.toJson())),
        "photos": photos == null
            ? []
            : List<Photo>.from(photos!.map((x) => x.toJson())),
        "reviews": reviews == null
            ? []
            : List<Review>.from(reviews!.map((x) => x.toJson())),
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

class Slot {
  int? id;
  int? listingId;
  String? slotName;
  DateTime? createdAt;
  DateTime? updatedAt;

  Slot({
    this.id,
    this.listingId,
    this.slotName,
    this.createdAt,
    this.updatedAt,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["id"],
        listingId: json["listing_id"],
        slotName: json["slot_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "listing_id": listingId,
        "slot_name": slotName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
