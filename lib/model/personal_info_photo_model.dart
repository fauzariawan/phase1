// import 'dart:convert';

class PersonalInfoPhoto {
  int id;
  int userId;
  String imagePath;
  PersonalInfoPhoto(
      {required this.id, required this.userId, required this.imagePath});

  factory PersonalInfoPhoto.fromJson(Map<String, dynamic> json) =>
      PersonalInfoPhoto(
          id: json["id"],
          userId: json["user_id"],
          imagePath: json["image_path"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "user_id": userId, "image_path": imagePath};
}
