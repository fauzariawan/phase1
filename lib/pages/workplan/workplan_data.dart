import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data_personal.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data_produk.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data_udf.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_view.dart';

import 'workplan_data_dokumen.dart';
import 'workplan_data_decision.dart';

MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);

class WorkplanData extends StatefulWidget {
  final WorkplanInboxData workplan;
  final User user;
  final bool isMaximumUmur;
  

  const WorkplanData(
      {Key? key,
      required this.workplan,
      required this.user,
      required this.isMaximumUmur})
      : super(key: key);
  @override
  _WorkplanDataState createState() => _WorkplanDataState();
}

class _WorkplanDataState extends State<WorkplanData> {
  late final Color? color;
  late WorkplanInboxData _wrk;
  bool loading = false;
  DatabaseHelper db = new DatabaseHelper();
  // SessionTimer sessionTimer = new SessionTimer();
  @override
  void initState() {
    super.initState();
    _wrk = widget.workplan;
    getWorkplanById();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        // //sessionTimer.userActivityDetected(context, widget.user);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkplanView(
                user: widget.user,
                workplan: _wrk,
                isMaximumUmur: widget.isMaximumUmur,
              ),
            ));
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Data Task'),
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
                        workplan: _wrk,
                        isMaximumUmur: widget.isMaximumUmur,
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
                  child: Column(
                    children: [
                      _wrk.flag == 0
                          ? Container(
                              child: Text(""),
                            )
                          : Card(
                              color: Colors.white,
                              //elevation: 2.0,
                              child: ListTile(
                                leading: Image.asset(
                                  "images/personal.png",
                                ),
                                title: Text(
                                  "Personal",
                                  style: TextStyle(fontSize: 16),
                                ),
                                subtitle: Text("Data Personal"),
                                trailing: Icon(Ionicons.arrow_down_circle,
                                    color: colorCustom),
                                onTap: () {
                                  // //sessionTimer.userActivityDetected(context, widget.user);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WorkplanDataPersonal(
                                                workplan: _wrk,
                                                user: widget.user,
                                                isMaximumUmur:
                                                    widget.isMaximumUmur),
                                      ));
                                },
                              ),
                            ),
                      Card(
                        color: Colors.white,
                        //elevation: 2.0,
                        child: ListTile(
                          leading: Image.asset(
                            "images/produk.png",
                          ),
                          title: Text(
                            "Produk",
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text("Data Produk"),
                          trailing: Icon(Ionicons.arrow_down_circle,
                              color: colorCustom),
                          onTap: () {
                            // //sessionTimer.userActivityDetected(context, widget.user);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkplanDataProduk(
                                      workplan: _wrk,
                                      user: widget.user,
                                      isMaximumUmur: widget.isMaximumUmur),
                                ));
                          },
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        //elevation: 2.0,
                        child: ListTile(
                          leading: Image.asset(
                            "images/dokumen.png",
                          ),
                          title: Text(
                            "Dokumen",
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text("Data Dokumen"),
                          trailing: Icon(Ionicons.arrow_down_circle,
                              color: colorCustom),
                          onTap: () {
                            //sessionTimer.userActivityDetected(context, widget.user);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkplanDataDokumen(
                                      workplan: _wrk,
                                      user: widget.user,
                                      title: "Dokumen",
                                      isMaximumUmur: widget.isMaximumUmur),
                                ));
                          },
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        //elevation: 2.0,
                        child: ListTile(
                          leading: Image.asset(
                            "images/dokumen.png",
                          ),
                          title: Text(
                            "UDF",
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text("User Define Field"),
                          trailing: Icon(Ionicons.arrow_down_circle,
                              color: colorCustom),
                          onTap: () {
                            //sessionTimer.userActivityDetected(context, widget.user);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkplanDataUdf(
                                      workplan: _wrk,
                                      user: widget.user,
                                      isMaximumUmur: widget.isMaximumUmur),
                                ));
                          },
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        //elevation: 2.0,
                        child: ListTile(
                          leading: Image.asset(
                            "images/keputusan.png",
                          ),
                          title: Text(
                            "Keputusan",
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text("Data Keputusan"),
                          trailing: Icon(Ionicons.arrow_down_circle,
                              color: colorCustom),
                          onTap: () {
                            //sessionTimer.userActivityDetected(context, widget.user);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkplanDataDecision(
                                      workplan: _wrk,
                                      user: widget.user,
                                      isMaximumUmur: widget.isMaximumUmur),
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                )));

  void getWorkplanById() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        loading = true;
        var data = {
          "id": widget.workplan.id,
        };

        var response = await RestService()
            .restRequestService(SystemParam.fWorkplanById, data);

        setState(() {
          WorkplanInboxModel wi = workplanInboxFromJson(response.body.toString());
          _wrk = wi.data[0];
          loading = false;
        });
      }else{
        
      }
    } on SocketException catch (_) {
      print('not connected');
       db.getWorkplanById(widget.workplan.id.toString()).then((value) {
      setState(() {
        _wrk = value;
      });
      
    });
    }
  }
}

class Choice {
  const Choice(
      {required this.title,
      required this.icon,
      required this.title2,
      required MaterialColor color});

  final String title;
  final String title2;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(
      title: 'INBOX', title2: '', icon: Icons.inbox, color: Colors.green),
  const Choice(
      title: 'LIST WORKPLAN',
      title2: '',
      icon: Icons.check_circle,
      color: Colors.green),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard(
      {Key? key,
      required this.choice,
      required this.onTap,
      required this.item,
      this.selected: false})
      : super(key: key);

  final Choice choice;
  final VoidCallback onTap;
  final Choice item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    // TextStyle? textStyle = Theme.of(context).textTheme.display1;

    // if (selected)
    // textStyle = textStyle!.copyWith(color: Colors.lightGreenAccent[400]);
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Card(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.topLeft,
                  child: Icon(choice.icon,
                      size: 80.0, color: Colors.lightGreenAccent[400])),
              new Expanded(
                child: new Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    choice.title,
                    semanticsLabel: choice.title2,
                    style: null,
                    textAlign: TextAlign.left,
                    maxLines: 5,
                  ),
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )),
    );
  }
}
