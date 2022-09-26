// To parse this JSON data, do
//
//     final worplanVisitNotification = worplanVisitNotificationFromJson(jsonString);

import 'dart:convert';

WorplanVisitNotification worplanVisitNotificationFromJson(String str) => WorplanVisitNotification.fromJson(json.decode(str));

String worplanVisitNotificationToJson(WorplanVisitNotification data) => json.encode(data.toJson());

class WorplanVisitNotification {
    WorplanVisitNotification({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<Datum> data;

    factory WorplanVisitNotification.fromJson(Map<String, dynamic> json) => WorplanVisitNotification(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.id,
        required this.nomorWorkplan,
        required this.checkIn,
        required this.checkInBatas,
        required this.isCheckIn,
        required this.isCheckOut,
        required this.batasWaktu,
        required this.maxUmur,
    });

    int id;
    String nomorWorkplan;
    DateTime checkIn;
    DateTime checkInBatas;
    String isCheckIn;
    String isCheckOut;
    int batasWaktu;
    DateTime maxUmur;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nomorWorkplan: json["nomor_workplan"],
        checkIn: DateTime.parse(json["check_in"]),
        checkInBatas: DateTime.parse(json["check_in_batas"]),
        isCheckIn: json["is_check_in"],
        isCheckOut: json["is_check_out"],
        batasWaktu: json["batas_waktu"],
        maxUmur: DateTime.parse(json["max_umur"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nomor_workplan": nomorWorkplan,
        "check_in": checkIn.toIso8601String(),
        "check_in_batas": checkInBatas.toIso8601String(),
        "is_check_in": isCheckIn,
        "is_check_out": isCheckOut,
        "batas_waktu": batasWaktu,
        "max_umur": "${maxUmur.year.toString().padLeft(4, '0')}-${maxUmur.month.toString().padLeft(2, '0')}-${maxUmur.day.toString().padLeft(2, '0')}",
    };
}
