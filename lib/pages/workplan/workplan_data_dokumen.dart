import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/parameter_dokumen_workplan_mapping.dart';
import 'package:workplan_beta_test/model/parameter_mapping_aktifitas_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data_dokumen_take_picture.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data_dokumen_detail.dart';

MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);

class WorkplanDataDokumen extends StatefulWidget {
  final WorkplanInboxData workplan;
  final User user;
  final String title;
  final bool isMaximumUmur;

  const WorkplanDataDokumen(
      {Key? key,
      required this.workplan,
      required this.user,
      required this.title,
      required this.isMaximumUmur})
      : super(key: key);

  @override
  _WorkplanDataDokumentate createState() => _WorkplanDataDokumentate();
}

class _WorkplanDataDokumentate extends State<WorkplanDataDokumen> {
  bool loading = false;
  bool enabled = false;
  // late List<ParameterDokumen> parameterDokumenList;
  List<ParameterDokumenWorkplanMappingData> parameterDokumenWorkplanList =
      <ParameterDokumenWorkplanMappingData>[];
  List<ParameterMappingAktifitas> parameterMappingActivityList =
      <ParameterMappingAktifitas>[];

  var db = new DatabaseHelper();
  bool isOnline = false;

  @override
  void initState() {
    super.initState();

    initParameterDokumen();
    if (widget.workplan.isCheckIn == "1" &&
        (widget.workplan.progresStatusIdAlter == 2 ||
            widget.workplan.progresStatusIdAlter == 4)) {
      enabled = true;
    } else {
      enabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final photos = <File>[];
    // final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkplanData(
                    workplan: widget.workplan,
                    user: widget.user,
                    isMaximumUmur: widget.isMaximumUmur),
              ));
          return false;
        },
        child: Scaffold(
            //drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              title: Text('Dokumen'),
              centerTitle: true,
              backgroundColor: colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkplanData(
                            workplan: widget.workplan,
                            user: widget.user,
                            isMaximumUmur: widget.isMaximumUmur),
                      ));
                },
              ),
            ),
            body: loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: new Container(
                        // height: 200,
                        child: isOnline
                            ? createListViewOnline()
                            : Center(child: Text('No Internet Connection'))), //createListViewOffline()),
                  )));
  }

  void initParameterDokumen() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        loading = true;
        isOnline = true;
        ParameterDokumenWorkplanMapping parameterModel;
        var data = {
          "company_id": widget.user.userCompanyId,
          "workplan_activity_id": widget.workplan.id,
          "product_id": widget.workplan.jenisProdukId
        };

        print('data yang mau dikirim <<<<<======');
        print(data);

        var response = await RestService().restRequestService(
            SystemParam.fParameterDokumenWorkplanMapping, data);

        setState(() {
          parameterModel =
              parameterDokumenWorkplanMappingFromJson(response.body.toString());
          parameterDokumenWorkplanList = parameterModel.data;
          print('ini list nya <<<<<<=======');
          print(parameterDokumenWorkplanList);
          loading = false;
        });
      }
    } on SocketException catch (_) {
      //print('not connected');
      isOnline = false;
      db
          .getListParameterMappingActivityByProdukId(
              widget.workplan.jenisProdukId)
          .then((value) {
        setState(() {
          parameterMappingActivityList = value;
        });
      });
    }
  }

  ListView createListViewOffline() {
    // TextStyle textStyle = Theme.of(context).textTheme.subhead;
    print("parameterMappingActivityList.toString:" +
        parameterMappingActivityList.length.toString());
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: parameterMappingActivityList.length,
      itemBuilder: (BuildContext context, int index) {
        return customListItemOffline(parameterMappingActivityList[index]);
      },
    );
  }

  ListView createListViewOnline() {
    // TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: parameterDokumenWorkplanList.length,
      itemBuilder: (BuildContext context, int index) {
        return customListItemOnline(parameterDokumenWorkplanList[index]);
      },
    );
  }

  customListItemOnline(ParameterDokumenWorkplanMappingData dt) {
    print('ini data nya <<<==');
    print(dt.description);
    print(dt.mandatory);
    var color = Colors.blue;
    var icon = Ionicons.arrow_up_circle;
    var iconComplete = Icon(Icons.add_a_photo, color: color);
    //Icon( Icons.add_a_photo, color: color),

    if (dt.isUploaded == 't') {
      icon = Ionicons.checkmark_circle_sharp;
      color = colorCustom;
    }

    if (dt.countDokumen >= dt.maxphoto) {
      iconComplete = Icon(
        Icons.check_box,
        color: color,
      );
    }

    // ignore: unrelated_type_equality_checks

    return Card(
      color: Colors.white,
      elevation: 0.1,
      child: ListTile(
        leading:
            dt.mandatory ? Icon(Ionicons.alert, color: Colors.red) : Text(" "),
        title: Text(
          dt.description,
          style: TextStyle(fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconComplete,
            Icon(icon, color: color),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkplanDataDokumenDetail(
                        workplan: widget.workplan,
                        user: widget.user,
                        title: dt.description,
                        // dt: dt,
                        dokumenId: dt.documentId,
                        maxPhoto: dt.maxphoto,
                        isMaximumUmur: widget.isMaximumUmur,
                        description: dt.description,
                      )));
          // if (dt.isUploaded == 'f' && enabled) {
          //   doCapture(dt);
          // } else if(dt.isUploaded == 't') {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => WorkplanDataDokumenViewImage(
          //           parameterDokumenWorkplan: dt,
          //         )
          //       ));
          // }
        },
      ),
    );
  }

  void doCapture(ParameterDokumenWorkplanMappingData dt) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkplanDokTakePicture(
              camera: firstCamera,
              // parameterDokumenWorkplan: dt,
              workplan: widget.workplan,
              user: widget.user,
              isMaximumUmur: widget.isMaximumUmur,
              workplanDokumenId: 0,
              dokumenId: dt.documentId,
              maxPhoto: dt.maxphoto,
              description: dt.description),
        ));
  }

  customListItemOffline(ParameterMappingAktifitas dt) {
    var color = Colors.blue;
    var icon = Ionicons.arrow_up_circle;
    var iconComplete = Icon(Icons.add_a_photo, color: color);
    //Icon( Icons.add_a_photo, color: color),

    // if (dt.isUploaded == 't') {
    //   icon = Ionicons.checkmark_circle_sharp;
    //   color = colorCustom;
    // }

    // if (dt.countDokumen >= dt.maxphoto) {
    //   iconComplete = Icon(
    //     Icons.check_box,
    //     color: color,
    //   );
    // }

    // ignore: unrelated_type_equality_checks

    return Card(
      color: Colors.white,
      elevation: 0.1,
      child: ListTile(
        leading: dt.mandatoryInt == 1
            ? Icon(Ionicons.alert, color: Colors.red)
            : Text(" "),
        title: Text(
          dt.dokumenDescription,
          style: TextStyle(fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconComplete,
            Icon(icon, color: color),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkplanDataDokumenDetail(
                        workplan: widget.workplan,
                        user: widget.user,
                        title: dt.dokumenDescription,
                        // dt: dt,
                        dokumenId: dt.documentId,
                        maxPhoto: dt.maxphoto,
                        isMaximumUmur: widget.isMaximumUmur,
                        description: dt.dokumenDescription,
                      )));
        },
      ),
    );
  }
}
