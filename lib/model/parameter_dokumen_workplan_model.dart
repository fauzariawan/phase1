// To parse this JSON data, do
//
//     final parameterDokumenWorkplanModel = parameterDokumenWorkplanModelFromJson(jsonString);

import 'dart:convert';

ParameterDokumenWorkplanModel parameterDokumenWorkplanModelFromJson(String str) => ParameterDokumenWorkplanModel.fromJson(json.decode(str));

String parameterDokumenWorkplanModelToJson(ParameterDokumenWorkplanModel data) => json.encode(data.toJson());

class ParameterDokumenWorkplanModel {
    ParameterDokumenWorkplanModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<ParameterDokumenWorkplan> data;

    factory ParameterDokumenWorkplanModel.fromJson(Map<String, dynamic> json) => ParameterDokumenWorkplanModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterDokumenWorkplan>.from(json["data"].map((x) => ParameterDokumenWorkplan.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ParameterDokumenWorkplan {
    ParameterDokumenWorkplan({
        required this.id,
        required this.code,
        required this.description,
        required this.companyId,
        // required this.createdBy,
        // required this.createdAt,
        // required this.updatedBy,
        // required this.updatedAt,
        required this.status,
        required this.isUploaded,
        required this.dokumen,
    });

    int id;
    String code;
    String description;
    int companyId;
    // dynamic createdBy;
    // dynamic createdAt;
    // dynamic updatedBy;
    // dynamic updatedAt;
    int status;
    String isUploaded;
    String dokumen;

    factory ParameterDokumenWorkplan.fromJson(Map<String, dynamic> json) => ParameterDokumenWorkplan(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        companyId: json["company_id"],
        // createdBy: json["created_by"],
        // createdAt: json["created_at"],
        // updatedBy: json["updated_by"] ,
        // updatedAt: json["updated_at"],
        status: json["status"],
        isUploaded: json["is_uploaded"],
        dokumen: json["dokumen"] == null ? null : json["dokumen"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "company_id": companyId,
        // "created_by": createdBy,
        // "created_at": createdAt.toIso8601String(),
        // "updated_by": updatedBy,
        // "updated_at": updatedAt,
        "status": status,
        "is_uploaded": isUploaded,
        "dokumen":  dokumen,
    };
}

