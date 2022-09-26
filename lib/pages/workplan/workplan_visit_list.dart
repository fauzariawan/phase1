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
import 'package:workplan_beta_test/model/workplan_visit_model.dart';
import 'package:workplan_beta_test/pages/workplan/visit_add.dart';
import 'package:workplan_beta_test/pages/workplan/visit_process.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_view.dart';
import 'package:workplan_beta_test/widget/warning.dart';

class WorkplanVisitList extends StatefulWidget {
  final WorkplanInboxData workplan;
  final User user;
  final bool isMaximumUmur;

  const WorkplanVisitList(
      {Key? key,
      required this.workplan,
      required this.user,
      required this.isMaximumUmur})
      : super(key: key);

  @override
  _WorkplanVisitListState createState() => _WorkplanVisitListState();
}

class _WorkplanVisitListState extends State<WorkplanVisitList> {
  get pageController => null;
  MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);
  // late WorkplanVisitModel workplanVisitModel;
  List<WorkplanVisit> workplanVisitList = <WorkplanVisit>[];
  bool loading = false;
  int count = 0;
  bool isLastVisitNotFinish = false;
  bool isDoneOrReject = false;
  var db = new DatabaseHelper();
  // SessionTimer sessionTimer = new SessionTimer();

  @override
  void initState() {
    super.initState();
    // if (widget.workplan.progresStatusId == 5) {
    //   isDone = true;
    // }

    // SessionTimer().userActivityDetected(context,widget.user);

    //reject/done
    if (widget.workplan.progresStatusCode == "PS005" ||
        widget.workplan.progresStatusCode == "PS004") {
      isDoneOrReject = true;
    }

    getWorkplanVisitList();
    // getWorkplanVisitListOnline();
    // getWorkplanVisitListDB();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        //  sessionTimer.userActivityDetected(context, widget.user);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkplanView(
                user: widget.user,
                workplan: widget.workplan,
                isMaximumUmur: widget.isMaximumUmur,
              ),
            ));
        return false;
      },
      child: Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('List Visit Activity'),
          centerTitle: true,
          backgroundColor: colorCustom,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            //onPressed: () => Navigator.of(context).pop(),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkplanView(
                      user: widget.user,
                      workplan: widget.workplan,
                      isMaximumUmur: widget.isMaximumUmur,
                    ),
                  ));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:
              isLastVisitNotFinish || isDoneOrReject || widget.isMaximumUmur
                  ? null
                  : visitAdd,
          // onPressed: isLastVisitNotFinish || isDone || widget.isMaximumUmur
          //     ? null
          //     : () => {

          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => VisitAdd(
          //                     workplan: widget.workplan,
          //                     user: widget.user,
          //                     isMaximumUmur: widget.isMaximumUmur),
          //               ))

          //         },
          backgroundColor: colorCustom,
          tooltip: 'Add Visit',
          child: Icon(Icons.add),
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Colors.white,
                elevation: 0.1,
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 8.0),
                    child: Icon(
                      Icons.card_travel,
                      color: colorCustom,
                      size: 50,
                    ),
                  ),
                  title: Text(widget.workplan.nomorWorkplan,
                      style: TextStyle(fontSize: 12)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.workplan.fullName,
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
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
                          badgeContent: Text(
                              widget.workplan.progresStatusDescription,
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
              loading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : new Container(
                      child: createListView(),
                    )
            ],
          ),
        ),
      ));

  ListView createListView() {
    int nomor = count + 1;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        nomor--;
        // ignore: unnecessary_null_comparison
        return customListItemTwo(workplanVisitList[index], nomor);
      },
    );
  }

  customListItemTwo(WorkplanVisit dt, int nomor) {
    print(widget.isMaximumUmur.toString() +
        "-" +
        isDoneOrReject.toString() +
        "-" +
        dt.isCheckOut.toString());
    //true-false-0
    return GestureDetector(
        onTap: isDoneOrReject || dt.isCheckOut == "1" || widget.isMaximumUmur
            ? null
            : () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VisitProcess(
                            workplan: widget.workplan,
                            workplanVisit: dt,
                            user: widget.user,
                            nomor: nomor,
                            isMaximumUmur: widget.isMaximumUmur)));
              },
        child: Card(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                      child: Text(
                        "Rencana Kunjungan Ke " + nomor.toString(),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 0),
                      child: Text(
                        dt.visitDatePlan == null
                            ? ""
                            : SystemParam.formatDateDisplay
                                .format(dt.visitDatePlan!),
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                      child: Text(
                        "Actual Kunjungan",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 0),
                      child: Text(
                        dt.visitDateActual == null
                            ? ""
                            : SystemParam.formatDateDisplay
                                .format(dt.visitDateActual!),
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                      child: Text(
                        "Keterangan 1",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 0),
                      child: Text(
                        dt.checkInDesc1 ?? "-",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                      child: Text(
                        "Keterangan 2",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 0),
                      child: Text(
                        dt.checkInDesc2 ?? "-",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                      child: Text(
                        "Tujuan",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 0),
                      child: Text(
                        // ignore: unnecessary_null_comparison
                        dt.visitPurposeDescription == null
                            ? ""
                            : dt.visitPurposeDescription,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                      child: Text(
                        "Hasil",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 0),
                      child: Text(
                        // ignore: unnecessary_null_comparison
                        dt.visitResultDescription == null
                            ? ""
                            : dt.visitResultDescription,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                          child: Text(
                            "Catatan Kunjungan",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        isDoneOrReject ||
                                dt.isCheckOut == "1" ||
                                widget.isMaximumUmur
                            ? Container()
                            : Icon(Icons.edit),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 0),
                      child: Text(
                        dt.note ?? "-",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ])),
        ));
  }

  void getWorkplanVisitList() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        getWorkplanVisitListOnline();
      }
    } on SocketException catch (_) {
      Warning.showWarning("No Internet Connection !!!");
      // print('not connected');
      // getWorkplanVisitListDB();
    }
  }

  // void getWorkplanVisitListDB() async {
  //   db.getWorkplanVisitList(widget.workplan.id).then((value) {
  //     setState(() {
  //       loading = true;
  //       workplanVisitList = value;
  //       count = value.length;
  //       for (var i = 0; i < count; i++) {
  //         if ((workplanVisitList[i].isCheckIn == "1" &&
  //                 workplanVisitList[i].isCheckOut == "0") ||
  //             (workplanVisitList[i].isCheckIn == "0" &&
  //                 workplanVisitList[i].isCheckOut == "0")) {
  //           isLastVisitNotFinish = true;
  //         }
  //       }
  //       loading = false;
  //     });
  //   });
  // }

  void getWorkplanVisitListOnline() async {
    print("ini workplan id nya <<<<<<<========== ");
    print(widget.workplan.id);
    var data = {
      "workplan_activity_id": widget.workplan.id,
    };
    var response = await RestService()
        .restRequestService(SystemParam.fWorkplanVisitList, data);

    setState(() {
      WorkplanVisitModel workplanVisitModel =
          workplanVisitModelFromJson(response.body.toString());
      count = workplanVisitModel.data.length;
      workplanVisitList = workplanVisitModel.data;
      print(workplanVisitList[0].checkInBatas);
      for (var i = 0; i < count; i++) {
        print('ini id dari visit list ${workplanVisitList[i].id}');
        if ((workplanVisitModel.data[i].isCheckIn == "1" &&
                workplanVisitModel.data[i].isCheckOut == "0") ||
            (workplanVisitModel.data[i].isCheckIn == "0" &&
                workplanVisitModel.data[i].isCheckOut == "0")) {
          isLastVisitNotFinish = true;
        }
      }
      loading = false;
    });
  }

  visitAdd() async {
    // onPressed: isLastVisitNotFinish || isDone || widget.isMaximumUmur
    //     ? null
    //     : () => {
    //  sessionTimer.userActivityDetected(context, widget.user);
    if (isLastVisitNotFinish || isDoneOrReject || widget.isMaximumUmur) {
      return;
    } else {
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VisitAdd(
                    workplan: widget.workplan,
                    user: widget.user,
                    isMaximumUmur: widget.isMaximumUmur),
              ));
        }
      } on SocketException catch (_) {
        print('not connected');
        Fluttertoast.showToast(
            msg: "No Internet Connection",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
