import 'dart:async';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/dropdown_item.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/parameter_udf_model.dart';
import 'package:workplan_beta_test/model/parameter_udf_option_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/visit_checkin_log_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_list.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_visit_list.dart';

class WorkplanView extends StatefulWidget {
  final WorkplanInboxData workplan;
  final User user;
  final bool isMaximumUmur;

  const WorkplanView(
      {Key? key,
      required this.workplan,
      required this.user,
      required this.isMaximumUmur})
      : super(key: key);
  @override
  _WorkplanViewState createState() => _WorkplanViewState();
}

class _WorkplanViewState extends State<WorkplanView> {
  MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);
  final _keyForm = GlobalKey<FormState>();
  DatabaseHelper db = new DatabaseHelper();
  bool loading = false;
  var _udfDateValue = "";

  TextEditingController _udfTextA1Ctr = TextEditingController();
  //  TextEditingController _udfTextA1Ctr = TextEditingController();
  TextEditingController _udfText2Ctr = TextEditingController();
  TextEditingController _udfNum1Ctr = TextEditingController();
  String labelUdfTextA1 = "UDF Text A1";
  String labelUdfTextA2 = "UDF Text A2";
  String labelUdfNumA1 = "UDF Num A1";
  String labelUdfDateA1 = "UDF Date A1";
  String labelUdfDdlA1 = "UDF DDL A1";
  int udfDDLA1 = 0;
  final bool withAsterisk = true;

  late List<ParameterUdfOption> parameterUdfOption1List;
  List<DropdownMenuItem<int>> itemsParameterUdfOption1 =
      <DropdownMenuItem<int>>[];
  int parameterUdfOption1Value = SystemParam.defaultValueOptionId;
  // SessionTimer sessionTimer = new SessionTimer();

  @override
  void initState() {
    super.initState();

    // sessionTimer().userActivityDetected(context,widget.user);
    getLableUdf();
    checkInTimeOutNotification();

    _udfTextA1Ctr.text = widget.workplan.udfText1;
    _udfText2Ctr.text = widget.workplan.udfText2;
    // ignore: unnecessary_null_comparison
    if (widget.workplan.udfNum1 != null) {
      _udfNum1Ctr.text = widget.workplan.udfNum1.toString();
    }

    // Timer.periodic(Duration(minutes: 1), (Timer timer) {
    //     //checkInTimeOutNotification();

    //   });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // sessionTimer.userActivityDetected(context, widget.user);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkplanList(user: widget.user)));
          return false;
        },
        child: Scaffold(
            //drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              title: Text('View Task'),
              centerTitle: true,
              backgroundColor: colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WorkplanList(user: widget.user)));
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _keyForm,
                    // autovalidate: false,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration:
                                  new BoxDecoration(color: Colors.white30),
                              height: 50,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "View Master Task",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: colorCustom,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'No Task',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              initialValue: widget.workplan.nomorWorkplan,
                              readOnly: true,
                              enabled: false,
                              // validator: validasiUsername,
                              onSaved: (em) {
                                if (em != null) {}
                              },
                              decoration: InputDecoration(
                                //icon: new Icon(Ionicons.document_outline),
                                fillColor: colorCustom,
                                //labelText: "No Workplan",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.italic),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Progress',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              initialValue:
                                  widget.workplan.progresStatusDescription,
                              readOnly: true,
                              enabled: false,
                              // validator: validasiUsername,
                              onSaved: (em) {
                                if (em != null) {}
                              },
                              decoration: InputDecoration(
                                //icon: new Icon(Ionicons.create_outline),
                                fillColor: colorCustom,
                                //labelText: "Progress",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Jenis Aktifitas',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              initialValue: widget.workplan.activityDescription,
                              readOnly: true,
                              enabled: false,
                              // validator: validasiUsername,
                              onSaved: (em) {
                                if (em != null) {}
                              },
                              decoration: InputDecoration(
                                //icon: new Icon(Ionicons.bookmark_outline),
                                fillColor: colorCustom,
                                //labelText: "Jenis Aktifitas",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Nama',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              initialValue: widget.workplan.fullName,
                              readOnly: false,
                              enabled: false,
                              // validator: validasiUsername,
                              onSaved: (em) {
                                if (em != null) {}
                              },
                              decoration: InputDecoration(
                                //icon: new Icon(Ionicons.person),
                                fillColor: colorCustom,
                                //labelText: "Nama",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'No HP',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: new TextStyle(color: Colors.black),
                              initialValue: widget.workplan.phone,
                              readOnly: false,
                              enabled: false,
                              // validator: validasiUsername,
                              onSaved: (em) {
                                if (em != null) {}
                              },
                              decoration: InputDecoration(
                                //icon: new Icon(Ionicons.phone_portrait),
                                fillColor: Colors.black,
                                //labelText: "No. HP",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration:
                                  new BoxDecoration(color: Colors.white30),
                              height: 50,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Alamat Usaha",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: colorCustom,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Nama Lokasi',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              initialValue: widget.workplan.location,
                              readOnly: false,
                              enabled: false,
                              // validator: validasiUsername,
                              onSaved: (em) {
                                if (em != null) {}
                              },
                              decoration: InputDecoration(
                                //icon: new Icon(Ionicons.location),
                                fillColor: colorCustom,
                                //labelText: "Nama Lokasi",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Alamat',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              initialValue: widget.workplan.alamat,
                              readOnly: false,
                              enabled: false,
                              // validator: validasiUsername,
                              onSaved: (em) {
                                if (em != null) {}
                              },
                              decoration: InputDecoration(
                                //icon: new Icon(Ionicons.home),
                                fillColor: colorCustom,
                                //labelText: "Alamat",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Kelurahan',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              initialValue: widget.workplan.kelurahan,
                              readOnly: false,
                              enabled: false,
                              // validator: validasiUsername,
                              onSaved: (em) {
                                if (em != null) {}
                              },
                              decoration: InputDecoration(
                                //icon: new Icon(Ionicons.home_sharp),
                                fillColor: colorCustom,
                                //labelText: "Kelurahan",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Kecamatan',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              initialValue: widget.workplan.kecamatan,
                              readOnly: false,
                              enabled: false,
                              // validator: validasiUsername,
                              onSaved: (em) {
                                if (em != null) {}
                              },
                              decoration: InputDecoration(
                                //icon: new Icon(Ionicons.home_sharp),
                                fillColor: colorCustom,
                                //labelText: "Kecamatan",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Kodya/ Kabupaten',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              enabled: false,
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              initialValue: widget.workplan.kabupaten,
                              readOnly: false,
                              // validator: validasiUsername,
                              onSaved: (em) {
                                if (em != null) {}
                              },
                              decoration: InputDecoration(
                                //icon: new Icon(Ionicons.home_sharp),
                                fillColor: colorCustom,
                                //labelText: "Kodya/ Kabupaten",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Kode Pos',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              initialValue: widget.workplan.kodepos,
                              readOnly: false,
                              enabled: false,
                              // validator: validasiUsername,
                              onSaved: (em) {
                                if (em != null) {}
                              },
                              decoration: InputDecoration(
                                //icon: new Icon(Ionicons.document),
                                fillColor: colorCustom,
                                //labelText: "Kode Pos",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Rencana Kunjungan',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DateTimeField(
                              enabled: false,
                              format: SystemParam.formatDateDisplay,
                              initialValue:
                                  widget.workplan.rencanaKunjungan == null
                                      ? null
                                      : widget.workplan.rencanaKunjungan,
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate:
                                        widget.workplan.rencanaKunjungan == null
                                            ? null
                                            : widget.workplan.rencanaKunjungan!,
                                    lastDate: DateTime(2100));

                                // if (date != null) {
                                //   final time = await showTimePicker(
                                //     context: context,
                                //     initialTime: TimeOfDay.fromDateTime(
                                //         currentValue ?? DateTime.now()),
                                //   );
                                //   return DateTimeField.combine(date, time);
                                // } else {
                                return date;
                                //}
                              },
                              decoration: InputDecoration(
                                suffixIcon: new Icon(Icons.date_range),
                                fillColor: colorCustom,
                                //labelText: "Rencana Kunjungan 1",
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.italic),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '$labelUdfTextA1',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? ' ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              enabled: false,
                              controller: _udfTextA1Ctr,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              //initialValue: widget.workplanInboxData.kodepos,
                              readOnly: false,
                              //validator: requiredValidator,
                              onSaved: (em) {
                                //if (em != null) {}
                              },
                              decoration: InputDecoration(
                                // icon: new Icon(Ionicons.document),
                                fillColor: colorCustom,
                                // //labelText: labelUdfTextA1,
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '$labelUdfTextA2',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              enabled: false,
                              controller: _udfText2Ctr,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              style: new TextStyle(color: Colors.black),
                              //initialValue: widget.workplanInboxData.kodepos,
                              readOnly: false,
                              //validator: requiredValidator,
                              onSaved: (em) {
                                //if (em != null) {}
                              },
                              decoration: InputDecoration(
                                // icon: new Icon(Ionicons.document),
                                fillColor: colorCustom,
                                // //labelText: labelUdfTextA2,
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '$labelUdfNumA1',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              enabled: false,
                              controller: _udfNum1Ctr,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              style: new TextStyle(color: Colors.black),
                              //initialValue: widget.workplanInboxData.kodepos,
                              readOnly: false,
                              //validator: requiredValidator,
                              onSaved: (em) {
                                //if (em != null) {}
                              },
                              decoration: InputDecoration(
                                // icon: new Icon(Ionicons.document),
                                fillColor: colorCustom,
                                // //labelText: labelUdfNumA1,
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.normal),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '$labelUdfDateA1',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DateTimeField(
                              enabled: false,
                              initialValue: widget.workplan.udfDate1 == null
                                  ? null
                                  : widget.workplan.udfDate1,
                              autovalidateMode: AutovalidateMode.always,
                              onSaved: (valueDate) {
                                _udfDateValue = SystemParam.formatDateValue
                                    .format(valueDate!);
                              },
                              onChanged: (valueDate) {
                                _udfDateValue = SystemParam.formatDateValue
                                    .format(valueDate!);
                              },
                              format: SystemParam.formatDateDisplay,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2010),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                              decoration: InputDecoration(
                                suffixIcon: new Icon(Icons.date_range),
                                fillColor: colorCustom,
                                // //labelText: labelUdfDateA1,
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.italic),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '$labelUdfDdlA1',
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: colorCustom,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  TextSpan(
                                      text: withAsterisk ? '  ' : ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),

                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                //suffixIcon: new Icon(Icons.date_range),
                                fillColor: colorCustom,
                                // //labelText: labelUdfDdlA1,
                                labelStyle: TextStyle(
                                    color: colorCustom,
                                    fontStyle: FontStyle.italic),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorCustom),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.all(10),
                              ),
                              value: parameterUdfOption1Value,
                              items: itemsParameterUdfOption1,
                              onChanged: null,
                              // onChanged: (object) {
                              //   setState(() {
                              //     parameterUdfOption1Value = object!;
                              //   });
                              // },
                            ),
                            // )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    primary: colorCustom),
                                child: Text("VISIT ACTIVITY"),
                                onPressed: () {
                                  // sessionTimer.userActivityDetected(context, widget.user);
                                  //prosesSave(empUpd);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WorkplanVisitList(
                                            workplan: widget.workplan,
                                            user: widget.user,
                                            isMaximumUmur:
                                                widget.isMaximumUmur),
                                      ));
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    primary: colorCustom),
                                child: Text("DATA TASK"),
                                onPressed: () {
                                  // showSimpleNotification(
                                  //   Text("Anda telah melampaui batas waktu kunjungan workplan, Simpan segera selesaikan aktifitas Anda dan lakukan check out"),
                                  //   background: WorkplanPallete.green,
                                  //   position: NotificationPosition.bottom
                                  // );
                                  // sessionTimer.userActivityDetected(context, widget.user);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WorkplanData(
                                            user: widget.user,
                                            workplan: widget.workplan,
                                            isMaximumUmur:
                                                widget.isMaximumUmur),
                                      ));
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  void initParameterUdfOption1(int udfDDLA1) async {
    loading = true;
    ParameterUdfOptionModel parameterModel;
    var data = {"company_id": widget.user.userCompanyId, "udf_id": udfDDLA1};

    var response = await RestService()
        .restRequestService(SystemParam.fParameterUdfOption1, data);

    setState(() {
      parameterModel =
          parameterUdfOptionModelFromJson(response.body.toString());
      parameterUdfOption1List = parameterModel.data;
      itemsParameterUdfOption1.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < parameterUdfOption1List.length; i++) {
        itemsParameterUdfOption1.add(DropdownItem.getItemParameter(
            parameterUdfOption1List[i].id,
            parameterUdfOption1List[i].optionDescription));
      }
      loading = false;
    });
  }

  void getLableUdf() async {
    Future<ParameterUdf> parameterUdfTextA1 =
        db.getParameterUdfByName(labelUdfTextA1);
    parameterUdfTextA1.then((data) {
      setState(() {
        labelUdfTextA1 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfTextA2 =
        db.getParameterUdfByName(labelUdfTextA2);
    parameterUdfTextA2.then((data) {
      setState(() {
        labelUdfTextA2 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfNumA2 =
        db.getParameterUdfByName(labelUdfNumA1);
    parameterUdfNumA2.then((data) {
      setState(() {
        labelUdfNumA1 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfDateA1 =
        db.getParameterUdfByName(labelUdfDateA1);
    parameterUdfDateA1.then((data) {
      setState(() {
        labelUdfDateA1 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfDdlA1 =
        db.getParameterUdfByName(labelUdfDdlA1);
    parameterUdfDdlA1.then((data) {
      setState(() {
        labelUdfDdlA1 = data.udfDescription;
        udfDDLA1 = data.id;
        // initParameterUdfOption1(udfDDLA1);
        initParameterUdfOptionDB(udfDDLA1);
      });
    });
  }

  void notification(context) {
    showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: SafeArea(
          child: ListTile(
            leading: SizedBox.fromSize(
                size: const Size(40, 40),
                child: ClipOval(
                    child: Container(
                  color: Colors.black,
                ))),
            //title: Text('Batas Waktu Kunjungan'),
            subtitle: Text(
                'Anda telah melampaui batas waktu kunjungan workplan, Simpan segera selesaikan aktifitas Anda dan lakukan check out'),
            trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  OverlaySupportEntry.of(context)!.dismiss();
                }),
          ),
        ),
      );
    }, duration: Duration(milliseconds: 4000));
  }

  void initParameterUdfOptionDB(udfDDLA1s) async {
    db.getParameterUdfOption1ByUdfId(udfDDLA1s).then((value) {
      setState(() {
        loading = true;
        parameterUdfOption1List = <ParameterUdfOption>[];
        itemsParameterUdfOption1.clear();
        parameterUdfOption1List = value;

        itemsParameterUdfOption1.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));

        for (var i = 0; i < parameterUdfOption1List.length; i++) {
          itemsParameterUdfOption1.add(DropdownItem.getItemParameter(
              parameterUdfOption1List[i].id,
              parameterUdfOption1List[i].optionDescription));
          if (widget.workplan.udfOpt1 != null &&
              parameterUdfOption1List[i].id == widget.workplan.udfOpt1) {
            parameterUdfOption1Value = widget.workplan.udfOpt1;
          }
        }

        if (widget.workplan.udfOpt1 != null &&
            parameterUdfOption1List.contains(widget.workplan.udfOpt1)) {
          parameterUdfOption1Value = widget.workplan.udfOpt1;
        }

        loading = false;
      });
    });
  }

  Future<void> checkInTimeOutNotification() async {
    var now = DateTime.now();
    await db
        .getVisitCheckInLogListByNoWorkplan(widget.workplan.nomorWorkplan)
        .then((vl) {
      print('ini value checkintimeoutnotification <<<<==========');
      print(vl);
      setState(() {
        List<VisitChecInLog> vlData = vl;
        for (var i = 0; i < vlData.length; i++) {
          print(vlData[i].batasWaktu);
          print(vlData[i].checkInBatas);
          if (vlData[i].batasWaktu < 999) {
            var checkInBatas = DateTime.parse(vlData[i].checkInBatas);
            if (now.isAfter(checkInBatas)) {
              //print("notif timeout");
              notification(context);
            }
          } else {
            print('batas check in tidak di tentukan');
          }
        }
      });
    });
  }
}
