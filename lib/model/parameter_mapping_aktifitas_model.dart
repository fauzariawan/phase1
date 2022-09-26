// To parse this JSON data, do
//
//     final parameterMappingAktifitasModel = parameterMappingAktifitasModelFromJson(jsonString);

import 'dart:convert';

ParameterMappingAktifitasModel parameterMappingAktifitasModelFromJson(
        String str) =>
    ParameterMappingAktifitasModel.fromJson(json.decode(str));

String parameterMappingAktifitasModelToJson(
        ParameterMappingAktifitasModel data) =>
    json.encode(data.toJson());

class ParameterMappingAktifitasModel {
  ParameterMappingAktifitasModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<ParameterMappingAktifitas> data;

  factory ParameterMappingAktifitasModel.fromJson(Map<String, dynamic> json) =>
      ParameterMappingAktifitasModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterMappingAktifitas>.from(json["data"].map((x) => ParameterMappingAktifitas.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ParameterMappingAktifitas {
  ParameterMappingAktifitas({
    required this.mappingId,
    // required this.activitiesId,
    // required this.createdBy,
    // required this.createdAt,
    // required this.updatedBy,
    // required this.updatedAt,
    required this.mappingStatusInt,
    required this.productId,
    required this.documentId,
    required this.mandatoryInt,
    required this.maxphoto,
    required this.companyId,
    required this.approvedStatus,
    required this.dokumenDescription,
  });

  int mappingId;
  // int activitiesId;
  // int createdBy;
  // dynamic createdAt;
  // int updatedBy;
  // dynamic updatedAt;
  int mappingStatusInt;
  int productId;
  int documentId;
  int mandatoryInt;
  int maxphoto;
  int companyId;
  int approvedStatus;
  String dokumenDescription;

  factory ParameterMappingAktifitas.fromJson(Map<String, dynamic> json) => ParameterMappingAktifitas(
        mappingId: json["mapping_id"],
        // activitiesId:json["activities_id"] == null ? null : json["activities_id"],
        // createdBy: json["created_by"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        // updatedAt: json["updated_at"] == null? null : DateTime.parse(json["updated_at"]),
       // mappingStatus: json["mapping_status_int"]?1:0,
       mappingStatusInt:json["mapping_status_int"] ,
        productId: json["product_id"],
        documentId: json["document_id"],
        mandatoryInt: json["mandatory_int"],
        maxphoto: json["maxphoto"],
        companyId: json["company_id"],
        approvedStatus: json["approved_status"],
        dokumenDescription: json["dokumen_description"],
      );

  Map<String, dynamic> toJson() => {
        "mapping_id": mappingId,
        "mapping_status_int": mappingStatusInt,
        "product_id": productId,
        "document_id": documentId,
        "mandatory_int": mandatoryInt,
        "maxphoto": maxphoto,
        "company_id": companyId,
        "approved_status": approvedStatus,
        "dokumen_description": dokumenDescription,
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["mapping_id"] = mappingId;
    // map["activities_id"] = activitiesId == null ? null : activitiesId;
    // map["created_by"] = createdBy;
    // map["created_at"] = createdAt.toIso8601String();
    // map["updated_by"] = updatedBy == null ? null : updatedBy;
    // map["updated_at"] = updatedAt == null ? null : updatedAt.toIso8601String();
    map["mapping_status_int"] = mappingStatusInt;
    map["product_id"] = productId;
    map["document_id"] = documentId;
    map["mandatory_int"] = mandatoryInt;
    map["maxphoto"] = maxphoto;
    map["company_id"] = companyId;
    map["approved_status"] = approvedStatus;
    map["dokumen_description"] = dokumenDescription;

    return map;
  }
}
