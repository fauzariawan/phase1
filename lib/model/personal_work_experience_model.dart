// To parse this JSON data, do
//
//     final personalWorkExperienceModel = personalWorkExperienceModelFromJson(jsonString);

import 'dart:convert';

PersonalWorkExperienceModel personalWorkExperienceModelFromJson(String str) => PersonalWorkExperienceModel.fromJson(json.decode(str));

String personalWorkExperienceModelToJson(PersonalWorkExperienceModel data) => json.encode(data.toJson());

class PersonalWorkExperienceModel {
    PersonalWorkExperienceModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<PersonalWorkExperience> data;

    factory PersonalWorkExperienceModel.fromJson(Map<String, dynamic> json) => PersonalWorkExperienceModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<PersonalWorkExperience>.from(json["data"].map((x) => PersonalWorkExperience.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class PersonalWorkExperience {
    PersonalWorkExperience({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.userId,
        required this.companyName,
        required this.position,
        required this.startDate,
        required this.endDate,
    });

    int id;
    dynamic createdAt;
    dynamic updatedAt;
    int createdBy;
    dynamic updatedBy;
    int userId;
    String companyName;
    String position;
    dynamic startDate;
    dynamic endDate;

    factory PersonalWorkExperience.fromJson(Map<String, dynamic> json) => PersonalWorkExperience(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"],
        userId: json["user_id"],
        companyName: json["company_name"],
        position: json["position"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy,
        "user_id": userId,
        "company_name": companyName,
        "position": position,
        "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    };
}
