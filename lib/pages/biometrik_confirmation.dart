import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/converter.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/setting/profile_setting.dart';

import 'loginscreen.dart';

class BiometrikConfirmation extends StatefulWidget {
  final User user;
  final String page;
  final String isBiometrics;

  const BiometrikConfirmation(
      {Key? key,
      required this.user,
      required this.page,
      required this.isBiometrics})
      : super(key: key);

  @override
  _BiometrikConfirmationState createState() => _BiometrikConfirmationState();
}

class _BiometrikConfirmationState extends State<BiometrikConfirmation> {
  final _keyForm = GlobalKey<FormState>();
  var db = new DatabaseHelper();
  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');
  TextEditingController _userIdCtrl = TextEditingController();
  TextEditingController _passwordCtrl = TextEditingController();
  TextEditingController _companyCodeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (widget.page == "LOGIN") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileSetting(
                    user: widget.user,
                  ),
                ));
          }
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Konfirmasi Biometrik'),
              centerTitle: true,
              backgroundColor: SystemParam.colorCustom,
            ),
            // resizeToAvoidBottomInset: false,
            //backgroundColor: Colors.white,
            body: Form(
                key: _keyForm,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      SizedBox(
                        height: 1.0,
                      ),
                      Text(
                        "",
                        style:
                            TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(children: [
                            SizedBox(
                              height: 1.0,
                            ),
                            TextFormField(
                              validator: requiredValidator,
                              controller: _userIdCtrl,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "User Id",
                                labelStyle: TextStyle(
                                    fontSize: 14.0, fontFamily: "Brand Bold"),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.0,
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 14.0, fontFamily: "Brand Bold"),
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            TextFormField(
                              validator: requiredValidator,
                              controller: _passwordCtrl,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(
                                    fontSize: 14.0, fontFamily: "Brand Bold"),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.0,
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 14.0, fontFamily: "Brand Bold"),
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            TextFormField(
                              validator: requiredValidator,
                              controller: _companyCodeCtrl,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Company Code",
                                labelStyle: TextStyle(
                                    fontSize: 14.0, fontFamily: "Brand Bold"),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.0,
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 14.0, fontFamily: "Brand Bold"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 1.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  doSave();
                                },
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  color: Colors.green,
                                  child: Center(
                                      child: const Text(
                                    'SIMPAN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  height: 50,
                                ),
                              ),
                            )
                          ]))
                    ])))));
  }

  void doSave() async {
    //TODO konfirmasi cek db user dan company
    db.getUserListByUsername(widget.user.username).then((value) {
      setState(() {
        String encryptedPassword =
            ConverterUtil().generateMd5(_passwordCtrl.text);
        String companyCode = _companyCodeCtrl.text.toUpperCase();
        String username = _userIdCtrl.text;
        String errorMsg = "";
        var user;
        List<User> userList = value;
        bool ketemu = false;
        // bool companyCodeErrorFound = false;

        for (var i = 0; i < userList.length; i++) {
          print('ini daftar company code <<<<<=======');
          print(userList[i].companyCode);
          print(companyCode.toUpperCase());
          if (userList[i].username != username &&
              userList[i].email != username) {
            if (errorMsg != "") {
              errorMsg += ", User Id";
            } else {
              errorMsg += "User Id";
            }
          }

          if (ketemu == false) {
            if (userList[i].companyCode.toUpperCase() !=
                companyCode.toUpperCase()) {
              if (errorMsg != "") {
                errorMsg += ", Company Code";
              } else {
                errorMsg += "Company Code";
              }
            } else {
              ketemu = true;
            }
          }

          if (userList[i].encryptedPassword != encryptedPassword) {
            if (errorMsg != "") {
              errorMsg += ", Password";
            } else {
              errorMsg += "Password";
            }
          }

          if (userList[i].encryptedPassword == encryptedPassword &&
              userList[i].companyCode.toUpperCase() ==
                  companyCode.toUpperCase()) {
            user = userList[i];
            errorMsg = "";
            /* INSERT USER */
            //db.insertUser(user);

          }
        }

        if (errorMsg != "") {
          Fluttertoast.showToast(
              msg: errorMsg + " salah",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          doOK();
        }
      });
    });
  }

  doOK() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "id": widget.user.id,
          "language_type": widget.user.languageType,
          "is_biometrik": widget.isBiometrics
        };

        //minimal password = 8 digit terdiri dari Angka, Huruf Besar dan huruf kecil
        // print(data);

        var response = await RestService()
            .restRequestService(SystemParam.fUpdateLanguageBiometrik, data);

        var convertDataToJson = json.decode(response.body);
        var code = convertDataToJson['code'];
        // var status = convertDataToJson['status'];

        if (code == "0") {
          /* UPDATE USER */
          User userDb = widget.user;
          userDb.isBiometrik = widget.isBiometrics;
          db.updateUser(userDb);

          if (widget.page == "LOGIN") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileSetting(
                    user: widget.user,
                  ),
                ));
          }
        } else {
          // print(status);
          Fluttertoast.showToast(
              msg: "Mohon Maaf, Anda Gagal Update Data :",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }
}
