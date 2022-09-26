// To parse this JSON data, do
//
//     final parameterUdfOption1Model = parameterUdfOption1ModelFromJson(jsonString);

import 'dart:convert';

ParameterUdfOptionModel parameterUdfOptionModelFromJson(String str) =>
    ParameterUdfOptionModel.fromJson(json.decode(str));

String parameterUdfOptionModelToJson(ParameterUdfOptionModel data) =>
    json.encode(data.toJson());

class ParameterUdfOptionModel {
  ParameterUdfOptionModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<ParameterUdfOption> data;

  factory ParameterUdfOptionModel.fromJson(Map<String, dynamic> json) =>
      ParameterUdfOptionModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterUdfOption>.from(
            json["data"].map((x) => ParameterUdfOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ParameterUdfOption {
  ParameterUdfOption(
      {required this.id,
      required this.companyId,
      // required this.createdAt,
      // this.createdBy,
      // this.updatedAt,
      // this.updatedBy,
      required this.optionCode,
      required this.optionDescription,
      required this.status,
      required this.udfId});

  int id;
  int companyId;
  // dynamic createdAt;
  // dynamic createdBy;
  // dynamic updatedAt;
  // dynamic updatedBy;
  String optionCode;
  String optionDescription;
  String status;
  int udfId;

  factory ParameterUdfOption.fromJson(Map<String, dynamic> json) =>
      ParameterUdfOption(
        id: json["id"],
        companyId: json["company_id"],
        // createdAt: json["created_at"]==null?null:DateTime.parse(json["created_at"]),
        // createdBy: json["created_by"],
        // updatedAt: json["updated_at"],
        // updatedBy: json["updated_by"],
        optionCode: json["option_code"],
        optionDescription: json["option_description"],
        status: json["status"],
        udfId: json["udf_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        // "created_at": createdAt.toIso8601String(),
        // "created_by": createdBy,
        // "updated_at": updatedAt,
        // "updated_by": updatedBy,
        "option_code": optionCode,
        "option_description": optionDescription,
        "status": status,
        "udf_id": udfId
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["company_id"] = companyId;
    map["option_code"] = optionCode;
    map["option_description"] = optionDescription;
    map["status"] = status;
    map["udf_id"] = udfId;

    return map;
  }
}
