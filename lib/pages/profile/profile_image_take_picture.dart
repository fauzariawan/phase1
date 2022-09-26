import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/helper/utility_image.dart';
import 'package:workplan_beta_test/model/personal_info_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/profile_page.dart';

class ProfileImageTakePicture extends StatefulWidget {
  final CameraDescription camera;
  final PersonalInfoProfilData personalInfoProfilData;
  final User user;

  const ProfileImageTakePicture({
    Key? key,
    required this.camera,
    required this.user,
    required this.personalInfoProfilData,
  }) : super(key: key);

  @override
  _ProfileImageTakePictureState createState() =>
      _ProfileImageTakePictureState();
}

class _ProfileImageTakePictureState extends State<ProfileImageTakePicture> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  // WorkplanVisit workplanVisit;

  @override
  void initState() {
    super.initState();
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
                  user: widget.user,
                  personalInfoProfilData: widget.personalInfoProfilData,
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
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final PersonalInfoProfilData personalInfoProfilData;
  final User user;
  final XFile imageSource;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
    required this.user,
    required this.imageSource,
    required this.personalInfoProfilData,
  }) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Profile")),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      // body: Image.file(File(imagePath)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Image.file(File(widget.imagePath)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("UPLOAD"),
                  onPressed: () {
                    uploadImage();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: SystemParam.colorCustom,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  // color: colorCustom,
                  // textColor: Colors.white,
                  //color: Colors.white20,
                  //color: Colors.white20[500],
                  // textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void uploadImage() async {
    // imageSource.readAsBytes();

    var path = widget.imageSource.path;
    File file = File(path);

    String baseimage = base64Encode(file.readAsBytesSync());
    String fileName = widget.user.id.toString() +
        "_" +
        widget.personalInfoProfilData.id.toString() +
        "_" +
        path.split('/').last;

   

    //save to local
    // Utility.saveImageToPreferences(
    //     Utility.base64String(file.readAsBytesSync()), fileName);

    var data = {
      "id": widget.personalInfoProfilData.id,
      "updated_by": widget.user.id,
      "company_id": widget.user.userCompanyId,
      "image": baseimage,
      "file_name": fileName,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fUploadImageProfile, data);

    print(response.body);
    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];

    // wVs.photoCheckIn = fileName;
    if (code == "0") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(
                    user: widget.user,
                  )));
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
}
