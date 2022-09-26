// To parse this JSON data, do
//
//     final personalAddressModel = personalAddressModelFromJson(jsonString);

import 'dart:convert';

PersonalAddressModel personalAddressModelFromJson(String str) => PersonalAddressModel.fromJson(json.decode(str));

String personalAddressModelToJson(PersonalAddressModel data) => json.encode(data.toJson());

class PersonalAddressModel {
    PersonalAddressModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<PersonalAddress> data;

    factory PersonalAddressModel.fromJson(Map<String, dynamic> json) => PersonalAddressModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<PersonalAddress>.from(json["data"].map((x) => PersonalAddress.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class PersonalAddress {
    PersonalAddress({
        required this.id,
        required this.userId,
        required this.createdAt,
        required this.createdBy,
        required this.updatedAt,
        required this.updatedBy,
        required this.addressName,
        required this.address,
        required this.provinceId,
        required this.provinceDesc,
        required this.kabKotaId,
        required this.kabKotaDesc,
        required this.kecamatan,
        required this.kelurahan,
        required this.kodepos,
        required this.provinceName,
        required this.kabKotaName,
        required this.rtrw
    });

    int id;
    int userId;
    DateTime createdAt;
    int createdBy;
    dynamic updatedAt;
    dynamic updatedBy;
    String addressName;
    String address;
    int provinceId;
    dynamic provinceDesc;
    int kabKotaId;
    dynamic kabKotaDesc;
    String kecamatan;
    String kelurahan;
    String kodepos;
    String provinceName;
    String kabKotaName;
    String rtrw;

    factory PersonalAddress.fromJson(Map<String, dynamic> json) => PersonalAddress(
        id: json["id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        addressName: json["address_name"],
        address: json["address"],
        provinceId: json["province_id"],
        provinceDesc: json["province_desc"],
        kabKotaId: json["kab_kota_id"],
        kabKotaDesc: json["kab_kota_desc"],
        kecamatan: json["kecamatan"],
        kelurahan: json["kelurahan"],
        kodepos: json["kodepos"],
        provinceName: json["province_name"],
        kabKotaName: json["kab_kota_name"],
        rtrw: json["rtrw"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "address_name": addressName,
        "address": address,
        "province_id": provinceId,
        "province_desc": provinceDesc,
        "kab_kota_id": kabKotaId,
        "kab_kota_desc": kabKotaDesc,
        "kecamatan": kecamatan,
        "kelurahan": kelurahan,
        "kodepos": kodepos,
        "province_name": provinceName,
        "kab_kota_name": kabKotaName,
        "rtrw":rtrw
    };
}
