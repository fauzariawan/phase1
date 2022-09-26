// To parse this JSON data, do
//
//     final workplanVisitModel = workplanVisitModelFromJson(jsonString);

import 'dart:convert';

WorkplanVisitModel workplanVisitModelFromJson(String str) =>
    WorkplanVisitModel.fromJson(json.decode(str));

String workplanVisitModelToJson(WorkplanVisitModel data) =>
    json.encode(data.toJson());

class WorkplanVisitModel {
  WorkplanVisitModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<WorkplanVisit> data;

  factory WorkplanVisitModel.fromJson(Map<String, dynamic> json) =>
      WorkplanVisitModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<WorkplanVisit>.from(
            json["data"].map((x) => WorkplanVisit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class WorkplanVisit {
  WorkplanVisit({
    required this.id,
    required this.workplanNo,
    required this.userCompanyId,
    required this.companyId,
    required this.activitiesId,
    required this.clientId,
    required this.firstVisit,
    required this.checkIn,
    required this.checkOut,
    required this.note,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.checkInLatitude,
    required this.checkInLongitude,
    required this.checkOutLatitude,
    required this.checkOutLongitude,
    required this.addressCheckOut,
    required this.timezone,
    required this.addressCheckIn,
    this.photoCheckIn,
    this.photoCheckOut,
    required this.visitPurposeId,
    required this.visitResultId,
    required this.workplanActivityId,
    this.visitDatePlan,
    this.visitDateActual,
    required this.visitPurposeCode,
    required this.visitPurposeDescription,
    required this.visitResultCode,
    required this.visitResultDescription,
    required this.isCheckIn,
    required this.isCheckOut,
    required this.batasWaktu,
    this.checkInBatas,
    this.baseImageCheckIn,
    this.baseImageCheckOut,
    required this.flagUpdate,
    required this.updatedBy,
    required this.checkInDesc1,
    required this.checkInDesc2,
  });

  int id;
  String workplanNo;
  int userCompanyId;
  int companyId;
  int activitiesId;
  int clientId;
  dynamic firstVisit;
  dynamic checkIn;
  dynamic checkOut;
  String? note;
  int status;
  dynamic createdAt;
  dynamic updatedAt;
  String checkInLatitude;
  String checkInLongitude;
  String checkOutLatitude;
  String checkOutLongitude;
  String addressCheckOut;
  String timezone;
  String addressCheckIn;
  dynamic photoCheckIn;
  dynamic photoCheckOut;
  int visitPurposeId;
  int visitResultId;
  int workplanActivityId;
  dynamic visitDatePlan;
  dynamic visitDateActual;
  String visitPurposeCode;
  String visitPurposeDescription;
  String visitResultCode;
  String visitResultDescription;
  String isCheckIn;
  String isCheckOut;
  int batasWaktu;
  dynamic checkInBatas;
  dynamic baseImageCheckIn;
  dynamic baseImageCheckOut;
  int flagUpdate;
  int updatedBy;
  String? checkInDesc1;
  String? checkInDesc2;

  factory WorkplanVisit.fromJson(Map<String, dynamic> json) => WorkplanVisit(
        id: json["id"],
        workplanNo: json["workplan_no"] == null ? null : json["workplan_no"],
        userCompanyId: json["user_company_id"],
        companyId: json["company_id"],
        activitiesId: json["activities_id"],
        clientId: json["client_id"],
        firstVisit: json["first_visit"] == null || json["first_visit"] == ""
            ? null
            : DateTime.parse(json["first_visit"]),
        checkIn: json["check_in"] == null || json["check_in"] == ""
            ? null
            : DateTime.parse(json["check_in"]),
        checkOut: json["check_out"] == null || json["check_out"] == ""
            ? null
            : DateTime.parse(json["check_out"]),
        note: json["note"],
        status: json["status"],
        createdAt: json["created_at"] == null || json["created_at"] == ""
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null || json["updated_at"] == ""
            ? null
            : DateTime.parse(json["updated_at"]),
        checkInLatitude: json["check_in_latitude"],
        checkInLongitude: json["check_in_longitude"],
        checkOutLatitude: json["check_out_latitude"],
        checkOutLongitude: json["check_out_longitude"],
        addressCheckOut: json["address_check_out"],
        timezone: json["timezone"],
        addressCheckIn: json["address_check_in"],
        photoCheckIn: json["photo_check_in"],
        photoCheckOut: json["photo_check_out"],
        visitPurposeId: json["visit_purpose_id"],
        visitResultId: json["visit_result_id"],
        workplanActivityId: json["workplan_activity_id"],
        visitDatePlan:
            json["visit_date_plan"] == null || json["visit_date_plan"] == ""
                ? null
                : DateTime.parse(json["visit_date_plan"]),
        visitDateActual:
            json["visit_date_actual"] == null || json["visit_date_actual"] == ""
                ? null
                : DateTime.parse(json["visit_date_actual"]),
        visitPurposeCode: json["visit_purpose_code"],
        visitPurposeDescription: json["visit_purpose_description"],
        visitResultCode: json["visit_result_code"],
        visitResultDescription: json["visit_result_description"],
        isCheckIn: json["is_check_in"],
        isCheckOut: json["is_check_out"],
        batasWaktu: json["batas_waktu"],
        checkInBatas:
            json["check_in_batas"] == null || json["check_in_batas"] == ""
                ? null
                : DateTime.parse(json["check_in_batas"]),
        baseImageCheckIn: json["base_image_check_in"],
        baseImageCheckOut: json["base_image_check_out"],
        flagUpdate: json["flag_update"],
        updatedBy: json["updated_by"],
        checkInDesc1: json["check_in_desc_1"],
        checkInDesc2: json["check_in_desc_2"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "workplan_no": workplanNo,
        "user_company_id": userCompanyId,
        "company_id": companyId,
        "activities_id": activitiesId,
        "client_id": clientId,
        "first_visit": firstVisit == null ? null : firstVisit.toIso8601String(),
        "check_in": checkIn == null ? null : checkIn.toIso8601String(),
        "check_out": checkOut == null ? null : checkOut.toIso8601String(),
        "note": note,
        "status": status,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "check_in_latitude": checkInLatitude,
        "check_in_longitude": checkInLongitude,
        "check_out_latitude": checkOutLatitude,
        "check_out_longitude": checkOutLongitude,
        "address_check_out": addressCheckOut,
        "timezone": timezone,
        "address_check_in": addressCheckIn,
        "photo_check_in": photoCheckIn,
        "photo_check_out": photoCheckOut,
        "visit_purpose_id": visitPurposeId,
        "visit_result_id": visitResultId,
        "workplan_activity_id": workplanActivityId,
        "visit_date_plan":
            visitDatePlan == null ? null : visitDatePlan.toIso8601String(),
        "visit_date_actual":
            visitDateActual == null ? null : visitDateActual.toIso8601String(),
        "visit_purpose_code": visitPurposeCode,
        "visit_purpose_description": visitPurposeDescription,
        "visit_result_code": visitResultCode,
        "visit_result_description": visitResultDescription,
        "is_check_in": isCheckIn,
        "is_check_out": isCheckOut,
        "batas_waktu": batasWaktu,
        "check_in_batas":
            checkInBatas == null ? null : checkInBatas.toIso8601String(),
        "base_image_check_in": baseImageCheckIn,
        "base_image_check_out": baseImageCheckOut,
        "flag_update": flagUpdate,
        "updated_by": updatedBy,
        "check_in_desc_1": checkInDesc1,
        "check_in_desc_2": checkInDesc2,
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["workplan_no"] = workplanNo;
    map["user_company_id"] = userCompanyId;
    map["company_id"] = companyId;
    map["activities_id"] = activitiesId;
    map["client_id"] = clientId;
    map["first_visit"] = firstVisit == null ? "" : firstVisit.toString();
    map["check_in"] = checkIn == null ? "" : checkIn.toString();
    map["check_out"] = checkOut == null ? "" : checkOut.toString();
    map["note"] = note;
    map["status"] = status;
    map["created_at"] = createdAt == null ? "" : createdAt.toString();
    map["updated_at"] = updatedAt == null ? "" : updatedAt.toString();
    map["check_in_latitude"] = checkInLatitude;
    map["check_in_longitude"] = checkInLongitude;
    map["check_out_latitude"] = checkOutLatitude;
    map["check_out_longitude"] = checkOutLongitude;
    map["address_check_out"] = addressCheckOut;
    map["timezone"] = timezone;
    map["address_check_in"] = addressCheckIn;
    map["photo_check_in"] = photoCheckIn;
    map["photo_check_out"] = photoCheckOut;
    map["visit_purpose_id"] = visitPurposeId;
    map["visit_result_id"] = visitResultId;
    map["workplan_activity_id"] = workplanActivityId;
    map["visit_date_plan"] =
        visitDatePlan == null ? "" : visitDatePlan.toString();
    map["visit_date_actual"] =
        visitDateActual == null ? "" : visitDateActual.toString();
    map["visit_purpose_code"] = visitPurposeCode;
    map["visit_purpose_description"] = visitPurposeDescription;
    map["visit_result_code"] = visitResultCode;
    map["visit_result_description"] = visitResultDescription;
    map["is_check_in"] = isCheckIn;
    map["is_check_out"] = isCheckOut;
    map["batas_waktu"] = batasWaktu;
    map["check_in_batas"] = checkInBatas == null ? "" : checkInBatas.toString();
    map["base_image_check_in"] = baseImageCheckIn;
    map["base_image_check_out"] = baseImageCheckOut;
    map["flag_update"] = flagUpdate;
    map["updated_by"] = updatedBy;
    map["check_in_desc_1"] = checkInDesc1;
    map["check_in_desc_2"] = checkInDesc2;
    return map;
  }
}
