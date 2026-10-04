// To parse this JSON data, do
//
//     final paymentBillingRes = paymentBillingResFromJson(jsonString);

import 'dart:convert';

PaymentBillingRes paymentBillingResFromJson(String str) =>
    PaymentBillingRes.fromJson(json.decode(str));

String paymentBillingResToJson(PaymentBillingRes data) =>
    json.encode(data.toJson());

class PaymentBillingRes {
  bool? status;
  String? message;
  List<PaymentBilling>? data;

  PaymentBillingRes({
    this.status,
    this.message,
    this.data,
  });

  factory PaymentBillingRes.fromJson(Map<String, dynamic> json) =>
      PaymentBillingRes(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<PaymentBilling>.from(
                json["data"]!.map((x) => PaymentBilling.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PaymentBilling {
  int? id;
  int? listingId;
  int? userId;
  int? serviceProviderId;
  String? subtotal;
  String? total;
  int? totalDays;
  String? invoiceId;
  dynamic pdfInvoice;
  dynamic carType;
  dynamic deleteMessege;
  String? providerFeeAfterComission;
  dynamic partialPaid;
  dynamic totalPaid;
  String? adminComission;
  String? paymentStatus;
  String? userPaymentId;
  dynamic adminPaymantId;
  String? status;
  dynamic rejectId;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  PaymentBilling({
    this.id,
    this.listingId,
    this.userId,
    this.serviceProviderId,
    this.subtotal,
    this.total,
    this.totalDays,
    this.invoiceId,
    this.pdfInvoice,
    this.carType,
    this.deleteMessege,
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
  });

  factory PaymentBilling.fromJson(Map<String, dynamic> json) => PaymentBilling(
        id: json["id"],
        listingId: json["listing_id"],
        userId: json["user_id"],
        serviceProviderId: json["service_provider_id"],
        subtotal: json["subtotal"],
        total: json["total"],
        totalDays: json["total_days"],
        invoiceId: json["invoice_id"],
        pdfInvoice: json["pdf_invoice"],
        carType: json["car_type"],
        deleteMessege: json["delete_messege"],
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
        "car_type": carType,
        "delete_messege": deleteMessege,
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
      };
}
