// To parse this JSON data, do
//
//     final bookingFormRes = bookingFormResFromJson(jsonString);

import 'dart:convert';

BookingFormRes bookingFormResFromJson(String str) =>
    BookingFormRes.fromJson(json.decode(str));

String bookingFormResToJson(BookingFormRes data) => json.encode(data.toJson());

class BookingFormRes {
  bool? status;
  String? message;
  BookingForm? data;

  BookingFormRes({this.status, this.message, this.data});

  factory BookingFormRes.fromJson(Map<String, dynamic> json) => BookingFormRes(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : BookingForm.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class BookingForm {
  int? id;
  int? userId;
  String? title;
  String? description;
  String? location;
  String? latitude;
  String? longitude;
  String? price;
  String? listingType;
  String? status;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Slot>? slot;
  List<Feature>? features;
  List<Extraservice>? extraservices;
  List<BikeId>? bikeIds;
  List<BoxItem>? boxes;

  BookingForm({
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
    this.slot,
    this.features,
    this.extraservices,
    this.bikeIds,
    this.boxes,
  });

  factory BookingForm.fromJson(Map<String, dynamic> json) => BookingForm(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    location: json["location"],
    latitude: json["latitude"],
    longitude: json["longitude"],
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
    slot: json["slot"] == null
        ? []
        : List<Slot>.from(json["slot"]!.map((x) => Slot.fromJson(x))),
    features: json["features"] == null
        ? []
        : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
    extraservices: json["extraservices"] == null
        ? []
        : List<Extraservice>.from(
            json["extraservices"]!.map((x) => Extraservice.fromJson(x)),
          ),
    bikeIds: json["bike_ids"] == null
        ? []
        : List<BikeId>.from(json["bike_ids"]!.map((x) => BikeId.fromJson(x))),

    boxes: json["boxes"] == null
        ? []
        : List<BoxItem>.from(json["boxes"]!.map((x) => BoxItem.fromJson(x))),
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
    "slot": slot == null
        ? []
        : List<dynamic>.from(slot!.map((x) => x.toJson())),
    "features": features == null
        ? []
        : List<dynamic>.from(features!.map((x) => x.toJson())),
    "extraservices": extraservices == null
        ? []
        : List<dynamic>.from(extraservices!.map((x) => x.toJson())),
  };
}

class Extraservice {
  int? id;
  int? listingId;
  String? serviceName;
  String? price;
  DateTime? createdAt;
  DateTime? updatedAt;

  Extraservice({
    this.id,
    this.listingId,
    this.serviceName,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory Extraservice.fromJson(Map<String, dynamic> json) => Extraservice(
    id: json["id"],
    listingId: json["listing_id"],
    serviceName: json["service_name"],
    price: json["price"],
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
    "service_name": serviceName,
    "price": price,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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

class BikeId {
  int? id;
  int? listingId;
  String? bikeId;

  BikeId({this.id, this.listingId, this.bikeId});

  factory BikeId.fromJson(Map<String, dynamic> json) => BikeId(
    id: json["id"],
    listingId: json["listing_id"],
    bikeId: json["bike_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_id": listingId,
    "bike_id": bikeId,
  };
}

class BoxItem {
  int? id;
  int? listingId;
  String? boxName;

  BoxItem({this.id, this.listingId, this.boxName});

  factory BoxItem.fromJson(Map<String, dynamic> json) => BoxItem(
    id: json["id"],
    listingId: json["listing_id"],
    boxName: json["box_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_id": listingId,
    "box_name": boxName,
  };
}

List<CommonItem>? getCommonList(BookingForm? data) {
  if (data == null) return [];
  if (data.slot != null && data.slot!.isNotEmpty) {
    return data.slot!
        .map(
          (x) => CommonItem(id: x.id, listingId: x.listingId, name: x.slotName),
        )
        .toList();
  }

  if (data.bikeIds != null && data.bikeIds!.isNotEmpty) {
    return data.bikeIds!
        .map(
          (x) => CommonItem(id: x.id, listingId: x.listingId, name: x.bikeId),
        )
        .toList();
  }

  if (data.boxes != null && data.boxes!.isNotEmpty) {
    return data.boxes!
        .map(
          (x) => CommonItem(id: x.id, listingId: x.listingId, name: x.boxName),
        )
        .toList();
  }

  return [];
}

class CommonItem {
  int? id;
  int? listingId;
  String? name;

  CommonItem({this.id, this.listingId, this.name});
}
