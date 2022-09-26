import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/setting/profile_setting.dart';
import 'package:workplan_beta_test/main_pages/constans.dart';

import 'biometrik_confirmation.dart';
import 'loginscreen.dart';

class BiometrikTermAndCondition extends StatefulWidget {
  final User user;
  final String page;
  const BiometrikTermAndCondition(
      {Key? key, required this.user, required this.page})
      : super(key: key);

  @override
  _BiometrikTermAndConditionState createState() =>
      _BiometrikTermAndConditionState();
}

class _BiometrikTermAndConditionState extends State<BiometrikTermAndCondition> {
  bool loading = false;
  var db = new DatabaseHelper();
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
              title: Text('Terms & Conditions', style: TextStyle(fontFamily: "Calibre", fontSize: 24, fontWeight: FontWeight.bold),),
              centerTitle: true,
              backgroundColor: SystemParam.colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
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
                },
              ),
            ),
            body: loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "1. Biometric Login adalah fitur tambahan yang kami sediakan kepada Anda untuk mengakses (login) aplikasi Workplan menggunakan pengenalan wajah (face recognition) Pengguna."),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "2. Kami tidak mewajibkan Pengguna untuk menggunakan fitur Biometric Login . Apabila Pengguna tidak ingin menggunakan sarana Biometric Login , Pengguna tetap dapat mengakses aplikasi Workplan dengan memasukkan User Id dan Password serta Company Code."),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "3. Dengan melakukan aktivasi pengenalan wajah, Pengguna mengetahui dan menyetujui bahwa seluruh pengenalan wajah tersebut dapat digunakan sebagai pilihan otentifikasi login pada aplikasi Workplan."),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "4. Pengguna sewaktu-waktu dapat menonaktifkan fitur Biometric Login melalui menu Personal Information > Setting pada aplikasi Workplan."),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "5. Kami tidak bertanggung jawab atas segala kerugian yang timbul, baik materiel maupun immateriel, yang disebabkan karena ketidakhati-hatian dan/atau kecerobohan dan/atau kesengajaan dan/atau penyalahgunaan yang dilakukan Pengguna dan/atau pihak lain terhadap pengenalan wajah pada aplikasi Workplan. materiel maupun immateriel, yang disebabkan karena ketidakhati-hatian dan/atau kecerobohan dan/atau kesengajaan dan/atau penyalahgunaan yang dilakukan Pengguna dan/atau pihak lain terhadap pengenalan wajah pada aplikasi Workplan."),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "Dengan memilih SETUJU, Anda telah membaca dan setuju dengan Syarat & Ketentuan.",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                /* SETUJU */
                                doSave("1");
                              },
                              child: Container(
                                alignment: Alignment.topCenter,
                                color: WorkplanPallete.green,
                                child: Center(
                                    child: const Text(
                                  'SETUJU',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                                height: 50,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                /* TIDAK SETUJU */
                                doSave("0");
                              },
                              child: Container(
                                alignment: Alignment.topCenter,
                                color: Colors.white,
                                child: Center(
                                    child: const Text(
                                  'TIDAK SETUJU',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )),
                                height: 50,
                              ),
                            ),
                          )
                        ]),
                  ))));
  }

  void doSave(isBiometrics)  {
    
    if(isBiometrics=="1"){
      Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BiometrikConfirmation(
                user: widget.user, isBiometrics: isBiometrics, page: widget.page,
              ),
            ));
    }else{
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
    }
    
  }

  void doSaveOld(isBiometrics) async {
    var data = {
      "id": widget.user.id,
      "language_type": widget.user.languageType,
      "is_biometrik": isBiometrics
    };

    var response = await RestService()
        .restRequestService(SystemParam.fUpdateLanguageBiometrik, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    // var status = convertDataToJson['status'];

    if (code == "0") {
      /* UPDATE USER */
      User userDb = widget.user;
      userDb.isBiometrik = isBiometrics;
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
}
