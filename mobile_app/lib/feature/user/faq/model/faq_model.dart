import 'dart:convert';

FaqRes faqResFromJson(String str) => FaqRes.fromJson(json.decode(str));

String faqResToJson(FaqRes data) => json.encode(data.toJson());

class FaqRes {
  bool? status;
  String? message;
  List<FaqData>? data;

  FaqRes({
    this.status,
    this.message,
    this.data,
  });

  factory FaqRes.fromJson(Map<String, dynamic> json) => FaqRes(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<FaqData>.from(json["data"]!.map((x) => FaqData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FaqData {
  int? id;
  String? question;
  String? answer;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  FaqData({
    this.id,
    this.question,
    this.answer,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory FaqData.fromJson(Map<String, dynamic> json) => FaqData(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
