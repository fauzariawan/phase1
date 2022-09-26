// To parse this JSON data, do
//
//     final personalTrainingModel = personalTrainingModelFromJson(jsonString);

import 'dart:convert';

PersonalTrainingModel personalTrainingModelFromJson(String str) => PersonalTrainingModel.fromJson(json.decode(str));

String personalTrainingModelToJson(PersonalTrainingModel data) => json.encode(data.toJson());

class PersonalTrainingModel {
    PersonalTrainingModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<PersonalTraining> data;

    factory PersonalTrainingModel.fromJson(Map<String, dynamic> json) => PersonalTrainingModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<PersonalTraining>.from(json["data"].map((x) => PersonalTraining.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class PersonalTraining {
    PersonalTraining({
        required this.id,
        this.createdAt,
        this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.userId,
        required this.institutionName,
        required this.trainingName,
        this.trainingDateStart,
        this.trainingDateEnd,
    });

    int id;
    dynamic createdAt;
    dynamic updatedAt;
    int createdBy;
    int updatedBy;
    int userId;
    String institutionName;
    String trainingName;
    dynamic trainingDateStart;
    dynamic trainingDateEnd;

    factory PersonalTraining.fromJson(Map<String, dynamic> json) => PersonalTraining(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"],
        userId: json["user_id"],
        institutionName: json["institution_name"],
        trainingName: json["training_name"]==null?"": json["training_name"],
        trainingDateStart: json["training_date_start"] == null ? null :DateTime.parse(json["training_date_start"]),
        trainingDateEnd: json["training_date_end"] == null ? null :DateTime.parse(json["training_date_end"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy,
        "user_id": userId,
        "institution_name": institutionName,
        "training_name": trainingName,
        "training_date_start": "${trainingDateStart.year.toString().padLeft(4, '0')}-${trainingDateStart.month.toString().padLeft(2, '0')}-${trainingDateStart.day.toString().padLeft(2, '0')}",
        "training_date_end": "${trainingDateEnd.year.toString().padLeft(4, '0')}-${trainingDateEnd.month.toString().padLeft(2, '0')}-${trainingDateEnd.day.toString().padLeft(2, '0')}",
    };
}
