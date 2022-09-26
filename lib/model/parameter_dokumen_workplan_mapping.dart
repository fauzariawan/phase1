// To parse this JSON data, do
//
//     final parameterDokumenWorkplanMapping = parameterDokumenWorkplanMappingFromJson(jsonString);

import 'dart:convert';

ParameterDokumenWorkplanMapping parameterDokumenWorkplanMappingFromJson(String str) => ParameterDokumenWorkplanMapping.fromJson(json.decode(str));

String parameterDokumenWorkplanMappingToJson(ParameterDokumenWorkplanMapping data) => json.encode(data.toJson());

class ParameterDokumenWorkplanMapping {
    ParameterDokumenWorkplanMapping({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<ParameterDokumenWorkplanMappingData> data;

    factory ParameterDokumenWorkplanMapping.fromJson(Map<String, dynamic> json) => ParameterDokumenWorkplanMapping(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterDokumenWorkplanMappingData>.from(json["data"].map((x) => ParameterDokumenWorkplanMappingData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ParameterDokumenWorkplanMappingData {
    ParameterDokumenWorkplanMappingData({
        required this.mappingId,
        required this.mandatory,
        required this.maxphoto,
        required this.documentId,
        required this.code,
        required this.description,
        required this.dokumen,
        required this.isUploaded,
        required this.workplanDokumenId,
        required this.countDokumen

    });

    int mappingId;
    bool mandatory;
    int maxphoto;
    int documentId;
    String code;
    String description;
    String dokumen;
    String isUploaded;
    int workplanDokumenId;
    int countDokumen;

    factory ParameterDokumenWorkplanMappingData.fromJson(Map<String, dynamic> json) => ParameterDokumenWorkplanMappingData(
        mappingId: json["mapping_id"],
        mandatory: json["mandatory"],
        maxphoto: json["maxphoto"],
        documentId: json["document_id"],
        code: json["code"],
        description: json["description"],
        dokumen: json["dokumen"] == null ? null : json["dokumen"],
        isUploaded: json["is_uploaded"],
        workplanDokumenId:json["workplan_dokumen_id"],
        countDokumen: json["count_dokumen"]
    );

    Map<String, dynamic> toJson() => {
        "mapping_id": mappingId,
        "mandatory": mandatory,
        "maxphoto": maxphoto,
        "document_id": documentId,
        "code": code,
        "description": description,
        "dokumen": dokumen == null ? null : dokumen,
        "is_uploaded": isUploaded,
        "workplan_dokumen_id": workplanDokumenId,
        "count_dokumen":countDokumen
    };
}
