// import 'dart:html';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/helper/utility_image.dart';
import 'package:workplan_beta_test/main_pages/landingpage_view.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/personal_info_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/loginscreen.dart';
import 'package:workplan_beta_test/pages/profile/contact/profile_contact.dart';
import 'package:workplan_beta_test/pages/profile/history/profile_history.dart';
import 'package:workplan_beta_test/pages/profile/profile_image_pick.dart';
import 'package:workplan_beta_test/pages/profile/profile_image_take_picture.dart';
import 'package:workplan_beta_test/pages/profile/info/profile_personal.dart';
import 'package:workplan_beta_test/pages/profile/setting/profile_setting.dart';
import 'package:workplan_beta_test/pages/profile/skill/profile_skill.dart';
import 'package:workplan_beta_test/main_pages/constans.dart';

String _s3Url = "";
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:typed_data';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = false;
  late PersonalInfoProfilData profileData;
  Image imageFromPreferences = new Image.asset("images/man.png");
  bool isImageExist = false;
  String fullname = "";
  var db = new DatabaseHelper();
  String _base64Photo = "";
  String _s3Url = "";
  String profileImageURl = "";

  @override
  void initState() {
    super.initState();
    // initS3Url();
    getMyPersonal();

    //loading = false;
  }

  // initS3Url() async {
  //   db.getEnvByName(SystemParam.EnvAWS).then((value) {
  //     setState(() {
  //       loading = true;
  //       _s3Url = value.value;
  //       print('ini _s3Url dari UAT <<<<<<========');
  //       print(_s3Url);
  //       loading = false;
  //     });
  //   });
  // }

  getMyPersonal() async {
    await db.getEnvByName(SystemParam.EnvAWS).then((value) {
      setState(() {
        loading = true;
        _s3Url = value.value;
        print('ini _s3Url dari UAT <<<<<<========');
        print(_s3Url);
        loading = false;
      });
    });

    // loading = true;

    var data = {
      "user_id": widget.user.id,
    };

    var response =
        await RestService().restRequestService(SystemParam.fPersonalInfo, data);

    setState(() {
      PersonalInfoModel personalInfoModel =
          personalInfoFromJson(response.body.toString());
      profileData = personalInfoModel.data[0];

      if (profileData.image != null && profileData.image != "") {
        print('ini url path image fram UAT <<<<<========');
        print(profileData.image);
        isImageExist = true;
        //loadImageFromPreferences(profileData.image);
        profileImageURl = _s3Url + "/" + profileData.image;
        print('ini url Full untuk menampilkan image <<<========');
        print(profileImageURl);
      }

      String firstName = "", middleName = "", lastName = "";
      if (profileData.firstName != null) {
        firstName = profileData.firstName;
      }

      if (profileData.middleName != null) {
        middleName = profileData.middleName;
      }

      if (profileData.lastName != null) {
        lastName = profileData.lastName;
      }

      fullname = firstName + " " + middleName + " " + lastName;

      // loadPhotoProfile();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        // sessionTimer.userActivityDetected(context,widget.user);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LandingPage(
                user: widget.user,
              ),
            ));
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Personal Information'),
            centerTitle: true,
            backgroundColor: SystemParam.colorCustom,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              //onPressed: () => Navigator.of(context).pop(),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LandingPage(
                        user: widget.user,
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
                  child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Stack(
                      children: <Widget>[
                        new Align(
                          alignment: FractionalOffset.bottomCenter,
                          heightFactor: 1,
                          child: new Column(
                            children: <Widget>[
                              isImageExist
                                  ?
                                  // ClipOval(
                                  //     child: CachedNetworkImage(
                                  //       fit: BoxFit.fitWidth,
                                  //       imageUrl: _s3Url + profileData.image,
                                  //       placeholder: (context, url) =>
                                  //           CircularProgressIndicator(),
                                  //       errorWidget: (context, url, error) =>
                                  //           Container(),
                                  //     ),
                                  //   )
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: CachedNetworkImage(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        imageUrl: profileImageURl,
                                        imageBuilder: (context, image) =>
                                            CircleAvatar(
                                              radius: 100,
                                          backgroundImage: image,
                                        ),
                                        placeholder: (context, url) => Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 100, vertical: 100),
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                                child: Text(
                                                    "Cannot Read Image From URL")),
                                      ),
                                  )
                                  // CachedNetworkImage(
                                  //    useOldImageOnUrlChange: true,
                                  //     imageUrl: profileImageURl,
                                  //     placeholder: (context, url) =>
                                  //         const CircleAvatar(
                                  //       backgroundColor: Colors.amber,
                                  //       radius: 150,
                                  //     ),
                                  // imageBuilder: (context, image) =>
                                  //     CircleAvatar(
                                  //   backgroundImage: image,
                                  //   radius: 150,
                                  // ),
                                  //   )
                                  : new CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          AssetImage("images/person.png"),
                                      radius: 100.0,
                                    )
                              // Hero(
                              //   tag: "avatarTag",
                              //   child: isImageExist && _base64Photo != ""
                              //       ?
                              //       new CircleAvatar(
                              //           backgroundColor: Colors.white,
                              //          backgroundImage:MemoryImage(base64Decode(_base64Photo)),
                              //           radius: 100.0,
                              //         )
                              //       :
                              //       new CircleAvatar(
                              //           backgroundColor: Colors.white,
                              //           backgroundImage:
                              //               AssetImage("images/person.png"),
                              //           radius: 100.0,
                              //         ),
                              // )
                            ],
                          ),
                        ),
                        new Positioned(
                          bottom: 26.0,
                          // left: 4.0,
                          right: 100.0,
                          child: GestureDetector(
                              onTap: () {
                                //TODO Edit Picture
                                // doCapture(personalInfoProfilData);
                                doPickImage(profileData);
                              },
                              child: new CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  Icons.edit,
                                ),
                                backgroundColor: WorkplanPallete.green,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      fullname,
                      style:
                          TextStyle(color: WorkplanPallete.green, fontSize: 18),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    //elevation: 2.0,
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        size: 38,
                      ),
                      title: Text(
                        "Personal",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text("Data Personal"),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: SystemParam.colorCustom),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePersonal(
                                    user: widget.user, profile: profileData)));
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    //elevation: 2.0,
                    child: ListTile(
                      leading: Icon(
                        Icons.history,
                        size: 38,
                      ),
                      title: Text(
                        "History",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text("Data History"),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: SystemParam.colorCustom),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileHistory(
                                    user: widget.user,
                                    profileInfo: profileData)));
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    //elevation: 2.0,
                    child: ListTile(
                      leading: Icon(
                        Icons.person_add_alt,
                        size: 38,
                      ),
                      title: Text(
                        "Skill",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text("Data Skill"),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: SystemParam.colorCustom),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileSkill(
                                    user: widget.user,
                                    profileInfo: profileData)));
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    //elevation: 2.0,
                    child: ListTile(
                      leading: Icon(
                        Icons.contact_page,
                        size: 38,
                      ),
                      title: Text(
                        "Contact",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text("Data Contact"),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: SystemParam.colorCustom),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileContact(
                                    user: widget.user, profile: profileData)));
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    //elevation: 2.0,
                    child: ListTile(
                      leading: Icon(
                        Icons.settings,
                        size: 38,
                      ),
                      title: Text(
                        "Setting",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text("Setting"),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: SystemParam.colorCustom),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfileSetting(user: widget.user)));
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    //elevation: 2.0,
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        size: 38,
                      ),
                      title: Text(
                        "Logout",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text("Keluar Aplikasi"),
                      trailing:
                          Icon(Icons.logout, color: SystemParam.colorCustom),
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove("dataUser");
                        updateIsLogin(widget.user, 0);
                        // sessionTimer.stopTimer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                    ),
                  ),
                ]))));

  void doCapture(PersonalInfoProfilData personalInfoProfilData) async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileImageTakePicture(
            camera: firstCamera,
            user: widget.user,
            personalInfoProfilData: personalInfoProfilData,
          ),
        ));
  }

  loadImageFromPreferences(String photo) {
    loading = true;
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
        imageFromPreferences = Utility.imageFromBase64String(img);
        // loading = false;
      });
    });
  }

  downloadImageToPreference(String photo) async {
    var data = {
      "filename": photo,
    };

    print(data);
    var response = await RestService()
        .restRequestService(SystemParam.fImageDownload, data);

    //print("response" + response.toString());
    // ImageProvider imageRes = Image.memory(response.bodyBytes).image;

    setState(() {
      imageFromPreferences = Image.memory(response.bodyBytes);
    });
  }

  void doPickImage(PersonalInfoProfilData personalInfoProfilData) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PickImagePage(
            profileData: personalInfoProfilData,
            user: widget.user,
          ),
        ));
  }

  // void loadPhotoProfile() async {
  //   db.getPersonalInfoPhoto(profileData.userId.toString()).then((value) {
  //     setState(() {
  //       print("value.hashCode:" + value.hashCode.toString());
  //       _base64Photo = value!.imagePath;
  //     });
  //   });
  // }

  Future<void> updateIsLogin(User user, int isLogin) async {
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
    } on SocketException catch (_) {}
  }
}
