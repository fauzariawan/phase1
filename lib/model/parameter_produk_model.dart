// To parse this JSON data, do
//
//     final parameterProdukModel = parameterProdukModelFromJson(jsonString);

import 'dart:convert';

ParameterProdukModel parameterProdukModelFromJson(String str) => ParameterProdukModel.fromJson(json.decode(str));

String parameterProdukModelToJson(ParameterProdukModel data) => json.encode(data.toJson());

class ParameterProdukModel {
    ParameterProdukModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<ParameterProduk> data;

    factory ParameterProdukModel.fromJson(Map<String, dynamic> json) => ParameterProdukModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<ParameterProduk>.from(json["data"].map((x) => ParameterProduk.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ParameterProduk {
    ParameterProduk({
        required this.id,
        required this.code,
        required this.description,
        required this.companyId,
        // required this.createdBy,
        // required this.createdAt,
        //required this.updatedBy,
        // this.updatedAt,
        required this.status,
        required this.codeAktifitas,
        required this.codeKategoriProduk,
        required this.kategoriProdukId,
    });

    int id;
    String code;
    String description;
    int companyId;
    // int createdBy;
    // dynamic createdAt;
    //int updatedBy;
    // dynamic updatedAt;
    int status;
    String codeAktifitas;
    String codeKategoriProduk;
    int kategoriProdukId;

    factory ParameterProduk.fromJson(Map<String, dynamic> json) => ParameterProduk(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        companyId: json["company_id"],
        // createdBy: json["created_by"],
        // createdAt: json["created_at"]==null?null:DateTime.parse(json["created_at"]),
       // updatedBy: json["updated_by"],
        // updatedAt: json["updated_at"],
        status: json["status"],
        codeAktifitas: json["code_aktifitas"],
        codeKategoriProduk: json["code_kategori_produk"],
        kategoriProdukId: json["kategori_produk_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "company_id": companyId,
        // "created_by": createdBy,
        // "created_at": createdAt.toIso8601String(),
        //"updated_by": updatedBy,
        // "updated_at": updatedAt,
        "status": status,
        "code_aktifitas": codeAktifitas,
        "code_kategori_produk": codeKategoriProduk,
        "kategori_produk_id": kategoriProdukId,
    };

    Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["code"] = code;
    map["description"] = description;
    map["company_id"] = companyId;
    map["status"] = status;
    map["code_aktifitas"] = codeAktifitas;
    map["code_kategori_produk"] =  codeKategoriProduk;
    map["kategori_produk_id"] = kategoriProdukId;

    return map;
  }
}
