import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
// import 'package:async/async.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/helper/utility_image.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/model/workplan_visit_model.dart';
import 'package:workplan_beta_test/pages/workplan/visit_checkin.dart';
import 'package:workplan_beta_test/pages/workplan/visit_checkout.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data_dokumen.dart';
import 'package:http/http.dart' as http;

class VisitCheckinTakePicture extends StatefulWidget {
  final CameraDescription camera;
  final WorkplanVisit wv;
  final WorkplanInboxData workplan;
  final User user;
  final String lblCheckInOut;
  final bool isMaximumUmur;
  final int nomor;

  const VisitCheckinTakePicture(
      {Key? key,
      required this.camera,
      required this.wv,
      required this.workplan,
      required this.user,
      required this.lblCheckInOut,
      required this.isMaximumUmur,
      required this.nomor})
      : super(key: key);

  @override
  _VisitCheckinTakePictureState createState() =>
      _VisitCheckinTakePictureState();
}

class _VisitCheckinTakePictureState extends State<VisitCheckinTakePicture> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  // WorkplanVisit workplanVisit;
  late WorkplanVisit _wv;
  late List<CameraDescription> _availableCameras;

  @override
  void initState() {
    super.initState();

    _getAvailableCameras();
    _wv = widget.wv;

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
  }

  Future<void> _getAvailableCameras() async {
    // WidgetsFlutterBinding.ensureInitialized();
    _availableCameras = await availableCameras();
    print('ini avaliable camera');
    print(_availableCameras);
    // final lensDirection = _controller.description.lensDirection;
    _initializeControllerFuture = _initCamera(widget.camera);
  }

  // init camera
  Future<void> _initCamera(CameraDescription description) async {
    _controller =
        CameraController(description, ResolutionPreset.max, enableAudio: true);

    try {
      await _controller.initialize();
      setState(() {});
      // to notify the widgets that camera has been initialized and now camera preview can be done
    } catch (e) {
      print(e);
    }
  }

  void _toggleCameraLens() {
    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;
    print('ini posisi camera pertama');
    print(lensDirection);
    if (lensDirection == CameraLensDirection.back) {
      newDescription = CameraDescription(
          name: "1",
          lensDirection: CameraLensDirection.front,
          sensorOrientation: 0);
      _initCamera(newDescription);
    } else {
      newDescription = CameraDescription(
          name: "0",
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 90);
      _initCamera(newDescription);
    }
    // get current lens direction (front / rear)
    // final lensDirection = _controller.description.lensDirection;
    // CameraDescription newDescription;
    // if (lensDirection == CameraLensDirection.front) {
    //   newDescription = _availableCameras.firstWhere((description) =>
    //       description.lensDirection == CameraLensDirection.back);
    // } else {
    //   newDescription = _availableCameras.firstWhere((description) =>
    //       description.lensDirection == CameraLensDirection.front);
    // }

    // if (newDescription != null) {
    //   _initCamera(newDescription);
    // } else {
    //   print('Asked camera not available');
    // }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
    _controller.dispose();
  }

  @override
  // ignore: override_on_non_overriding_member
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    // ignore: unnecessary_null_comparison
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // ignore: unnecessary_null_comparison
      if (_controller != null) {
        _initCamera(_controller.description);
        // onNewCameraSelected(_controller.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Take a picture')),
        // You must wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner until the
        // controller has finished initializing.
        body: Center(child: CameraPreview(_controller)),
        // FutureBuilder<void>(
        //   future: _initializeControllerFuture,
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       // If the Future is complete, display the preview.
        //       return CameraPreview(_controller);
        //     } else if (snapshot.connectionState == ConnectionState.none) {
        //       return const Center(child: CircularProgressIndicator());
        //     } else {
        //       // Otherwise, display a loading indicator.
        //       return const Center(child: CircularProgressIndicator());
        //     }
        //   },
        // ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
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

                  //final imageReadAsBytes = image.readAsBytes();
                  // If the picture was taken, display it on a new screen.
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(
                          // Pass the automatically generated path to
                          // the DisplayPictureScreen widget.
                          // imageReadAsBytes:imageReadAsBytes,
                          imageSource: image,
                          imagePath: image.path,
                          wv: _wv,
                          workplan: widget.workplan,
                          user: widget.user,
                          lblCheckInOut: widget.lblCheckInOut,
                          isMaximumUmur: widget.isMaximumUmur,
                          nomor: widget.nomor),
                    ),
                  );
                } on CameraException catch(e) {
                  print('masuk kesini gabisa ambil gambar <<<<<<===');
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
              child: const Icon(Icons.camera_alt),
              backgroundColor: SystemParam.colorCustom,
            ),
            FloatingActionButton(
              // Provide an onPressed callback.
              backgroundColor: SystemParam.colorCustom,
              onPressed: () async {
                _toggleCameraLens();
              },
              child: const Icon(Icons.change_circle),
            ),
          ],
        ));
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final WorkplanVisit wv;
  final WorkplanInboxData workplan;
  final User user;
  final XFile imageSource;
  final String lblCheckInOut;
  final bool isMaximumUmur;
  final int nomor;

  const DisplayPictureScreen(
      {Key? key,
      required this.imagePath,
      required this.wv,
      required this.workplan,
      required this.user,
      required this.imageSource,
      required this.lblCheckInOut,
      required this.isMaximumUmur,
      required this.nomor})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  // WorkplanVisit wv;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lblCheckInOut)),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      // body: Image.file(File(imagePath)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Image.file(File(widget.imagePath)),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text("Keterangan 1"),
              // SizedBox(height: 5),
              // TextFormField(
              //   controller: ket1,
              //   onChanged: (ket1) {
              //     print(ket1);
              //   },
              //   keyboardType: TextInputType.multiline,
              //   maxLines: null,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text("Keterangan 2"),
              // SizedBox(height: 5),
              // TextFormField(
              //     controller: ket2,
              //     onChanged: (ket2) {
              //       print(ket2);
              //     },
              //     keyboardType: TextInputType.multiline,
              //     maxLines: null,
              //     decoration: InputDecoration(border: OutlineInputBorder())),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("UPLOAD"),
                  onPressed: () {
                    uploadImage(context, widget.wv);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: colorCustom,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadOnline(File imageFile, String filename, BuildContext context,
      WorkplanVisit wv) async {
    var stream = new http.ByteStream(Stream.castFrom(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(SystemParam.baseUrl + SystemParam.fUploadImageCheckIn);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    // request.fields.addEntries(data);
    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    request.fields['created_by'] = widget.user.id.toString();
    request.fields['workplan_activity_id'] = widget.workplan.id.toString();
    request.fields['visit_id'] = widget.wv.id.toString();
    request.fields['company_id'] = widget.user.userCompanyId.toString();
    request.fields['file_name'] = filename;
    request.fields['label'] = widget.lblCheckInOut;
    // request.fields['check_in_desc_1'] = ket1.text;
    // request.fields['check_in_desc_2'] = ket2.text;

    var response = await request.send();
    // print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print('ini respon dari upload foto');
      print(value);
    });

    WorkplanVisit wVs = widget.wv;

    if (widget.lblCheckInOut == "CHECK IN") {
      wVs.photoCheckIn = filename;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisitCheckIn(
            workplan: widget.workplan,
            workplanVisit: wVs,
            user: widget.user,
            lblCheckInOut: widget.lblCheckInOut,
            isMaximumUmur: widget.isMaximumUmur,
            nomor: widget.nomor,
            isPhotoFromCam: true,
          ),
        ),
      );
    } else {
      wVs.photoCheckOut = filename;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisitCheckOut(
            workplan: widget.workplan,
            workplanVisit: wVs,
            user: widget.user,
            lblCheckInOut: widget.lblCheckInOut,
            isMaximumUmur: widget.isMaximumUmur,
            nomor: widget.nomor,
            isPhotoFromCam: true,
          ),
        ),
      );
    }
  }

  uploadImage(BuildContext context, WorkplanVisit wv) async {
    // imageSource.readAsBytes();

    var path = widget.imageSource.path;
    File file = File(path);
    //String baseimage = base64Encode(file.readAsBytesSync());
    String fileName = widget.user.id.toString() +
        "_" +
        widget.wv.id.toString() +
        "_" +
        path.split('/').last;

    //save to local
    Utility.saveImageToPreferences(
        Utility.base64String(file.readAsBytesSync()), fileName);

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        uploadOnline(file, fileName, context, wv);
      }
    } on SocketException catch (_) {
      print('not connected');
      uploadOffline(file, fileName, context, wv);
    }
  }

  void uploadOffline(File file, String filename, BuildContext context,
      WorkplanVisit wv) async {
    var db = new DatabaseHelper();
    String baseimage = base64Encode(file.readAsBytesSync());
    if (widget.lblCheckInOut == "CHECK IN") {
      wv.baseImageCheckIn = baseimage;
      wv.photoCheckIn = filename;
    } else {
      wv.baseImageCheckOut = baseimage;
      wv.photoCheckOut = filename;
    }
    db.updateWorkplanVisitCheckIn(wv);

    if (widget.lblCheckInOut == "CHECK IN") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VisitCheckIn(
                    workplan: widget.workplan,
                    workplanVisit: wv,
                    user: widget.user,
                    lblCheckInOut: widget.lblCheckInOut,
                    isMaximumUmur: widget.isMaximumUmur,
                    nomor: widget.nomor,
                    isPhotoFromCam: true,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VisitCheckOut(
                    workplan: widget.workplan,
                    workplanVisit: wv,
                    user: widget.user,
                    lblCheckInOut: widget.lblCheckInOut,
                    isMaximumUmur: widget.isMaximumUmur,
                    nomor: widget.nomor,
                    isPhotoFromCam: true,
                  )));
    }
  }

  // uploadImageOld(BuildContext context)async{
  // var data = {
  //   "created_by": widget.user.id,
  //   "workplan_activity_id": widget.workplan.id,
  //   "visit_id": widget.wv.id,
  //   "company_id": widget.user.companyId,
  //   "image": baseimage,
  //   "file_name": fileName,
  //   "label": widget.lblCheckInOut
  // };

  // var response = await RestService()
  //     .restRequestService(SystemParam.fUploadImageCheckIn, data);

  // print(response.body);
  // var convertDataToJson = json.decode(response.body);
  // var code = convertDataToJson['code'];
  // var status = convertDataToJson['status'];

  // //update photocheckin
  // widget.wv.photoCheckIn = fileName;

  // WorkplanVisit wVs = widget.wv;
  // wVs.photoCheckIn = fileName;
  // if (code == "0") {
  // if (widget.lblCheckInOut == "CHECK IN") {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => VisitCheckIn(
  //                 workplan: widget.workplan,
  //                 workplanVisit: wVs,
  //                 user: widget.user,
  //                 lblCheckInOut: widget.lblCheckInOut,
  //                 isMaximumUmur: widget.isMaximumUmur,
  //                 nomor: widget.nomor,
  //                 isPhotoFromCam: true,
  //               )));
  // } else {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => VisitCheckOut(
  //                 workplan: widget.workplan,
  //                 workplanVisit: wVs,
  //                 user: widget.user,
  //                 lblCheckInOut: widget.lblCheckInOut,
  //                 isMaximumUmur: widget.isMaximumUmur,
  //                 nomor: widget.nomor,
  //                 isPhotoFromCam: true,
  //               )));
  // }
  // } else {
  //   Fluttertoast.showToast(
  //       msg: status,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }
  // }
}
