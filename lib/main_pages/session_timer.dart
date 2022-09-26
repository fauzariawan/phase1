// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:workplan_beta_test/base/system_param.dart';
// import 'package:workplan_beta_test/helper/rest_service.dart';
// import 'package:workplan_beta_test/model/user_model.dart';

// import 'launcher_view.dart';
// // import 'package:in_app_session_timeout/global.dart';
// // import 'package:in_app_session_timeout/login_screen.dart';
// // import 'package:in_app_session_timeout/main.dart';

// class SessionTimer {

//   // late Timer _timer; //= Timer.periodic(const Duration(minutes: 1), (_) {});
//   // Timer _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
    
//   // });
  
//   // late BuildContext _context;
//   final User user;
//   // int _countTimer = 0;
//   // int _minutesTimeout = 5;

//   SessionTimer(this.user);

//   void stopTimer(){
    
//     //  _minutesTimeout = 999999;
//     //  _timer.cancel();
//     //  print(":::stopTimer:::_minutesTimeout:"+_minutesTimeout.toString());
//   }

//   void startTimer(User user) {

//     // if (null != user.timeoutLogin) {
//     //   _minutesTimeout = user.timeoutLogin;
//     // }

//     // //print("_countTimer:"+_countTimer.toString()+"::: _minutesTimeout:"+_minutesTimeout.toString());

//     // _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
//     //   _countTimer += 1;
//     //   print(":::_countTimer:"+_countTimer.toString()+":::_minutesTimeout:::"+_minutesTimeout.toString());
//     //   if (_countTimer >= _minutesTimeout) {
//     //     _minutesTimeout = 999999;
//     //     timer.cancel();
//     //     _timer.cancel();
//     //     timedOut(user);
//     //   }
//     // });
//   }

//   userActivityDetected(BuildContext context, User user) {
//     // if (!_timer.isActive) {
//     //   return;
//     // }
    
//     // _context = context;
//     // //  user = user;
//     // _countTimer = 0;
//     // print("_countTimer:"+_countTimer.toString());
//    // startTimer(user);
//   }



//   Future<void> timedOut(User user) async {
//     // updateIsLogin(user, 0);
//     // await showDialog(
//     //   context: _context,
//     //   barrierDismissible: false,
//     //   builder: (context) => new AlertDialog(
//     //     title: new Text('Alert'),
//     //     content: Text('Maaf anda telah logout karena tidak aktif ...'),
//     //     actions: <Widget>[
//     //       new ElevatedButton(
//     //         onPressed: () {
//     //           Navigator.pushAndRemoveUntil<dynamic>(
//     //             context,
//     //             MaterialPageRoute<dynamic>(
//     //               builder: (BuildContext context) => LauncherPage(),
//     //             ),
//     //             (route) => false,
//     //           );
//     //         },
//     //         child: new Text('OK'),
//     //       ),
//     //     ],
//     //   ),
//     // );
//   }

//   void updateIsLogin(User user, int isLogin) async {
//     // try {
//     //   final result = await InternetAddress.lookup('example.com');
//     //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//     //     var dataPassword = {
//     //       "id": user.id,
//     //       "updated_by": user.id,
//     //       "is_login_mobile": isLogin,
//     //     };

//     //     var response = await RestService()
//     //         .restRequestService(SystemParam.fUpdateIsLogin, dataPassword);

//     //     var convertDataToJson = json.decode(response.body);
//     //     var code = convertDataToJson['code'];
//     //   }
//     // } on SocketException catch (_) {}
//   }
// }
