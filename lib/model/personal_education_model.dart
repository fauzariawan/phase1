// To parse this JSON data, do
//
//     final personalEducationModel = personalEducationModelFromJson(jsonString);

import 'dart:convert';

PersonalEducationModel personalEducationModelFromJson(String str) => PersonalEducationModel.fromJson(json.decode(str));

String personalEducationModelToJson(PersonalEducationModel data) => json.encode(data.toJson());

class PersonalEducationModel {
    PersonalEducationModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<PersonalEducation> data;

    factory PersonalEducationModel.fromJson(Map<String, dynamic> json) => PersonalEducationModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<PersonalEducation>.from(json["data"].map((x) => PersonalEducation.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class PersonalEducation {
    PersonalEducation({
        required this.id,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        required this.userId,
        required this.institution,
        this.startDate,
        this.endDate,
        required this.educationTypeId,
        required this.educationTypeDesc,
        required this.educationTypeCode,
    });

    int id;
    dynamic createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    int userId;
    String institution;
    dynamic startDate;
    dynamic endDate;
    int educationTypeId;
    String educationTypeDesc;
    String educationTypeCode;

    factory PersonalEducation.fromJson(Map<String, dynamic> json) => PersonalEducation(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        userId: json["user_id"],
        institution: json["institution"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        educationTypeId: json["education_type_id"],
        educationTypeDesc: json["education_type_desc"],
        educationTypeCode: json["education_type_code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "user_id": userId,
        "institution": institution,
        "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "education_type_id": educationTypeId,
        "education_type_desc": educationTypeDesc,
        "education_type_code": educationTypeCode,
    };
}
