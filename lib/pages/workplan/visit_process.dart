import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/visit_checkin_log_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/model/workplan_visit_model.dart';
import 'package:workplan_beta_test/pages/workplan/visit_checkin.dart';
import 'package:workplan_beta_test/pages/workplan/visit_checkout.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_visit_list.dart';
import 'package:location_permissions/location_permissions.dart' as lp;
import 'package:geolocator/geolocator.dart' as gl;
import 'package:workplan_beta_test/widget/warning.dart';

class VisitProcess extends StatefulWidget {
  final WorkplanInboxData workplan;
  final WorkplanVisit workplanVisit;
  final User user;
  final int nomor;
  final bool isMaximumUmur;

  const VisitProcess(
      {Key? key,
      required this.workplan,
      required this.workplanVisit,
      required this.user,
      required this.nomor,
      required this.isMaximumUmur})
      : super(key: key);
  @override
  _VisitProcessState createState() => _VisitProcessState();
}

class _VisitProcessState extends State<VisitProcess> {
  final _keyForm = GlobalKey<FormState>();
  MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);
  late WorkplanInboxData wid;
  bool loading = false;
  bool isPhotoFromCamCheckIn = false;
  bool isPhotoFromCamCheckOut = false;
  // late Timer _timer;
  var db = new DatabaseHelper();
  var geoLocator = Geolocator();
  // SessionTimer sessionTimer = new SessionTimer();
  // cons twentyMillis = Duration(milliseconds: 20);
  var location = Location();

  @override
  void initState() {
    // Timer.periodic(Duration(minutes: 1), (Timer timer) {
    //   checkInTimeOutNotification();
    // });

    super.initState();
    // _getLocation().then((valuel) {});
    wid = widget.workplan;
    // getWorkplanById();

    //print("widget.workplanVisit.flagUpdate:"+widget.workplanVisit.flagUpdate.toString());
  }

  // Future<bool?> getDeviceLocation() async {
  //   print('get device location');
  //   bool? hasil;
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       _getLocation().then((value) {
  //         print('ini value dari get device location <<<<<<========');
  //         print(value);
  //         hasil = value!;
  //         // setState(() {
  //         //   loading = true;
  //         //   userLocation = value;
  //         //   getAddress(userLocation).then((value) => {_currentAddress = value});
  //         //   _addressCtr.text = _currentAddress;
  //         //   _initialcameraposition = LatLng(value.latitude, value.longitude);
  //         //   isInitialCamera = true;
  //         //   _latitude = value.latitude.toString();
  //         //   _longitude = value.longitude.toString();
  //         //   loading = false;
  //         // });
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     Warning.showWarning('No Internet Connection');
  //     //print('not connected');
  //     // setState(() {
  //     //   loading = true;
  //     //   db.getDeviceLocation().then((value) {
  //     //     _currentAddress = value.address;
  //     //     _addressCtr.text = value.address;
  //     //     _latitude = value.latitude;
  //     //     _longitude = value.longitude;

  //     //     double latitude = double.parse(value.latitude);
  //     //     double longitude = double.parse(value.longitude);
  //     //     _initialcameraposition = LatLng(latitude, longitude);
  //     //     isInitialCamera = true;
  //     //     loading = false;
  //     //   });
  //     // });
  //   }
  //   return hasil;
  // }

  Future<bool?> _getLocation() async {
    print('masuk get location');
    var currentLocation;
    lp.PermissionStatus permission = await _getLocationPermission();
    if (permission == lp.PermissionStatus.granted) {
      print('disini permission status grand');
      try {
        currentLocation = await gl.Geolocator.getCurrentPosition(
            desiredAccuracy: gl.LocationAccuracy.best);
        print(currentLocation);
        if (currentLocation != null) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        currentLocation = null;
        return false;
        print('masuk ke catch error');
        print(e);
      }
    } else if (permission == lp.PermissionStatus.denied) {
      print('disini permission status denied <<<====');
      return null;
    } else if (permission == lp.PermissionStatus.restricted) {
      print('disini permission status restricted <<<====');
      return null;
    } else {
      return false;
    }
    // return currentLocation;
  }

  cekGps() async {
    print('cek gps');
    bool enabled = await location.serviceEnabled();
    print(enabled);
    // final lp.ServiceStatus permission = await lp.LocationPermissions()
    //     .checkServiceStatus(level: lp.LocationPermissionLevel.location);
    // print(permission);
  }

  Future<lp.PermissionStatus> _getLocationPermission() async {
    print('getlocationpermission');
    print('menunggu permissions...');
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

  @override
  Widget build(BuildContext context) {
    var lblCheckInOut = "CHECK IN";
    //if (widVisit.checkIn != null && widVisit.checkIn != "") {
    // if (wid.isCheckIn == "1" ) {
    // ignore: unnecessary_null_comparison
    if (widget.workplanVisit.isCheckIn == "1" &&
        // ignore: unnecessary_null_comparison
        (widget.workplanVisit.isCheckOut == null ||
            widget.workplanVisit.isCheckOut == "0")) {
      lblCheckInOut = "CHECK OUT";
      isPhotoFromCamCheckIn = true;
    }

    if (widget.workplanVisit.isCheckOut == "1") {
      isPhotoFromCamCheckOut = true;
    }

    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkplanVisitList(
                    workplan: widget.workplan,
                    user: widget.user,
                    isMaximumUmur: widget.isMaximumUmur),
              ));
          return false;
        },
        child: Scaffold(
            //drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              title: Text('Visit Activity Task'),
              centerTitle: true,
              backgroundColor: colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkplanVisitList(
                            workplan: widget.workplan,
                            user: widget.user,
                            isMaximumUmur: widget.isMaximumUmur),
                      ));
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _keyForm,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            color: Colors.white,
                            elevation: 0.1,
                            child: ListTile(
                              leading: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0.0, top: 8.0),
                                child: Icon(
                                  Icons.card_travel,
                                  color: colorCustom,
                                  size: 50,
                                ),
                              ),
                              title: Text(wid.nomorWorkplan,
                                  style: TextStyle(fontSize: 12)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wid.fullName,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Badge(
                                      toAnimate: false,
                                      shape: BadgeShape.square,
                                      badgeColor: colorCustom,
                                      borderRadius: BorderRadius.circular(8),
                                      badgeContent: Text(
                                          wid.progresStatusDescription,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Icon(Icons.more_vert)
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Rencana Kunjungan ke " +
                                          widget.nomor.toString(),
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
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
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              initialValue: SystemParam.formatDateDisplay
                                  .format(widget.workplanVisit.visitDatePlan),
                              readOnly: false,
                              //validator: requiredValidator,
                              enabled: false,
                              onSaved: (em) {
                                //if (em != null) {}
                              },
                              decoration: InputDecoration(
                                icon: new Icon(Icons.date_range),
                                fillColor: colorCustom,
                                // labelText: labelUdfTextA1,
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: DateTimeField(
                          //     enabled: false,
                          //     format: SystemParam.formatDateDisplay,
                          //     initialValue: widget.workplanVisit.visitDatePlan!,
                          //     onShowPicker: (context, currentValue) async {
                          //       final date = await showDatePicker(
                          //           context: context,
                          //           firstDate: DateTime(1900),
                          //           initialDate: widget.workplanVisit.visitDatePlan!,
                          //           lastDate: DateTime(2100));

                          //       return date;
                          //     },
                          //     decoration: InputDecoration(
                          //       icon: new Icon(Icons.date_range),
                          //       fillColor: colorCustom,
                          //       labelText: "Rencana Kunjungan ",
                          //       labelStyle: TextStyle(
                          //           color: colorCustom,
                          //           fontStyle: FontStyle.italic),
                          //       enabledBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(color: colorCustom),
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(10))),
                          //       focusedBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(color: colorCustom),
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(10))),
                          //       contentPadding: EdgeInsets.all(10),
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text(lblCheckInOut),
                                style: ElevatedButton.styleFrom(
                                  primary: colorCustom,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () async {
                                  // sessionTimer.userActivityDetected(context, widget.user);
                                  cekAkses(lblCheckInOut == 'CHECK IN'
                                      ? 'CHECK IN'
                                      : 'CHECK OUT');
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  cekAkses(String type) async {
    bool? timeAuto = await DatetimeSetting.timeIsAuto();
    bool? timezoneAuto = await DatetimeSetting.timeZoneIsAuto();
    try {
      Warning.loading(context);
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _getLocation().then((value) {
          print('ini value dari get device location <<<<<<========');
          next() {
            if (value!) {
              // print(
              //     'hasil cek auto datetime and atuo timezone <<<<<<<<<<=========');
              // print(timeAuto);
              // print(timezoneAuto);
              if (!timeAuto || !timezoneAuto) {
                Navigator.pop(context);
                Warning.showWarning(
                    "Harap aktifkan auto date time & auto timezone agar bisa melanjutkan proses");
                return;
              } else {
                if (type == "CHECK IN") {
                  print('masuk checkin');
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitCheckIn(
                          workplan: wid,
                          workplanVisit: widget.workplanVisit,
                          user: widget.user,
                          lblCheckInOut: type,
                          isMaximumUmur: widget.isMaximumUmur,
                          nomor: widget.nomor,
                          isPhotoFromCam: isPhotoFromCamCheckIn,
                        ),
                      ));
                } else {
                  print('masuk checkout');
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitCheckOut(
                          workplan: wid,
                          workplanVisit: widget.workplanVisit,
                          user: widget.user,
                          lblCheckInOut: type,
                          isMaximumUmur: widget.isMaximumUmur,
                          nomor: widget.nomor,
                          isPhotoFromCam: isPhotoFromCamCheckOut,
                        ),
                      ));
                }
                // Navigator.pop(context);
                // Navigator.pushNamed(
                //   context,
                //   locationClockInClockOut,
                //   arguments: {"type": type, "user": userString},
                // );
              }
            } else {
              Navigator.pop(context);
              Warning.showWarning('Aktifkan GPS Terlebih Dahulu!!!');
            }
          }

          warning() {
            Navigator.pop(context);
            Warning.showWarning('Berikan Akses Lokasi Terlebih Dahulu!!!');
          }

          print(value);
          value == null ? warning() : next();
        });
      }
    } on SocketException catch (_) {
      Navigator.pop(context);
      Warning.showWarning('No Internet Connection');
    }
  }

  // void getWorkplanById() async {
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       loading = true;
  //       var data = {
  //         "id": widget.workplan.id,
  //       };
  //       var response = await RestService()
  //           .restRequestService(SystemParam.fWorkplanById, data);
  //       setState(() {
  //         WorkplanInboxModel wi =
  //             workplanInboxFromJson(response.body.toString());
  //         wid = wi.data[0];
  //         loading = false;
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     Warning.showWarning("No Internet Connection");
  //   }
  // }

  // void checkInTimeOutNotification() {
  //   var now = DateTime.now();
  //   DatabaseHelper().db.then((database) {
  //     Future<List<VisitChecInLog>> vlFuture = db.getVisitCheckInLogList();
  //     vlFuture.then((vl) {
  //       setState(() {
  //         List<VisitChecInLog> vlData = vl;
  //         //print("checkInBatas:"+vlData[0].checkInBatas);
  //         // print("vlData.length :"+vlData.length.toString());
  //         for (var i = 0; i < vlData.length; i++) {
  //           var checkInBatas = DateTime.parse(vlData[0].checkInBatas);
  //           //var checkInBatas = DateTime.parse("2021-09-29 16:09:00");
  //           if (now.isAfter(checkInBatas)) {
  //             //print("notif timeout");
  //             notification(context, vlData[0]);
  //           }
  //           print("checkInBatas:" +
  //               checkInBatas.toString() +
  //               ",now:" +
  //               now.toString());
  //         }
  //       });
  //     });
  //   });
  // }

  // void notification(context, VisitChecInLog vlData) {
  //   showOverlayNotification((context) {
  //     return Card(
  //       margin: const EdgeInsets.symmetric(horizontal: 4),
  //       child: SafeArea(
  //         child: ListTile(
  //           leading: SizedBox.fromSize(
  //               size: const Size(40, 40),
  //               child: ClipOval(
  //                   child: Container(
  //                 color: Colors.black,
  //               ))),
  //           //title: Text('Batas Waktu Kunjungan'),
  //           subtitle: Text(
  //               ' Anda telah melampaui batas waktu kunjungan workplan, Simpan segera selesaikan aktifitas Anda dan lakukan check out'),
  //           trailing: IconButton(
  //               icon: Icon(Icons.close),
  //               onPressed: () {
  //                 OverlaySupportEntry.of(context)!.dismiss();
  //               }),
  //         ),
  //       ),
  //     );
  //   }, duration: Duration(milliseconds: 8000));
  // }
  // void cekGps() async {
  //   // bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
  //   // print('hasil cek GPS aktif atau tidak');
  //   // print(isLocationEnabled);
  //   var status = await geoLocator.checkGeolocationPermissionStatus();
  //   print('hasil cek GPS aktif atau tidak');
  //   print(status);
  //   //   if (status == GeolocationStatus.denied);
  //   //     // Take user to permission settings
  //   //   else if (status == GeolocationStatus.disabled)
  //   //     // Take user to location page
  //   //   else if (status == GeolocationStatus.restricted)
  //   //     // Restricted
  //   //   else if (status == GeolocationStatus.unknown)
  //   //     // Unknown
  //   //   else if (status == GeolocationStatus.granted)
  // }
}
