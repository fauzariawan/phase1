// To parse this JSON data, do
//
//     final personalFamilyModel = personalFamilyModelFromJson(jsonString);

import 'dart:convert';

PersonalFamilyModel personalFamilyModelFromJson(String str) => PersonalFamilyModel.fromJson(json.decode(str));

String personalFamilyModelToJson(PersonalFamilyModel data) => json.encode(data.toJson());

class PersonalFamilyModel {
    PersonalFamilyModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<FamilyData> data;

    factory PersonalFamilyModel.fromJson(Map<String, dynamic> json) => PersonalFamilyModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<FamilyData>.from(json["data"].map((x) => FamilyData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class FamilyData {
    FamilyData({
        required this.id,
        this.createdAt,
        this.updatedAt,
        required this.createdBy,
        this.updatedBy,
        required this.userId,
        required this.familyName,
        required this.familyRelationship,
        this.dateOfBirth,
        required this.status,
    });

    int id;
    dynamic createdAt;
    dynamic updatedAt;
    int createdBy;
    dynamic updatedBy;
    int userId;
    String familyName;
    String familyRelationship;
    dynamic dateOfBirth;
    int status;

    factory FamilyData.fromJson(Map<String, dynamic> json) => FamilyData(
        id: json["id"],
        createdAt: json["created_at"] == null ? null :DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"],
        userId: json["user_id"],
        familyName: json["family_name"],
        familyRelationship: json["family_relationship"],
        dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy,
        "user_id": userId,
        "family_name": familyName,
        "family_relationship": familyRelationship,
        "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "status": status,
    };
}
