import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
 
class Utility {
  //
  //static const String KEY = "IMAGE_KEY";
 
  static Future<String?> getImageFromPreferences(key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? null;
  }
 
  static Future<bool> saveImageToPreferences(String value,String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
 
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }
 
  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }
 
  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
