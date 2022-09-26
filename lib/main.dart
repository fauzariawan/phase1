import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:workplan_beta_test/main_pages/landingpage_view.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/biometrik_login.dart';
// import 'package:workplan_beta_test/launcher/launcher_view.dart';
import 'package:workplan_beta_test/main_pages/constans.dart';
import 'package:workplan_beta_test/pages/on_boarding_page.dart';

import 'base/system_param.dart';
import 'helper/rest_service.dart';
import 'main_pages/launcher_view.dart';
import 'model/workplan_visit_notification.dart';
import 'pages/loginscreen.dart';

// const simplePeriodicTask = "CheckInTask";

// void main() => runApp(new MyApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    print('cek data User');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs);
    bool isLogedIn = prefs.containsKey('dataUser');
    print(isLogedIn);
    var data = prefs.getString("dataUser");
    var dataUser;
    if (data != null) {
      dataUser = json.decode(data);
    }

    User user = User.fromJson(dataUser);
    print(dataUser);
    Widget halaman = isLogedIn
        ? LandingPage(
            user: user,
          )
        : OnBoardingPage();
    runApp(MyApp(halaman: halaman));
  } catch (e) {
    print('ini error ketika sharedpreference nya');
    print(e);
    runApp(MyApp(halaman: OnBoardingPage()));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.halaman}) : super(key: key);
  final Widget? halaman;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
       Locale('de', 'DE'),
       Locale('en', 'US'),
       Locale('id','ID')
      ],
      // initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'Task',
      theme: new ThemeData(
        fontFamily: 'NeoSans',
        primaryColor: WorkplanPallete.green,
        primarySwatch: SystemParam.colorCustom
      ),
      home: widget.halaman
      // LauncherPage(),
    ));
  }

  Future onSelectNotification(String? payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
