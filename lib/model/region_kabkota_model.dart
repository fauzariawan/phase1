// To parse this JSON data, do
//
//     final regionKabKotaModel = regionKabKotaModelFromJson(jsonString);

import 'dart:convert';

RegionKabKotaModel regionKabKotaModelFromJson(String str) => RegionKabKotaModel.fromJson(json.decode(str));

String regionKabKotaModelToJson(RegionKabKotaModel data) => json.encode(data.toJson());

class RegionKabKotaModel {
    RegionKabKotaModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<RegionKabKota> data;

    factory RegionKabKotaModel.fromJson(Map<String, dynamic> json) => RegionKabKotaModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<RegionKabKota>.from(json["data"].map((x) => RegionKabKota.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class RegionKabKota {
    RegionKabKota({
        required this.regionId,
        required this.countryId,
        required this.regionCode,
        required this.regionName,
        required this.regionType,
        required this.regionParentId,
        required this.mapRegionCode,
        this.isRegionActive,
        this.createdBy,
        this.createdOn,
        this.updatedBy,
        this.updatedOn,
    });

    int regionId;
    int countryId;
    int regionCode;
    String regionName;
    int regionType;
    int regionParentId;
    String mapRegionCode;
    dynamic isRegionActive;
    dynamic createdBy;
    dynamic createdOn;
    dynamic updatedBy;
    dynamic updatedOn;

    factory RegionKabKota.fromJson(Map<String, dynamic> json) => RegionKabKota(
        regionId: json["region_id"],
        countryId: json["country_id"],
        regionCode: json["region_code"],
        regionName: json["region_name"],
        regionType: json["region_type"],
        regionParentId: json["region_parent_id"],
        mapRegionCode: json["map_region_code"],
        isRegionActive: json["is_region_active"],
        createdBy: json["created_by"],
        createdOn: json["created_on"],
        updatedBy: json["updated_by"],
        updatedOn: json["updated_on"],
    );

    Map<String, dynamic> toJson() => {
        "region_id": regionId,
        "country_id": countryId,
        "region_code": regionCode,
        "region_name": regionName,
        "region_type": regionType,
        "region_parent_id": regionParentId,
        "map_region_code": mapRegionCode,
        "is_region_active": isRegionActive,
        "created_by": createdBy,
        "created_on": createdOn,
        "updated_by": updatedBy,
        "updated_on": updatedOn,
    };
}
