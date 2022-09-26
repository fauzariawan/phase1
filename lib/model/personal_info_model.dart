// To parse this JSON data, do
//
//     final personalInfoProfil = personalInfoProfilFromJson(jsonString);

import 'dart:convert';

PersonalInfoModel personalInfoFromJson(String str) =>
    PersonalInfoModel.fromJson(json.decode(str));

String personalInfoProfilToJson(PersonalInfoModel data) =>
    json.encode(data.toJson());

class PersonalInfoModel {
  PersonalInfoModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<PersonalInfoProfilData> data;

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) =>
      PersonalInfoModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<PersonalInfoProfilData>.from(
            json["data"].map((x) => PersonalInfoProfilData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PersonalInfoProfilData {
  PersonalInfoProfilData({
    required this.id,
    required this.userId,
    required this.image,
    required this.status,
    required this.gender,
    required this.placeOfBirthday,
    required this.dateOfBirthday,
    required this.createdAt,
    required this.updatedAt,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    this.about,
    this.creative,
    this.motivated,
    this.punctual,
    required this.religion,
    required this.nationality,
    required this.taxNumber,
    required this.taxAddress,
    required this.identityCardNumber,
    required this.identityCardAddress,
    this.employmentInsuranceNumber,
    this.healthInsuranceNumber,
    required this.bloodGroup,
    this.updatedBy,
    this.createdBy,
    required this.companyId,
    required this.facebook,
    required this.linkedIn,
    required this.twitter,
    required this.instagram,
    required this.homePhone,
    required this.officePhone,
    required this.phone,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.emergencyContactRelationship,
    required this.emergencyContactAddress,
    required this.isUseGlasses,
    required this.height,
    required this.weight,
    required this.sickHistory, 
    // required this.languageType,
  });

  int id;
  int userId;
  dynamic image;
  int status;
  int gender;
  String placeOfBirthday;
  dynamic dateOfBirthday;
  dynamic createdAt;
  dynamic updatedAt;
  String firstName;
  String middleName;
  String lastName;
  dynamic about;
  dynamic creative;
  dynamic motivated;
  dynamic punctual;
  int religion;
  int nationality;
  String taxNumber;
  String taxAddress;
  String identityCardNumber;
  String identityCardAddress;
  dynamic employmentInsuranceNumber;
  dynamic healthInsuranceNumber;
  int bloodGroup;
  dynamic updatedBy;
  dynamic createdBy;
  int companyId;
  String facebook;
  String linkedIn;
  String twitter;
  String instagram;
  String homePhone;
  String officePhone;
  String phone;
  String emergencyContactName;
  String emergencyContactPhone;
  String emergencyContactRelationship;
  String emergencyContactAddress;
  String isUseGlasses;
  int height;
  int weight;
  String sickHistory;
  // int languageType;

  factory PersonalInfoProfilData.fromJson(Map<String, dynamic> json) =>
      PersonalInfoProfilData(
        id: json["id"],
        userId: json["user_id"],
        image: json["image"],
        status: json["status"],
        gender: json["gender"],
        placeOfBirthday: json["place_of_birthday"],
        // dateOfBirthday: DateTime.parse(json["date_of_birthday"]),
        dateOfBirthday: json["date_of_birthday"] == null
            ? null
            : DateTime.parse(json["date_of_birthday"]),

        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        //updatedAt: DateTime.parse(json["updated_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        about: json["about"],
        creative: json["creative"],
        motivated: json["motivated"],
        punctual: json["punctual"],
        religion: json["religion"],
        nationality: json["nationality"],
        taxNumber: json["tax_number"],
        taxAddress: json["tax_address"],
        identityCardNumber: json["identity_card_number"],
        identityCardAddress: json["identity_card_address"],
        employmentInsuranceNumber: json["employment_insurance_number"],
        healthInsuranceNumber: json["health_insurance_number"],
        bloodGroup: json["blood_group"],
        updatedBy: json["updated_by"],
        createdBy: json["created_by"],
        companyId: json["company_id"],
        facebook: json["facebook"],
        linkedIn: json["linkedIn"],
        twitter: json["twitter"],
        instagram: json["instagram"],
        homePhone: json["home_phone"],
        officePhone: json["office_phone"],
        phone: json["phone"],
        emergencyContactName: json["emergency_contact_name"],
        emergencyContactPhone: json["emergency_contact_phone"],
        emergencyContactRelationship: json["emergency_contact_relationship"],
        emergencyContactAddress: json["emergency_contact_address"],
        isUseGlasses: json["is_use_glasses"],
        height: json["height"],
        weight: json["weight"],
        sickHistory: json["sick_history"],
        // languageType:json["language_type"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "image": image,
        "status": status,
        "gender": gender,
        "place_of_birthday": placeOfBirthday,
        "date_of_birthday":
            "${dateOfBirthday.year.toString().padLeft(4, '0')}-${dateOfBirthday.month.toString().padLeft(2, '0')}-${dateOfBirthday.day.toString().padLeft(2, '0')}",
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "about": about,
        "creative": creative,
        "motivated": motivated,
        "punctual": punctual,
        "religion": religion,
        "nationality": nationality,
        "tax_number": taxNumber,
        "tax_address": taxAddress,
        "identity_card_number": identityCardNumber,
        "identity_card_address": identityCardAddress,
        "employment_insurance_number": employmentInsuranceNumber,
        "health_insurance_number": healthInsuranceNumber,
        "blood_group": bloodGroup,
        "updated_by": updatedBy,
        "created_by": createdBy,
        "company_id": companyId,
        "facebook": facebook,
        "linkedIn": linkedIn,
        "twitter": twitter,
        "instagram": instagram,
        "home_phone": homePhone,
        "office_phone": officePhone,
        "phone": phone,
        "emergency_contact_name": emergencyContactName,
        "emergency_contact_phone": emergencyContactPhone,
        "emergency_contact_relationship": emergencyContactRelationship,
        "emergency_contact_address": emergencyContactAddress,
        "is_use_glasses": isUseGlasses,
        "height": height,
        "weight": weight,
        "sick_history": sickHistory,
        // "language_type":languageType
      };
}
