import 'dart:convert';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/dropdown_item.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/parameter_activity_model.dart';
import 'package:workplan_beta_test/model/parameter_udf_model.dart';
import 'package:workplan_beta_test/model/parameter_udf_option_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_list.dart';

MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);

class WorkplanInput extends StatefulWidget {
  final User user;

  const WorkplanInput({Key? key, required this.user}) : super(key: key);
  @override
  _WorkplanInputState createState() => _WorkplanInputState();
}

class _WorkplanInputState extends State<WorkplanInput> {
  final _keyForm = GlobalKey<FormState>();
  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');
  bool loading = false;
  late List<ParameterActivity> parameterActivityList;
  List<DropdownMenuItem<int>> itemsParameterActivity =
      <DropdownMenuItem<int>>[];
  int parameterActivityValue = SystemParam.defaultValueOptionId;
  String parameterActivityDesc = "";
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
  var progresStatusId = "1";
  String progresStatusDesc = "";

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
  final bool withAsterisk = true;
  // SessionTimer sessionTimer = new SessionTimer();

  @override
  void initState() {
    super.initState();
    // initParameterActivity();
    initParameterActivityDB();
    getProgressNameDB(progresStatusId);

    getLableUdf();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        behavior: HitTestBehavior.translucent,
        // onTap: sessionTimer.userActivityDetected(context, widget.user),
        // onPanDown: sessionTimer.userActivityDetected(context, widget.user),
        // onScaleStart: sessionTimer.userActivityDetected(context, widget.user),
        //onHorizontalDragStart:
            //sessionTimer.userActivityDetected(context, widget.user),
        child: WillPopScope(
            onWillPop: () async {
              //sessionTimer.userActivityDetected(context, widget.user);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkplanList(user: widget.user),
                  ));
              return false;
            },
            child: Scaffold(
                //drawer: NavigationDrawerWidget(),
                appBar: AppBar(
                  title: Text('Input Master Task'),
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
                                WorkplanList(user: widget.user),
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
                            Form(
                              // onChanged: sessionTimer.userActivityDetected( context, widget.user),
                              // onChanged: SessionTimer().userActivityDetected(context,widget.user),
                              key: _keyForm,
                              // autovalidateMode: ,
                              // autovalidate: false,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        style:
                                            new TextStyle(color: Colors.black),
                                        initialValue: "-",
                                        enabled: false,
                                        validator: requiredValidator,
                                        onSaved: (em) {
                                          if (em != null) {}
                                        },
                                        decoration: InputDecoration(
                                          //icon: new Icon(Ionicons.document_outline),
                                          fillColor: colorCustom,
                                          labelText: "No Task",
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.italic),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                        style:
                                            new TextStyle(color: Colors.black),
                                        initialValue: "-",
                                        enabled: false,
                                        validator: requiredValidator,
                                        onSaved: (em) {
                                          if (em != null) {}
                                        },
                                        decoration: InputDecoration(
                                          // icon: new Icon(Ionicons.create_outline),
                                          fillColor: colorCustom,
                                          labelText: "Progress",
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.normal),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                      ),
                                    ),
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
                                              "Input",
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
                                                text: 'Jenis Aktifitas',
                                                style: TextStyle(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    color: colorCustom,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                                text:
                                                    withAsterisk ? ' * ' : ' ',
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
                                      // child: DropdownButtonHideUnderline(
                                      child: DropdownButtonFormField<int>(
                                        decoration: InputDecoration(
                                          //icon: new Icon(Ionicons.person),
                                          //errorText: "this field is required",
                                          fillColor: colorCustom,
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.normal),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                        // hint: Padding(
                                        //   padding: const EdgeInsets.all(8.0),
                                        //   child: Text(
                                        //     "Jenis Aktifitas",
                                        //     style: TextStyle(color: Colors.blue[900]),
                                        //   ),
                                        // ),
                                        validator: (value) {
                                          print("validaor select:" +
                                              value.toString());
                                          // ignore: unrelated_type_equality_checks
                                          if (value == 0) {
                                            return "this field is required";
                                          }
                                          return null;
                                        },
                                        value: parameterActivityValue,
                                        items: itemsParameterActivity,
                                        onChanged: (object) {
                                          setState(() {
                                            parameterActivityValue = object!;
                                            int idxPA = parameterActivityList
                                                .indexWhere((element) =>
                                                    element.id == object);
                                            parameterActivityDesc =
                                                parameterActivityList[idxPA]
                                                    .description;
                                          });
                                        },
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
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    color: colorCustom,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                                text:
                                                    withAsterisk ? ' * ' : ' ',
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
                                        validator: requiredValidator,
                                        controller: _nameCtr,
                                        // onChanged:sessionTimer.userActivityDetected(context, widget.user),
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        style:
                                            new TextStyle(color: Colors.black),
                                        readOnly: false,
                                        onSaved: (em) {
                                          if (em != null) {}
                                        },
                                        decoration: InputDecoration(
                                          //icon: new Icon(Ionicons.person),
                                          fillColor: colorCustom,
                                          // isDense: true,
                                          // isCollapsed: true,

                                          //labelText: "Nama",
                                          // alignLabelWithHint: false,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          //  prefix: Text("*",style: TextStyle(
                                          //   color: Colors.red,)),
                                          // prefixText: '*',
                                          // prefixStyle: TextStyle(
                                          //   color: Colors.red,

                                          // ),
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.normal),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: 'No HP',
                                                style: TextStyle(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    color: colorCustom,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                                text:
                                                    withAsterisk ? ' * ' : ' ',
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
                                        controller: _noHpCtr,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        style: new TextStyle(
                                            color: Colors.blue[900]),
                                        readOnly: false,
                                        validator: requiredValidator,
                                        onSaved: (em) {
                                          if (em != null) {}
                                        },
                                        decoration: InputDecoration(
                                          // icon: new Icon(Ionicons.phone_portrait),
                                          fillColor: Colors.black,
                                          // labelText: "Nomor HP",
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.normal),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                      ),
                                    ),
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
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    color: colorCustom,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                                text:
                                                    withAsterisk ? ' * ' : ' ',
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
                                        controller: _namaLokasiCtr,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        style:
                                            new TextStyle(color: Colors.black),
                                        readOnly: false,
                                        validator: requiredValidator,
                                        onSaved: (em) {
                                          if (em != null) {}
                                        },
                                        decoration: InputDecoration(
                                          // icon: new Icon(Ionicons.location),
                                          fillColor: colorCustom,
                                          // labelText: "Nama Lokasi",
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.normal),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: 'Alamat',
                                                style: TextStyle(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    color: colorCustom,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                                text:
                                                    withAsterisk ? ' * ' : ' ',
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
                                        controller: _alamatUsahaCtr,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        style:
                                            new TextStyle(color: Colors.black),
                                        readOnly: false,
                                        validator: requiredValidator,
                                        onSaved: (em) {
                                          if (em != null) {}
                                        },
                                        decoration: InputDecoration(
                                          //icon: new Icon(Ionicons.home),
                                          fillColor: colorCustom,
                                          // labelText: "Alamat",
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.normal),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: 'Kelurahan',
                                                style: TextStyle(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    color: colorCustom,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                                text:
                                                    withAsterisk ? ' * ' : ' ',
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
                                        controller: _kelurahanCtr,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        style:
                                            new TextStyle(color: Colors.black),
                                        readOnly: false,
                                        validator: requiredValidator,
                                        onSaved: (em) {
                                          if (em != null) {}
                                        },
                                        decoration: InputDecoration(
                                          //icon: new Icon(Ionicons.home_sharp),
                                          fillColor: colorCustom,
                                          // labelText: "Kelurahan",
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.normal),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: 'Kecamatan',
                                                style: TextStyle(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    color: colorCustom,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                                text:
                                                    withAsterisk ? ' * ' : ' ',
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
                                        controller: _kecamatanCtr,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        style:
                                            new TextStyle(color: Colors.black),
                                        readOnly: false,
                                        validator: requiredValidator,
                                        onSaved: (em) {
                                          if (em != null) {}
                                        },
                                        decoration: InputDecoration(
                                          //icon: new Icon(Ionicons.home_sharp),
                                          fillColor: colorCustom,
                                          // labelText: "Kecamatan",
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.normal),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: 'Kodya/ Kabupaten',
                                                style: TextStyle(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    color: colorCustom,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                                text:
                                                    withAsterisk ? ' * ' : ' ',
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
                                        controller: _kabupatenCtr,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        style:
                                            new TextStyle(color: Colors.black),
                                        readOnly: false,
                                        validator: requiredValidator,
                                        onSaved: (em) {
                                          if (em != null) {}
                                        },
                                        decoration: InputDecoration(
                                          //icon: new Icon(Ionicons.home_sharp),
                                          fillColor: colorCustom,
                                          // labelText: "Kodya/Kabupaten",
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.normal),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: 'Kode Pos',
                                                style: TextStyle(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    color: colorCustom,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                                text:
                                                    withAsterisk ? ' * ' : ' ',
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
                                        controller: _kodeposCtr,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        style:
                                            new TextStyle(color: Colors.black),
                                        readOnly: false,
                                        validator: requiredValidator,
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
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: 'Rencana Kunjungan 1',
                                                style: TextStyle(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    color: colorCustom,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                            TextSpan(
                                                text:
                                                    withAsterisk ? ' * ' : ' ',
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
                                        validator: (value) {
                                          if (value == null) {
                                            return "this field is required";
                                          }
                                          return null;
                                        },
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
                                              firstDate: DateTime(
                                                  SystemParam.firstDate),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime(
                                                  SystemParam.lastDate),
                                              fieldHintText: SystemParam
                                                  .strFormatDateHint);
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon:
                                              new Icon(Icons.date_range),
                                          fillColor: colorCustom,
                                          // labelText: "Rencana Kunjungan 1",
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.italic),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: withAsterisk ? ' ' : ' ',
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
                                        style:
                                            new TextStyle(color: Colors.black),
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
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: withAsterisk ? '  ' : ' ',
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
                                        style:
                                            new TextStyle(color: Colors.black),
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
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: withAsterisk ? '  ' : ' ',
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
                                        style:
                                            new TextStyle(color: Colors.black),
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
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: withAsterisk ? '  ' : ' ',
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
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
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
                                              firstDate: DateTime(
                                                  SystemParam.firstDate),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime(
                                                  SystemParam.lastDate),
                                              fieldHintText: SystemParam
                                                  .strFormatDateHint);
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon:
                                              new Icon(Icons.date_range),
                                          fillColor: colorCustom,
                                          // labelText: labelUdfDateA1,
                                          labelStyle: TextStyle(
                                              color: colorCustom,
                                              fontStyle: FontStyle.italic),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                                text: withAsterisk ? '  ' : ' ',
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
                                              borderSide: BorderSide(
                                                  color: colorCustom),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorCustom),
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
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              primary: colorCustom),
                                          child: Text("SIMPAN"),
                                          onPressed: () {
                                            //prosesSave(empUpd);
                                           // sessionTimer.userActivityDetected(context, widget.user);
                                            if (_keyForm.currentState!
                                                .validate()) {
                                              saveData();
                                            }
                                            //saveData();
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
                      ))));
  }

  void initParameterActivity() async {
    loading = true;
    ParameterActivityModel parameterModel;
    var data = {"company_id": widget.user.userCompanyId};

    var response = await RestService()
        .restRequestService(SystemParam.fParameterActivity, data);

    setState(() {
      parameterModel = parameterActivityModelFromJson(response.body.toString());
      parameterActivityList = parameterModel.data;
      itemsParameterActivity.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < parameterActivityList.length; i++) {
        itemsParameterActivity.add(DropdownItem.getItemParameter(
            parameterActivityList[i].id, parameterActivityList[i].description));
      }
      loading = false;
    });
  }

  void saveData() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        //saveDataOffline();
        saveDataOnline();
      } else {
        print('not connected-else');
        saveDataOffline();
      }
    } on SocketException catch (_) {
      print('not connected-catch');
      saveDataOffline();
    }
  }

  void initParameterUdfOption1() async {
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
        // initParameterUdfOption1();
        initParameterUdfOptionDB();
      });
    });
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
      });
    });
  }

  void initParameterActivityDB() async {
    db.getParameterActivityList().then((value) {
      setState(() {
        loading = true;
        parameterActivityList = value;
        itemsParameterActivity.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < parameterActivityList.length; i++) {
          itemsParameterActivity.add(DropdownItem.getItemParameter(
              parameterActivityList[i].id,
              parameterActivityList[i].description));
        }
        loading = false;
      });
    });
  }

  void saveDataOnline() async {
    var data = {
      "progres_status_id": progresStatusId,
      "activity_id": parameterActivityValue,
      "full_name": _nameCtr.text,
      "phone": _noHpCtr.text,
      "location": _namaLokasiCtr.text,
      "alamat": _alamatUsahaCtr.text,
      "rencana_kunjungan": _rencanaKunjunganValue,
      "user_id": widget.user.id,
      "kecamatan": _kecamatanCtr.text,
      "kabupaten": _kabupatenCtr.text,
      "kelurahan": _kelurahanCtr.text,
      "kodepos": _kodeposCtr.text,
      "created_by": widget.user.id,
      "udf_text1": _udfText1Ctr.text,
      "udf_text2": _udfText2Ctr.text,
      "udf_num1": _udfNum1Ctr.text,
      "udf_opt1": parameterUdfOption1Value,
      "udf_date1": _udfDateValue,
      "company_id": widget.user.userCompanyId
    };

    print(data);
    var response = await RestService()
        .restRequestService(SystemParam.fWorkplanCreate, data);

    print("response.body" + response.body.toString());

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];
    print(status);
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

  void saveDataOffline() {
    //var workplanInboxData = WorkplanInboxData();
    var map = new Map<String, dynamic>();
    map["progres_status_id"] = progresStatusId;
    map["activity_id"] = parameterActivityValue;
    map["full_name"] = _nameCtr.text;
    map["phone"] = _noHpCtr.text;
    map["location"] = _namaLokasiCtr.text;
    map["alamat"] = _alamatUsahaCtr.text;
    map["rencana_kunjungan"] = _rencanaKunjunganValue;
    map["user_id"] = widget.user.id;
    map["kecamatan"] = _kecamatanCtr.text;
    map["kabupaten"] = _kabupatenCtr.text;
    map["kelurahan"] = _kelurahanCtr.text;
    map["kodepos"] = _kodeposCtr.text;
    // map["created_by"] =widget.user.id;
    map["udf_text1"] = _udfText1Ctr.text;
    map["udf_text2"] = _udfText2Ctr.text;
    map["udf_num1"] = _udfNum1Ctr.text;
    map["udf_opt1"] = parameterUdfOption1Value;
    map["udf_date1"] = _udfDateValue;
    map["company_id"] = widget.user.userCompanyId;
    map["receive_date"] =
        SystemParam.formatDateTimeValue.format(DateTime.now());
    map["activity_description"] = parameterActivityDesc;
    map["progres_status_description"] = progresStatusDesc;

    db.insertWorkplanActivity(map);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkplanList(user: widget.user)));
  }

  getProgressNameDB(String pId) async {
    db.getParameterProgresStatusById(pId).then((value) {
      progresStatusDesc = value.description;
    });
  }
}
