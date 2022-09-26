import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/dropdown_item.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/main_pages/landingpage_view.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/user_model.dart';

import 'loginscreen.dart';

class LoginChooseCompanyCode extends StatefulWidget {
  const LoginChooseCompanyCode({Key? key, required this.userList,  required this.deviceId})
      : super(key: key);
  // final User user;
  final List<User> userList;
  final String deviceId;
  @override
  _LoginChooseCompanyCodeState createState() => _LoginChooseCompanyCodeState();
}

class _LoginChooseCompanyCodeState extends State<LoginChooseCompanyCode> {
  final _keyForm = GlobalKey<FormState>();
  // int companyValue = 0;
  List<DropdownMenuItem<int>> itemsCompany = <DropdownMenuItem<int>>[];
  var db = new DatabaseHelper();
  bool loading = false;
  // SessionTimer sessionTimer = new SessionTimer();

  @override
  void initState() {
    super.initState();
    initCompany();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          //exit(0);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Pilih  Company Code'),
              centerTitle: true,
              backgroundColor: SystemParam.colorCustom,
            ),
            body: Form(
              key: _keyForm,
              child: Column(
                children: [
                  SizedBox(
                    height: 1.0,
                  ),
                  Text(
                    "",
                    style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                    textAlign: TextAlign.center,
                  ),
                  SingleChildScrollView(
                    child: new Container(
                      child: loading == true
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : new Container(child: createListView()),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: DropdownButtonHideUnderline(
                  //       child: Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     //height: 50.0,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         border: Border.all(color: SystemParam.colorCustom)),
                  //     child: DropdownButton<int>(
                  //       // hint: Padding(
                  //       //   padding: const EdgeInsets.all(8.0),
                  //       //   child: Text(
                  //       //     "UDF DDL B2",
                  //       //     style: TextStyle(color: Colors.blue[900]),
                  //       //   ),
                  //       // ),
                  //       // value: companyValue,
                  //       items: itemsCompany,
                  //       onChanged: (object) {
                  //         setState(() {
                  //           // parameterUdfOption2Value = object!;
                  //   db.getUserById(object.toString()).then((value) {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => LandingPage(
                  //             user: value,
                  //           ),
                  //         ));
                  //   });
                  //  });
                  //       },
                  //     ),
                  //   )),
                  // ),
                ],
              ),
            )));
  }

  void initCompany() {
    // itemsCompany.add(DropdownItem.getItemParameter(
    //       SystemParam.defaultValueOptionId,
    //       SystemParam.defaultValueOptionDesc));

    // db.getUserList().then((value) {
    setState(() {
      loading = true;
      // itemsCompany.clear();
      //     List<User> dtList = value;
      // for (var i = 0; i < widget.userList.length; i++) {
      //   print("widget.userList[i].id.toString(" +
      //       widget.userList[i].id.toString());
      //   itemsCompany.add(DropdownItem.getItemParameter(
      //       widget.userList[i].id, widget.userList[i].companyCode));
      // }
      loading = false;
    });
    // });
  }

  ListView createListView() {
    // TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.userList.length,
      itemBuilder: (BuildContext context, int index) {
        return customListItem(widget.userList[index]);
      },
    );
  }

  customListItem(User user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        //elevation: 2.0,
        child: ListTile(
          // leading: Image.asset(
          //   "images/man.png",
          // ),
          // leading:Icon(Icons.company),
          title: Text(
            user.companyCode,
            style: TextStyle(fontSize: 16),
          ),
          //subtitle: Text(dt.activityDescription),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            doLogin(context, user);

            // });
          },
        ),
      ),
    );
  }

  void updateIsLogin(User user, String isLogin) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var dataPassword = {
          "id": user.id,
          "updated_by": user.id,
          "is_login_mobile": isLogin,
          "device_id":widget.deviceId
        };

        var response = await RestService()
            .restRequestService(SystemParam.fUpdateIsLogin, dataPassword);

        var convertDataToJson = json.decode(response.body);
        var code = convertDataToJson['code'];
        print("updateIsLogin:" + code);
      }
    } on SocketException catch (_) {}
  }

  void doLogin(BuildContext context, User user) async {
    
    bool isActive= true;
    if (0 == user.employeeStatus) {
      if (1 == user.resignFlag) {
        DateTime dtNow = DateTime.now();
        if (user.resignDate != null) {
          if (dtNow.isAfter(user.resignDate)) {
            //user inactive becouse resign date
            isActive= false;
          }
        }
      } else {
        //user inactive
        isActive= false;
      }

    }
    if(!isActive){
      //USER INACTIVE
      Fluttertoast.showToast(
          msg: "User is not actived yet. Call the administrator !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;

    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic json = jsonEncode(user);
      prefs.setString("dataUser", json.toString());
      updateIsLogin(user, "1");

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LandingPage(
              user: user,
            ),
          ));
    }
  }
}
