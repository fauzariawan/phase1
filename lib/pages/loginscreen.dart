import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:fake_gps_detector/fake_gps_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:get_version/get_version.dart';
import 'package:local_auth/local_auth.dart';
import 'package:safe_device/safe_device.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/cek_mock_location.dart';
import 'package:workplan_beta_test/helper/converter.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/permission.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/main_pages/landingpage_view.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/biometrik_termandcondition.dart';
import 'package:workplan_beta_test/main_pages/constans.dart';
import 'package:workplan_beta_test/widget/warning.dart';
import 'package:workplan_beta_test/widget/warning.dart';
import 'package:workplan_beta_test/widget/warning.dart';

import 'login_choose_company.dart';
import 'new_change_password.dart';
// import 'package:unique_identifier/unique_identifier.dart';
import 'package:trust_location/trust_location.dart';

MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);

class LoginScreen extends StatefulWidget {
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userIdCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController companyCodeCtrl = TextEditingController();
  TextEditingController userIdDialogCtrl = TextEditingController();
  TextEditingController companyCodeDialogCtrl = TextEditingController();
  TextEditingController nomorHpDialogCtrl = TextEditingController();
  String appName = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";
  String appType = "";
  final _keyForm = GlobalKey<FormState>();
  // late User user;
  // String projectVersion = "1.0.0";
  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String _message = "Not Authorized";
  var db = new DatabaseHelper();
  bool loading = false;
  bool isCheckedBiometrics = false;
  String _deviceId = 'Unknown';
  bool isClicked = false;
  String baseUrl = SystemParam.baseUrl;

  String? _latitude;
  String? _longitude;
  bool _isMockLocation = false;
  bool showText = false;
  dynamic _isFakeGps = 'Unknown';
  dynamic _isEmulator = 'Unknown';
  PermissionStatus? statusPermission;

  // String smsGatewayAPI =SystemParam.smsGatewayAPIDefault;
  // String smsGatewayUserKey =SystemParam.smsGatewayUserKeyDefault;
  // String smsGatewayPassKey =SystemParam.smsGatewayPassKeyDefault;
  // String tokenUrl = SystemParam.tokenUrlDefault;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUser();
    initUniqueIdentifierState();
    getPackageInfo();
    switch (baseUrl) {
      case 'https://workplan-app-uat.dev-v3.aplikasidev.com/api/':
        appType = 'UAT';
        break;
      case 'https://workplan-app-beta.dev-v3.aplikasidev.com/api/':
        appType = 'BETA';
        break;
      case "https://hci-demo-be.aplikasidev.com/api/":
        appType = 'HSI Demo';
        break;
      default:
    }
    askForPermission();
    CekMockLocation().runCekMockLocation();
    // TrustLocation.start(5);

    // /// the stream getter where others can listen to.
    // TrustLocation.onChange.listen((values) => {
    //       setState(() {
    //         _isMockLocation = values.isMockLocation!;
    //       }),
    //       print(
    //           'dari init state loginscreen : ${values.latitude} ${values.longitude} ${values.isMockLocation}')
    //     });
    // initPlatformState();
    // requestLocationPermission();
    // input seconds into parameter for getting location with repeating by timer.
    // this example set to 5 seconds.
    // TrustLocation.start(1);
    // requestPermission();
    // getLocation();
    // Timer.periodic(Duration(seconds: 1), (Timer timer) async {
    //   setState(() {
    //     _isMockLocation = CekMockLocation().isMockLocation;
    //     print(' ini data mock dari login screen, is mock locaton : $_isMockLocation');
    //   });
    // });
    // CekMockLocation().runCekMockLocation();
    // // cekMockLocation();
    // print("ini data dari cek mock location <<<<<======");
    // print(_isMockLocation);
  }

  void askForPermission() async {
    statusPermission = await Permission().requestLocationPermission();
    // print('from askForPermission = $statusPermission');
  }

  // Future<void> initPlatformState() async {
  //   bool? isMock;
  //   bool? isEmulator;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     PermissionStatus permission =
  //         await LocationPermissions().requestPermissions();
  //     if (permission == PermissionStatus.granted) {
  //       isMock = await FakeGpsDetector.isFakeGps;
  //       isEmulator = await FakeGpsDetector.isEmulator;
  //       print('is mock : $isMock <<<====');
  //       print('is emulator : $isMock <<<====');
  //     }
  //   } on PlatformException {
  //     print("failed");
  //   }

  //   if (!mounted) return;
  //   setState(() {
  //     _isFakeGps = isMock!;
  //     _isEmulator = isEmulator!;
  //   });
  // }

  // void requestLocationPermission() async {
  //   PermissionStatus permission =
  //       await LocationPermissions().requestPermissions();
  //   if (permission == PermissionStatus.granted) {
  //     TrustLocation.start(2);
  //     getLocation();
  //   } else if (permission == PermissionStatus.denied) {
  //     await LocationPermissions().requestPermissions();
  //   }
  //   print('permissions: $permission');
  // }

  // void requestPermission() async {
  //   final permission = await Permission.location.request();
  //   if (permission == PermissionStatus.granted) {
  //     TrustLocation.start(2);
  //     getLocation();
  //   } else if (permission == PermissionStatus.denied) {
  //     await Permission.location.request();
  //   }
  // }

  // Future<void> getLocation() async {
  //   try {
  //     // _isMockLocation = await TrustLocation.isMockLocation;
  //     // print('apakah menggunakan mock location $_isMockLocation <<<===');
  //     TrustLocation.onChange.listen((values) {
  //       setState(() {
  //         _latitude = values.latitude;
  //         _longitude = values.longitude;
  //         _isMockLocation = values.isMockLocation;
  //         showText = true;
  //         print('ini dari trust location');
  //         print('$_isMockLocation <<<===');
  //       });
  //       geoCode();
  //     });
  //   } on PlatformException catch (e) {
  //     print('PlatformException $e');
  //   }
  // }

  void geoCode() async {
    List<Placemark> placemark = await placemarkFromCoordinates(
        double.parse(_latitude!), double.parse(_longitude!));
    print(placemark[0].country);
    print(placemark[0].street);
  }

  void dispose() {
    TrustLocation.stop();
    super.dispose();
  }

  Future<void> initUniqueIdentifierState() async {
    String identifier;
    try {
      identifier = (await UniqueIdentifier.serial)!;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;

    setState(() {
      _deviceId = identifier;
      print(":::_deviceId::::" + _deviceId);
    });
  }

  Future<void> _authenticateMe() async {
// 8. this method opens a dialog for fingerprint authentication.
//    we do not need to create a dialog nut it popsup from device natively.
    print('cek finger pring <<<<<=========');
    bool authenticated = false;

    // Future<bool> isAvailableBiometrics = getAvailabelBioMetrics();
    // bool canCheckBiometrics = await authenticateIsAvailable();
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    // print(isAvailableBiometrics.then((value) => print(value)));
    if (!canCheckBiometrics) {
      Warning.showWarning("Fitur Biometrics tidak tersedia pada device anda");
      return;
    }
    // isAvailableBiometrics.then((value) {
    //   print("isAvailableBiometrics");
    //   print(canCheckBiometrics);
    //   if (value) {
    //     Warning.showWarning("Fitur Biometrics tidak tersedia pada device anda");
    //     return;
    //   }
    // });

    print('coba menampilkan showdialog finger print');
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Authenticate for login", // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true,
        biometricOnly: true,
        // native process
      );

      setState(() async {
        _message = authenticated ? "Authorized" : "Not Authorized";

        if (authenticated) {
          loginBiometrik("LOGIN");
        }
      });
    } on PlatformException catch (e) {
      print('gagal mencoba buka showdialog finger print');
      print(e);
      Warning.showWarning('Your Fingerprint Not Supported');
      print(e);
    }
    if (!mounted) return;
  }

  Future<bool> authenticateIsAvailable() async {
    final isAvailable = await _localAuthentication.canCheckBiometrics;
    final isDeviceSupported = await _localAuthentication.isDeviceSupported();
    print(isAvailable);
    print(isDeviceSupported);
    return isAvailable && isDeviceSupported;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // return false;
          exit(0);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Form(
                    key: _keyForm,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.0,
                          ),
                          Image(
                            image: AssetImage("images/logo_only.jpg"),
                            width: 200.0,
                            height: 150.0,
                            alignment: Alignment.center,
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                          Text(_isMockLocation
                              ? "is mock location : $_isMockLocation"
                              : ""),
                          Text(
                            "WrkPln",
                            style: TextStyle(
                                fontSize: 24.0, fontFamily: "Brand Bold"),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 1.0,
                                ),
                                TextFormField(
                                  validator: requiredValidator,
                                  controller: userIdCtrl,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: "User Id/ Email",
                                    labelStyle: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: "Brand Bold"),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 14.0, fontFamily: "Brand Bold"),
                                ),
                                SizedBox(
                                  height: 1.0,
                                ),
                                TextFormField(
                                  validator: requiredValidator,
                                  controller: passwordCtrl,
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: "Brand Bold"),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 14.0, fontFamily: "Brand Bold"),
                                ),
                                SizedBox(
                                  height: 1.0,
                                ),
                                TextFormField(
                                  validator: requiredValidator,
                                  controller: companyCodeCtrl,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: "Company Code",
                                    labelStyle: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: "Brand Bold"),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 14.0, fontFamily: "Brand Bold"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 1.0,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            // if (_keyForm.currentState!.validate()) {
                                            //   doLogin(context);
                                            // }
                                          },
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            // color: WorkplanPallete.green,
                                            child: const Text(
                                              "",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54,
                                                fontStyle: FontStyle.italic,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                            height: 20,
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            // if (_keyForm.currentState!.validate()) {
                                            //   doLogin(context);
                                            // }
                                            showDeleteDialog(context);
                                          },
                                          child: Container(
                                            alignment: Alignment.topRight,
                                            // color: WorkplanPallete.green,
                                            child: const Text('Forgot Password',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54,
                                                  fontStyle: FontStyle.italic,
                                                  // fontWeight: FontWeight.italic,
                                                  decoration:
                                                      TextDecoration.underline,
                                                )),
                                            height: 20,
                                          ),
                                        )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 1.0,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            print(statusPermission);
                                            if (statusPermission !=
                                                PermissionStatus.granted) {
                                              askForPermission();
                                              return;
                                            }
                                            if (_keyForm.currentState!
                                                .validate()) {
                                              CekMockLocation()
                                                  .getValueMockLocation()
                                                  .then((value) {
                                                print(
                                                    'is mock location : $value');
                                                value
                                                    ? Warning.showWarning(
                                                        "HP Anda terdeteksi telah di-root atau menggunakan aplikasi fake GPS sehingga Anda tidak diperkenankan login ke aplikasi.")
                                                    : doLogin(context);
                                              });
                                              // CekMockLocation()
                                              //     .getValueMockLocation()
                                              //     .then((value) {
                                              //   print(
                                              //       'is mock location : $value');
                                              //   value
                                              //       ? Warning.showWarning(
                                              //           "HP Anda terdeteksi telah di-root atau menggunakan aplikasi fake GPS sehingga Anda tidak diperkenankan login ke aplikasi.")
                                              //       : doLogin(context);
                                              // });
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.topCenter,
                                            color: WorkplanPallete.green,
                                            child: Center(
                                                child: const Text(
                                              'Login',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                            height: 50,
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                        //color: Colors.yellow,
                                        //child: Center(child: const Text('Button')),
                                        height: 50,
                                      ),
                                    ),
                                    //!isCheckedBiometrics
                                    //? Container()
                                    //:
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.topCenter,
                                            color: WorkplanPallete.grey,
                                            child: IconButton(
                                                iconSize: 35,
                                                onPressed: () {
                                                  // if (_keyForm.currentState!.validate()) {
                                                  if (!isCheckedBiometrics) {
                                                    print('masuk kesini');
                                                    loginBiometrik("DAFTAR");
                                                  } else {
                                                    _authenticateMe();
                                                  }
                                                  // }
                                                },
                                                // onPressed:_authenticateMe,
                                                icon: Image.asset(
                                                    "images/facial_recognition.png")
                                                // i
                                                ))),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.all(0.0),
                                //       child: ElevatedButton(
                                //           style: ElevatedButton.styleFrom(
                                //             primary: colorCustom,
                                //             shape: new RoundedRectangleBorder(
                                //                 borderRadius:
                                //                     new BorderRadius.circular(24.0)),
                                //           ),
                                //           child: Container(
                                //             height: 50.0,
                                //             // width: 250.0,
                                //             child: Center(
                                //                 child: Text(
                                //               "LOGIN",
                                //               style: TextStyle(
                                //                   fontSize: 18.0,
                                //                   fontFamily: "Brand Bold"),
                                //             )),
                                //           ),
                                //           onPressed: () {
                                //             if (_keyForm.currentState!.validate()) {
                                //               doLogin(context);
                                //             }
                                //           }),
                                //     ),
                                //     Padding(
                                //         padding: const EdgeInsets.all(8.0),
                                // child: IconButton(
                                //   iconSize: 40,
                                //   onPressed: _authenticateMe,
                                //   icon: Image.asset("images/facial_recognition.png")
                                //   // i
                                // ))
                                //   ],
                                // )
                              ],
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text(
                                  "version " + version + " " + appType,
                                  style: TextStyle(
                                      fontSize: 9, fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )));
  }

  void doLogin(BuildContext context) async {
    String encryptedPassword = ConverterUtil().generateMd5(passwordCtrl.text);
    String companyCode = companyCodeCtrl.text.toUpperCase();
    String username = userIdCtrl.text;
    print('masuk ke sini <<<<<<<<<<<<<<<<<<<<<=============');
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // db.deleteUser();
        loginApi(username, encryptedPassword, companyCode);
      }
    } on SocketException catch (_) {
      Warning.showWarning("No Internet Connection");
    }

    // List<User> userList;

    /* 
      ok Input User Id benar, Password dan Company Code salah	Tidak menampilkan notifikasi Password dan Company Code salah, tapi incorrect username/email/company code or password (sama untuk semua kondisi)
      ok Input User Id dan Password benar, Company Code salah	Tidak menampilkan notifikasi Company Code salah, tapi incorrect username/email/company code or password (sama untuk semua kondisi)
      ok Input User Id salah, Password dan Company Code benar	Tidak menampilkan notifikasi User Id salah, tapi incorrect username/email/company code or password (sama untuk semua kondisi)
      ok Input User Id dan Password salah, Company Code benar	Tidak menampilkan notifikasi User Id salah, tapi incorrect username/email/company code or password (sama untuk semua kondisi)
      mikir Input User Id salah, Password benar, Company Code salah	Tidak menampilkan notifikasi User Id dan Company Code salah, tapi incorrect username/email/company code or password (sama untuk semua kondisi)
      ok Input User Id benar, Password salah, Company Code benar	Tidak menampilkan notifikasi Password salah, tapi incorrect username/email/company code or password (sama untuk semua kondisi)
    */
  }

  // void initPlatformState() async {
  //   String version;
  //   try {
  //     version = await GetVersion.projectVersion;
  //   } on PlatformException {
  //     version = 'Failed to get project version.';
  //   }

  //   if (!mounted) return;
  //   setState(() {
  //     projectVersion = version;
  //   });
  // }

  void loginApi(
      String username, String encryptedPassword, String companyCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = {
      "username": username,
    };
    Warning.loading(context);
    print('hit api <<<<<=========');
    var response = await RestService()
        .restRequestService(SystemParam.fLoginByUserIdOrEmail, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    //var status = convertDataToJson['status'];
    print(convertDataToJson);
    String errorMsg = "";
    bool isLogin = false;
    bool isActive = true;
    var user;

    if (code == "0") {
      await db.deleteUser();

      UserModel userModel = userFromJson(response.body.toString());
      List<User> userList = userModel.data;
      // bool isInsert = false;

      if (null != userList && userList.length < 1) {
        errorMsg += "User Id";
      }

      if (null != userList &&
          userList.length > 0 &&
          userList[0].isLoginMobile == "1" &&
          userList[0].deviceId != _deviceId) {
        print("Device ID::::" +
            userList[0].deviceId.toString() +
            "::::" +
            _deviceId.toString());
        isLogin = true;
      }

      if (null != userList &&
          userList.length > 0 &&
          userList[0].encryptedPassword != encryptedPassword) {
        if (errorMsg != "") {
          errorMsg += ", Password";
        } else {
          errorMsg = "Password";
        }
      }

      String errorCompany = "";
      for (var i = 0; i < userList.length; i++) {
        if (userList[i].companyCode.toUpperCase() ==
            companyCode.toUpperCase()) {
          user = userList[i];
          errorCompany = "";

          break;
        } else {
          //cek company tidak cocok
          if (userList[i].companyCode.toUpperCase() !=
              companyCode.toUpperCase()) {
            errorCompany = "Company Code";
          }
        }
      }

      if (errorCompany != "") {
        if (errorMsg != "") {
          errorMsg += ", Company";
        } else {
          errorMsg += "Company";
        }
      }

      if (errorMsg == "") {
        for (var i = 0; i < userList.length; i++) {
          /* INSERT USER */
          db.insertUser(userList[i]);
        }
      }
    } else {
      Navigator.pop(context);
      if (errorMsg != "") {
        errorMsg += ", User Id";
      } else {
        errorMsg += "User Id";
      }
    }

    if (errorMsg != "" || isLogin) {
      String errMsg = "";
      if (errorMsg != "") {
        errMsg = errorMsg + " salah ";
      } else {
        errMsg = "User sudah login di device lain";
      }
      Navigator.pop(context);
      Warning.showWarning(errMsg);
      return;
    } else {
      bool isActive = true;
      if (0 == user.employeeStatus) {
        if (1 == user.resignFlag) {
          DateTime dtNow = DateTime.now();
          if (user.resignDate != null) {
            if (dtNow.isAfter(user.resignDate)) {
              //user inactive becouse resign date
              isActive = false;
            }
          }
        } else {
          //user inactive
          isActive = false;
        }
      }

      if (!isActive) {
        //USER INACTIVE
        Navigator.pop(context);
        Warning.showWarning("User is not active!");
        return;
      } else if (null == user.lastSignInAt) {
        //USER BARU
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewChangePassword(
                user: user,
                rootAsal: 'loginScreen',
              ),
            ));
      } else {
        /* UPDATE IS LOGIN */
        Navigator.pop(context);
        dynamic json = jsonEncode(user);
        prefs.setString("dataUser", json.toString());
        print(json);
        onLoginSuccess(user);
      }
    }
  }

  void loginLocal(List<User> userList, String username,
      String encryptedPassword, String companyCode) async {
    String errorMsg = "";
    var user;

    if (null != userList && userList.length < 1) {
      errorMsg += "User Id";
    }

    if (null != userList &&
        userList.length > 0 &&
        userList[0].isLoginMobile == "1" &&
        userList[0].deviceId != _deviceId) {
      errorMsg += "User sudah login di device lain";
    }

    if (null != userList &&
        userList.length > 0 &&
        userList[0].encryptedPassword != encryptedPassword) {
      if (errorMsg != "") {
        errorMsg += ", Password";
      } else {
        errorMsg = "Password";
      }
    }

    String errorCompany = "";
    for (var i = 0; i < userList.length; i++) {
      if (userList[i].companyCode.toUpperCase() == companyCode.toUpperCase()) {
        user = userList[i];
        errorCompany = "";

        break;
      } else {
        //cek company tidak cocok
        if (userList[i].companyCode.toUpperCase() !=
            companyCode.toUpperCase()) {
          errorCompany = "Company Code";
        }
      }
    }

    if (errorCompany != "") {
      if (errorMsg != "") {
        errorMsg += ", Company";
      } else {
        errorMsg += "Company";
      }
    }

    if (errorMsg != "") {
      Warning.showWarning(errorMsg + "salah");
      // Fluttertoast.showToast(
      //     msg: errorMsg + " salah",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    } else {
      /* UPDATE IS LOGIN */
      onLoginSuccess(user);
      // updateIsLogin(user, "1");
      // sessionTimer.startTimer(user);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => LandingPage(
      //         user: user,
      //       ),
      //     ));
    }
  }

  void loginBiometrik(String type) async {
    var user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Future<List<User>> userListFuture = db.getUserList();
    await db.getUserList().then((value) {
      if (value != null && value.length > 0) {
        user = value[0];
      }
    });

    print(user);
    if (user == null) {
      Warning.showWarning(
          "Belum ada data Local, silahkan login manual terlebih dahulu");
    } else {
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // db.getUserList().then((value)  {
          // setState(() async {
          //print("user.username" + user.username);
          if (null != user) {
            var data = {
              "username": user.username,
            };

            var response = await RestService()
                .restRequestService(SystemParam.fLoginByUserIdOrEmail, data);

            var convertDataToJson = json.decode(response.body);
            var code = convertDataToJson['code'];

            if (code == "0") {
              UserModel userModel = userFromJson(response.body.toString());
              List<User> userList = userModel.data;
              await db.deleteUser();
              for (var i = 0; i < userList.length; i++) {
                await db.insertUser(userList[i]);
              }

              if (userList.length > 1) {
                if (type == "LOGIN") {
                  if (userList[0].isLoginMobile == "1" &&
                      userList[0].deviceId != _deviceId) {
                    Warning.showWarning("User sudah login di device lain");
                    return;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginChooseCompanyCode(
                            userList: userList, deviceId: _deviceId),
                      ));
                } else {
                  /* DAFTAR */
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BiometrikTermAndCondition(
                          user: user,
                          page: "LOGIN",
                        ),
                      ));
                }
              } else if (userList.length == 1) {
                for (var i = 0; i < userList.length; i++) {
                  user = userList[i];
                  dynamic json = jsonEncode(user);
                  prefs.setString("dataUser", json.toString());
                }

                if (type == "LOGIN") {
                  if (user.isLoginMobile == "1" && user.deviceId != _deviceId) {
                    Warning.showWarning("User sudah login di device lain");
                    return;
                  }
                  /* UPDATE IS LOGIN */
                  onLoginSuccess(user);
                  // updateIsLogin(user, "1");
                  // sessionTimer.startTimer(user);
                  // /* LOGIN */
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => LandingPage(
                  //         user: user,
                  //       ),
                  //     ));
                } else {
                  /* DAFTAR */
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BiometrikTermAndCondition(
                          user: user,
                          page: "LOGIN",
                        ),
                      ));
                }
              } else {
                Warning.showWarning("Silahkan login terlebih dahulu");
              }
            }
          }
          // });
          // });
        }
      } on SocketException catch (_) {
        Warning.showWarning("No Internet Connection");

        // db.getUserList().then((userList) {
        //   // setState(() {
        //   if (userList.length > 1) {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => LoginChooseCompanyCode(
        //             userList: userList,
        //             deviceId: _deviceId,
        //           ),
        //         ));
        //   } else if (userList.length == 1) {
        //     for (var i = 0; i < userList.length; i++) {
        //       user = userList[i];
        //     }

        //     if (type == "LOGIN") {
        //       /* UPDATE IS LOGIN */
        //       onLoginSuccess(user);
        //       // updateIsLogin(user, "1");
        //       // sessionTimer.startTimer(user);
        //       // /* LOGIN */
        //       // Navigator.push(
        //       //     context,
        //       //     MaterialPageRoute(
        //       //       builder: (context) => LandingPage(
        //       //         user: user,
        //       //       ),
        //       //     ));
        //     } else {
        //       /* DAFTAR */
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => BiometrikTermAndCondition(
        //               user: user,
        //               page: "LOGIN",
        //             ),
        //           ));
        //     }
        //   } else {
        //     Warning.showWarning("Silahkan login terlebih dahulu");
        //   }
        //   // });
        // });
      }
    }
  }

  Future<bool> getAvailabelBioMetrics() async {
    List<BiometricType> availableBiometrics =
        await _localAuthentication.getAvailableBiometrics();
    bool isAvailable = true;
    if (Platform.isIOS) {
      if (!availableBiometrics.contains(BiometricType.face)) {
        // !Face ID.
        isAvailable = false;
      }
    }

    if (Platform.isAndroid) {
      if (!availableBiometrics.contains(BiometricType.face)) {
        // !Face ID.
        isAvailable = false;
      }
    }
    return isAvailable;
  }

  showDeleteDialog(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        primary: Colors.green,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Reset Password"),
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          primary: Colors.red),
      onPressed: resetPassword,
    );

    Widget loading = SpinKitCircle(color: Colors.grey[350], size: 15);
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset Password"),
      content: SingleChildScrollView(
          child: Column(
        children: [
          TextFormField(
            validator: requiredValidator,
            controller: nomorHpDialogCtrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Input Nomor HP",
              labelStyle: TextStyle(fontSize: 14.0, fontFamily: "Brand Bold"),
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 10.0,
              ),
            ),
            style: TextStyle(fontSize: 14.0, fontFamily: "Brand Bold"),
          ),
          // TextFormField(
          //   validator: requiredValidator,
          //   controller: userIdDialogCtrl,
          //   keyboardType: TextInputType.text,
          //   decoration: InputDecoration(
          //     labelText: "User Id/ Email",
          //     labelStyle: TextStyle(fontSize: 14.0, fontFamily: "Brand Bold"),
          //     hintStyle: TextStyle(
          //       color: Colors.grey,
          //       fontSize: 10.0,
          //     ),
          //   ),
          //   style: TextStyle(fontSize: 14.0, fontFamily: "Brand Bold"),
          // ),
          // SizedBox(
          //   height: 1.0,
          // ),
          // TextFormField(
          //   validator: requiredValidator,
          //   controller: companyCodeDialogCtrl,
          //   keyboardType: TextInputType.text,
          //   decoration: InputDecoration(
          //     labelText: "Company Code",
          //     labelStyle: TextStyle(fontSize: 14.0, fontFamily: "Brand Bold"),
          //     hintStyle: TextStyle(
          //       color: Colors.grey,
          //       fontSize: 10.0,
          //     ),
          //   ),
          //   style: TextStyle(fontSize: 14.0, fontFamily: "Brand Bold"),
          // ),
        ],
      )),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void resetPassword() async {
    if (nomorHpDialogCtrl.text == "") {
      Warning.showWarning("Nomor HP harus diisi");
      return;
    }
    Navigator.of(context).pop();
    Warning.showWarning("Reset password sedang di proses...");
    String datetime = SystemParam.formatDateTimeUnique.format(DateTime.now());
    String token = datetime + nomorHpDialogCtrl.text;
    // String pesan ="Jika anda melakukan permintaan reset password WrkPln klik link berikut, "+tokenUrl+token.toUpperCase();

    //fUpdateUserToken
    var data = {
      "token": token.toUpperCase(),
      "phone": nomorHpDialogCtrl.text,
      //"message":pesan
    };

    // var response = await RestService()
    //     .restRequestService(SystemParam.fUpdateUserToken, data);
    var response = await RestService()
        .restRequestService(SystemParam.fResetPassword, data);
    var responToJson = json.decode(response.body);
    var code = responToJson['code'];

    if (code == "0") {
      //delete users
      //await db.deleteUser();

      // var dataPesan = {
      //   "userkey": smsGatewayUserKey,
      //   "passkey": smsGatewayPassKey,
      //   "nohp": nomorHpDialogCtrl.text,
      //   "pesan": pesan
      // };

      // var responsePesan = await RestService()
      //     .restRequestServiceOthers(smsGatewayAPI, dataPesan);
      // print("convertDataToJsonPesan:"+responsePesan.body);

      Warning.showWarning("Reset password berhasil, silahkan cek pesan anda.");

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      Warning.showWarning(
          "Reset password gagal, silahkan hubungi admin perusahaan anda.");
    }
  }

  void initUser() async {
    loading = true;
    print('masuk ke init device');
    db.getUserList().then((value) {
      print(value);
      if (value.length > 0) {
        print('ada db local');
        setState(() {
          late User userDb = value[0];
          print("isBiometrik");
          print(userDb.isBiometrik);
          if (userDb.isBiometrik == "1") {
            isCheckedBiometrics = true;
            _authenticateMe();
          } else {
            isCheckedBiometrics = false;
          }

          loading = false;
        });
      }
    });
    loading = false;
  }

  void updateIsLogin(User user, String isLogin) async {
    // Flutter
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var dataPassword = {
          "id": user.id,
          "updated_by": user.id,
          "is_login_mobile": isLogin,
          "device_id": _deviceId
        };

        var response = await RestService()
            .restRequestService(SystemParam.fUpdateIsLogin, dataPassword);

        var convertDataToJson = json.decode(response.body);
        var code = convertDataToJson['code'];
        print("code is login response:" + code);
      }
    } on SocketException catch (_) {
      Warning.showWarning('No Internet Connection');
    }
  }

  onLoginSuccess(user) {
    updateIsLogin(user, "1");

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(user: user),
        ));
  }

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      buildNumber = packageInfo.buildNumber;
    });
  }

  Future<bool?> cekMockLocation() async {
    List<String?> position = await TrustLocation.getLatLong;

    /// check mock location on Android device.
    _isMockLocation = await TrustLocation.isMockLocation;
    print('ini hasil cek mock location $_isMockLocation <<<<=====');
    return _isMockLocation;
  }

  void cekDevelopmentMode() async {
    bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
    print(' apakah development mode hidup : $isDevelopmentModeEnable');
  }

  // void initSmsGateway() async{
  //   setState(() {
  //       db.getParameterByCode(SystemParam.parameterCodeSmsGatewayAPI).then((value) {
  //         smsGatewayAPI = value.parameterValue;
  //       });

  //       db.getParameterByCode(SystemParam.parameterCodeSmsGatewayUserKey).then((value) {
  //         smsGatewayUserKey = value.parameterValue;
  //       });

  //       db.getParameterByCode(SystemParam.parameterCodeSmsGatewayPassKey).then((value) {
  //         smsGatewayPassKey = value.parameterValue;
  //       });

  //       db.getParameterByCode(SystemParam.parameterCodeTokenUrl).then((value) {
  //         tokenUrl = value.parameterValue;
  //       });

  //   });
  // }
}
