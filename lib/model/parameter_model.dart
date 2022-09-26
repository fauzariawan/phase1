// To parse this JSON data, do
//
//     final parameterModel = parameterModelFromJson(jsonString);

import 'dart:convert';

ParameterModel parameterModelFromJson(String str) =>
    ParameterModel.fromJson(json.decode(str));

String parameterModelToJson(ParameterModel data) => json.encode(data.toJson());

class ParameterModel {
  ParameterModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<Parameter> data;

  factory ParameterModel.fromJson(Map<String, dynamic> json) => ParameterModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<Parameter>.from(
            json["data"].map((x) => Parameter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Parameter {
  Parameter(
      {required this.id,
      required this.parameterType,
      required this.parameterName,
      required this.parameterValue,
      this.parameterNote,
      // this.createdAt,
      // this.updatedAt,
      // this.createdBy,
      // this.updatedBy,
      required this.parameterCode,
      this.status,
      required this.companyId});

  int id;
  String parameterType;
  String parameterName;
  String parameterValue;
  dynamic parameterNote;
  // dynamic createdAt;
  // dynamic updatedAt;
  // dynamic createdBy;
  // dynamic updatedBy;
  String parameterCode;
  dynamic status;
  int companyId;

  factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
        id: json["id"],
        parameterType: json["parameter_type"],
        parameterName: json["parameter_name"],
        parameterValue: json["parameter_value"],
        parameterNote: json["parameter_note"],
        // createdAt: json["created_at"],
        // updatedAt: json["updated_at"],
        // createdBy: json["created_by"],
        // updatedBy: json["updated_by"],
        parameterCode: json["parameter_code"],
        status: json["status"],
        companyId: json["company_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parameter_type": parameterType,
        "parameter_name": parameterName,
        "parameter_value": parameterValue,
        "parameter_note": parameterNote,
        // "created_at": createdAt,
        // "updated_at": updatedAt,
        // "created_by": createdBy,
        // "updated_by": updatedBy,
        "parameter_code": parameterCode,
        "status": status,
        "company_id": companyId
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["parameter_type"] = parameterType;
    map["parameter_name"] = parameterName;
    map["parameter_value"] = parameterValue;
    map["parameter_note"] = parameterNote;
    map["parameter_code"] = parameterCode;
    map["status"] = status;
    map["company_id"] = companyId;

    return map;
  }

   
}
