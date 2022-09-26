// To parse this JSON data, do
//
//     final menuOtorizeModel = menuOtorizeModelFromJson(jsonString);

import 'dart:convert';

MenuOtorizeModel menuOtorizeModelFromJson(String str) =>
    MenuOtorizeModel.fromJson(json.decode(str));

String menuOtorizeModelToJson(MenuOtorizeModel data) =>
    json.encode(data.toJson());

class MenuOtorizeModel {
  MenuOtorizeModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<MenuOtorize> data;

  factory MenuOtorizeModel.fromJson(Map<String, dynamic> json) =>
      MenuOtorizeModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<MenuOtorize>.from(
            json["data"].map((x) => MenuOtorize.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MenuOtorize {
  MenuOtorize({
    required this.menuId,
    required this.menuName,
    required this.menuDesc,
    // this.menuUrl,
    // this.menuIcon,
    // this.menuIsParent,
    // this.menuParent,
    // this.menuStatus,
    // this.menuOrder,
    // this.createdBy,
    // this.createdAt,
    // this.updatedBy,
    // this.updatedAt,
    // this.deletedBy,
    // this.deletedAt,
    // this.onlyAdmin,
    // this.menuType,
    required this.canRead,
    required this.canWrite,
    required this.canUpdate,
    required this.canApprove,
    required this.menuCode
  });

  int menuId;
  String menuName;
  String menuDesc;
  // String menuUrl;
  // dynamic menuIcon;
  // String menuIsParent;
  // int menuParent;
  // String menuStatus;
  // int menuOrder;
  // dynamic createdBy;
  // DateTime createdAt;
  // dynamic updatedBy;
  // dynamic updatedAt;
  // dynamic deletedBy;
  // dynamic deletedAt;
  // int onlyAdmin;
  // int menuType;
  int canRead;
  int canWrite;
  int canUpdate;
  int canApprove;
  String menuCode;

  factory MenuOtorize.fromJson(Map<String, dynamic> json) => MenuOtorize(
        menuId: json["menu_id"],
        menuName: json["menu_name"],
        menuDesc: json["menu_desc"],
        // menuUrl: json["menu_url"],
        // menuIcon: json["menu_icon"],
        // menuIsParent: json["menu_is_parent"],
        // menuParent: json["menu_parent"],
        // menuStatus: json["menu_status"],
        // menuOrder: json["menu_order"],
        // createdBy: json["created_by"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedBy: json["updated_by"],
        // updatedAt: json["updated_at"],
        // deletedBy: json["deleted_by"],
        // deletedAt: json["deleted_at"],
        // onlyAdmin: json["only_admin"],
        // menuType: json["menu_type"],
        canRead: json["can_read"],
        canWrite: json["can_write"],
        canUpdate: json["can_update"],
        canApprove: json["can_approve"],
        menuCode: json["menu_code"],
      );

  Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "menu_name": menuName,
        "menu_desc": menuDesc,
        // "menu_url": menuUrl,
        // "menu_icon": menuIcon,
        // "menu_is_parent": menuIsParent,
        // "menu_parent": menuParent,
        // "menu_status": menuStatus,
        // "menu_order": menuOrder,
        // "created_by": createdBy,
        // "created_at": createdAt.toIso8601String(),
        // "updated_by": updatedBy,
        // "updated_at": updatedAt,
        // "deleted_by": deletedBy,
        // "deleted_at": deletedAt,
        // "only_admin": onlyAdmin,
        // "menu_type": menuType,
        "can_read": canRead,
        "can_write": canWrite,
        "can_update": canUpdate,
        "can_approve": canApprove,
         "menu_code": menuCode,
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["menu_id"] = menuId;
    map["menu_name"] = menuName;
    map["menu_desc"] = menuDesc;
    map["can_read"] = canRead;
    map["can_write"] = canWrite;
    map["can_update"] = canUpdate;
    map["can_approve"] = canApprove;
    map["menu_code"] = menuCode;

    return map;
  }
}
