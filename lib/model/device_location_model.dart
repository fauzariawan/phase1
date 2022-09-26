// import 'dart:convert';

class DeviceLocation {
  // int id;
  String createdDate;
  String address;
  String longitude;
  String latitude;

  DeviceLocation({ required this.createdDate, required this.address,required this.longitude,required this.latitude});

  factory DeviceLocation.fromJson(Map<String, dynamic> json) => DeviceLocation(
      // id: json["id"],
      createdDate: json["created_date"],
      address: json["address"],
      longitude: json["longitude"],
      latitude: json["latitude"]);

  Map<String, dynamic> toJson() =>
      { "created_date": createdDate, "address": address, "longitude": longitude, "latitude": latitude};

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    // map["id"] = id;
    map["created_date"] = createdDate;
    map["address"] = address;
    map["longitude"] = longitude;
    map["latitude"] = latitude;
    

    return map;
  }

}
