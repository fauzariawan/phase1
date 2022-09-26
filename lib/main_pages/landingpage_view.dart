import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/helper/utility_image.dart';
import 'package:workplan_beta_test/model/device_location_model.dart';
import 'package:workplan_beta_test/model/env_model.dart';
import 'package:workplan_beta_test/model/menu_otorize_model.dart';
import 'package:workplan_beta_test/model/notice_model.dart';
import 'package:workplan_beta_test/model/parameter_activity_model.dart';
import 'package:workplan_beta_test/model/parameter_hasil_kunjungan.dart';
import 'package:workplan_beta_test/model/parameter_kategori_produk_model.dart';
import 'package:workplan_beta_test/model/parameter_mapping_aktifitas_model.dart';
import 'package:workplan_beta_test/model/parameter_model.dart';
import 'package:workplan_beta_test/model/parameter_produk_model.dart';
import 'package:workplan_beta_test/model/parameter_progres_status_model.dart';
import 'package:workplan_beta_test/model/parameter_tujuan_kunjungan.dart';
import 'package:workplan_beta_test/model/parameter_udf_model.dart';
import 'package:workplan_beta_test/model/parameter_udf_option_model.dart';
import 'package:workplan_beta_test/model/parameter_usaha_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/visit_checkin_log_model.dart';
import 'package:workplan_beta_test/model/workplan_dokumen_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/model/workplan_messages.dart';
import 'package:workplan_beta_test/model/workplan_visit_model.dart';
import 'package:workplan_beta_test/pages/loginscreen.dart';
import 'package:workplan_beta_test/main_pages/home_view.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart' as gl;
import 'package:location_permissions/location_permissions.dart' as lp;
import 'package:http/http.dart' as http;
import 'package:workplan_beta_test/widget/warning.dart';

import 'basic_page.dart';
import 'launcher_view.dart';
import 'session_timer.dart';

// class LandingPage extends StatefulWidget {
class LandingPage extends BasePage {
  final User user;

  LandingPage({required this.user}) : super(user);
  // const LandingPage({Key? key, required this.user}) : super(key: key);
  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends BaseState<LandingPage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  int _bottomNavCurrentIndex = 0;
  late List<Widget> _container;
  var db = new DatabaseHelper();
  // SessionTimer sessionTimer = new SessionTimer();
  // String _currentAddress = "";
  // int _minutesTimeout = 1;
  // Duration _duration = Duration(minutes: 1);
  late Timer _timer;
  int _countTimer = 0;
  int _minutesTimeout = 5;
  // late BuildContext _context;

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // print("AppLifecycleState:::: $state ::::" + DateTime.now().toIso8601String());
    // if (state == AppLifecycleState.paused) {
    //   // _initializeTimer();
    // } else if (state == AppLifecycleState.resumed) {
    //   // _countTimer = 0;
    //   widget.sessionTimer.userActivityDetected(_scaffoldKey.currentState!.context,widget.user);
    // } else if (state == AppLifecycleState.inactive) {
    //   // _initializeTimer();
    // }else if(state == AppLifecycleState.detached){
    //     updateIsLogin(widget.user, 0);
    //     widget.sessionTimer.stopTimer();
    // }
  }

  _initializeTimer() {
    // print("session time start:::" +
    //     DateTime.now().toIso8601String() +
    //     " ::: " +
    //     widget.user.timeoutLogin.toString() +
    //     "_countTimer:::" +
    //     _countTimer.toString());
    // // _timer = Timer.periodic(Duration(minutes: widget.user.timeoutLogin),
    // _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
    //   _countTimer += 1;
    //   print("_countTimer:::" + _countTimer.toString());
    //   if (_countTimer >= _minutesTimeout) {
    //     print("session timed out:::" +
    //         DateTime.now().toIso8601String() +
    //         " ::: " +
    //         widget.user.timeoutLogin.toString());
    //     timedOut();
    //     timer.cancel();
    //     _minutesTimeout = 999;
    //   }
    // });
  }

  Future<void> timedOut() async {
    // updateIsLogin(widget.user, 0);
    // await showDialog(
    //   context: _scaffoldKey.currentState!.context,
    //   barrierDismissible: false,
    //   builder: (context) => new AlertDialog(
    //     title: new Text('Alert'),
    //     content: Text('Maaf anda telah logout karena tidak aktif ...'),
    //     actions: <Widget>[
    //       new ElevatedButton(
    //         onPressed: () {
    //           //updateIsLogin(_user,0);
    //           Navigator.pushAndRemoveUntil<dynamic>(
    //             context,
    //             MaterialPageRoute<dynamic>(
    //               builder: (BuildContext context) => LauncherPage(),
    //             ),
    //             (route) => false,
    //           );
    //         },
    //         child: new Text('OK'),
    //       ),
    //     ],
    //   ),
    // );
  }

  void updateIsLogin(User user, int isLogin) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var dataPassword = {
          "id": user.id,
          "updated_by": user.id,
          "is_login_mobile": isLogin,
        };

        var response = await RestService()
            .restRequestService(SystemParam.fUpdateIsLogin, dataPassword);

        var convertDataToJson = json.decode(response.body);
        var code = convertDataToJson['code'];
        print("code:::" + code);
      }
    } on SocketException catch (_) {
      Warning.showWarning("No Internet Connection !!!");
    }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   setState(() {
  //     // _lastLifecycleState = state;
  //     print("AppLifecycleState:::: $state");

  //   });
  // }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    // _minutesTimeout = widget.user.timeoutLogin;
    // _initializeTimer();
    //sessionTimer.userActivityDetected(_scaffoldKey.currentState!.context,widget.user);

    getMenuOtorize();
    getEnv();
    userNotice();
    getParameterUdf();
    getParameterUdfOption();
    getParameterActivity();
    getParameterProgresStatus();
    getParameter();
    getParameterUsaha();
    getParameterKategoriProduk();
    getParameterProduk();
    getWorkplanMessages();
    getParameterTujuanKunjungan();
    getParameterHasilKunjungan();
    getParameterMappingActivity();

    /* TASK */
    getWorkplanList();
    getWorkplanVisitList();
    getWorkplanDokumenList();
    //getDeviceLocation();

    // JANGAN LUPA DI BUKA LAGI NANTI !!!!
    // Timer.periodic(Duration(seconds: 10), (Timer timer) async {
    //   try {
    //     final result = await InternetAddress.lookup('example.com');
    //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //       //getWorkplanList();
    //       //getWorkplanVisitList();
    //       //getDeviceLocation();
    //       userNotice();
    //       //getWorkplanDokumenList();
    //     }
    //   } on SocketException catch (_) {
    //     //print('not connected');
    //   }
    // });

    // Timer.periodic(Duration(seconds: 10), (Timer timer) async {

    //  });

    _container = [
      new BerandaPage(
        user: widget.user,
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        behavior: HitTestBehavior.translucent,
        // onTap: () {
        // _handleUserInteraction(context);
        //},
        // onPanDown: (){
        //   _handleUserInteraction();
        // },
        // onHorizontalDragStart: SessionTimer().userActivityDetected(context,widget.user),
        child: WillPopScope(
            onWillPop: () async {
              await showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: new Text('Are you sure?'),
                  content: new Text('Do you want to exit an App'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text('No'),
                    ),
                    TextButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove("dataUser");
                        /* LOGOUT */
                        updateIsLogin(widget.user, 0);
                        // widget.sessionTimer.stopTimer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LauncherPage(),
                            ));
                      },
                      child: new Text('Yes'),
                    ),
                  ],
                ),
              );
              return false;
            },
            child: Scaffold(
              key: _scaffoldKey,
              body: _container[_bottomNavCurrentIndex],
            )));
  }

  void getParameterUdf() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');

        var data = {"company_id": widget.user.userCompanyId};
        var response = await RestService()
            .restRequestService(SystemParam.fParameterUdfList, data);
        ParameterUdfModel parameterUdfModel =
            parameterUdfModelFromJson(response.body.toString());
        List<ParameterUdf> parameterUdfList = parameterUdfModel.data;

        await db.deleteParameterUdf();
        for (var i = 0; i < parameterUdfList.length; i++) {
          await db.insertParameterUdf(parameterUdfList[i]);
        }
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  Future<void> checkInTimeOutNotification() async {
    var now = DateTime.now();
    // await DatabaseHelper().db.then((database) {
    await db.getVisitCheckInLogList().then((vl) {
      setState(() {
        List<VisitChecInLog> vlData = vl;
        for (var i = 0; i < vlData.length; i++) {
          var checkInBatas = DateTime.parse(vlData[i].checkInBatas);
          if (now.isAfter(checkInBatas)) {
            //print("notif timeout");
            notification(context, vlData[i]);
          }
        }
      });
    });
    // });
  }

  getWorkplanList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');

        //get to update Inbox
        await db.getWorkplanActivityUpdateInbox().then((value) async {
          //print("value"+value.length.toString());
          var jsonData = value;
          //print(jsonData);
          var data = {"worklan_inbox_list": jsonData};
          // print(data);
          // var respons =
          await RestService()
              .restRequestService(SystemParam.fWorkplanInboxUpdateList, data);
          //print("getWorkplanActivityInboxForUpdate :" + respons.body.toString());
        });

        await db.getWorkplanActivityUpdatePersonal().then((value) async {
          print(value.length);
          if (null != value && value.length > 0) {
            // var jsonData = value;
            //print(jsonData);
            var data = {"worklan_personal_list": value};
            // print(data);
            var respons = await RestService().restRequestService(
                SystemParam.fWorkplanPersonalUpdateList, data);
            print("fWorkplanPersonalUpdateList :" + respons.body.toString());
          }
        });

        await db.getWorkplanActivityUpdateProduk().then((value) async {
          //print("value"+value.length.toString());
          var jsonData = value;
          //print(jsonData);
          var data = {"worklan_produk_list": jsonData};
          // print(data);
          // var respons =
          await RestService()
              .restRequestService(SystemParam.fWorkplanProdukUpdateList, data);
          //print("getWorkplanActivityInboxForUpdate :" + respons.body.toString());
        });

        await db.getWorkplanActivityUpdateUdf().then((value) async {
          //print("value"+value.length.toString());
          var jsonData = value;
          //print(jsonData);
          var data = {"worklan_udf_list": jsonData};
          // print(data);
          // var respons =
          await RestService()
              .restRequestService(SystemParam.fWorkplanUdfUpdateList, data);
          //print("getWorkplanActivityInboxForUpdate :" + respons.body.toString());
        });

        var data = {"user_id": widget.user.id};
        var response = await RestService()
            .restRequestService(SystemParam.fWorkplanListAll, data);

        // setState(() {
        WorkplanInboxModel wi = workplanInboxFromJson(response.body.toString());
        // db.deleteWorkplanActivityInbox();
        await db.deleteWorkplanActivityAll();
        for (var i = 0; i < wi.data.length; i++) {
          await db.insertWorkplanActivity(wi.data[i].toMap());
        }
        // });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  void notification(context, VisitChecInLog vlData) {
    showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: SafeArea(
          child: ListTile(
            leading: SizedBox.fromSize(
                size: const Size(40, 40),
                child: ClipOval(
                    child: Container(
                  color: Colors.black,
                ))),
            subtitle: Text('No Task : ' +
                vlData.nomorWorkplan +
                ' Anda telah melampaui batas waktu kunjungan workplan, Simpan segera selesaikan aktifitas Anda dan lakukan check out'),
            trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  OverlaySupportEntry.of(context)!.dismiss();
                }),
          ),
        ),
      );
    }, duration: Duration(milliseconds: 60000));
  }

  void userNotice() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');

        var data = {
          "user_id": widget.user.id,
          "company_id": widget.user.userCompanyId,
          "organization_id": widget.user.organizationId,
          "function_id": widget.user.functionId,
          "structure_id": widget.user.structureId,
        };

        var response =
            await RestService().restRequestService(SystemParam.fNotice, data);

        var convertDataToJson = json.decode(response.body);
        var code = convertDataToJson['code'];

        if (code == "0") {
          await db.deleteNotice();
          NoticeModel messageModel =
              noticeModelFromJson(response.body.toString());
          List<Notice> messageList = messageModel.data;
          for (var i = 0; i < messageList.length; i++) {
            await db.insertNotice(messageList[i]);
          }
        }
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getParameterUdfOption() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');

        var data = {"company_id": widget.user.userCompanyId};
        var response = await RestService()
            .restRequestService(SystemParam.fParameterUdfOption, data);
        ParameterUdfOptionModel udfOptionModel =
            parameterUdfOptionModelFromJson(response.body.toString());
        List<ParameterUdfOption> parameterUdfList = udfOptionModel.data;

        await db.deleteParameterUdfOption();
        for (var i = 0; i < parameterUdfList.length; i++) {
          await db.insertParameterUdfOption(parameterUdfList[i]);
        }
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getParameterActivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');
        ParameterActivityModel parameterModel;
        var data = {"company_id": widget.user.userCompanyId};

        var response = await RestService()
            .restRequestService(SystemParam.fParameterActivity, data);
        print('ini parameter activity <<<<=========');
        print(response.body);

        parameterModel =
            parameterActivityModelFromJson(response.body.toString());
        List<ParameterActivity> parameterActivityList = parameterModel.data;

        await db.deleteParameterActivity();
        for (var i = 0; i < parameterActivityList.length; i++) {
          await db.insertParameterActivity(parameterActivityList[i]);
        }
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getWorkplanVisitList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');

        List<WorkplanVisit> visitList = <WorkplanVisit>[];

        await db.getVisitListUpdate().then((value) async {
          visitList = value;
          var data = {"worklan_visit_list": value};
          await RestService()
              .restRequestService(SystemParam.fWorkplanVisitUpdateList, data);
        });

        for (var i = 0; i < visitList.length; i++) {
          uploadImageVisit(visitList[i]);
        }

        var data = {
          "user_id": widget.user.id,
        };

        var response = await RestService()
            .restRequestService(SystemParam.fWorkplanVisitListByUserId, data);

        WorkplanVisitModel workplanVisitModel =
            workplanVisitModelFromJson(response.body.toString());
        int count = workplanVisitModel.data.length;

        await db.deleteWorkplanVisit();
        for (var i = 0; i < count; i++) {
          await db.insertWorkplanVisit(workplanVisitModel.data[i]);
        }
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getParameterProgresStatus() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');
        ParameterProgresStatusModel parameterModel;
        var data = {"company_id": widget.user.userCompanyId};

        var response = await RestService()
            .restRequestService(SystemParam.fParameterProgresStatus, data);

        parameterModel =
            parameterProgresStatusModelFromJson(response.body.toString());
        List<ParameterProgresStatus> parameterList = parameterModel.data;

        await db.deleteParameterProgresStatus();
        for (var i = 0; i < parameterList.length; i++) {
          await db.insertParameterProgresStatus(parameterList[i]);
        }
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getParameter() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');

        var data = {"company_id": widget.user.userCompanyId};
        var response = await RestService()
            .restRequestService(SystemParam.fParameter, data);
        //print("parameter " + response.body.toString());
        ParameterModel parameterModel =
            parameterModelFromJson(response.body.toString());
        List<Parameter> parameterList = parameterModel.data;

        await db.deleteParameter();
        for (var i = 0; i < parameterList.length; i++) {
          await db.insertParameter(parameterList[i]);
        }
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getParameterUsaha() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');

        var data = {"company_id": widget.user.userCompanyId};
        var response = await RestService()
            .restRequestService(SystemParam.fParameterUsaha, data);

        //print("parameter usaha" + response.body.toString());
        ParameterUsahaModel parameterModel =
            parameterUsahaModelFromJson(response.body.toString());
        List<ParameterUsaha> parameterList = parameterModel.data;

        await db.deleteParameterUsaha();
        for (var i = 0; i < parameterList.length; i++) {
          await db.insertParameterUsaha(parameterList[i]);
        }
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getParameterKategoriProduk() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "company_id": widget.user.userCompanyId,
        };

        // print(data);

        var response = await RestService().restRequestService(
            SystemParam.fParameterKategoriProdukByCompanyId, data);

        // print("kategori produk"+response.body.toString());

        // setState(() async {
        ParameterKategoriProdukModel parameterModel =
            parameterKategoriProdukModelFromJson(response.body.toString());
        List<ParameterKategoriProduk> parameterKategoriProdukList =
            parameterModel.data;

        await db.deleteParameterKategoriProduk();
        for (var i = 0; i < parameterKategoriProdukList.length; i++) {
          // db.insertParameter
          await db
              .insertParameterKategoriProduk(parameterKategoriProdukList[i]);
        }
        // });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getParameterProduk() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "company_id": widget.user.userCompanyId,
        };

        var response = await RestService()
            .restRequestService(SystemParam.fParameterProdukByCompanyId, data);
        // print("produk:"+response.body.toString());
        // setState(() async {
        ParameterProdukModel parameterModel =
            parameterProdukModelFromJson(response.body.toString());
        List<ParameterProduk> parameterProdukList = parameterModel.data;

        await db.deleteParameterProduk();
        for (var i = 0; i < parameterProdukList.length; i++) {
          // db.insertParameter
          await db.insertParameterProduk(parameterProdukList[i]);
        }
        // });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  void getWorkplanMessages() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // var userId = widget.user.data.id;
        var data = {
          "user_id": widget.user.id
          // ,"progres_status_id": progresStatusId
        };

        var response = await RestService()
            .restRequestService(SystemParam.fWorkplanMessagesByUserId, data);

        // setState(() async {
        WorkplanMessagesModel wmM =
            workplanMessagesFromJson(response.body.toString());
        // List<WorkplanMessagesData> data = wmM.data;
        await db.deleteWorkplanMessages();
        for (var i = 0; i < wmM.data.length; i++) {
          await db.insertWorkplanMessages(wmM.data[i]);
        }
        // });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getParameterTujuanKunjungan() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "company_id": widget.user.userCompanyId,
        };

        var response = await RestService().restRequestService(
            SystemParam.fParameterTujuanKunjunganByCompanyId, data);

        // print("response.body.toString()"+response.body.toString());
        // setState(() async {
        ParameterTujuanKunjunganModel parameterModel =
            parameterTujuanKunjunganFromJson(response.body.toString());
        List<ParameterTujuanKunjungan> parameterList = parameterModel.data;
        db.deleteParameterTujuanKunjungan();
        for (var i = 0; i < parameterList.length; i++) {
          await db.insertParameterTujuanKunjungan(parameterList[i]);
        }
        // });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getParameterHasilKunjungan() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "company_id": widget.user.userCompanyId,
        };

        var response = await RestService().restRequestService(
            SystemParam.fParameterHasilKunjunganByCompanyId, data);

        // setState(() async {
        ParameterHasilKunjunganModel parameterModel =
            parameterHasilKunjunganFromJson(response.body.toString());
        List<ParameterHasilKunjungan> parameterList = parameterModel.data;
        db.deleteParameterHasilKunjungan();
        for (var i = 0; i < parameterList.length; i++) {
          await db.insertParameterHasilKunjungan(parameterList[i]);
        }
        // });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getDeviceLocation() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _getLocation().then((value) {
          // setState(() {
          gl.Position userLocation = value;
          //String currentAddress = "";
          String datetime =
              SystemParam.formatDateTimeValue.format(DateTime.now());

          getAddress(userLocation).then((addrss) {
            DeviceLocation dl = DeviceLocation(
                address: addrss,
                latitude: userLocation.latitude.toString(),
                longitude: userLocation.longitude.toString(),
                createdDate: datetime);
            db.deleteDeviceLocation();
            db.insertDeviceLocation(dl);
          });
          // });
        });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  Future<gl.Position> _getLocation() async {
    //loading = true;
    var currentLocation;
    lp.PermissionStatus permission = await _getLocationPermission();
    if (permission == lp.PermissionStatus.granted) {
      try {
        currentLocation = await gl.Geolocator.getCurrentPosition(
            desiredAccuracy: gl.LocationAccuracy.best);
      } catch (e) {
        currentLocation = null;
      }
    }
    return currentLocation;
  }

  Future<lp.PermissionStatus> _getLocationPermission() async {
    final lp.PermissionStatus permission = await lp.LocationPermissions()
        .checkPermissionStatus(level: lp.LocationPermissionLevel.location);

    if (permission != lp.PermissionStatus.granted) {
      final lp.PermissionStatus permissionStatus =
          await lp.LocationPermissions().requestPermissions(
              permissionLevel: lp.LocationPermissionLevel.location);

      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<String> getAddress(gl.Position userLocation) async {
    String address = "";
    List<gc.Placemark> placemark = await gc.placemarkFromCoordinates(
        userLocation.latitude, userLocation.longitude);

    // setState(() {
    try {
      // ignore: unnecessary_null_comparison
      if (placemark[0] != null) {
        String fulladdress = placemark[0].toString();

        // String name = placemark[0].street != null
        //     ? placemark[0].street.toString()
        //     : "";
        String subThoroughfare = placemark[0].subThoroughfare != null
            ? placemark[0].subThoroughfare.toString()
            : "";

        String thoroughfare = placemark[0].thoroughfare != null
            ? placemark[0].thoroughfare.toString()
            : "";
        String subLocality = placemark[0].subLocality != null
            ? placemark[0].subLocality.toString()
            : "";
        String locality = placemark[0].locality != null
            ? placemark[0].locality.toString()
            : "";
        String administrativeArea = placemark[0].administrativeArea != null
            ? placemark[0].administrativeArea.toString()
            : "";
        String postalCode = placemark[0].postalCode != null
            ? placemark[0].postalCode.toString()
            : "";
        String country =
            placemark[0].country != null ? placemark[0].country.toString() : "";

        address = thoroughfare +
            ", " +
            subThoroughfare +
            ", " +
            subLocality +
            ", " +
            locality +
            ", " +
            administrativeArea +
            ", " +
            postalCode +
            ", " +
            country;

        address = fulladdress;
        // _currentAddress = address;
        // _addressCtr.text = address;
      }
    } catch (e) {
      address = "";
    }
    // });
    return address;
  }

  Future<void> uploadImageVisit(WorkplanVisit visit) async {
    try {
      var uri =
          Uri.parse(SystemParam.baseUrl + SystemParam.fUploadImageCheckInOut);
      var request = new http.MultipartRequest("POST", uri);

      final tempDir = await getTemporaryDirectory();

      if (visit.baseImageCheckIn != null && visit.baseImageCheckIn != "") {
        String baseImageCheckIn = visit.baseImageCheckIn;
        Uint8List bytesCheckIn = base64.decode(baseImageCheckIn);
        Utility.getImageFromPreferences(visit.photoCheckIn.split('/').last)
            .then((img) {
          if (null == img) {
            return;
          }
          bytesCheckIn = base64.decode(img);
        });

        File fileCheckIn =
            await File('${tempDir.path}/' + visit.photoCheckIn.split('/').last)
                .create();
        fileCheckIn.writeAsBytesSync(bytesCheckIn);

        var streamCheckIn =
            new http.ByteStream(Stream.castFrom(fileCheckIn.openRead()));
        var lengthCheckIn = await fileCheckIn.length();

        var multipartFileCheckIn = new http.MultipartFile(
            'image_check_in', streamCheckIn, lengthCheckIn,
            filename: basename(fileCheckIn.path));

        request.fields['file_name_check_in'] = visit.photoCheckIn;
        request.files.add(multipartFileCheckIn);
      }

      if (visit.baseImageCheckOut != null && visit.baseImageCheckOut != "") {
        String baseImageCheckOut = visit.baseImageCheckOut;
        Uint8List bytesCheckOut = base64.decode(baseImageCheckOut);

        Utility.getImageFromPreferences(visit.photoCheckOut.split('/').last)
            .then((img) {
          if (null == img) {
            return;
          }
          //Image imageCheckIn = Utility.imageFromBase64String(img);
          bytesCheckOut = base64.decode(img);
        });

        File fileCheckOut =
            await File('${tempDir.path}/' + visit.photoCheckOut.split('/').last)
                .create();
        fileCheckOut.writeAsBytesSync(bytesCheckOut);

        var streamCheckOut =
            new http.ByteStream(Stream.castFrom(fileCheckOut.openRead()));
        var lengthCheckOut = await fileCheckOut.length();

        var multipartFileCheckOut = new http.MultipartFile(
            'image_check_out', streamCheckOut, lengthCheckOut,
            filename: basename(fileCheckOut.path));
        request.files.add(multipartFileCheckOut);
        request.fields['file_name_check_out'] = visit.photoCheckOut;
      }

      request.fields['updated_by'] = widget.user.id.toString();
      request.fields['visit_id'] = visit.id.toString();
      request.fields['company_id'] = widget.user.userCompanyId.toString();

      var response = await request.send();
      //print("response.statusCode:"+response.statusCode.toString());

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        // print(value);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  getParameterMappingActivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "company_id": widget.user.userCompanyId,
        };

        var response = await RestService()
            .restRequestService(SystemParam.fParameterMappingAktifitas, data);

        // setState(() async {
        ParameterMappingAktifitasModel parameterModel =
            parameterMappingAktifitasModelFromJson(response.body.toString());
        List<ParameterMappingAktifitas> parameterList = parameterModel.data;
        db.deleteParameterMappingActivity();
        for (var i = 0; i < parameterList.length; i++) {
          await db.insertParameterMappingActivity(parameterList[i]);
        }
        // });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  getWorkplanDokumenList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "user_id": widget.user.id,
        };

        var response = await RestService()
            .restRequestService(SystemParam.fWorkplanDokumenByUserId, data);

        // setState(() async {
        WorkplanDokumenModel model =
            workplanDokumenModelFromJson(response.body.toString());
        List<WorkplanDokumen> wdList = model.data;
        db.deleteWorkplanDokumen();
        for (var i = 0; i < wdList.length; i++) {
          await db.insertWorkplanDokumen(wdList[i]);
        }
        // });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  //deleteMenuOtorize
  getMenuOtorize() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "role_id": widget.user.roleId,
          "company_id": widget.user.userCompanyId
        };

        var response =
            await RestService().restRequestService(SystemParam.fMenu, data);

        // setState(() async {
        MenuOtorizeModel model =
            menuOtorizeModelFromJson(response.body.toString());
        List<MenuOtorize> wdList = model.data;
        await db.deleteMenuOtorize();
        for (var i = 0; i < wdList.length; i++) {
          await db.insertMenuOtorize(wdList[i]);
        }
        // });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  @override
  Widget rootWidget(BuildContext context) {
    // TODO: implement rootWidget
    throw UnimplementedError();
  }

  getEnv() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "user_id": widget.user.id,
          "company_id": widget.user.userCompanyId
        };

        var response =
            await RestService().restRequestService(SystemParam.fGetEnvS3, data);

        // setState(() async {
        EnvModel model = envModelFromJson(response.body.toString());
        List<Env> wdList = model.data;
        await db.deleteEnv();
        for (var i = 0; i < wdList.length; i++) {
          await db.insertEnv(wdList[i]);
        }
        // });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }
}
