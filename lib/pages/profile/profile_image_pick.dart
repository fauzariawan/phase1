import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';

// import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/helper/utility_image.dart';
import 'package:workplan_beta_test/model/personal_info_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/profile_page.dart';
import 'package:workplan_beta_test/main_pages/constans.dart';
// import 'package:image_picker_sample/image_args.dart';

class PickImagePage extends StatefulWidget {
  final PersonalInfoProfilData profileData;
  final User user;

  const PickImagePage({Key? key, required this.profileData, required this.user})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => PickImagePageState();
}

class PickImagePageState extends State<PickImagePage> {
  final ImagePicker _picker = ImagePicker();
  // ignore: unused_field
  XFile? _imageFile;
  // bool isImageView = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  user: widget.user,
                ),
              ));
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Pick image'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              //onPressed: () => Navigator.of(context).pop(),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        user: widget.user,
                      ),
                    ));
              },
            ),
          ),
          body: SingleChildScrollView(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _imageFile != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.camera_alt,
                              color: WorkplanPallete.green,
                              size: 24.0,
                            ),
                            label: Text(
                              "Upload",
                              style: TextStyle(color: WorkplanPallete.green),
                            ),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.white),
                            onPressed: () {
                              uploadImage(_imageFile, context);
                              print("::finish upload::");
                            },
                          ),
                        ),
                      )
                    : Container(),
                _imageFile != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Image.file(File(_imageFile!.path)),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.camera_alt,
                              color: WorkplanPallete.green,
                              size: 24.0,
                            ),
                            label: Text(
                              "Ubah Profile",
                              style: TextStyle(color: WorkplanPallete.green),
                            ),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.white),
                            onPressed: () {
                              _pickImage(ImageSource.gallery);
                            },
                          ),
                        ),
                      ),
              ],
            ),
          )),
        ));
  }

  _pickImage(ImageSource imageSource) async {
    //XFile? image = await _picker.pickImage(source: imageSource);
    final pickedFile = await _picker.pickImage(source: imageSource);
    setState(() {
      _imageFile = pickedFile;
      // isImageView = true;
    });
  }

  uploadImage(_imageFile, BuildContext context) async {
    var path = _imageFile.path;
    File file = File(path);
    // String baseimage = base64Encode(file.readAsBytesSync());
    String fileName = widget.user.id.toString() +
        "_" +
        widget.profileData.id.toString() +
        "_" +
        path.split('/').last;

    //save to local
    Utility.saveImageToPreferences(
        Utility.base64String(file.readAsBytesSync()), fileName);

    upload(file, fileName, context);

    //  Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => ProfilePage(
    //                 user: widget.user,
    //               )));
    // var data = {
    //   "id": widget.profileData.id,
    //   "updated_by": widget.user.id,
    //   "company_id": widget.user.companyId,
    //   "file_name": fileName,
    //   "image": baseimage,
    //   "image_file_path":path
    // };

    //dio.MultipartFile.fromFile('./text.txt',filename: 'upload.txt');

    // Dio dio = new Dio();
    // var formData = FormData.fromMap({
    //   "id": widget.profileData.id,
    //   "updated_by": widget.user.id,
    //   "company_id": widget.user.companyId,
    //   "file_name": fileName,
    //   "image_file_path":path,
    //   // "image": await MultipartFile.
    //   // "image": baseimage,

    // });
    // formdata.add("photos", );

    // var response = await RestService()
    //     .restRequestService(SystemParam.fUploadImageProfile, data);

    // print(response.body);
    // var convertDataToJson = json.decode(response.body);
    // var code = convertDataToJson['code'];
    // var status = convertDataToJson['status'];

    // // wVs.photoCheckIn = fileName;
    // if (code == "0") {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => ProfilePage(
    //                 user: widget.user,
    //               )));
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
  }

  upload(File imageFile, String filename, BuildContext context) async {
    String baseimage = base64Encode(imageFile.readAsBytesSync());
    //INSERT TO personal info profile photo
    Map<String, dynamic> map = {
      "id": widget.profileData.id,
      "user_id": widget.user.id,
      "image_path": baseimage
    };

    var db = new DatabaseHelper();
    db.deletePersonalInfoPhoto();
    db.insertPersonalInfoPhoto(map);

    // open a bytestream
    //var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var stream = new http.ByteStream(Stream.castFrom(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(SystemParam.baseUrl + SystemParam.fUploadImageProfile);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    // request.fields.addEntries(data);
    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);
    request.fields['id'] = widget.profileData.id.toString();
    request.fields['updated_by'] = widget.user.id.toString();
    request.fields['company_id'] = widget.user.userCompanyId.toString();
    request.fields['file_name'] = filename;
    request.fields['image_file_path'] = imageFile.path;

    var response = await request.send();
    print(response.statusCode);

    if(response.statusCode==200){
       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            user: widget.user,
          ),
        ));
    }

   

    // listen for response
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
  }
}
