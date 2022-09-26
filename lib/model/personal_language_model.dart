// To parse this JSON data, do
//
//     final personalLanguageModel = personalLanguageModelFromJson(jsonString);

import 'dart:convert';

PersonalLanguageModel personalLanguageModelFromJson(String str) => PersonalLanguageModel.fromJson(json.decode(str));

String personalLanguageModelToJson(PersonalLanguageModel data) => json.encode(data.toJson());

class PersonalLanguageModel {
    PersonalLanguageModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<PersonalLanguage> data;

    factory PersonalLanguageModel.fromJson(Map<String, dynamic> json) => PersonalLanguageModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<PersonalLanguage>.from(json["data"].map((x) => PersonalLanguage.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class PersonalLanguage {
    PersonalLanguage({
        required this.id,
        this.createdAt,
        this.updatedAt,
        required this.createdBy,
        this.updatedBy,
        required this.userId,
        required this.languageType,
        required this.readingScore,
        required this.writtingScore,
        required this.speakingScore,
    });

    int id;
    dynamic createdAt;
    dynamic updatedAt;
    int createdBy;
    dynamic updatedBy;
    int userId;
    String languageType;
    int readingScore;
    int writtingScore;
    int speakingScore;

    factory PersonalLanguage.fromJson(Map<String, dynamic> json) => PersonalLanguage(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"],
        userId: json["user_id"],
        languageType: json["language_type"],
        readingScore: json["reading_score"],
        writtingScore: json["writting_score"],
        speakingScore: json["speaking_score"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy,
        "user_id": userId,
        "language_type": languageType,
        "reading_score": readingScore,
        "writting_score": writtingScore,
        "speaking_score": speakingScore,
    };
}
