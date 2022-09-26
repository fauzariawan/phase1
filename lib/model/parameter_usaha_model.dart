// To parse this JSON data, do
//
//     final parameterUsahaModel = parameterUsahaModelFromJson(jsonString);

import 'dart:convert';

ParameterUsahaModel parameterUsahaModelFromJson(String str) =>
    ParameterUsahaModel.fromJson(json.decode(str));

String parameterUsahaModelToJson(ParameterUsahaModel data) =>
    json.encode(data.toJson());

class ParameterUsahaModel {
  ParameterUsahaModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<ParameterUsaha> data;

  factory ParameterUsahaModel.fromJson(Map<String, dynamic> json) =>
      ParameterUsahaModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterUsaha>.from(
            json["data"].map((x) => ParameterUsaha.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ParameterUsaha {
  ParameterUsaha({
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
  int companyId;
  // int createdBy;
  // dynamic createdAt;
  // int updatedBy;
  // dynamic updatedAt;
  int status;

  factory ParameterUsaha.fromJson(Map<String, dynamic> json) => ParameterUsaha(
        id: json["id"],
        code: json["code"] == null ? null : json["code"],
        description: json["description"],
        companyId: json["company_id"],
        // createdBy: json["created_by"],
        // createdAt: json["created_at"] == null
        //     ? null
        //     : DateTime.parse(json["created_at"]),
        // updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        // updatedAt: json["updated_at"] == null
        //     ? null
        //     : DateTime.parse(json["updated_at"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "company_id": companyId,
        // "created_by": createdBy,
        // "created_at": createdAt.toIso8601String(),
        // "updated_by": updatedBy,
        // "updated_at": updatedAt.toIso8601String(),
        "status": status,
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["code"] = code;
    map["description"] = description;
    map["company_id"] = companyId;
    map["status"] = status;
    return map;
  }
}
