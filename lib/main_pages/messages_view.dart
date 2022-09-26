import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/notice_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/main_pages/constans.dart';

import 'landingpage_view.dart';

class NoticesView extends StatefulWidget {
  final User user;
  const NoticesView({Key? key, required this.user}) : super(key: key);

  @override
  _NoticesViewState createState() => _NoticesViewState();
}

class _NoticesViewState extends State<NoticesView> {
  var db = new DatabaseHelper();
  List<Notice> noticeList = <Notice>[];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    // userNotice();
    initNotice();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          //  Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingPage(user: widget.user)));
          return false;
        },
        child: Scaffold(
            //drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              title: Text('Pesan'),
              centerTitle: true,
              backgroundColor: SystemParam.colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LandingPage(user: widget.user,)));
                },
              ),
            ),
            body: loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: new Container(
                        child: createListViewNotice(),
                      ),
                    ),
                  ))));
  }

  void initNotice() {
    loading = true;
    Future<List<Notice>> messageFuture =
        db.getNoticeListByMediaTypeCode(SystemParam.mediaTypeCode);
    messageFuture.then((value) {
      setState(() {
        noticeList = value;
        db.updateNoticeListRead(noticeList);

        updateNoticeListRead(noticeList);
      });
    });
    loading = false;
  }

  ListView createListViewNotice() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: noticeList.length,
      itemBuilder: (BuildContext context, int index) {
        return getNoticeListTile(
          noticeList[index],
        );
      },
    );
  }

  getNoticeListTile(Notice dt) {
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
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        dt.noticeBody == null ? " " : "" + dt.noticeBody,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "" + dt.createdName == null
                            ? " "
                            : " " + dt.createdName,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )),
            )),
      ),
    );
  }

  void userNotice() async {
    loading = true;

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
    print(convertDataToJson);
    var code = convertDataToJson['code'];
    if (code == "0") {
      db.deleteNotice();
      NoticeModel noticeModel = noticeModelFromJson(response.body.toString());
      List<Notice> noticeList2 = noticeModel.data;

      for (var i = 0; i < noticeList2.length; i++) {
        db.insertNotice(noticeList2[i]);
      }
    }

    loading = false;
  }

  void updateNoticeListRead(List<Notice> noticeList) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        String ids = "";
        for (var i = 0; i < noticeList.length; i++) {
          if (ids == "") {
            ids += noticeList[i].id.toString();
          } else {
            ids += "," + noticeList[i].id.toString();
          }
        }

        // print("ids:" + ids);
        var data = {"ids": ids};

        var response = await RestService()
            .restRequestService(SystemParam.fNoticeUpdateRead, data);
        var convertDataToJson = json.decode(response.body);
        print(convertDataToJson);
        var code = convertDataToJson['code'];
        if (code == "0") {
          print("ok");
        }
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }
}
