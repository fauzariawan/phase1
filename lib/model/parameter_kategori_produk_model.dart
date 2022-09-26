// To parse this JSON data, do
//
//     final parameterKategoriProdukModel = parameterKategoriProdukModelFromJson(jsonString);

import 'dart:convert';

ParameterKategoriProdukModel parameterKategoriProdukModelFromJson(String str) =>
    ParameterKategoriProdukModel.fromJson(json.decode(str));

String parameterKategoriProdukModelToJson(ParameterKategoriProdukModel data) =>
    json.encode(data.toJson());

class ParameterKategoriProdukModel {
  ParameterKategoriProdukModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<ParameterKategoriProduk> data;

  factory ParameterKategoriProdukModel.fromJson(Map<String, dynamic> json) =>
      ParameterKategoriProdukModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterKategoriProduk>.from(
            json["data"].map((x) => ParameterKategoriProduk.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ParameterKategoriProduk {
  ParameterKategoriProduk({
    required this.id,
    required this.code,
    required this.description,
    required this.companyId,
    // required this.createdBy,
    // required this.createdAt,
    // required this.updatedBy,
    // required this.updatedAt,
    required this.status,
    required this.codeAktifitas,
    required this.activityId,
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
  String codeAktifitas;
  int activityId;

  factory ParameterKategoriProduk.fromJson(Map<String, dynamic> json) =>
      ParameterKategoriProduk(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        companyId: json["company_id"],
        // createdBy: json["created_by"],
        // createdAt: json["created_at"]==null?null:DateTime.parse(json["created_at"]),
        // updatedBy: json["updated_by"],
        // updatedAt: json["updated_at"]==null?null:DateTime.parse(json["updated_at"]),
        status: json["status"],
        codeAktifitas: json["code_aktifitas"],
        activityId: json["activity_id"],
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
        "code_aktifitas": codeAktifitas,
        "activity_id": activityId,
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["code"] = code;
    map["description"] = description;
    map["company_id"] = companyId;
    map["status"] = status;
    map["code_aktifitas"] = codeAktifitas;
    map["activity_id"] = activityId;

    return map;
  }
}
