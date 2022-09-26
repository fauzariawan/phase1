// To parse this JSON data, do
//
//     final parameterHasilKunjungan = parameterHasilKunjunganFromJson(jsonString);

import 'dart:convert';

ParameterHasilKunjunganModel parameterHasilKunjunganFromJson(String str) => ParameterHasilKunjunganModel.fromJson(json.decode(str));

String parameterHasilKunjunganToJson(ParameterHasilKunjunganModel data) => json.encode(data.toJson());

class ParameterHasilKunjunganModel {
    ParameterHasilKunjunganModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<ParameterHasilKunjungan> data;

    factory ParameterHasilKunjunganModel.fromJson(Map<String, dynamic> json) => ParameterHasilKunjunganModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterHasilKunjungan>.from(json["data"].map((x) => ParameterHasilKunjungan.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ParameterHasilKunjungan {
    ParameterHasilKunjungan({
        required this.id,
        required this.code,
        required this.description,
        required this.companyId,
        // required this.createdBy,
        // this.createdAt,
        // required this.updatedBy,
        // this.updatedAt,
        required this.status,
        required this.idAktifitas,
        required this.idKategoriProduk,
        required this.idProduk,
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
    int idAktifitas;
    int idKategoriProduk;
    int idProduk;

    factory ParameterHasilKunjungan.fromJson(Map<String, dynamic> json) => ParameterHasilKunjungan(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        companyId: json["company_id"],
        // createdBy: json["created_by"],
        // createdAt: json["created_at"] == null ? null :DateTime.parse(json["created_at"]),
        // updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        // updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        status: json["status"],
        idAktifitas: json["id_aktifitas"],
        idKategoriProduk: json["id_kategori_produk"],
        idProduk: json["id_produk"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "company_id": companyId,
        // "created_by": createdBy,
        // "created_at": createdAt.toIso8601String(),
        // "updated_by": updatedBy == null ? null : updatedBy,
        // "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "status": status,
        "id_aktifitas": idAktifitas,
        "id_kategori_produk": idKategoriProduk,
        "id_produk": idProduk,
    };

    Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["code"] = code;
    map["description"] = description;
    map["company_id"] = companyId;
    map["status"] = status;
    map["id_aktifitas"] = idAktifitas;
    map["id_kategori_produk"] = idKategoriProduk;
    map["id_produk"] = idProduk;

    return map;
  }
}
