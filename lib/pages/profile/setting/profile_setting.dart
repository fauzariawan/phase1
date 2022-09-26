import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/converter.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/dropdown_item.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/parameter_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/loginscreen.dart';
import 'package:workplan_beta_test/pages/profile/profile_page.dart';
import 'package:workplan_beta_test/main_pages/constans.dart';

import '../../biometrik_termandcondition.dart';

class ProfileSetting extends StatefulWidget {
  final User user;
  // final PersonalInfoProfilData profileInfo;
  const ProfileSetting({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  bool loading = false;

  late List<Parameter> languageTypeList;
  List<DropdownMenuItem<int>> itemsLanguageType = <DropdownMenuItem<int>>[];
  int languageTypeValue = SystemParam.defaultValueOptionId;

  TextEditingController _currentPasswordCtrl = new TextEditingController();
  TextEditingController _newPasswordCtrl = new TextEditingController();
  TextEditingController _confirmPasswordCtrl = new TextEditingController();
  bool isCheckedBiometrics = false;
  var isBiometrics = "0";
  var db = new DatabaseHelper();
  late User user = widget.user;

  @override
  void initState() {
    super.initState();

    initUser();
    initParameterLanguageType();
    // ignore: unnecessary_null_comparison
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  user: user,
                ),
              ));
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Setting'),
              centerTitle: true,
              backgroundColor: SystemParam.colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          user: user,
                        ),
                      ));
                },
              ),
            ),
            body: loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        // ini file pemilihan bahasa
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: RichText(
                        //     text: TextSpan(
                        //       children: <TextSpan>[
                        //         TextSpan(
                        //             text: 'Bahasa',
                        //             style: TextStyle(
                        //                 backgroundColor: Theme.of(context)
                        //                     .scaffoldBackgroundColor,
                        //                 color: SystemParam.colorCustom,
                        //                 fontWeight: FontWeight.w400,
                        //                 fontSize: 14)),
                        //         TextSpan(
                        //             text: ' ',
                        //             style: TextStyle(
                        //                 fontWeight: FontWeight.w500,
                        //                 fontSize: 14,
                        //                 backgroundColor: Theme.of(context)
                        //                     .scaffoldBackgroundColor,
                        //                 color: Colors.red)),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   // child: DropdownButtonHideUnderline(
                        //   child: DropdownButtonFormField<int>(
                        //     decoration: InputDecoration(
                        //       //icon: new Icon(Ionicons.person),
                        //       //errorText: "this field is required",
                        //       fillColor: SystemParam.colorCustom,
                        //       labelStyle: TextStyle(
                        //           color: SystemParam.colorCustom,
                        //           fontStyle: FontStyle.normal),
                        //       enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //               color: SystemParam.colorCustom),
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(10))),
                        //       focusedBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //               color: SystemParam.colorCustom),
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(10))),
                        //       contentPadding: EdgeInsets.all(10),
                        //     ),
                        //     validator: (value) {
                        //       //print("validaor select:" + value.toString());
                        //       // ignore: unrelated_type_equality_checks
                        //       if (value == 0 || value == null) {
                        //         return "this field is required";
                        //       }
                        //       return null;
                        //     },
                        //     value: languageTypeValue,
                        //     items: itemsLanguageType,
                        //     onChanged: (object) {
                        //       setState(() {
                        //         // genderSelected = object!;
                        //         languageTypeValue = object!;
                        //       });
                        //     },
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(getColor),
                                  value: isCheckedBiometrics,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (!isCheckedBiometrics) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BiometrikTermAndCondition(
                                                      user: widget.user,
                                                      page: "PROFILE"),
                                            ));
                                      }
                                      isCheckedBiometrics = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    "Login dengan pengenalan wajah(Biometrics)",
                                    style:
                                        TextStyle(color: WorkplanPallete.green),
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Current Password',
                                    style: TextStyle(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: SystemParam.colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: Colors.red)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            style: new TextStyle(color: Colors.black),
                            controller: _currentPasswordCtrl,
                            //initialValue: widget.datum.writtingScore.toString(),
                            readOnly: false,
                            obscureText: true,
                            onSaved: (em) {
                              if (em != null) {}
                            },
                            decoration: InputDecoration(
                              fillColor: SystemParam.colorCustom,
                              labelStyle: TextStyle(
                                  color: SystemParam.colorCustom,
                                  fontStyle: FontStyle.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'New Password',
                                    style: TextStyle(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: SystemParam.colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: Colors.red)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            style: new TextStyle(color: Colors.black),
                            controller: _newPasswordCtrl,
                            //initialValue: widget.datum.writtingScore.toString(),
                            readOnly: false,
                            obscureText: true,
                            onSaved: (em) {
                              if (em != null) {}
                            },
                            decoration: InputDecoration(
                              fillColor: SystemParam.colorCustom,
                              labelStyle: TextStyle(
                                  color: SystemParam.colorCustom,
                                  fontStyle: FontStyle.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Password Confirmation',
                                    style: TextStyle(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: SystemParam.colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: Colors.red)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            style: new TextStyle(color: Colors.black),
                            controller: _confirmPasswordCtrl,
                            readOnly: false,
                            obscureText: true,
                            onSaved: (em) {
                              if (em != null) {}
                            },
                            decoration: InputDecoration(
                              fillColor: SystemParam.colorCustom,
                              labelStyle: TextStyle(
                                  color: SystemParam.colorCustom,
                                  fontStyle: FontStyle.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: SystemParam.colorCustom,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text("UPDATE"),
                              onPressed: () {
                                saveData();
                              },
                            ),
                          ),
                        )
                      ]))));
  }

  void saveData() async {
    if (_currentPasswordCtrl.text == "" &&
        _newPasswordCtrl.text == "" &&
        _confirmPasswordCtrl.text == "") {
      //UPDATE BAHASA dan biometrik saja
      doSave(SystemParam.fUpdateLanguageBiometrik);
    } else {
      var userCurrentPassword = user.encryptedPassword;
      var currentPassword =
          ConverterUtil().generateMd5(_currentPasswordCtrl.text);

      if (userCurrentPassword != currentPassword) {
        Fluttertoast.showToast(
            msg: "Current Password tidak sesuai ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }

      // if (!validateStructure(_newPasswordCtrl.text)) {
      if (_newPasswordCtrl.text.length < 8) {
        Fluttertoast.showToast(
            // msg:"Password harus mengandung: \n Minimum 8 Character \n Minimum 1 Upper case \n Minimum 1 lowercase \n Minimum 1 Numeric Number ",
            msg: "Password harus mengandung minimum 8 character ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        return;
      }

      if (_newPasswordCtrl.text != _confirmPasswordCtrl.text) {
        Fluttertoast.showToast(
            msg: "New Password dan Confirmation Password tidak sesuai ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }

      doSave(SystemParam.fChangePassword);
    }
  }

  void initParameterLanguageType() async {
    itemsLanguageType.clear();
    languageTypeList = <Parameter>[];
    //loading = true;
    ParameterModel parameterModel;
    var data = {
      "parameter_type": SystemParam.parameterTypeLanguageType,
      "company_id": user.userCompanyId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fParameterByTypeCompanyId, data);

    setState(() {
      parameterModel = parameterModelFromJson(response.body.toString());
      languageTypeList = parameterModel.data;
      itemsLanguageType.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < languageTypeList.length; i++) {
        itemsLanguageType.add(DropdownItem.getItemParameter(
            languageTypeList[i].id, languageTypeList[i].parameterValue));

        if (user.languageType != null && languageTypeList[i].id == user.languageType)  {
          languageTypeValue = user.languageType;
        }
      }

      //loading = false;
    });
  }

  bool validateStructure(String value) {
    /*
      Minimum 1 Upper case
      Minimum 1 lowercase
      Minimum 1 Numeric Number
      ----- tifak pake Special Character
      Minimum 1 Special Character
      Common Allow Character ( ! @ # $ & * ~ )
      String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    */
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void doSave(function) async {
    if (isCheckedBiometrics) {
      isBiometrics = "1";
    } else {
      isBiometrics = "0";
    }

    var data = {
      "id": user.id,
      "encrypted_password": ConverterUtil().generateMd5(_newPasswordCtrl.text),
      "language_type": languageTypeValue,
      "is_biometrik": isBiometrics

      // "new_password": _newPasswordCtrl.text,
      // "confirmation_password": _confirmPasswordCtrl.text,
    };

    //minimal password = 8 digit terdiri dari Angka, Huruf Besar dan huruf kecil

    print(data);

    var response = await RestService().restRequestService(function, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];

    if (code == "0") {
      if (function == SystemParam.fChangePassword) {
        /* UPDATE USER */
        user.encryptedPassword =
            ConverterUtil().generateMd5(_newPasswordCtrl.text);
        db.updateUser(user);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        /* UPDATE USER */
        user.isBiometrik = isBiometrics;
        user.languageType = languageTypeValue;

        db.updateUser(user);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileSetting(
                      user: user,
                      // profileInfo: widget.profileInfo,
                    )));
      }

      Fluttertoast.showToast(
          msg: "Update Data Berhasil",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: SystemParam.colorCustom,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print(status);
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

  void initUser() async {
    loading = true;
    // db.getUserListByUsername(userDb.username).then((value) {
    //   setState(() {
    //     userDb = value[0];
    //     // ignore: unnecessary_null_comparison
    //     if (userDb.languageType != null) {
    //       languageTypeValue = userDb.languageType;
    //     }

    //     isBiometrics = userDb.isBiometrik;
    //     if (userDb.isBiometrik == "1") {
    //       isCheckedBiometrics = true;
    //     } else {
    //       isCheckedBiometrics = false;
    //     }

    //     loading = false;
    //   });
    // });

    db.getUserById(user.userCompanyId.toString()).then((value) {
      setState(() {
        user = value;
        // ignore: unnecessary_null_comparison
        

        isBiometrics = user.isBiometrik;
        if (user.isBiometrik == "1") {
          isCheckedBiometrics = true;
        } else {
          isCheckedBiometrics = false;
        }

        loading = false;
      });
    });
  }
}
