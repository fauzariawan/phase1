// To parse this JSON data, do
//  final workplanDokumenModel = workplanDokumenModelFromJson(jsonString);

import 'dart:convert';

WorkplanDokumenModel workplanDokumenModelFromJson(String str) => WorkplanDokumenModel.fromJson(json.decode(str));

String workplanDokumenModelToJson(WorkplanDokumenModel data) => json.encode(data.toJson());

class WorkplanDokumenModel {
    WorkplanDokumenModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<WorkplanDokumen> data;

    factory WorkplanDokumenModel.fromJson(Map<String, dynamic> json) => WorkplanDokumenModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<WorkplanDokumen>.from(json["data"].map((x) => WorkplanDokumen.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class WorkplanDokumen {
    WorkplanDokumen({
        required this.id,
        required this.workplanActivityId,
        required this.dokumenId,
        required this.dokumen,
        // required this.createdBy,
        // required this.createdAt,
        // required this.updatedBy,
        // required this.updatedAt,
        required this.companyId,
        this.dokumenBaseImg,
        this.flagUpdate
    });

    int id;
    int workplanActivityId;
    int dokumenId;
    String dokumen;
    // int createdBy;
    // DateTime createdAt;
    // int updatedBy;
    // DateTime updatedAt;
    dynamic companyId;
    dynamic dokumenBaseImg;
    dynamic flagUpdate;

    factory WorkplanDokumen.fromJson(Map<String, dynamic> json) => WorkplanDokumen(
        id: json["id"],
        workplanActivityId: json["workplan_activity_id"],
        dokumenId: json["dokumen_id"],
        dokumen: json["dokumen"],
        //createdBy: json["created_by"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        // updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        companyId: json["company_id"],
        dokumenBaseImg:json["dokumen_base_img"],
        flagUpdate:json["flag_update"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "workplan_activity_id": workplanActivityId,
        "dokumen_id": dokumenId,
        "dokumen": dokumen,
        // "created_by": createdBy,
        // "created_at": createdAt.toIso8601String(),
        // "updated_by": updatedBy == null ? null : updatedBy,
        // "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "company_id": companyId,
        "dokumen_base_img":dokumenBaseImg,
         "flag_update":flagUpdate
    };

    Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
     map["id"] = id;
     map["workplan_activity_id"] = workplanActivityId;
     map["dokumen_id"] = dokumenId;
     map["dokumen"] = dokumen;
     map["company_id"] = companyId;
     map["dokumen_base_img"] = dokumenBaseImg;
    
      return map;

    }
}
