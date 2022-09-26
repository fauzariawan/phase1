// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<User> data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class User {
  User(
      {required this.id,
      required this.email,
      required this.encryptedPassword,
      // this.resetPasswordToken,
      // this.resetPasswordSentAt,
      // this.rememberCreatedAt,
      // required this.signInCount,
      // required this.currentSignInAt,
      // required this.lastSignInAt,
      // required this.currentSignInIp,
      // required this.lastSignInIp,
      // this.confirmationToken,
      // this.confirmedAt,
      // this.confirmationSentAt,
      // this.unconfirmedEmail,
      // this.createdAt,
      // required this.updatedAt,
      required this.username,
      // this.isReadValue,
      // this.language,
      // required this.isActiveInt,
      // this.image,
      required this.fullName,
      // this.isTakeTour,
      // required this.lastActiveAt,
      // required this.isOnline,
      // required this.isLock,
      // this.pin,
      // this.isUsePin,
      // this.timeLock,
      // this.lockedCount,
      // required this.companyId,
      // required this.updatedBy,
      // required this.userRoleId,
      this.phone,
      // this.createdBy,
      required this.languageType,
      required this.companyCode,
      required this.isBiometrik,
      required this.organizationId,
      required this.functionId,
      required this.structureId,
      required this.employeeStatus,
      required this.userCompanyId,
      required this.packageType,
      required this.roleId,
      required this.isLoginMobile,
      required this.timeoutLogin,
      this.lastSignInAt,
      required this.resignFlag,
      this.resignDate,
      required this.deviceId});

  int id;
  String email;
  String encryptedPassword;
  // dynamic resetPasswordToken;
  // dynamic resetPasswordSentAt;
  // dynamic rememberCreatedAt;
  // int signInCount;
  // dynamic currentSignInAt;
  // dynamic lastSignInAt;
  // String currentSignInIp;
  // String lastSignInIp;
  // dynamic confirmationToken;
  // dynamic confirmedAt;
  // dynamic confirmationSentAt;
  // dynamic unconfirmedEmail;
  // dynamic createdAt;
  // dynamic updatedAt;
  String username;
  // dynamic isReadValue;
  // dynamic language;
  // int isActiveInt;
  // dynamic image;
  String fullName;
  // dynamic isTakeTour;
  // dynamic lastActiveAt;
  // bool isOnline;
  // bool isLock;
  // dynamic pin;
  // dynamic isUsePin;
  // dynamic timeLock;
  // dynamic lockedCount;
  int userCompanyId;
  //int updatedBy;
  //int userRoleId;
  dynamic phone;
  //dynamic createdBy;
  int languageType;
  String companyCode;
  String isBiometrik;
  int organizationId;
  int functionId;
  int structureId;
  int employeeStatus;
  int packageType;
  int roleId;
  String isLoginMobile;
  int timeoutLogin;
  dynamic lastSignInAt;
  int resignFlag;
  dynamic resignDate;
  String deviceId;
  // int userCompanyId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        encryptedPassword: json["encrypted_password"],
        // resetPasswordToken: json["reset_password_token"],
        // resetPasswordSentAt: json["reset_password_sent_at"],
        // rememberCreatedAt: json["remember_created_at"],
        // signInCount: json["sign_in_count"],
        // currentSignInAt: json["current_sign_in_at"] == null ? null : DateTime.parse(json["current_sign_in_at"]),
        // lastSignInAt: json["last_sign_in_at"] == null ? null : DateTime.parse(json["last_sign_in_at"]),
        // currentSignInIp: json["current_sign_in_ip"] == null  ? null : json["current_sign_in_ip"],
        // lastSignInIp: json["last_sign_in_ip"],
        // confirmationToken: json["confirmation_token"],
        // confirmedAt: json["confirmed_at"],
        // confirmationSentAt: json["confirmation_sent_at"],
        // unconfirmedEmail: json["unconfirmed_email"],
        // createdAt: json["created_at"],
        // updatedAt: DateTime.parse(json["updated_at"]),
        username: json["username"],
        // isReadValue: json["is_read_value"],
        // language: json["language"],
        //isActiveInt: json["is_active_int"],
        // image: json["image"],
        fullName: json["full_name"],
        // isTakeTour: json["is_take_tour"],
        // lastActiveAt: json["last_active_at"] == null  ? null : DateTime.parse(json["last_active_at"]),
        // isOnline: json["is_online"],
        // isLock: json["is_lock"],
        // pin: json["pin"],
        // isUsePin: json["is_use_pin"],
        // timeLock: json["time_lock"],
        // lockedCount: json["locked_count"],
        // companyId: json["company_id"],
        // updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        // userRoleId: json["user_role_id"],
        phone: json["phone"],
        // createdBy: json["created_by"],
        languageType: json["language_type"],
        companyCode: json["company_code"],
        isBiometrik: json["is_biometrik"],
        organizationId: json["organization_id"],
        functionId: json["function_id"],
        structureId: json["structure_id"],
        employeeStatus: json["employee_status"],
        userCompanyId: json["user_company_id"],
        packageType: json["package_type"],
        roleId: json["role_id"],
        isLoginMobile: json["is_login_mobile"],
        timeoutLogin: json["timeout_login"],
        lastSignInAt: json["last_sign_in_at"] == "null" ||
                json["last_sign_in_at"] == null ||
                json["last_sign_in_at"] == ""
            ? null
            : DateTime.parse(json["last_sign_in_at"]),
        resignDate: json["resign_date"] == "null" ||
                json["resign_date"] == null ||
                json["resign_date"] == ""
            ? null
            : DateTime.parse(json["resign_date"]),
        resignFlag: json["resign_flag"],
        deviceId: json["device_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "encrypted_password": encryptedPassword,
        // "reset_password_token": resetPasswordToken,
        // "reset_password_sent_at": resetPasswordSentAt,
        // "remember_created_at": rememberCreatedAt,
        // "sign_in_count": signInCount,
        // "current_sign_in_at":currentSignInAt == null ? null : currentSignInAt.toIso8601String(),
        // "last_sign_in_at": lastSignInAt.toIso8601String(),
        // "current_sign_in_ip": currentSignInIp == null ? null : currentSignInIp,
        // "last_sign_in_ip": lastSignInIp,
        // "confirmation_token": confirmationToken,
        // "confirmed_at": confirmedAt,
        // "confirmation_sent_at": confirmationSentAt,
        // "unconfirmed_email": unconfirmedEmail,
        // "created_at": createdAt,
        // "updated_at": updatedAt.toIso8601String(),
        "username": username,
        // "is_read_value": isReadValue,
        // "language": language,
        // "is_active_int": isActiveInt,
        // "image": image,
        "full_name": fullName,
        // "is_take_tour": isTakeTour,
        // "last_active_at": lastActiveAt.toIso8601String(),
        // "is_online": isOnline,
        // "is_lock": isLock,
        // "pin": pin,
        // "is_use_pin": isUsePin,
        // "time_lock": timeLock,
        // "locked_count": lockedCount,
        // "company_id": companyId,
        // "updated_by": updatedBy == null ? null : updatedBy,
        // "user_role_id": userRoleId,
        "phone": phone,
        // "created_by": createdBy,
        "language_type": languageType,
        "company_code": companyCode,
        "is_biometrik": isBiometrik,
        "organization_id": organizationId,
        "function_id": functionId,
        "structure_id": structureId,
        "employee_status": employeeStatus,
        "user_company_id": userCompanyId,
        "package_type": packageType,
        "role_id": roleId,
        "is_login_mobile": isLoginMobile,
        "timeout_login": timeoutLogin,
        "last_sign_in_at":
            lastSignInAt == null ? null : lastSignInAt.toIso8601String(),
        "resign_date": resignDate == null ? null : resignDate.toIso8601String(),
        "resign_flag": resignFlag,
        "device_id":deviceId
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["email"] = email;
    map["encrypted_password"] = encryptedPassword;
    map["username"] = username;
    map["full_name"] = fullName;
    // map["company_id"] = companyId;
    map["phone"] = phone;
    map["language_type"] = languageType;
    map["company_code"] = companyCode;
    map["is_biometrik"] = isBiometrik;
    map["organization_id"] = organizationId;
    map["function_id"] = functionId;
    map["structure_id"] = structureId;
    // map["is_active_int"] =  isActiveInt;
    map["employee_status"] = employeeStatus;
    map["user_company_id"] = userCompanyId;
    map["package_type"] = packageType;
    map["role_id"] = roleId;
    map["is_login_mobile"] = isLoginMobile;
    map["timeout_login"] = timeoutLogin;
    map["last_sign_in_at"] =lastSignInAt == null ? "" : lastSignInAt.toString();
    map["resign_date"] = resignDate == null ? "" : resignDate.toString();
    map["resign_flag"] = resignFlag;
    map["device_id"] =deviceId;
    // "employee_status": employeeStatus
    return map;
  }
}
