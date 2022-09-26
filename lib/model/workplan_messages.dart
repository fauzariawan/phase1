// To parse this JSON data, do
//
//     final workplanMessages = workplanMessagesFromJson(jsonString);

import 'dart:convert';

WorkplanMessagesModel workplanMessagesFromJson(String str) =>
    WorkplanMessagesModel.fromJson(json.decode(str));

String workplanMessagesToJson(WorkplanMessagesModel data) =>
    json.encode(data.toJson());

class WorkplanMessagesModel {
  WorkplanMessagesModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<WorkplanMessages> data;

  factory WorkplanMessagesModel.fromJson(Map<String, dynamic> json) =>
      WorkplanMessagesModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<WorkplanMessages>.from(
            json["data"].map((x) => WorkplanMessages.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class WorkplanMessages {
  WorkplanMessages({
    required this.id,
    required this.createdAt,
    // this.updatedAt,
    // this.createdBy,
    // this.updatedBy,
    required this.userId,
    required this.body,
    required this.workplanActivityId,
    required this.companyId,
    this.username,
    this.fullName
  });

  int id;
  DateTime createdAt;
  // dynamic updatedAt;
  // int createdBy;
  // dynamic updatedBy;
  int userId;
  String body;
  int workplanActivityId;
  int companyId;
  dynamic username;
  dynamic fullName;

  factory WorkplanMessages.fromJson(Map<String, dynamic> json) =>
      WorkplanMessages(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: json["updated_at"],
        // createdBy: json["created_by"],
        // updatedBy: json["updated_by"],
        userId: json["user_id"],
        body: json["body"],
        workplanActivityId: json["workplan_activity_id"],
        companyId: json["company_id"],
        username: json["username"],
        fullName: json["full_name"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt,
        // "created_by": createdBy,
        // "updated_by": updatedBy,
        "user_id": userId,
        "body": body,
        "workplan_activity_id": workplanActivityId,
        "company_id": companyId,
        "username": username,
        "full_name":fullName
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["created_at"] = createdAt.toIso8601String();
    map["user_id"] = userId;
    map["company_id"] = companyId;
    map["body"] = body;
    map["workplan_activity_id"] = workplanActivityId;

    return map;
  }
}
