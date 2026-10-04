// To parse this JSON data, do
//
//     final bookingStoreRes = bookingStoreResFromJson(jsonString);

import 'dart:convert';

BookingStoreRes bookingStoreResFromJson(String str) =>
    BookingStoreRes.fromJson(json.decode(str));

String bookingStoreResToJson(BookingStoreRes data) =>
    json.encode(data.toJson());

class BookingStoreRes {
  int? listingId;
  int? userId;
  double? total;
  double? subtotal;
  String? title;
  String? location;
  List<Slot>? slots;
  List<SelectedSlotModel>? selectedSlots;
  List<BoxItem>? boxes;
  List<BikeItem>? bikes;
  List<ExtraService>? extraServices;

  BookingStoreRes({
    this.listingId,
    this.userId,
    this.total,
    this.subtotal,
    this.slots,
    this.selectedSlots,
    this.boxes,
    this.bikes,
    this.extraServices,
    this.title,
    this.location,
  });

  factory BookingStoreRes.fromJson(
    Map<String, dynamic> json,
  ) => BookingStoreRes(
    listingId: json["listing_id"],
    userId: json["user_id"],
    total: json["total"],
    title: json["title"],
    location: json["location"],
    subtotal: json["subtotal"],
    slots: json["slots"] == null
        ? []
        : List<Slot>.from(json["slots"]!.map((x) => Slot.fromJson(x))),
    selectedSlots: json["selected_slots"] == null
        ? []
        : List<SelectedSlotModel>.from(
            json["selected_slots"]!.map((x) => SelectedSlotModel.fromJson(x)),
          ),
    boxes: json["boxes"] == null
        ? []
        : List<BoxItem>.from(json["boxes"]!.map((x) => BoxItem.fromJson(x))),
    bikes: json["bikes"] == null
        ? []
        : List<BikeItem>.from(json["bikes"]!.map((x) => BikeItem.fromJson(x))),
    extraServices: json["extra_services"] == null
        ? []
        : List<ExtraService>.from(
            json["extra_services"]!.map((x) => ExtraService.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "listing_id": listingId,
    "user_id": userId,
    "total": total,
    "subtotal": subtotal,
    "title": title,
    "location": location,
    "slots": slots == null
        ? []
        : List<dynamic>.from(slots!.map((x) => x.toJson())),
    "selected_slots": selectedSlots,
    "boxes": boxes == null
        ? []
        : List<dynamic>.from(boxes!.map((x) => x.toJson())),
    "bikes": bikes == null
        ? []
        : List<dynamic>.from(bikes!.map((x) => x.toJson())),
    "extra_services": extraServices == null
        ? []
        : List<dynamic>.from(extraServices!.map((x) => x.toJson())),
  };
}

class ExtraService {
  int? id;
  String? name;
  double? price;
  double? totalPrice;

  ExtraService({this.id, this.name, this.price, this.totalPrice});

  factory ExtraService.fromJson(Map<String, dynamic> json) => ExtraService(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    totalPrice: json["total_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "total_price": totalPrice,
  };
}

class Slot {
  int? slotId;
  DateTime? slotDate;

  Slot({this.slotId, this.slotDate});

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    slotId: json["slot_id"],
    slotDate: json["slot_date"] == null
        ? null
        : DateTime.parse(json["slot_date"]),
  );

  Map<String, dynamic> toJson() => {
    "slot_id": slotId,
    "slot_date":
        "${slotDate!.year.toString().padLeft(4, '0')}-${slotDate!.month.toString().padLeft(2, '0')}-${slotDate!.day.toString().padLeft(2, '0')}",
  };
}

class BoxItem {
  int? boxId;
  DateTime? boxDate;

  BoxItem({this.boxId, this.boxDate});

  factory BoxItem.fromJson(Map<String, dynamic> json) => BoxItem(
    boxId: json["box_id"],
    boxDate: json["box_date"] == null ? null : DateTime.parse(json["box_date"]),
  );

  Map<String, dynamic> toJson() => {
    "box_id": boxId,
    "box_date":
        "${boxDate!.year.toString().padLeft(4, '0')}-${boxDate!.month.toString().padLeft(2, '0')}-${boxDate!.day.toString().padLeft(2, '0')}",
  };
}

class BikeItem {
  int? bikeId;
  DateTime? bikeDate;

  BikeItem({this.bikeId, this.bikeDate});

  factory BikeItem.fromJson(Map<String, dynamic> json) => BikeItem(
    bikeId: json["bike_id"],
    bikeDate: json["bike_date"] == null
        ? null
        : DateTime.parse(json["bike_date"]),
  );

  Map<String, dynamic> toJson() => {
    "bike_id": bikeId,
    "bike_date":
        "${bikeDate!.year.toString().padLeft(4, '0')}-${bikeDate!.month.toString().padLeft(2, '0')}-${bikeDate!.day.toString().padLeft(2, '0')}",
  };
}
// To parse this JSON data, do
//
//     final selectedSlotModel = selectedSlotModelFromJson(jsonString);

List<SelectedSlotModel> selectedSlotModelFromJson(String str) =>
    List<SelectedSlotModel>.from(
      json.decode(str).map((x) => SelectedSlotModel.fromJson(x)),
    );

String selectedSlotModelToJson(List<SelectedSlotModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SelectedSlotModel {
  int? id;
  String? name;
  List<String>? dates;

  SelectedSlotModel({this.id, this.name, this.dates});

  factory SelectedSlotModel.fromJson(Map<String, dynamic> json) =>
      SelectedSlotModel(
        id: json["id"],
        name: json["name"],
        dates: json["dates"] == null ? [] : List<String>.from(json["dates"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "dates": dates == null ? [] : List<dynamic>.from(dates!.map((x) => x)),
  };
}
