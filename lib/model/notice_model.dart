// To parse this JSON data, do
//
//     final noticeModel = noticeModelFromJson(jsonString);

import 'dart:convert';

NoticeModel noticeModelFromJson(String str) =>
    NoticeModel.fromJson(json.decode(str));

String noticeModelToJson(NoticeModel data) => json.encode(data.toJson());

class NoticeModel {
  NoticeModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<Notice> data;

  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<Notice>.from(json["data"].map((x) => Notice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Notice {
  Notice({
    required this.id,
    required this.noticeType,
    required this.noticeTitle,
    required this.noticeBody,
    required this.status,
    required this.createdAt,
    // required this.updatedBy,
    // required this.updatedAt,
    // required this.createdBy,
    required this.companyId,
    required this.receiveId,
    required this.mediaType,
    // required this.startDate,
    // required this.endDate,
    required this.createdName,
    required this.noticeTypeCode,
    required this.mediaTypeCode,
    required this.isRead,
    required this.createdUsername
  });

  int id;
  int noticeType;
  String noticeTitle;
  String noticeBody;
  int status;
  dynamic createdAt;
  // dynamic updatedBy;
  // dynamic updatedAt;
  // int createdBy;
  int companyId;
  int receiveId;
  int mediaType;
  // DateTime startDate;
  // DateTime endDate;
  String createdName;
  String noticeTypeCode;
  String mediaTypeCode;
  String isRead;
  String createdUsername;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json["id"],
        noticeType: json["notice_type"],
        noticeTitle: json["notice_title"],
        noticeBody: json["notice_body"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        // updatedBy: json["updated_by"],
        // updatedAt: json["updated_at"] == null
        //     ? null
        //     : DateTime.parse(json["updated_at"]),
        // createdBy: json["created_by"],
        companyId: json["company_id"],
        receiveId: json["receive_id"],
        mediaType: json["media_type"],
        // startDate: DateTime.parse(json["start_date"]),
        // endDate: DateTime.parse(json["end_date"]),
        createdName: json["created_name"],
        noticeTypeCode: json["notice_type_code"],
        mediaTypeCode: json["media_type_code"],
        isRead:json["is_read"],
        createdUsername:json["created_username"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notice_type": noticeType,
        "notice_title": noticeTitle,
        "notice_body": noticeBody,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        // "updated_by": updatedBy,
        // "updated_at": updatedAt,
        // "created_by": createdBy,
        "company_id": companyId,
        "receive_id": receiveId,
        "media_type": mediaType,
        // "start_date":
        //     "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        // "end_date":
        //     "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "created_name": createdName,
        "notice_type_code": noticeTypeCode,
        "media_type_code": mediaTypeCode,
        "is_read":isRead,
        "created_username":createdUsername
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["notice_type"] = noticeType;
    map["notice_title"] = noticeTitle;
    map["notice_body"] = noticeBody;
    map["status"] = status;
    map["created_at"] = createdAt==null?"":createdAt.toString();
    // map["updated_by"] = updatedBy;
    // map["updated_at"] = updatedAt;
    // map["created_by"] = createdBy;
    map["company_id"] = companyId;
    map["receive_id"] = receiveId;
    map["media_type"] = mediaType;
    // map["start_date"] = startDate;
    // map["end_date"] = endDate;
    map["created_name"] = createdName;
    map["notice_type_code"] = noticeTypeCode;
    map["media_type_code"] = mediaTypeCode;
    map["is_read"] = isRead;
    map["created_username"] =createdUsername;
    return map;
    
  }
}
