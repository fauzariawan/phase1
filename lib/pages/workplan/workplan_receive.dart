import 'dart:convert';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/dropdown_item.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/parameter_udf_model.dart';
import 'package:workplan_beta_test/model/parameter_udf_option_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_inbox.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_list.dart';
import 'package:workplan_beta_test/widget/warning.dart';

class WorkplanInboxReceive extends StatefulWidget {
  final WorkplanInboxData workplanInboxData;
  final User user;
  const WorkplanInboxReceive(
      {Key? key, required this.workplanInboxData, required this.user})
      : super(key: key);

  @override
  _WorkplanInboxReceiveState createState() => _WorkplanInboxReceiveState();
}

class _WorkplanInboxReceiveState extends State<WorkplanInboxReceive> {
  late WorkplanInboxData _wi;
  MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);
  final _keyForm = GlobalKey<FormState>();
  bool loading = false;
  var progresStatusId = 1;
  // var progresStatusIdReal=1;

  TextEditingController _jenisAktifitasController = TextEditingController();
  TextEditingController _nameCtr = TextEditingController();
  TextEditingController _noHpCtr = TextEditingController();
  TextEditingController _alamatUsahaCtr = TextEditingController();
  TextEditingController _namaLokasiCtr = TextEditingController();
  TextEditingController _kecamatanCtr = TextEditingController();
  TextEditingController _kabupatenCtr = TextEditingController();
  TextEditingController _kodeposCtr = TextEditingController();
  TextEditingController _kelurahanCtr = TextEditingController();
  TextEditingController _udfText1Ctr = TextEditingController();
  TextEditingController _udfText2Ctr = TextEditingController();
  TextEditingController _udfNum1Ctr = TextEditingController();
  var _rencanaKunjunganValue = "";
  var _udfDateValue = "";
  // var _udfOptValue = '1';

  late List<ParameterUdfOption> parameterUdfOption1List;
  List<DropdownMenuItem<int>> itemsParameterUdfOption1 =
      <DropdownMenuItem<int>>[];
  int parameterUdfOption1Value = SystemParam.defaultValueOptionId;
  DatabaseHelper db = new DatabaseHelper();
  String labelUdfTextA1 = "UDF Text A1";
  String labelUdfTextA2 = "UDF Text A2";
  String labelUdfNumA1 = "UDF Num A1";
  String labelUdfDateA1 = "UDF Date A1";
  String labelUdfDdlA1 = "UDF DDL A1";
  int udfDDLA1 = 0;
  //  SessionTimer sessionTimer = new SessionTimer();

  @override
  void initState() {
    super.initState();

    // SessionTimer().userActivityDetected(context,widget.user);
    _wi = widget.workplanInboxData;
    _jenisAktifitasController.text =
        widget.workplanInboxData.activityDescription;
    _nameCtr.text = widget.workplanInboxData.fullName;
    _noHpCtr.text = widget.workplanInboxData.phone;
    _alamatUsahaCtr.text = widget.workplanInboxData.alamat;
    _namaLokasiCtr.text = widget.workplanInboxData.location;
    _kecamatanCtr.text = widget.workplanInboxData.kecamatan;
    _kabupatenCtr.text = widget.workplanInboxData.kabupaten;
    _kodeposCtr.text = widget.workplanInboxData.kodepos;
    _kelurahanCtr.text = widget.workplanInboxData.kelurahan;

    _udfText1Ctr.text = widget.workplanInboxData.udfText1;
    _udfText2Ctr.text = widget.workplanInboxData.udfText2;
    //_rencanaKunjunganValue = widget.workplanInboxData.rencanaKunjungan;
    if (widget.workplanInboxData.rencanaKunjungan != null) {
      _rencanaKunjunganValue = SystemParam.formatDateValue
          .format(widget.workplanInboxData.rencanaKunjungan);
    }

    // ignore: unnecessary_null_comparison
    if (widget.workplanInboxData.udfNum1 != null) {
      _udfNum1Ctr.text = widget.workplanInboxData.udfNum1.toString();
    }

    getLableUdf();
    // initParameterUdfA1();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkplanInboxPage(user: widget.user),
              ));
          return false;
        },
        child: Scaffold(
            //drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              title: Text('Update Master Task'),
              centerTitle: true,
              backgroundColor: colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  // sessionTimer.userActivityDetected(context, widget.user);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WorkplanInboxPage(user: widget.user),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    decoration: new BoxDecoration(
                                        color: Colors.white30),
                                    height: 50,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "Update Master Task",
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    // controller: ,
                                    enableInteractiveSelection: false,
                                    focusNode: FocusNode(),
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    style: new TextStyle(color: Colors.black),
                                    initialValue:
                                        widget.workplanInboxData.nomorWorkplan,
                                    readOnly: true,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.document_outline),
                                      fillColor: colorCustom,
                                      enabled: false,
                                      labelText: "No Task",
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.italic),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    style: new TextStyle(color: Colors.black),
                                    initialValue: "",
                                    readOnly: true,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.create_outline),
                                      fillColor: colorCustom,
                                      labelText: "Progress",
                                      enabled: false,
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _jenisAktifitasController,
                                    autovalidateMode: AutovalidateMode.always,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    style: new TextStyle(color: Colors.black),
                                    //initialValue: widget.workplanInboxData.fullName,
                                    readOnly: true,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.person),
                                      fillColor: colorCustom,
                                      labelText: "Jenis Aktifitas",
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _nameCtr,
                                    autovalidateMode: AutovalidateMode.always,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    style: new TextStyle(color: Colors.black),
                                    //initialValue: widget.workplanInboxData.fullName,
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.person),
                                      fillColor: colorCustom,
                                      labelText: "Nama",
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _noHpCtr,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: new TextStyle(color: Colors.black),
                                    // initialValue: widget.workplanInboxData.phone,
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.phone_portrait),
                                      fillColor: Colors.black,
                                      labelText: "No. HP",
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _namaLokasiCtr,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    style: new TextStyle(color: Colors.black),
                                    //initialValue: widget.workplanInboxData.location,
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.location),
                                      fillColor: colorCustom,
                                      labelText: "Nama Lokasi",
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _alamatUsahaCtr,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    style: new TextStyle(color: Colors.black),
                                    //initialValue: widget.workplanInboxData.alamat,
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.home),
                                      fillColor: colorCustom,
                                      labelText: "Alamat",
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _kelurahanCtr,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    style: new TextStyle(color: Colors.black),
                                    //initialValue: "",
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.home_sharp),
                                      fillColor: colorCustom,
                                      labelText: "Kelurahan",
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _kecamatanCtr,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    style: new TextStyle(color: Colors.black),
                                    // initialValue: widget.workplanInboxData.kecamatan,
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.home_sharp),
                                      fillColor: colorCustom,
                                      labelText: "Kecamatan",
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _kabupatenCtr,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    style: new TextStyle(color: Colors.black),
                                    // initialValue: widget.workplanInboxData.kabupaten,
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.home_sharp),
                                      fillColor: colorCustom,
                                      labelText: "Kodya/Kabupaten",
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _kodeposCtr,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: new TextStyle(color: Colors.black),
                                    // initialValue: widget.workplanInboxData.kodepos,
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.document),
                                      fillColor: colorCustom,
                                      labelText: "Kode Pos",
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DateTimeField(
                                    initialValue: widget.workplanInboxData
                                                .rencanaKunjungan ==
                                            null
                                        ? null
                                        : widget
                                            .workplanInboxData.rencanaKunjungan,
                                    autovalidateMode: AutovalidateMode.always,
                                    onSaved: (valueDate) {
                                      _rencanaKunjunganValue = SystemParam
                                          .formatDateValue
                                          .format(valueDate!);
                                    },
                                    onChanged: (valueDate) {
                                      _rencanaKunjunganValue = SystemParam
                                          .formatDateValue
                                          .format(valueDate!);
                                    },
                                    format: SystemParam.formatDateDisplay,
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          locale: Locale('id'),
                                          firstDate:
                                              DateTime(SystemParam.firstDate),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate:
                                              DateTime(SystemParam.lastDate),
                                          fieldHintText:
                                              SystemParam.strFormatDateHint);
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: new Icon(Icons.date_range),
                                      fillColor: colorCustom,
                                      labelText: "Rencana Kunjungan 1",
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.italic),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
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
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: colorCustom,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                        TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _udfText1Ctr,
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
                                      // labelText: labelUdfTextA1,
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
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
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: colorCustom,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                        TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
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
                                      // labelText: labelUdfTextA2,
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
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
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: colorCustom,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                        TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _udfNum1Ctr,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: new TextStyle(color: Colors.black),
                                    //initialValue: widget.workplanInboxData.kodepos,
                                    readOnly: false,
                                    //validator: requiredValidator,
                                    onSaved: (em) {
                                      //if (em != null) {}
                                    },
                                    maxLength: 15,
                                    decoration: InputDecoration(
                                      // icon: new Icon(Ionicons.document),
                                      fillColor: colorCustom,
                                      // labelText: labelUdfNumA1,
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
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
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: colorCustom,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                        TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DateTimeField(
                                    autovalidateMode: AutovalidateMode.always,
                                    onSaved: (valueDate) {
                                      _udfDateValue = SystemParam
                                          .formatDateValue
                                          .format(valueDate!);
                                    },
                                    onChanged: (valueDate) {
                                      _udfDateValue = SystemParam
                                          .formatDateValue
                                          .format(valueDate!);
                                    },
                                    format: SystemParam.formatDateDisplay,
                                    // initialValue: ,
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          locale: Locale('id'),
                                          firstDate:
                                              DateTime(SystemParam.firstDate),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate:
                                              DateTime(SystemParam.lastDate),
                                          fieldHintText:
                                              SystemParam.strFormatDateHint);
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: new Icon(Icons.date_range),
                                      fillColor: colorCustom,
                                      // labelText: labelUdfDateA1,
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.italic),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
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
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: colorCustom,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                        TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                backgroundColor: Theme.of(
                                                        context)
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
                                      // labelText: labelUdfDdlA1,
                                      labelStyle: TextStyle(
                                          color: colorCustom,
                                          fontStyle: FontStyle.italic),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorCustom),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                    value: parameterUdfOption1Value,
                                    items: itemsParameterUdfOption1,
                                    onChanged: (object) {
                                      setState(() {
                                        parameterUdfOption1Value = object!;
                                      });
                                    },
                                  ),
                                  // )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      child: Text("TERIMA"),
                                      onPressed: () {
                                        saveData();

                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) => WorkplanList(
                                        //         user: widget.user,
                                        //       ),
                                        //     ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: colorCustom,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      // color: colorCustom,
                                      // textColor: Colors.white,
                                      //color: Colors.white20,
                                      //color: Colors.white20[500],
                                      // textColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )));
  }

  void saveData() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        saveDataOnline();
      }
    } on SocketException catch (_) {
      Warning.showWarning("No Internet Connection");
    }
  }

  void initParameterUdfA1() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        loading = true;
        ParameterUdfOptionModel parameterModel;
        var data = {
          "company_id": widget.user.userCompanyId,
          "udf_id": udfDDLA1
        };

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
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  void initParameterUdfOptionDB() async {
    db.getParameterUdfOption1ByUdfId(udfDDLA1).then((value) {
      setState(() {
        loading = true;
        parameterUdfOption1List = value;
        itemsParameterUdfOption1.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < parameterUdfOption1List.length; i++) {
          itemsParameterUdfOption1.add(DropdownItem.getItemParameter(
              parameterUdfOption1List[i].id,
              parameterUdfOption1List[i].optionDescription));
        }
        loading = false;

        if (widget.workplanInboxData.udfOpt1 != null &&
            parameterUdfOption1List
                .contains(widget.workplanInboxData.udfOpt1)) {
          parameterUdfOption1Value = widget.workplanInboxData.udfOpt1;
        }
      });
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
        // initParameterUdfA1();
        initParameterUdfOptionDB();
      });
    });
  }

  void saveDataOnline() async {
    var data = {
      "id": _wi.id,
      "progres_status_id": progresStatusId,
      "distribusi_workplan_id": _wi.distribusiWorkplanId,
      "activity_id": _wi.activityId,
      "full_name": _nameCtr.text,
      "phone": _noHpCtr.text,
      "location": _namaLokasiCtr.text,
      "alamat": _alamatUsahaCtr.text,
      "rencana_kunjungan": _rencanaKunjunganValue,
      "user_id": widget.user.id,
      "nomor_workplan": _wi.nomorWorkplan,
      "kecamatan": _kecamatanCtr.text,
      "kabupaten": _kabupatenCtr.text,
      "kelurahan": _kelurahanCtr.text,
      "kodepos": _kodeposCtr.text,
      "updated_by": widget.user.id,
      "udf_text1": _udfText1Ctr.text,
      "udf_text2": _udfText2Ctr.text,
      "udf_num1": _udfNum1Ctr.text,
      "udf_opt1": parameterUdfOption1Value,
      "udf_date1": _udfDateValue,
      "company_id": widget.user.userCompanyId,
      // "progres_status_id_real": progresStatusIdReal,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fWorkplanInboxUpdate, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];

    if (code == "0") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WorkplanList(user: widget.user)));
    } else {
      Fluttertoast.showToast(
          msg: status,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void saveDataOffline() async {
    int udfNum1 = 0;
    if (_udfNum1Ctr != null && _udfNum1Ctr.text != "") {
      udfNum1 = int.parse(_udfNum1Ctr.text);
    }
    _wi.progresStatusId = progresStatusId;
    _wi.phone = _noHpCtr.text;
    _wi.location = _namaLokasiCtr.text;
    _wi.alamat = _alamatUsahaCtr.text;
    _wi.rencanaKunjungan = _rencanaKunjunganValue;
    _wi.kecamatan = _kecamatanCtr.text;
    _wi.kabupaten = _kabupatenCtr.text;
    _wi.kelurahan = _kelurahanCtr.text;
    _wi.kodepos = _kodeposCtr.text;
    _wi.udfText1 = _udfText1Ctr.text;
    _wi.udfText2 = _udfText2Ctr.text;
    _wi.udfNum1 = udfNum1;
    _wi.udfOpt1 = parameterUdfOption1Value;
    _wi.udfDate1 = _udfDateValue;
    _wi.flagUpdate = 1;
    // _wi.progresStatusIdReal = progresStatusIdReal;

    db.updateWorkplanActivity(_wi);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkplanInboxPage(user: widget.user)));
  }
}
