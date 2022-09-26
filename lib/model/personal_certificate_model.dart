// To parse this JSON data, do
//
//     final personalCertificateModel = personalCertificateModelFromJson(jsonString);

import 'dart:convert';

PersonalCertificateModel personalCertificateModelFromJson(String str) => PersonalCertificateModel.fromJson(json.decode(str));

String personalCertificateModelToJson(PersonalCertificateModel data) => json.encode(data.toJson());

class PersonalCertificateModel {
    PersonalCertificateModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<PersonalCertificate> data;

    factory PersonalCertificateModel.fromJson(Map<String, dynamic> json) => PersonalCertificateModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<PersonalCertificate>.from(json["data"].map((x) => PersonalCertificate.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class PersonalCertificate {
    PersonalCertificate({
        required this.id,
        this.createdAt,
        this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.userId,
        required this.institutionName,
        required this.certificateName,
        this.certificateDate,
    });

    int id;
    dynamic createdAt;
    dynamic updatedAt;
    int createdBy;
    int updatedBy;
    int userId;
    String institutionName;
    String certificateName;
    dynamic certificateDate;

    factory PersonalCertificate.fromJson(Map<String, dynamic> json) => PersonalCertificate(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        userId: json["user_id"],
        institutionName: json["institution_name"],
        certificateName: json["certificate_name"],
        certificateDate: json["certificate_date"] == null ? null : DateTime.parse(json["certificate_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy,
        "user_id": userId,
        "institution_name": institutionName,
        "certificate_name": certificateName,
        "certificate_date": "${certificateDate.year.toString().padLeft(4, '0')}-${certificateDate.month.toString().padLeft(2, '0')}-${certificateDate.day.toString().padLeft(2, '0')}",
    };
}
