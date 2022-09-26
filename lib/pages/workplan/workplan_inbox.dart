import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/main_pages/landingpage_view.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/main_pages/task_menu.dart';

import 'workplan_receive.dart';

class WorkplanInboxPage extends StatefulWidget {
  final User user;
  const WorkplanInboxPage({Key? key, required this.user}) : super(key: key);

  @override
  _WorkplanInboxPageState createState() => _WorkplanInboxPageState();
}

class _WorkplanInboxPageState extends State<WorkplanInboxPage> {
  MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);
  late List<WorkplanInboxData> widList = <WorkplanInboxData>[];
  // late WorkplanInbox wokplanInbox;
  bool loading = false;
  int count = 0;
  var progresStatusId = 0;
  var db = new DatabaseHelper();
  //  SessionTimer sessionTimer = new SessionTimer();

  @override
  void initState() {
    super.initState();
    // loading = true;
     //SessionTimer().userActivityDetected(context,widget.user);
    getWorkplanInbox();
    // getWorkplanInboxOnline();
    // getWorkplanInboxDB();
    // Timer.periodic(Duration(minutes: 1), (Timer timer) {
    //   getWorkplanInboxDB();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // sessionTimer.userActivityDetected(context, widget.user);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskMenu(
                  user: widget.user,
                ),
              ));
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Inbox Task'),
              centerTitle: true,
              backgroundColor: colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskMenu(
                          user: widget.user,
                        ),
                      ));
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  loading == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : new Container(child: createListView()),
                ],
              ),
            )));
  }

  ListView createListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widList.length,
      itemBuilder: (BuildContext context, int index) {
        return customListItem(widList[index]);
      },
    );
  }

  Future getWorkplanInboxOnline() async {
    loading = true;
    // var userId = widget.user.id;
    var data = {
      "user_id": widget.user.id,
      "company_id": widget.user.userCompanyId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fWorkplanInboxByUserCompanyId, data);

    setState(() {
      // print("response.body.toString():" + response.body.toString());
      WorkplanInboxModel wi = workplanInboxFromJson(response.body.toString());
      widList = wi.data;
      count = wi.data.length;
      // // count = ;
      // for (var i = 0; i < wi.data.length; i++) {
      //   // print(wi.data[i].toString());
      //   db.deleteWorkplanActivityById(wi.data[i].id);
      //   db.insertWorkplanActivity(wi.data[i]);
      // }

      loading = false;
    });
  }

  customListItem(WorkplanInboxData dt) {
    return Card(
      color: Colors.white,
      //elevation: 2.0,
      child: ListTile(
        leading: Image.asset(
          "images/man.png",
        ),
        title: Text(
          dt.fullName,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Text(dt.activityDescription),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // sessionTimer.userActivityDetected(context, widget.user);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkplanInboxReceive(
                  workplanInboxData: dt,
                  user: widget.user,
                ),
              ));
        },
      ),
    );
  }

  void getWorkplanInboxDB() async {
    loading = true;
    Future<List<WorkplanInboxData>> wiDF = db.getWorkplanActivityInbox();
    wiDF.then((value) {
      setState(() {
        widList = value;
        count = value.length;
      });
    });

    loading = false;
  }

  Future<void> getWorkplanInbox() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        getWorkplanInboxOnline();
      }
    } on SocketException catch (_) {
      print('not connected');
      getWorkplanInboxDB();
    }
  }
}
