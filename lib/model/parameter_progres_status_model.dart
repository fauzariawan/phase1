// To parse this JSON data, do
//
//     final parameterProgresStatusModel = parameterProgresStatusModelFromJson(jsonString);

import 'dart:convert';

ParameterProgresStatusModel parameterProgresStatusModelFromJson(String str) => ParameterProgresStatusModel.fromJson(json.decode(str));

String parameterProgresStatusModelToJson(ParameterProgresStatusModel data) => json.encode(data.toJson());

class ParameterProgresStatusModel {
    ParameterProgresStatusModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<ParameterProgresStatus> data;

    factory ParameterProgresStatusModel.fromJson(Map<String, dynamic> json) => ParameterProgresStatusModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterProgresStatus>.from(json["data"].map((x) => ParameterProgresStatus.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ParameterProgresStatus {
    ParameterProgresStatus({
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
    // DateTime createdAt;
    // int updatedBy;
    // DateTime updatedAt;
    int status;

    factory ParameterProgresStatus.fromJson(Map<String, dynamic> json) => ParameterProgresStatus(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        companyId: json["company_id"],
        // createdBy: json["created_by"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedBy: json["updated_by"],
        // updatedAt: DateTime.parse(json["updated_at"]),
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
    map["status"] = companyId;
    
    return map;
  }
}
