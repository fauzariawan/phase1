// To parse this JSON data, do
//
//     final VisitChecInLogModel = VisitChecInLogModelFromJson(jsonString);

import 'dart:convert';

VisitChecInLogModel visitChecInLogModelFromJson(String str) =>
    VisitChecInLogModel.fromJson(json.decode(str));

String visitChecInLogModelToJson(VisitChecInLogModel data) =>
    json.encode(data.toJson());

class VisitChecInLogModel {
  VisitChecInLogModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<VisitChecInLog> data;

  factory VisitChecInLogModel.fromJson(Map<String, dynamic> json) =>
      VisitChecInLogModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<VisitChecInLog>.from(
            json["data"].map((x) => VisitChecInLog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

//await db.execute("CREATE TABLE visit_checkin_log (visit_id INTEGER PRIMARY KEY, check_in TEXT, check_in_batas TEXT, batas_waktu INTEGER)");
class VisitChecInLog {
  VisitChecInLog({
    required this.visitId,
    required this.checkIn,
    required this.checkInBatas,
    required this.batasWaktu,
    required this.nomorWorkplan
  });

  int visitId;
  String checkIn;
  String checkInBatas;
  int batasWaktu;
  String nomorWorkplan;

  factory VisitChecInLog.fromJson(Map<String, dynamic> json) => VisitChecInLog(
        visitId: json["visit_id"],
        checkIn: json["check_in"],
        checkInBatas: json["check_in_batas"],
        batasWaktu: json["batas_waktu"],
        nomorWorkplan:json["nomor_workplan"]
      );

  Map<String, dynamic> toJson() => {
        "visit_id": visitId,
        "check_in": checkIn,
        "check_in_batas": checkInBatas,
        "batas_waktu": batasWaktu,
       "nomor_workplan":nomorWorkplan
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["visit_id"] = visitId;
    map["check_in"] = checkIn;
    map["check_in_batas"] = checkInBatas;
    map["batas_waktu"] = batasWaktu;
    map["nomor_workplan"] = nomorWorkplan;

    return map;
  }
}
