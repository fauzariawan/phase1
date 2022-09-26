// To parse this JSON data, do
//
//     final parameterActivityModel = parameterActivityModelFromJson(jsonString);

import 'dart:convert';

ParameterActivityModel parameterActivityModelFromJson(String str) =>
    ParameterActivityModel.fromJson(json.decode(str));

String parameterActivityModelToJson(ParameterActivityModel data) =>
    json.encode(data.toJson());

class ParameterActivityModel {
  ParameterActivityModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<ParameterActivity> data;

  factory ParameterActivityModel.fromJson(Map<String, dynamic> json) =>
      ParameterActivityModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterActivity>.from(
            json["data"].map((x) => ParameterActivity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ParameterActivity {
  ParameterActivity({
    required this.id,
    required this.code,
    required this.description,
    required this.companyId,
    // required this.createdBy,
    // required this.createdAt,
    // required this.updatedBy,
    // required this.updatedAt,
    required this.status,
    required this.batasWaktu,
    required this.maksimalUmur,
    required this.flag,
  });

  int id;
  String code;
  String description;
  int companyId;
  // String createdBy;
  // dynamic createdAt;
  // String updatedBy;
  // dynamic updatedAt;
  int status;
  int batasWaktu;
  int maksimalUmur;
  int flag;

  factory ParameterActivity.fromJson(Map<String, dynamic> json) =>
      ParameterActivity(
          id: json["id"],
          code: json["code"],
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
          batasWaktu: json["batas_waktu"],
          maksimalUmur: json["maksimal_umur"],
          flag: json["flag"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "company_id": companyId,
        "status": status,
        "batas_waktu": batasWaktu,
        "maksimal_umur": maksimalUmur,
        "flag": flag
        // "created_by": createdBy,
        // "created_at": createdAt.toIso8601String(),
        // "updated_by": updatedBy == null ? null : updatedBy,
        // "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["code"] = code;
    map["description"] = description;
    map["company_id"] = companyId;
    map["status"] = status;
    map["batas_waktu"] = batasWaktu;
    map["maksimal_umur"] = maksimalUmur;
    map["flag"] = flag;

    return map;
  }
}
