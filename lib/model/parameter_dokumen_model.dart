// To parse this JSON data, do
//
//     final parameterDokumenModel = parameterDokumenModelFromJson(jsonString);

import 'dart:convert';

ParameterDokumenModel parameterDokumenModelFromJson(String str) => ParameterDokumenModel.fromJson(json.decode(str));

String parameterDokumenModelToJson(ParameterDokumenModel data) => json.encode(data.toJson());

class ParameterDokumenModel {
    ParameterDokumenModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<ParameterDokumen> data;

    factory ParameterDokumenModel.fromJson(Map<String, dynamic> json) => ParameterDokumenModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterDokumen>.from(json["data"].map((x) => ParameterDokumen.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ParameterDokumen {
    ParameterDokumen({
        required this.id,
        required this.code,
        required this.description,
        required this.companyId,
        // required this.createdBy,
        // required this.createdAt,
        // required this.updatedBy,
        // required this.updatedAt,
        required this.status,
    });

    int id;
    String code;
    String description;
    String companyId;
    // dynamic createdBy;
    // dynamic createdAt;
    // dynamic updatedBy;
    // dynamic updatedAt;
    String status;

    factory ParameterDokumen.fromJson(Map<String, dynamic> json) => ParameterDokumen(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        companyId: json["company_id"],
        // createdBy: json["created_by"],
        // createdAt: json["created_at"]==null?null:DateTime.parse(json["created_at"]),
        // updatedBy: json["updated_by"] ,
        // updatedAt: json["updated_at"]==null?null:DateTime.parse(json["updated_at"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "company_id": companyId,
        // "created_by": createdBy,
        // "created_at": createdAt.toIso8601String(),
        // "updated_by": updatedBy == null ? null : updatedBy,
        // "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "status": status,
    };
}

