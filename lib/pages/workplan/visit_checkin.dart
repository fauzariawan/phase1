import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart' as gl;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart' as lp;
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/helper/utility_image.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/visit_checkin_log_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/model/workplan_visit_model.dart';
import 'package:workplan_beta_test/pages/workplan/visit_process.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data.dart';
// import 'package:workplan_beta_test/pages/workplan/visit_checkout.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_view.dart';
import 'package:workplan_beta_test/widget/warning.dart';

import 'visit_checkin_take_picture.dart';

class VisitCheckIn extends StatefulWidget {
  final WorkplanInboxData workplan;
  final WorkplanVisit workplanVisit;
  final User user;
  final String lblCheckInOut;
  final bool isMaximumUmur;
  final int nomor;
  final bool isPhotoFromCam;

  const VisitCheckIn(
      {Key? key,
      required this.workplan,
      required this.workplanVisit,
      required this.user,
      required this.lblCheckInOut,
      required this.isMaximumUmur,
      required this.nomor,
      required this.isPhotoFromCam})
      : super(key: key);
  @override
  _VisitCheckInState createState() => _VisitCheckInState();
}

class _VisitCheckInState extends State<VisitCheckIn> {
  final _keyForm = GlobalKey<FormState>();
  MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);
  bool loading = false;
  late gl.Position userLocation;
  late String _currentAddress = "";
  TextEditingController _addressCtr = new TextEditingController();
//  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late LatLng _initialcameraposition = LatLng(-6.2293867, 106.6894316);
  bool isInitialCamera = false;
  Location _location = Location();
  // late GoogleMapController _controllerGmaps;
  var progressStatusId = 2;
  late var time = SystemParam.formatTime.format(DateTime.now());
  late Image _imageFromPreferences;
  late WorkplanVisit _widVisit;
  bool isPhotoCheckIn = false;
  late WorkplanInboxData _wid;
  var photoCheckIn = "";
  var db = new DatabaseHelper();
  String _latitude = "";
  String _longitude = "";
  //  SessionTimer sessionTimer = new SessionTimer();
  // late LatLng _initialcameraposition;

  // bool isPhotoFromCam = false;
  // WorkplanInboxData _workplan;
  TextEditingController ket1 = TextEditingController();
  TextEditingController ket2 = TextEditingController();

  @override
  void initState() {
    super.initState();

    getDeviceLocation();
    _wid = widget.workplan;
    _widVisit = widget.workplanVisit;
    getWorkplanById();

    setState(() {
      if (_widVisit.photoCheckIn != null && widget.isPhotoFromCam) {
        isPhotoCheckIn = true;
        loadImageFromPreferences(_widVisit.photoCheckIn);
        photoCheckIn = _widVisit.photoCheckIn;
      } else {
        photoCheckIn = "";
      }

      time = SystemParam.formatTime.format(DateTime.now());
    });

    //print("isPhotoCheckIn:" + isPhotoCheckIn.toString());
  }

  @override
  Widget build(BuildContext context) {
    //final photos = <File>[];

    return WillPopScope(
        onWillPop: () async {
          //  sessionTimer.userActivityDetected(context, widget.user);
          //  Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VisitProcess(
                  workplan: widget.workplan,
                  user: widget.user,
                  isMaximumUmur: widget.isMaximumUmur,
                  nomor: widget.nomor,
                  workplanVisit: widget.workplanVisit,
                ),
              ));
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.lblCheckInOut),
              centerTitle: true,
              backgroundColor: colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitProcess(
                          workplan: widget.workplan,
                          user: widget.user,
                          isMaximumUmur: widget.isMaximumUmur,
                          nomor: widget.nomor,
                          workplanVisit: widget.workplanVisit,
                        ),
                      ));
                },
              ),
            ),
            body: loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Form(
                    key: _keyForm,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: widget.lblCheckInOut + ' Time: ',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: '$time',
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
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Alamat',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: true ? '  ' : ' ',
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
                              controller: _addressCtr,
                              keyboardType: TextInputType.multiline,
                              minLines:
                                  10, //Normal textInputField will be displayed
                              maxLines: 20,
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 11),
                              // initialValue:_currentAddress,
                              readOnly: false,
                              enabled: false,
                              decoration: InputDecoration(
                                //con: new Icon(Ionicons.document_outline),
                                fillColor: colorCustom,
                                //labelText: "Alamat Check In",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.italic),
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
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                isInitialCamera == false
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : SizedBox(
                                        width:
                                            500, // or use fixed size like 200
                                        height: 300,
                                        child: GoogleMap(
                                          initialCameraPosition: CameraPosition(
                                              target: _initialcameraposition,
                                              zoom: 15),
                                          mapType: MapType.normal,
                                          onMapCreated: _onMapCreated,
                                          myLocationEnabled: true,
                                        ))
                              ])),

                          Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: GestureDetector(
                            //   onTap: () {
                            //     if (widget.lblCheckInOut == "CHECK IN") {
                            //       // if (wVLcl.photoCheckIn != null &&
                            //       //     wVLcl.photoCheckIn != "") {
                            //       //   Navigator.push(
                            //       //       context,
                            //       //       MaterialPageRoute(
                            //       //           builder: (context) =>
                            //       //               VisitCheckinViewImage(
                            //       //                 workplanVisit: wVLcl,
                            //       //               )));
                            //       // } else {
                            //       doCapture(wVLcl);
                            //       // }
                            //     } else {
                            //       //CHECK OUT
                            //       // if (wVLcl.photoCheckOut != null &&
                            //       //     wVLcl.photoCheckOut != "") {
                            //       //   Navigator.push(
                            //       //       context,
                            //       //       MaterialPageRoute(
                            //       //           builder: (context) =>
                            //       //               VisitCheckinViewImage(
                            //       //                 workplanVisit: wVLcl,
                            //       //               )));
                            //       // } else {
                            //       doCapture(wVLcl);
                            //       // }
                            //     }
                            //   },
                            child: !isPhotoCheckIn
                                ? GestureDetector(
                                    onTap: () {
                                      //  sessionTimer.userActivityDetected(context, widget.user);
                                      doCapture(_widVisit);
                                    },
                                    child: Container(
                                      child: Icon(Ionicons.camera, size: 130),
                                    ))
                                : Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Container(
                                        child: _imageFromPreferences,
                                      ),
                                    ),
                                  ),
                          )),
                          // ),
                          !isPhotoCheckIn
                              ? Center(
                                  child: Container(
                                    child: Text("silakan ambil photo lokasi"),
                                  ),
                                )
                              : Text(""),

                          if (isPhotoCheckIn)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Keterangan 1"),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    controller: ket1,
                                    onChanged: (ket1) {
                                      print(ket1);
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Keterangan 2"),
                                  SizedBox(height: 5),
                                  TextFormField(
                                      controller: ket2,
                                      onChanged: (ket2) {
                                        print(ket2);
                                      },
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder())),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),

                          // ignore: unnecessary_null_comparison
                          // imageFromPreferences==null?Container():

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text("SUBMIT"),
                                style: ElevatedButton.styleFrom(
                                  primary: colorCustom,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  //prosesSave(empUpd);
                                  //  sessionTimer.userActivityDetected(context, widget.user);
                                  print('sudah di submit <<<<<<<<<<=========');
                                  submit();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
  }

  Future<gl.Position?> _getLocation() async {
    print('masuk get location');
    var currentLocation;
    lp.PermissionStatus permission = await _getLocationPermission();
    print('sudah dipilih');
    if (permission == lp.PermissionStatus.granted) {
      try {
        currentLocation = await gl.Geolocator.getCurrentPosition(
            desiredAccuracy: gl.LocationAccuracy.best);
      } catch (e) {
        currentLocation = null;
        print('masuk ke catch error');
        print(e);
      }
    } else if (permission == lp.PermissionStatus.denied) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisitProcess(
            workplan: widget.workplan,
            user: widget.user,
            isMaximumUmur: widget.isMaximumUmur,
            nomor: widget.nomor,
            workplanVisit: widget.workplanVisit,
          ),
        ),
      );
    } else {}
    return currentLocation;
    // //loading = true;
    // print('masuk _getLocation');
    // var currentLocation;
    // // lp.PermissionStatus permission = await _getLocationPermission();
    // // if (permission == lp.PermissionStatus.granted) {
    // //   try {
    // //     currentLocation = await gl.Geolocator.getCurrentPosition(
    // //         desiredAccuracy: gl.LocationAccuracy.best);
    // //   } catch (e) {
    // //     currentLocation = null;
    // //   }
    // // }
    // // return currentLocation;
    // return null;
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

  void _onMapCreated(GoogleMapController _cntlr) {
    // _controllerGmaps = _cntlr;
    _location.onLocationChanged.listen((l) {});
  }

  Future<String> getAddress(gl.Position userLocation) async {
    loading = true;
    String address = "";
    List<gc.Placemark> placemark = await gc.placemarkFromCoordinates(
        userLocation.latitude, userLocation.longitude);

    setState(() {
      try {
        // ignore: unnecessary_null_comparison
        if (placemark[0] != null) {
          String fulladdress = placemark[0].toString();

          // String name = placemark[0].street != null
          //     ? placemark[0].street.toString()
          //     : "";
          // String subThoroughfare = placemark[0].subThoroughfare != null
          //     ? placemark[0].subThoroughfare.toString()
          //     : "";

          // String thoroughfare = placemark[0].thoroughfare != null
          //     ? placemark[0].thoroughfare.toString()
          //     : "";
          // String subLocality = placemark[0].subLocality != null
          //     ? placemark[0].subLocality.toString()
          //     : "";
          // String locality = placemark[0].locality != null
          //     ? placemark[0].locality.toString()
          //     : "";
          // String administrativeArea = placemark[0].administrativeArea != null
          //     ? placemark[0].administrativeArea.toString()
          //     : "";
          // String postalCode = placemark[0].postalCode != null
          //     ? placemark[0].postalCode.toString()
          //     : "";
          // String country = placemark[0].country != null
          //     ? placemark[0].country.toString()
          //     : "";

          // address = thoroughfare +
          //     ", " +
          //     subThoroughfare +
          //     ", " +
          //     subLocality +
          //     ", " +
          //     locality +
          //     ", " +
          //     administrativeArea +
          //     ", " +
          //     postalCode +
          //     ", " +
          //     country;

          address = fulladdress;
          _currentAddress = address;
          _addressCtr.text = address;
        }
      } catch (e) {
        address = "";
      }
    });
    return address;
  }

  void submit() async {
    if (photoCheckIn == "") {
      Fluttertoast.showToast(
          msg: "silakan ambil photo lokasi!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        submitOnline();
      }
    } on SocketException catch (_) {
      Warning.showWarning("No Internet Connection");
      // print('not connected');
      // submitOffline();
    }
  }

  void submitOnline() async {
    var data = {
      "id": _widVisit.id,
      // "check_in_latitude": _initialcameraposition.latitude,
      // "check_in_longitude": _initialcameraposition.longitude,
      "check_in_latitude": _latitude,
      "check_in_longitude": _longitude,
      "address_check_in": _currentAddress,
      // "photo_check_in": "",
      "workplan_activity_id": widget.workplan.id,
      "progres_status_id": progressStatusId,
      "label": widget.lblCheckInOut,
      "check_in_desc_1": ket1.text,
      "check_in_desc_2": ket2.text
    };

    print("ini data yang mau di kirim <<<<<<========");
    print(data);

    var response =
        await RestService().restRequestService(SystemParam.fVisitCheckIn, data);

    var convertDataToJson = json.decode(response.body);
    print('ini response submit check in <<<<<<<+=======');
    print(convertDataToJson);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];

    if (code == "0") {
      getWorkplanVisitById();

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkplanView(
                user: widget.user,
                workplan: _wid,
                isMaximumUmur: widget.isMaximumUmur),
          ));
    } else {
      Fluttertoast.showToast(
          msg: status,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void getWorkplanVisitById() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        loading = true;
        var data = {
          "visit_id": widget.workplanVisit.id,
        };

        var response = await RestService()
            .restRequestService(SystemParam.fWorkplanVisitById, data);

        setState(() {
          // print("response.body.toString():" + response.body.toString());
          WorkplanVisitModel workplanVisitModel =
              workplanVisitModelFromJson(response.body.toString());
          WorkplanVisit wV = workplanVisitModel.data[0];

          //INSERT LOG CHECK IN
          var db = new DatabaseHelper();
          VisitChecInLog vcIL = new VisitChecInLog(
              visitId: wV.id,
              checkInBatas: wV.checkInBatas.toString(),
              batasWaktu: wV.batasWaktu,
              checkIn: wV.checkIn.toString(),
              nomorWorkplan: widget.workplan.nomorWorkplan);
          db.insertVisitCheckInLog(vcIL);

          loading = false;
        });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  void doCapture(WorkplanVisit workplanVisit) async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisitCheckinTakePicture(
            camera: firstCamera,
            wv: workplanVisit,
            user: widget.user,
            workplan: widget.workplan,
            lblCheckInOut: widget.lblCheckInOut,
            isMaximumUmur: widget.isMaximumUmur,
            nomor: widget.nomor,
          ),
        ));
  }

  loadImageFromPreferences(String photo) {
    // loading = true;
    Utility.getImageFromPreferences(photo.split('/').last).then((img) {
      //print("img check null" +img.toString());
      if (null == img) {
        //print("null image");
        setState(() {
          downloadImageToPreference(photo);
          print("image from api");
        });
        return;
      }
      setState(() {
        _imageFromPreferences = Utility.imageFromBase64String(img);
        // loading = false;
      });
    });
  }

  downloadImageToPreference(String photo) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "filename": photo,
        };

        print(data);
        var response = await RestService()
            .restRequestService(SystemParam.fImageDownload, data);

        print("response" + response.toString());
        // ImageProvider imageRes = Image.memory(response.bodyBytes).image;

        setState(() {
          _imageFromPreferences = Image.memory(response.bodyBytes);
        });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  void getWorkplanById() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        loading = true;
        var data = {
          "id": widget.workplan.id,
        };
        var response = await RestService()
            .restRequestService(SystemParam.fWorkplanById, data);
        setState(() {
          WorkplanInboxModel wi =
              workplanInboxFromJson(response.body.toString());
          _wid = wi.data[0];
          loading = false;
        });
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  void submitOffline() async {
    // "check_in_latitude": _initialcameraposition.latitude,
    //   "check_in_longitude": _initialcameraposition.longitude,
    //   "address_check_in": _currentAddress,
    //   "photo_check_in": "",
    //   "workplan_activity_id": widget.workplan.id,
    //   "progres_status_id": progressStatusId,
    //   "label": widget.lblCheckInOut

    //UPDATE WORKPLAN VISIT
    //String dateVisit = SystemParam.formatDateValue.format(DateTime.now());
    _widVisit.checkInLatitude = _latitude;
    _widVisit.checkInLongitude = _longitude;
    _widVisit.addressCheckIn = _currentAddress;
    _widVisit.isCheckIn = "1";
    _widVisit.visitDateActual = DateTime.now();
    _widVisit.checkIn = DateTime.now();
    _widVisit.flagUpdate = 1;
    _widVisit.updatedBy = widget.user.id;

    // _widVisit.photoCheckIn = "";
    // _widVisit.progressStatusId = progressStatusId;

    db.updateWorkplanVisitCheckIn(_widVisit);

    //UPDATE WORKPLAN
    _wid.isCheckIn = "1";
    _wid.progresStatusIdAlter = 2;
    _wid.progresStatusId = 2;

    db.getParameterProgresStatusById("2").then((value) {
      _wid.progresStatusDescription = value.description;
      _wid.progresStatusIdAlterDescription = value.description;
    });

    db.updateWorkplanActivity(_wid);

    Fluttertoast.showToast(
        msg: "Data tersimpan secara offline",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkplanView(
              user: widget.user,
              workplan: _wid,
              isMaximumUmur: widget.isMaximumUmur),
        ));
  }

  getDeviceLocation() async {
    print('masuk _getLocation');
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('ada koneksi internet');
        _getLocation().then((value) {
          setState(() {
            print(value!.latitude.toString() +
                "lt:lg" +
                value.longitude.toString());
            loading = true;
            userLocation = value;
            getAddress(userLocation).then((value) => {_currentAddress = value});
            _addressCtr.text = _currentAddress;
            _initialcameraposition = LatLng(value.latitude, value.longitude);
            isInitialCamera = true;
            _latitude = value.latitude.toString();
            _longitude = value.longitude.toString();
            loading = false;
          });
        });
      }
    } on SocketException catch (_) {
      Warning.showWarning('No Internet Connection');
    }
  }
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
