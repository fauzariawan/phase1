// To parse this JSON data, do
//
//     final noticeModel = noticeModelFromJson(jsonString);

import 'dart:convert';

EnvModel envModelFromJson(String str) =>
    EnvModel.fromJson(json.decode(str));

String envModelToJson(EnvModel data) => json.encode(data.toJson());

class EnvModel {
  EnvModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<Env> data;

  factory EnvModel.fromJson(Map<String, dynamic> json) => EnvModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<Env>.from(json["data"].map((x) => Env.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Env {
  Env({
    required this.name,
    required this.value,
    
  });

  String name;
  String value;
 

  factory Env.fromJson(Map<String, dynamic> json) => Env(
        name: json["name"],
        value: json["value"],
        
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["name"] = name;
    map["value"] = value;
    
    return map;
    
  }
}
