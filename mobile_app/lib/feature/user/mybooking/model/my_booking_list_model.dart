// To parse this JSON data, do
//
//     final myBookingListRes = myBookingListResFromJson(jsonString);

import 'dart:convert';

MyBookingListRes myBookingListResFromJson(String str) =>
    MyBookingListRes.fromJson(json.decode(str));

String myBookingListResToJson(MyBookingListRes data) =>
    json.encode(data.toJson());

class MyBookingListRes {
  bool? status;
  String? message;
  List<MyBookingListModel>? data;

  MyBookingListRes({this.status, this.message, this.data});

  factory MyBookingListRes.fromJson(Map<String, dynamic> json) =>
      MyBookingListRes(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MyBookingListModel>.from(
                json["data"]!.map((x) => MyBookingListModel.fromJson(x)),
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

class MyBookingListModel {
  int? id;
  int? listingId;
  int? userId;
  int? serviceProviderId;
  String? subtotal;
  String? total;
  int? totalDays;
  String? invoiceId;
  String? pdfInvoice;
  String? providerFeeAfterComission;
  String? partialPaid;
  String? totalPaid;
  String? adminComission;
  String? paymentStatus;
  String? userPaymentId;
  dynamic adminPaymantId;
  String? status;
  dynamic rejectId;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<BoxesGrouped>? slotsGrouped;
  List<BoxesGrouped>? boxesGrouped;
  List<BikesGrouped>? bikesGrouped;
  Listing? listing;
  User? user;
  ServiceProvider? serviceProvider;
  List<SlotDate>? slotDateBookingManages;
  List<Box>? boxBookingDateManages;
  List<BikeIdmanageDate>? bikeIdmanageDates;
  List<ExtraServicesBooking>? extraServicesBooking;

  MyBookingListModel({
    this.id,
    this.listingId,
    this.userId,
    this.serviceProviderId,
    this.subtotal,
    this.total,
    this.totalDays,
    this.invoiceId,
    this.pdfInvoice,
    this.providerFeeAfterComission,
    this.partialPaid,
    this.totalPaid,
    this.adminComission,
    this.paymentStatus,
    this.userPaymentId,
    this.adminPaymantId,
    this.status,
    this.rejectId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.slotsGrouped,
    this.boxesGrouped,
    this.bikesGrouped,
    this.listing,
    this.user,
    this.serviceProvider,
    this.slotDateBookingManages,
    this.boxBookingDateManages,
    this.bikeIdmanageDates,
    this.extraServicesBooking,
  });

  List<CommonGroupedItem> get commonGroupedItems {
    if (listing?.listingType == 'parking') {
      return slotsGrouped
              ?.map(
                (e) => CommonGroupedItem(
                  id: e.id,
                  name: e.slotName,
                  dates: e.slotDates
                      ?.map((d) => CommonDateItem(id: d.id, date: d.slotDate))
                      .toList(),
                ),
              )
              .toList() ??
          [];
    } else if (listing?.listingType == 'luggage') {
      return boxesGrouped
              ?.map(
                (e) => CommonGroupedItem(
                  id: e.id,
                  name: e.boxName,
                  dates: e.boxDates
                      ?.map((d) => CommonDateItem(id: d.id, date: d.boxDate))
                      .toList(),
                ),
              )
              .toList() ??
          [];
    } else if (listing?.listingType == 'bike_rent') {
      return bikesGrouped
              ?.map(
                (e) => CommonGroupedItem(
                  id: e.id,
                  name: e.bikeName,
                  dates: e.bikeDates
                      ?.map((d) => CommonDateItem(id: d.id, date: d.bikeDate))
                      .toList(),
                ),
              )
              .toList() ??
          [];
    }
    return [];
  }

  factory MyBookingListModel.fromJson(
    Map<String, dynamic> json,
  ) => MyBookingListModel(
    id: json["id"],
    listingId: json["listing_id"],
    userId: json["user_id"],
    serviceProviderId: json["service_provider_id"],
    subtotal: json["subtotal"],
    total: json["total"],
    totalDays: json["total_days"],
    invoiceId: json["invoice_id"],
    pdfInvoice: json["pdf_invoice"],
    providerFeeAfterComission: json["provider_fee_after_comission"],
    partialPaid: json["partial_paid"],
    totalPaid: json["total_paid"],
    adminComission: json["admin_comission"],
    paymentStatus: json["payment_status"],
    userPaymentId: json["user_payment_id"],
    adminPaymantId: json["admin_paymant_id"],
    status: json["status"],
    rejectId: json["reject_id"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    slotsGrouped: json["slots_grouped"] == null
        ? []
        : List<BoxesGrouped>.from(
            json["slots_grouped"]!.map((x) => BoxesGrouped.fromJson(x)),
          ),
    boxesGrouped: json["boxes_grouped"] == null
        ? []
        : List<BoxesGrouped>.from(
            json["boxes_grouped"]!.map((x) => BoxesGrouped.fromJson(x)),
          ),
    bikesGrouped: json["bikes_grouped"] == null
        ? []
        : List<BikesGrouped>.from(
            json["bikes_grouped"]!.map((x) => BikesGrouped.fromJson(x)),
          ),
    listing: json["listing"] == null ? null : Listing.fromJson(json["listing"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    serviceProvider: json["service_provider"] == null
        ? null
        : ServiceProvider.fromJson(json["service_provider"]),
    slotDateBookingManages: json["slot_date_booking_manages"] == null
        ? []
        : List<SlotDate>.from(
            json["slot_date_booking_manages"]!.map((x) => SlotDate.fromJson(x)),
          ),
    boxBookingDateManages: json["box_booking_date_manages"] == null
        ? []
        : List<Box>.from(
            json["box_booking_date_manages"]!.map((x) => Box.fromJson(x)),
          ),
    bikeIdmanageDates: json["bike_idmanage_dates"] == null
        ? []
        : List<BikeIdmanageDate>.from(
            json["bike_idmanage_dates"]!.map(
              (x) => BikeIdmanageDate.fromJson(x),
            ),
          ),
    extraServicesBooking: json["extra_services_booking"] == null
        ? []
        : List<ExtraServicesBooking>.from(
            json["extra_services_booking"]!.map(
              (x) => ExtraServicesBooking.fromJson(x),
            ),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_id": listingId,
    "user_id": userId,
    "service_provider_id": serviceProviderId,
    "subtotal": subtotal,
    "total": total,
    "total_days": totalDays,
    "invoice_id": invoiceId,
    "pdf_invoice": pdfInvoice,
    "provider_fee_after_comission": providerFeeAfterComission,
    "partial_paid": partialPaid,
    "total_paid": totalPaid,
    "admin_comission": adminComission,
    "payment_status": paymentStatus,
    "user_payment_id": userPaymentId,
    "admin_paymant_id": adminPaymantId,
    "status": status,
    "reject_id": rejectId,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "slots_grouped": slotsGrouped == null
        ? []
        : List<dynamic>.from(slotsGrouped!.map((x) => x.toJson())),
    "boxes_grouped": boxesGrouped == null
        ? []
        : List<dynamic>.from(boxesGrouped!.map((x) => x.toJson())),
    "bikes_grouped": bikesGrouped == null
        ? []
        : List<dynamic>.from(bikesGrouped!.map((x) => x.toJson())),
    "listing": listing?.toJson(),
    "user": user?.toJson(),
    "service_provider": serviceProvider?.toJson(),
    "slot_date_booking_manages": slotDateBookingManages == null
        ? []
        : List<dynamic>.from(slotDateBookingManages!.map((x) => x.toJson())),
    "box_booking_date_manages": boxBookingDateManages == null
        ? []
        : List<dynamic>.from(boxBookingDateManages!.map((x) => x.toJson())),
    "bike_idmanage_dates": bikeIdmanageDates == null
        ? []
        : List<dynamic>.from(bikeIdmanageDates!.map((x) => x.toJson())),
    "extra_services_booking": extraServicesBooking == null
        ? []
        : List<dynamic>.from(extraServicesBooking!.map((x) => x.toJson())),
  };
}

class BikeIdmanageDate {
  int? id;
  int? listingId;
  BoxesGrouped? bikeId;
  DateTime? bikeDate;
  int? bookingId;
  DateTime? createdAt;
  DateTime? updatedAt;

  BikeIdmanageDate({
    this.id,
    this.listingId,
    this.bikeId,
    this.bikeDate,
    this.bookingId,
    this.createdAt,
    this.updatedAt,
  });

  factory BikeIdmanageDate.fromJson(Map<String, dynamic> json) =>
      BikeIdmanageDate(
        id: json["id"],
        listingId: json["listing_id"],
        bikeId: json["bike_id"] == null
            ? null
            : BoxesGrouped.fromJson(json["bike_id"]),
        bikeDate: json["bike_date"] == null
            ? null
            : DateTime.parse(json["bike_date"]),
        bookingId: json["booking_id"],
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
    "bike_id": bikeId?.toJson(),
    "bike_date": bikeDate?.toIso8601String(),
    "booking_id": bookingId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class SlotDate {
  int? id;
  int? listingId;
  int? slotId;
  DateTime? slotDate;
  int? bookingId;
  DateTime? createdAt;
  DateTime? updatedAt;
  BoxesGrouped? slot;

  SlotDate({
    this.id,
    this.listingId,
    this.slotId,
    this.slotDate,
    this.bookingId,
    this.createdAt,
    this.updatedAt,
    this.slot,
  });

  factory SlotDate.fromJson(Map<String, dynamic> json) => SlotDate(
    id: json["id"],
    listingId: json["listing_id"],
    slotId: json["slot_id"],
    slotDate: json["slot_date"] == null
        ? null
        : DateTime.parse(json["slot_date"]),
    bookingId: json["booking_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    slot: json["slot"] == null ? null : BoxesGrouped.fromJson(json["slot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_id": listingId,
    "slot_id": slotId,
    "slot_date": slotDate?.toIso8601String(),
    "booking_id": bookingId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "slot": slot?.toJson(),
  };
}

class Box {
  int? id;
  int? listingId;
  int? boxId;
  DateTime? boxDate;
  int? bookingId;
  DateTime? createdAt;
  DateTime? updatedAt;
  BoxesGrouped? box;

  Box({
    this.id,
    this.listingId,
    this.boxId,
    this.boxDate,
    this.bookingId,
    this.createdAt,
    this.updatedAt,
    this.box,
  });

  factory Box.fromJson(Map<String, dynamic> json) => Box(
    id: json["id"],
    listingId: json["listing_id"],
    boxId: json["box_id"],
    boxDate: json["box_date"] == null ? null : DateTime.parse(json["box_date"]),
    bookingId: json["booking_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    box: json["box"] == null ? null : BoxesGrouped.fromJson(json["box"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_id": listingId,
    "box_id": boxId,
    "box_date": boxDate?.toIso8601String(),
    "booking_id": bookingId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "box": box?.toJson(),
  };
}

class BoxesGrouped {
  int? id;
  int? listingId;
  String? bikeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? boxName;
  List<Box>? boxDates;
  String? slotName;
  List<SlotDate>? slotDates;

  BoxesGrouped({
    this.id,
    this.listingId,
    this.bikeId,
    this.createdAt,
    this.updatedAt,
    this.boxName,
    this.boxDates,
    this.slotName,
    this.slotDates,
  });

  factory BoxesGrouped.fromJson(Map<String, dynamic> json) => BoxesGrouped(
    id: json["id"],
    listingId: json["listing_id"],
    bikeId: json["bike_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    boxName: json["box_name"],
    boxDates: json["box_dates"] == null
        ? []
        : List<Box>.from(json["box_dates"]!.map((x) => Box.fromJson(x))),
    slotName: json["slot_name"],
    slotDates: json["slot_dates"] == null
        ? []
        : List<SlotDate>.from(
            json["slot_dates"]!.map((x) => SlotDate.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_id": listingId,
    "bike_id": bikeId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "box_name": boxName,
    "box_dates": boxDates == null
        ? []
        : List<dynamic>.from(boxDates!.map((x) => x.toJson())),
    "slot_name": slotName,
    "slot_dates": slotDates == null
        ? []
        : List<dynamic>.from(slotDates!.map((x) => x.toJson())),
  };
}

class ServiceProvider {
  int? id;
  String? name;
  dynamic username;
  dynamic lastName;
  String? email;
  String? phone;
  dynamic coverImage;
  String? profileImage;
  String? address;
  DateTime? dob;
  String? gender;
  String? role;
  bool? isAgree;
  String? blockStatus;
  dynamic latitude;
  dynamic longitude;
  String? status;
  String? lastLoginRole;
  dynamic deletedAt;

  ServiceProvider({
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

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      ServiceProvider(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        coverImage: json["cover_image"],
        profileImage: json["profile_image"],
        address: json["address"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
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
    "dob": dob?.toIso8601String(),
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

class BikesGrouped {
  int? id;
  int? listingId;
  String? bikeName;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<BikeDate>? bikeDates;

  BikesGrouped({
    this.id,
    this.listingId,
    this.bikeName,
    this.createdAt,
    this.updatedAt,
    this.bikeDates,
  });

  factory BikesGrouped.fromJson(Map<String, dynamic> json) => BikesGrouped(
    id: json["id"],
    listingId: json["listing_id"],
    bikeName: json["bike_name"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    bikeDates: json["bike_dates"] == null
        ? []
        : List<BikeDate>.from(
            json["bike_dates"]!.map((x) => BikeDate.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_id": listingId,
    "bike_name": bikeName,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "bike_dates": bikeDates == null
        ? []
        : List<dynamic>.from(bikeDates!.map((x) => x.toJson())),
  };
}

class BikeDate {
  int? id;
  int? listingId;
  int? bikeId;
  DateTime? bikeDate;
  int? bookingId;
  DateTime? createdAt;
  DateTime? updatedAt;

  BikeDate({
    this.id,
    this.listingId,
    this.bikeId,
    this.bikeDate,
    this.bookingId,
    this.createdAt,
    this.updatedAt,
  });

  factory BikeDate.fromJson(Map<String, dynamic> json) => BikeDate(
    id: json["id"],
    listingId: json["listing_id"],
    bikeId: json["bike_id"],
    bikeDate: json["bike_date"] == null
        ? null
        : DateTime.parse(json["bike_date"]),
    bookingId: json["booking_id"],
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
    "bike_id": bikeId,
    "bike_date": bikeDate?.toIso8601String(),
    "booking_id": bookingId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class ExtraServicesBooking {
  int? id;
  int? listingId;
  int? extraServiceId;
  String? price;
  String? totalServicePrice;
  int? bookingId;
  DateTime? createdAt;
  DateTime? updatedAt;
  ExtraService? extraService;

  ExtraServicesBooking({
    this.id,
    this.listingId,
    this.extraServiceId,
    this.price,
    this.totalServicePrice,
    this.bookingId,
    this.createdAt,
    this.updatedAt,
    this.extraService,
  });

  factory ExtraServicesBooking.fromJson(Map<String, dynamic> json) =>
      ExtraServicesBooking(
        id: json["id"],
        listingId: json["listing_id"],
        extraServiceId: json["extra_service_id"],
        price: json["price"],
        totalServicePrice: json["total_service_price"],
        bookingId: json["booking_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        extraService: json["extra_service"] == null
            ? null
            : ExtraService.fromJson(json["extra_service"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_id": listingId,
    "extra_service_id": extraServiceId,
    "price": price,
    "total_service_price": totalServicePrice,
    "booking_id": bookingId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "extra_service": extraService?.toJson(),
  };
}

class ExtraService {
  int? id;
  int? listingId;
  String? serviceName;
  String? price;
  DateTime? createdAt;
  DateTime? updatedAt;

  ExtraService({
    this.id,
    this.listingId,
    this.serviceName,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory ExtraService.fromJson(Map<String, dynamic> json) => ExtraService(
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

class Listing {
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

  Listing({
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
  });

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
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
  dynamic profileImage;
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

class CommonGroupedItem {
  int? id;
  String? name;
  List<CommonDateItem>? dates;

  CommonGroupedItem({this.id, this.name, this.dates});
}

class CommonDateItem {
  int? id;
  DateTime? date;

  CommonDateItem({this.id, this.date});
}
