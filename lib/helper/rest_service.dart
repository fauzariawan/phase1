import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:workplan_beta_test/base/system_param.dart';

class RestService {
  static RestService _instance = new RestService.internal();
  RestService.internal();
  factory RestService() => _instance;

  Future<Response> restRequestService(String url, var data) async {
    //print(Uri.parse(url));
    // print("parameter: "+jsonEncode(data));
    //print("url:"+SystemParam.baseUrl + url);
    var respon = await post(
      Uri.parse(SystemParam.baseUrl + url),
      headers: {"content-type": "application/json"},
      body: jsonEncode(data),
    );
    print(SystemParam.baseUrl + url);
    print(data);
    return respon;
  }

  Future<Response> restRequestServiceOthers(String url, var data) async {
    // print(Uri.parse(url));
    var respon = await post(
      Uri.parse(url),
      headers: {"content-type": "application/json"},
      body: jsonEncode(data),
    );
    return respon;
  }
}
