// To parse this JSON data, do
//
//     final stripConfirmationRes = stripConfirmationResFromJson(jsonString);

import 'dart:convert';

StripConfirmationRes stripConfirmationResFromJson(String str) =>
    StripConfirmationRes.fromJson(json.decode(str));

String stripConfirmationResToJson(StripConfirmationRes data) =>
    json.encode(data.toJson());

class StripConfirmationRes {
  bool? status;
  String? message;
  StripModel? data;

  StripConfirmationRes({this.status, this.message, this.data});

  factory StripConfirmationRes.fromJson(Map<String, dynamic> json) =>
      StripConfirmationRes(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : StripModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class StripModel {
  StripeAccount? stripeAccount;

  StripModel({this.stripeAccount});

  factory StripModel.fromJson(Map<String, dynamic> json) => StripModel(
    stripeAccount: json["stripe_account"] == null
        ? null
        : StripeAccount.fromJson(json["stripe_account"]),
  );

  Map<String, dynamic> toJson() => {"stripe_account": stripeAccount?.toJson()};
}

class StripeAccount {
  String? accountId;
  String? accountHolder;
  String? accountNumber;
  PayoutSchedule? payoutSchedule;
  dynamic taxIdentity;

  StripeAccount({
    this.accountId,
    this.accountHolder,
    this.accountNumber,
    this.payoutSchedule,
    this.taxIdentity,
  });

  factory StripeAccount.fromJson(Map<String, dynamic> json) => StripeAccount(
    accountId: json["account_id"],
    accountHolder: json["account_holder"],
    accountNumber: json["account_number"],
    payoutSchedule: json["payout_schedule"] == null
        ? null
        : PayoutSchedule.fromJson(json["payout_schedule"]),
    taxIdentity: json["tax_identity"],
  );

  Map<String, dynamic> toJson() => {
    "account_id": accountId,
    "account_holder": accountHolder,
    "account_number": accountNumber,
    "payout_schedule": payoutSchedule?.toJson(),
    "tax_identity": taxIdentity,
  };
}

class PayoutSchedule {
  int? delayDays;
  String? interval;

  PayoutSchedule({this.delayDays, this.interval});

  factory PayoutSchedule.fromJson(Map<String, dynamic> json) =>
      PayoutSchedule(delayDays: json["delay_days"], interval: json["interval"]);

  Map<String, dynamic> toJson() => {
    "delay_days": delayDays,
    "interval": interval,
  };
}
