import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:marquee/marquee.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/main_pages/constans.dart';
import 'package:workplan_beta_test/main_pages/landingpage_view.dart';
// import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/main_pages/task_menu.dart';
import 'package:workplan_beta_test/main_pages/tes.dart';
import 'package:workplan_beta_test/main_pages/workplan_appbar.dart';
import 'package:workplan_beta_test/model/home_model.dart';
import 'package:workplan_beta_test/model/notice_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/loginscreen.dart';
import 'package:workplan_beta_test/pages/marquee_page.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_inbox.dart';

import 'basic_page.dart';

// class BerandaPage extends StatefulWidget {
//   final User user;
//   const BerandaPage({Key? key, required this.user}) : super(key: key);
//   @override
//   _BerandaPageState createState() => new _BerandaPageState();
// }

class BerandaPage extends BasePage {
  final User user;
  // final SessionTimer sessionTimer;
  //const BerandaPage({Key? key, required this.user}) : super(key: key);
  BerandaPage({required this.user}) : super(user);
  @override
  _BerandaPageState createState() => new _BerandaPageState();
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

// class _BerandaPageState extends State<BerandaPage> {
class _BerandaPageState extends BaseState<BerandaPage> with BasicPage {
  List<WorkplanMenu> _workplanServiceList = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  BehaviorSubject<String?> selectNotificationSubject =
      BehaviorSubject<String?>();

  // int _noticeCount = 0, _noticeCountMarquee = 0;
  List<Notice> _noticeListDashboard = [];
  List<Notice> _noticeListMarquee = [];
  bool loading = false;
  // bool _useRtlText = false;
  String marqueeText = "";
  var db = new DatabaseHelper();
  int newMessage = 0;
  late Timer timer;
  int counter = 0;
  int itemCountMenu = 0;
  // SessionTimer sessionTimer = new SessionTimer();

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

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // print('ini nilai yang ada di class TEST <<<<<<=======');
    // print(Test().huruf);

    setState(() {
      //loading = true;
      // SessionTimer().startTimer(widget.user.timeoutLogin);
      initNotice();
      initNoticePersonalCount();

      timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
        initNoticePersonalCount();
      });

      _requestPermissions();
      _configureDidReceiveLocalNotificationSubject();
      _configureSelectNotificationSubject();

      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
      var initializationSettingsAndroid =
          new AndroidInitializationSettings('app_icon');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      // initNoticeApi();

      //  IconData comingSoonIcon = ImageIcon(AssetImage("images/coming_soon.png")) as IconData;
      //Image.asset('images/coming_soon.png');

      initMenu();
      //loading = false;
    });
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LandingPage(
                        user: widget.user,
                      ),
                    ));
                // Navigator.of(context, rootNavigator: true).pop();
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute<void>(
                //     builder: (BuildContext context) =>
                //         SecondPage(receivedNotification.payload),
                //   ),
                // );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      // await Navigator.pushNamed(context, '/secondPage');
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LandingPage(
              user: widget.user,
            ),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: new Scaffold(
        appBar: new WorkPlanAppBar(context, widget.user, newMessage),
        backgroundColor: WorkplanPallete.grey,
        body: loading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 13.0),
                  color: Colors.white,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //_buildGopayMenu(),
                      _buildGojekServicesMenu(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: new Container(
                          child: createListViewNotice(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 13.0),
                        child: Text("Pesan Berjalan:",
                            style: TextStyle(
                                color: WorkplanPallete.green, fontSize: 14)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0, right: 8.0),
                        child: marqueeText == ""
                            ? Container()
                            : Container(
                                color: WorkplanPallete.green,
                                // width: 200.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: MarqueeWidget(
                                      direction: Axis.horizontal,
                                      child: Text(
                                        marqueeText,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      )),
                                )),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container())
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(left: 8.0, right: 8.0),
                      //   child: new Container(
                      //     child: createListViewNoticeMarquee(),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildGojekServicesMenu() {
    return itemCountMenu == 0
        ? new Container()
        : new SizedBox(
            width: double.infinity,
            height: 120.0,
            child: new Container(
                margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: GridView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: itemCountMenu,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                    itemBuilder: (context, position) {
                      return _rowGojekService(_workplanServiceList[position]);
                    })));
  }

  Widget _rowGojekService(WorkplanMenu menu) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              //sessionTimer.userActivityDetected(context, widget.user);
              if (menu.title == "TASK") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskMenu(
                        user: widget.user,
                      ),
                    ));
              } else if (menu.title == "INBOX") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WorkplanInboxPage(user: widget.user),
                    ));
              } else if (menu.title == "OTHER") {}
            },
            child: new Container(
              decoration: new BoxDecoration(
                  border:
                      Border.all(color: WorkplanPallete.grey200, width: 1.0),
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(20.0))),
              padding: EdgeInsets.all(12.0),
              // child: new Icon(
              //   menu.image,
              //   color: menu.color,
              //   size: 32.0,
              // ),
              child: menu.image,
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 6.0),
          ),
          new Text(menu.title, style: new TextStyle(fontSize: 10.0))
        ],
      ),
    );
  }

  void initNoticeApi() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {
          "user_id": widget.user.id,
          "company_id": widget.user.userCompanyId,
          "organization_id": widget.user.organizationId,
          "function_id": widget.user.functionId,
          "structure_id": widget.user.structureId,
        };

        print(data);

        print(data);
        var response =
            await RestService().restRequestService(SystemParam.fNotice, data);
        setState(() {
          loading = true;
          // setState(() {
          NoticeModel model = noticeModelFromJson(response.body.toString());

          for (var i = 0; i < model.data.length; i++) {
            if (model.data[i].mediaTypeCode == "PESAN_BERJALAN") {
              _noticeListMarquee.add(model.data[i]);
              marqueeText += model.data[i].noticeBody + ".           ";
            } else if (model.data[i].mediaTypeCode == "DASHBOARD") {
              _noticeListDashboard.add(model.data[i]);
            }
          }

          loading = false;
        });
      }
    } on SocketException catch (_) {}
  }

  getNoticeList(Notice dt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: WorkplanPallete.green,
              child: Container(
                  child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          dt.noticeBody == null ? " " : "" + dt.noticeBody,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              dt.createdName == null
                                  ? " "
                                  : " " + dt.createdName,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                          Align()
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            )),
      ),
    );
  }

  ListView createListViewNotice() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _noticeListDashboard.length,
      itemBuilder: (BuildContext context, int index) {
        return getNoticeList(
          _noticeListDashboard[index],
        );
      },
    );
  }

  ListView createListViewNoticeMarquee() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _noticeListMarquee.length,
      itemBuilder: (BuildContext context, int index) {
        return getNoticeListMarquee(
          _noticeListMarquee[index],
        );
      },
    );
  }

  getNoticeListMarquee(Notice dt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Marquee(
        key: Key("__" + dt.id.toString()),
        text: dt.noticeBody,
        velocity: 50.0,
      ),
    );
  }

  void initNotice() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
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
        // print(convertDataToJson);
        var code = convertDataToJson['code'];
        if (code == "0") {
          setState(() {
            loading = true;
            NoticeModel messageModel =
                noticeModelFromJson(response.body.toString());
            List<Notice> noticeList = messageModel.data;
            _noticeListMarquee.clear();
            _noticeListDashboard.clear();
            marqueeText = "";
            for (var i = 0; i < noticeList.length; i++) {
              if (noticeList[i].mediaTypeCode == "PESAN_BERJALAN") {
                _noticeListMarquee.add(noticeList[i]);
                // ignore: unnecessary_null_comparison
                if (noticeList[i].noticeBody != null) {
                  marqueeText += noticeList[i].noticeBody + ".           ";
                }
              } else if (noticeList[i].mediaTypeCode == "DASHBOARD") {
                _noticeListDashboard.add(noticeList[i]);
              }
            }
            loading = false;
          });
        }
      }
      //loading = false;
    } on SocketException catch (_) {
      //loading = true;
      setState(() {
        loading = true;
        db
            .getNoticeList(widget.user.userCompanyId.toString())
            .then((noticeList) {
          _noticeListMarquee.clear();
          _noticeListDashboard.clear();
          marqueeText = "";
          for (var i = 0; i < noticeList.length; i++) {
            if (noticeList[i].mediaTypeCode == "PESAN_BERJALAN") {
              _noticeListMarquee.add(noticeList[i]);
              marqueeText += noticeList[i].noticeBody + ".           ";
            } else if (noticeList[i].mediaTypeCode == "DASHBOARD") {
              _noticeListDashboard.add(noticeList[i]);
            }
          }
        });
        loading = false;
      });
      //
    }
  }

  void initNoticePersonalCount() async {
    setState(() {
      loading = true;
      db.countNoticeByMediaTypeCode("KOTAK_PERSONAL").then((value) {
        newMessage = value;
      });
      loading = false;
    });
  }

  initMenu() async {
    _workplanServiceList.add(
      new WorkplanMenu(
          image: Image.asset(
            "images/checked.png",
            width: 36,
            height: 36,
          ),
          color: WorkplanPallete.menuPulsa,
          title: "TASK"),
    );

    _workplanServiceList.add(new WorkplanMenu(
        image: Image.asset("images/coming_soon2.png", width: 35, height: 35),
        color: WorkplanPallete.menuBluebird,
        title: "ATTENDANCES"));

    _workplanServiceList.add(new WorkplanMenu(
        image: Image.asset("images/coming_soon2.png", width: 35, height: 35),
        color: WorkplanPallete.menuDeals,
        title: "APPROVAL"));

    _workplanServiceList.add(new WorkplanMenu(
        image: Image.asset("images/coming_soon2.png", width: 35, height: 35),
        color: WorkplanPallete.menuTix,
        title: "DAILY JOURNEY"));

    itemCountMenu = 4;
  }

  @override
  Widget rootWidget(BuildContext context) {
    // TODO: implement rootWidget
    throw UnimplementedError();
  }
}
