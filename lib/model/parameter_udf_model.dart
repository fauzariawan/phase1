// To parse this JSON data, do
//
//     final parameterUdfModel = parameterUdfModelFromJson(jsonString);

import 'dart:convert';

ParameterUdfModel parameterUdfModelFromJson(String str) =>
    ParameterUdfModel.fromJson(json.decode(str));

String parameterUdfModelToJson(ParameterUdfModel data) =>
    json.encode(data.toJson());

class ParameterUdfModel {
  ParameterUdfModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<ParameterUdf> data;

  factory ParameterUdfModel.fromJson(Map<String, dynamic> json) =>
      ParameterUdfModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterUdf>.from(json["data"].map((x) => ParameterUdf.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ParameterUdf {
  ParameterUdf({
    required this.id,
    required this.udfName,
    required this.udfType,
    required this.udfDescription,
    required this.companyId,
    //required this.modul,
    // this.createdBy,
    // this.createdAt,
    // required this.updatedBy,
    // required this.updatedAt,
  });

  int id;
  String udfName;
  String udfType;
  String udfDescription;
  int companyId;
  //String modul;
  // dynamic createdBy;
  // dynamic createdAt;
  // String updatedBy;
  // dynamic updatedAt;

  factory ParameterUdf.fromJson(Map<String, dynamic> json) => ParameterUdf(
        id: json["id"],
        udfName: json["udf_name"],
        udfType: json["udf_type"],
        udfDescription: json["udf_description"],
        companyId: json["company_id"],
        //modul: json["modul"],
        // createdBy: json["created_by"],
        // createdAt: json["created_at"],
        // updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        // updatedAt: json["updated_at"] == null? null: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "udf_name": udfName,
        "udf_type": udfType,
        "udf_description": udfDescription,
        "company_id": companyId,
        //"modul": modul,
        // "created_by": createdBy,
        // "created_at": createdAt,
        // "updated_by": updatedBy == null ? null : updatedBy,
        // "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["udf_name"] = udfName;
    map["udf_type"] = udfType;
    map["udf_description"] = udfDescription;
    map["company_id"] = companyId;
  //  map["modul"] = modul;
    // map["created_by"] = createdBy;
    // map["created_at"] = createdAt;
    // map["updated_by"] = updatedBy;
    // map["updated_at"] = updatedAt;

    return map;
  }
}
