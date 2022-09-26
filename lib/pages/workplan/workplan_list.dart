// import 'dart:io';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_input.dart';
import 'package:workplan_beta_test/widget/warning.dart';

import '../../main_pages/task_menu.dart';
import 'workplan_view.dart';

class WorkplanList extends StatefulWidget {
  final User user;

  const WorkplanList({Key? key, required this.user}) : super(key: key);
  @override
  _WorkplanListState createState() => _WorkplanListState();
}

class _WorkplanListState extends State<WorkplanList> {
  MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);
  get pageController => null;
  // late WorkplanInboxModel wokplanInbox;
  List<WorkplanInboxData> _wiData = <WorkplanInboxData>[];
  bool loading = false;
  int count = 0;
  var progresStatusId = 1;
  DatabaseHelper db = new DatabaseHelper();
  //  SessionTimer sessionTimer = new SessionTimer();

  @override
  void initState() {
    super.initState();
    // getWorkplanListOnline();
    // getWorkplanListDB();

    getWorkplanList();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        //sessionTimer.userActivityDetected(context, widget.user);
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
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('List Task'),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final result = await InternetAddress.lookup('example.com');
              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                //sessionTimer.userActivityDetected(context, widget.user);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkplanInput(user: widget.user),
                    ));
              }
            } on SocketException catch (_) {
              //print('not connected');
              Fluttertoast.showToast(
                  msg: "No Internet Connection", // rencana kunjungan baru
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          backgroundColor: colorCustom,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: new Container(
            child: loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : new Container(child: createListView()),
          ),
        ),
      ));

  ListView createListView() {
    // TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return customListItem(_wiData[index]);
      },
    );
  }

  customListItem(WorkplanInboxData dt) {
    var distribusi = "Input";
    // ignore: unnecessary_null_comparison
    if (dt.distribusiWorkplanId != null) {
      distribusi = "Distribusi";
    }

    // ignore: unnecessary_null_comparison
    var progressStatus =
        dt.progresStatusDescription == null ? "" : dt.progresStatusDescription;

    bool isMaximumUmur = false;
    DateTime dtNow = DateTime.now();
    //print("dt.maksimalUmurDate:"+dt.maksimalUmurDate.toString()+"-"+dtNow.toString());

    // if(dt.maksimalUmurDate!=null){
    //   if(dtNow.isAfter(dt.maksimalUmurDate)) {
    //     isMaximumUmur = true;
    //   }
    // }

    if (dt.maximumDate != null) {
      if (dt.progresStatusIdAlter == 3) {
        isMaximumUmur = true;
      }
    }

    return GestureDetector(
      onTap: () {
        //sessionTimer.userActivityDetected(context, widget.user);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkplanView(
                  user: widget.user,
                  workplan: dt,
                  isMaximumUmur: isMaximumUmur),
            ));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                color: Colors.white,
                elevation: 0.1,
                child: ListTile(
                  // leading: CircleAvatar(
                  //   backgroundColor: Colors.white,
                  //   child: Icon(Icons.book),
                  // ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 8.0),
                    child: Icon(
                      Icons.card_travel,
                      color: colorCustom,
                      size: 50,
                    ),
                  ),
                  title: Text(
                      // ignore: unnecessary_null_comparison
                      dt.nomorWorkplan == null ? "" : dt.nomorWorkplan,
                      style: TextStyle(fontSize: 12)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dt.fullName,
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          dt.activityDescription == null
                              ? ""
                              : dt.activityDescription,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          distribusi,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // trailing: GestureDetector(
                  //   child: Icon(Icons.more_vert),
                  // ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Badge(
                          toAnimate: false,
                          shape: BadgeShape.square,
                          badgeColor: colorCustom,
                          borderRadius: BorderRadius.circular(8),
                          badgeContent: Text(progressStatus,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                        ),
                      ),
                      Icon(Icons.more_vert)
                    ],
                  ),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 0),
                child: new Container(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                child: Text(
                  "Rencana Kunjungan 1",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 0),
                child: dt.rencanaKunjungan == null
                    ? null
                    : Text(
                        SystemParam.formatDateDisplay
                            .format(dt.rencanaKunjungan),
                        style: TextStyle(fontSize: 11),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                child: Text(
                  "No. HP",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 0),
                child: Text(
                  dt.phone,
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getWorkplanList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        getWorkplanListOnline();
      }
    } on SocketException catch (_) {
      Warning.showWarning("No Internet Connection !!!");
      // print('not connected');
      // getWorkplanListDB();
    }
  }

  void getWorkplanListOnline() async {
    print('ini data untuk get list task <<<<<=====');
    print(widget.user.id);
    print(progresStatusId);
    print(widget.user.userCompanyId);
    var data = {
      "user_id": widget.user.id,
      "progres_status_id": progresStatusId,
      "company_id": widget.user.userCompanyId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fWorkplanListByUserCompanyId, data);
    // var response =await RestService().restRequestService(SystemParam.fWorkplanListByUserCompanyIdNew, data);

    setState(() {
      // print("response.body.toString():" + response.body.toString());
      WorkplanInboxModel wokplanInboxModel =
          workplanInboxFromJson(response.body.toString());
      _wiData = wokplanInboxModel.data;
      count = wokplanInboxModel.data.length;
      loading = false;
    });
  }

  // void getWorkplanListDB() async {
  //   loading = true;
  //   Future<List<WorkplanInboxData>> wiDF = db.getWorkplanActivityList();
  //   wiDF.then((value) {
  //     setState(() {
  //       _wiData = value;
  //       count = value.length;
  //     });
  //   });
  //   loading = false;
  // }

}
