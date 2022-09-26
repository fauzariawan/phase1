// To parse this JSON data, do
//
//     final regionByTypeModel = regionByTypeModelFromJson(jsonString);

import 'dart:convert';

RegionByTypeModel regionByTypeModelFromJson(String str) => RegionByTypeModel.fromJson(json.decode(str));

String regionByTypeModelToJson(RegionByTypeModel data) => json.encode(data.toJson());

class RegionByTypeModel {
    RegionByTypeModel({
        required this.code,
        required this.status,
        required this.datetime,
        required this.data,
    });

    String code;
    String status;
    DateTime datetime;
    List<RegionByType> data;

    factory RegionByTypeModel.fromJson(Map<String, dynamic> json) => RegionByTypeModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<RegionByType>.from(json["data"].map((x) => RegionByType.fromJson(x))),
    );

  // int get regionId => null;

  // String get regionName => null;

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class RegionByType {
    RegionByType({
        required this.regionId,
        required this.countryId,
        required this.regionCode,
        required this.regionName,
        required this.regionType,
        required this.regionParentId,
        required this.mapRegionCode,
        required this.isRegionActive,
        required this.createdBy,
        required this.createdOn,
        required this.updatedBy,
        required this.updatedOn,
    });

    int regionId;
    int countryId;
    int regionCode;
    String regionName;
    int regionType;
    dynamic regionParentId;
    String mapRegionCode;
    dynamic isRegionActive;
    dynamic createdBy;
    dynamic createdOn;
    dynamic updatedBy;
    dynamic updatedOn;

    factory RegionByType.fromJson(Map<String, dynamic> json) => RegionByType(
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
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        updatedOn: json["updated_on"] == null ? null : json["updated_on"],
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
        "updated_by": updatedBy == null ? null : updatedBy,
        "updated_on": updatedOn == null ? null : updatedOn.toIso8601String(),
    };
}
