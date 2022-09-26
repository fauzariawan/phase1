import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:workplan_beta_test/base/system_param.dart';


class Warning {
  static showWarning(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static loading(BuildContext context) {
    showDialog(
        barrierColor: Colors.black38,
        context: context,
        builder: (BuildContext context) {
          return SpinKitRing(
            color: SystemParam.colorCustom,
            size: 50,
          );
        });
  }

  static warningLogout(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("WARNING"),
          content: const Text("Maaf Anda Logout Karena Tidak Aktif !!!"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("OK"))
          ],
        );
      },
    );
  }
}