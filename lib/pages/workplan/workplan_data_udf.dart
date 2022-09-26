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
import 'package:workplan_beta_test/model/parameter_udf_model.dart';
import 'package:workplan_beta_test/model/parameter_udf_option_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data.dart';

class WorkplanDataUdf extends StatefulWidget {
  final WorkplanInboxData workplan;
  final User user;
  final bool isMaximumUmur;

  const WorkplanDataUdf(
      {Key? key,
      required this.workplan,
      required this.user,
      required this.isMaximumUmur})
      : super(key: key);

  @override
  _WorkplanDataUdfState createState() => _WorkplanDataUdfState();
}

class _WorkplanDataUdfState extends State<WorkplanDataUdf> {
  final _keyForm = GlobalKey<FormState>();
  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');
  bool loading = false;
  TextEditingController _udfTextD1Ctr = TextEditingController();
  TextEditingController _udfTextD2Ctr = TextEditingController();
  TextEditingController _udfTextD3Ctr = TextEditingController();
  TextEditingController _udfNumD1Ctr = TextEditingController();
  TextEditingController _udfNumD2Ctr = TextEditingController();
  TextEditingController _udfNumD3Ctr = TextEditingController();

  bool enabled = false;
  var _udfDateD1Value = "";
  var _udfDateD2Value = "";
  var _udfDateD3Value = "";

  DatabaseHelper db = new DatabaseHelper();
  String labelUdfTextD1 = "UDF Text D1";
  String labelUdfTextD2 = "UDF Text D2";
  String labelUdfTextD3 = "UDF Text D3";
  String labelUdfNumD1 = "UDF Num D1";
  String labelUdfNumD2 = "UDF Num D2";
  String labelUdfNumD3 = "UDF Num D3";

  String labelUdfDateD1 = "UDF Date D1";
  String labelUdfDateD2 = "UDF Date D2";
  String labelUdfDateD3 = "UDF Date D3";

  String labelUdfDdlD1 = "UDF DDL D1";
  String labelUdfDdlD2 = "UDF DDL D2";
  String labelUdfDdlD3 = "UDF DDL D3";

  int udfDDlD1 = 0;
  int udfDDlD2 = 0;
  int udfDDlD3 = 0;

  List<ParameterUdfOption> parameterUdfOptionD1List = <ParameterUdfOption>[];
  List<DropdownMenuItem<int>> itemsParameterUdfOptionD1 =
      <DropdownMenuItem<int>>[];
  int parameterUdfOptionD1Value = SystemParam.defaultValueOptionId;

  List<ParameterUdfOption> parameterUdfOptionD2List = <ParameterUdfOption>[];
  List<DropdownMenuItem<int>> itemsParameterUdfOptionD2 =
      <DropdownMenuItem<int>>[];
  int parameterUdfOptionD2Value = SystemParam.defaultValueOptionId;

  List<ParameterUdfOption> parameterUdfOptionD3List = <ParameterUdfOption>[];
  List<DropdownMenuItem<int>> itemsParameterUdfOptionD3 =
      <DropdownMenuItem<int>>[];
  int parameterUdfOptionD3Value = SystemParam.defaultValueOptionId;

  late WorkplanInboxData _workplan;

  @override
  void initState() {
    super.initState();

    _workplan = widget.workplan;

    getParameterUdf();
    getLableUdf();
    // initParameterUdfOptionD1();
    // initParameterUdfOptionD2();
    // initParameterUdfOptionD3();

    _udfTextD1Ctr.text = widget.workplan.udfTextD1;
    _udfTextD2Ctr.text = widget.workplan.udfTextD2;
    _udfTextD3Ctr.text = widget.workplan.udfTextD3;

    if (widget.workplan.udfNumD1 != null) {
      _udfNumD1Ctr.text = widget.workplan.udfNumD1.toString();
    }

    if (widget.workplan.udfNumD2 != null) {
      _udfNumD2Ctr.text = widget.workplan.udfNumD2.toString();
    }

    if (widget.workplan.udfNumD2 != null) {
      _udfNumD2Ctr.text = widget.workplan.udfNumD2.toString();
    }

    if (widget.workplan.udfNumD3 != null) {
      _udfNumD3Ctr.text = widget.workplan.udfNumD3.toString();
    }

    if (_workplan.udfDateD1 != null && _workplan.udfDateD1 != "") {
      try {
        _udfDateD1Value =
            SystemParam.formatDateValue.format(_workplan.udfDateD1);
      } on SocketException catch (_) {
        _udfDateD1Value = _workplan.udfDateD1;
      }
    }

    if (_workplan.udfDateD2 != null && _workplan.udfDateD2 != "") {
      try {
        _udfDateD2Value =
            SystemParam.formatDateValue.format(_workplan.udfDateD2);
      } on SocketException catch (_) {
        _udfDateD2Value = _workplan.udfDateD2;
      }
    }

    if (_workplan.udfDateD3 != null && _workplan.udfDateD3 != "") {
      try {
        _udfDateD3Value =
            SystemParam.formatDateValue.format(_workplan.udfDateD3);
      } on SocketException catch (_) {
        _udfDateD3Value = _workplan.udfDateD3;
      }
    }

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
              title: Text('UDF'),
              centerTitle: true,
              backgroundColor: SystemParam.colorCustom,
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
                    child: Column(children: [
                    Form(
                        key: _keyForm,
                        child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '$labelUdfTextD1',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _udfTextD1Ctr,
                                  enabled: enabled,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfTextA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.normal),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
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
                                          text: '$labelUdfTextD2',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _udfTextD2Ctr,
                                  enabled: enabled,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfTextA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.normal),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
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
                                          text: '$labelUdfTextD3',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _udfTextD3Ctr,
                                  enabled: enabled,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfTextA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.normal),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
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
                                          text: '$labelUdfNumD1',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: _udfNumD1Ctr,
                                  enabled: enabled,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfNumA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.normal),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
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
                                          text: '$labelUdfNumD2',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: _udfNumD2Ctr,
                                  enabled: enabled,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfNumA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.normal),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
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
                                          text: '$labelUdfNumD3',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: _udfNumD3Ctr,
                                  enabled: enabled,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfNumA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.normal),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
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
                                          text: '$labelUdfDateD1',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DateTimeField(
                                  enabled: enabled,
                                  autovalidateMode: AutovalidateMode.always,
                                  onSaved: (valueDate) {
                                    _udfDateD1Value = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                  },
                                  onChanged: (valueDate) {
                                    _udfDateD1Value = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                  },
                                  format: SystemParam.formatDateDisplay,
                                  initialValue:
                                      widget.workplan.udfDateD1 != null
                                          ? widget.workplan.udfDateD1
                                          : null,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfDateA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.italic),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
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
                                          text: '$labelUdfDateD2',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DateTimeField(
                                  enabled: enabled,
                                  autovalidateMode: AutovalidateMode.always,
                                  onSaved: (valueDate) {
                                    _udfDateD2Value = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                  },
                                  onChanged: (valueDate) {
                                    _udfDateD2Value = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                  },
                                  format: SystemParam.formatDateDisplay,
                                  initialValue:
                                      widget.workplan.udfDateD2 != null
                                          ? widget.workplan.udfDateD2
                                          : null,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfDateA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.italic),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
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
                                          text: '$labelUdfDateD3',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DateTimeField(
                                  enabled: enabled,
                                  autovalidateMode: AutovalidateMode.always,
                                  onSaved: (valueDate) {
                                    _udfDateD3Value = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                  },
                                  onChanged: (valueDate) {
                                    _udfDateD3Value = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                  },
                                  format: SystemParam.formatDateDisplay,
                                  initialValue:
                                      widget.workplan.udfDateD3 != null
                                          ? widget.workplan.udfDateD3
                                          : null,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfDateA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.italic),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
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
                                          text: '$labelUdfDdlD1',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfDdlA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.italic),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                  value: parameterUdfOptionD1Value,
                                  items: itemsParameterUdfOptionD1,
                                  onChanged: !enabled
                                      ? null
                                      : (object) {
                                          setState(() {
                                            parameterUdfOptionD1Value = object!;
                                          });
                                        },
                                ),
                                // )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '$labelUdfDdlD2',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfDdlA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.italic),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                  value: parameterUdfOptionD2Value,
                                  items: itemsParameterUdfOptionD2,
                                  onChanged: !enabled
                                      ? null
                                      : (object) {
                                          setState(() {
                                            parameterUdfOptionD2Value = object!;
                                          });
                                        },
                                ),
                                // )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '$labelUdfDdlD3',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
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
                                    fillColor: SystemParam.colorCustom,
                                    // labelText: labelUdfDdlA1,
                                    labelStyle: TextStyle(
                                        color: SystemParam.colorCustom,
                                        fontStyle: FontStyle.italic),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: SystemParam.colorCustom),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                  value: parameterUdfOptionD3Value,
                                  items: itemsParameterUdfOptionD3,
                                  onChanged: !enabled
                                      ? null
                                      : (object) {
                                          setState(() {
                                            parameterUdfOptionD3Value = object!;
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
                                                BorderRadius.circular(10)),
                                        primary: SystemParam.colorCustom),
                                    child: Text("SIMPAN"),
                                    onPressed: !enabled
                                        ? null
                                        : () {
                                            //prosesSave(empUpd);
                                            if (_keyForm.currentState!
                                                .validate()) {
                                              saveData();
                                            }
                                            //saveData();
                                          },
                                  ),
                                ),
                              )
                            ])))
                  ]))));
  }

  void getParameterUdf() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        loading = true;
        var data = {"company_id": widget.user.userCompanyId};
        var response = await RestService()
            .restRequestService(SystemParam.fParameterUdfList, data);
        ParameterUdfModel parameterUdfModel =
            parameterUdfModelFromJson(response.body.toString());
        List<ParameterUdf> parameterUdfList = parameterUdfModel.data;

        await db.deleteParameterUdf();
        for (var i = 0; i < parameterUdfList.length; i++) {
          await db.insertParameterUdf(parameterUdfList[i]);
        }
        loading = false;
      }
    } on SocketException catch (_) {
      //print('not connected');
    }
  }

  void getLableUdf() {
    Future<ParameterUdf> parameterUdfTextA1 =
        db.getParameterUdfByName(labelUdfTextD1);
    parameterUdfTextA1.then((data) {
      setState(() {
        labelUdfTextD1 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfTextD2 =
        db.getParameterUdfByName(labelUdfTextD2);
    parameterUdfTextD2.then((data) {
      setState(() {
        labelUdfTextD2 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfTextD3 =
        db.getParameterUdfByName(labelUdfTextD3);
    parameterUdfTextD3.then((data) {
      setState(() {
        labelUdfTextD3 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfNumD1 =
        db.getParameterUdfByName(labelUdfNumD1);
    parameterUdfNumD1.then((data) {
      setState(() {
        labelUdfNumD1 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfNumD2 =
        db.getParameterUdfByName(labelUdfNumD2);
    parameterUdfNumD2.then((data) {
      setState(() {
        labelUdfNumD2 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfNumD3 =
        db.getParameterUdfByName(labelUdfNumD3);
    parameterUdfNumD3.then((data) {
      setState(() {
        labelUdfNumD3 = data.udfDescription;
      });
    });

    /* Date */

    Future<ParameterUdf> parameterUdfDateD1 =
        db.getParameterUdfByName(labelUdfDateD1);
    parameterUdfDateD1.then((data) {
      setState(() {
        labelUdfDateD1 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfDateD2 =
        db.getParameterUdfByName(labelUdfDateD2);
    parameterUdfDateD2.then((data) {
      setState(() {
        labelUdfDateD2 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfDateD3 =
        db.getParameterUdfByName(labelUdfDateD3);
    parameterUdfDateD3.then((data) {
      setState(() {
        labelUdfDateD3 = data.udfDescription;
      });
    });

    /* DDL */

    Future<ParameterUdf> parameterUdfDDLD1 =
        db.getParameterUdfByName(labelUdfDdlD1);
    parameterUdfDDLD1.then((data) {
      setState(() {
        labelUdfDdlD1 = data.udfDescription;
        udfDDlD1 = data.id;
        // initParameterUdfOptionD1();
        initParameterUdfOptionD1DB();
      });
    });

    Future<ParameterUdf> parameterUdfDDLD2 =
        db.getParameterUdfByName(labelUdfDdlD2);
    parameterUdfDDLD2.then((data) {
      setState(() {
        labelUdfDdlD2 = data.udfDescription;
        udfDDlD2 = data.id;
        initParameterUdfOptionD2DB();
      });
    });

    Future<ParameterUdf> parameterUdfDDLD3 =
        db.getParameterUdfByName(labelUdfDdlD3);
    parameterUdfDDLD3.then((data) {
      setState(() {
        labelUdfDdlD3 = data.udfDescription;
        udfDDlD3 = data.id;
        initParameterUdfOptionD3DB();
      });
    });
  }

  initParameterUdfOptionD1DB() async {
    db.getParameterUdfOption1ByUdfId(udfDDlD1).then((data) {
      setState(() {
        loading = true;
        parameterUdfOptionD1List = <ParameterUdfOption>[];
        itemsParameterUdfOptionD1.clear();
        parameterUdfOptionD1List = data;
        itemsParameterUdfOptionD1.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < parameterUdfOptionD1List.length; i++) {
          itemsParameterUdfOptionD1.add(DropdownItem.getItemParameter(
              parameterUdfOptionD1List[i].id,
              parameterUdfOptionD1List[i].optionDescription));

          if (widget.workplan.udfDdlD1 != null &&
              parameterUdfOptionD1List[i].id == widget.workplan.udfDdlD1) {
            parameterUdfOptionD1Value = widget.workplan.udfDdlD1;
          }
        }
        loading = false;

        if (widget.workplan.udfDdlD1 != null &&
            parameterUdfOptionD1List.contains(widget.workplan.udfDdlD1)) {
          parameterUdfOptionD1Value = widget.workplan.udfDdlD1;
        }

        // parameterUdfOptionD2Value = widget.workplan.udfDdlD2;
        // parameterUdfOptionD3Value = widget.workplan.udfDdlD3;
      });
    });
  }

  // void initParameterUdfOptionD1() async {
  //   loading = true;
  //   ParameterUdfOptionModel parameterModel;
  //   var data = {"company_id": widget.user.companyId, "udf_id": udfDDlD1};

  //   var response = await RestService()
  //       .restRequestService(SystemParam.fParameterUdfOption1, data);

  //   setState(() {
  //     parameterModel =
  //         parameterUdfOptionModelFromJson(response.body.toString());
  //     parameterUdfOptionD1List = parameterModel.data;
  //     itemsParameterUdfOptionD1.add(DropdownItem.getItemParameter(
  //         SystemParam.defaultValueOptionId,
  //         SystemParam.defaultValueOptionDesc));
  //     for (var i = 0; i < parameterUdfOptionD1List.length; i++) {
  //       itemsParameterUdfOptionD1.add(DropdownItem.getItemParameter(
  //           parameterUdfOptionD1List[i].id,
  //           parameterUdfOptionD1List[i].optionDescription));
  //     }
  //     loading = false;
  //   });
  // }

  initParameterUdfOptionD2DB() async {
    db.getParameterUdfOption1ByUdfId(udfDDlD2).then((data) {
      setState(() {
        loading = true;
        itemsParameterUdfOptionD2.clear();
        parameterUdfOptionD2List = <ParameterUdfOption>[];
        parameterUdfOptionD2List = data;
        itemsParameterUdfOptionD2.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < parameterUdfOptionD2List.length; i++) {
          itemsParameterUdfOptionD2.add(DropdownItem.getItemParameter(
              parameterUdfOptionD2List[i].id,
              parameterUdfOptionD2List[i].optionDescription));

          if (widget.workplan.udfDdlD2 != null &&
              parameterUdfOptionD2List[i].id == widget.workplan.udfDdlD2) {
            parameterUdfOptionD2Value = widget.workplan.udfDdlD2;
          }
        }
        loading = false;

        if (widget.workplan.udfDdlD2 != null &&
            parameterUdfOptionD2List.contains(widget.workplan.udfDdlD2)) {
          parameterUdfOptionD2Value = widget.workplan.udfDdlD2;
        }
      });
    });
  }

  // void initParameterUdfOptionD2() async {
  //   loading = true;
  //   ParameterUdfOptionModel parameterModel;
  //   var data = {"company_id": widget.user.companyId, "udf_id": udfDDlD2};

  //   var response = await RestService()
  //       .restRequestService(SystemParam.fParameterUdfOption1, data);

  //   setState(() {
  //     parameterModel =
  //         parameterUdfOptionModelFromJson(response.body.toString());
  //     parameterUdfOptionD2List = parameterModel.data;
  //     itemsParameterUdfOptionD2.add(DropdownItem.getItemParameter(
  //         SystemParam.defaultValueOptionId,
  //         SystemParam.defaultValueOptionDesc));
  //     for (var i = 0; i < parameterUdfOptionD2List.length; i++) {
  //       itemsParameterUdfOptionD2.add(DropdownItem.getItemParameter(
  //           parameterUdfOptionD2List[i].id,
  //           parameterUdfOptionD2List[i].optionDescription));
  //     }
  //     loading = false;
  //   });
  // }

  initParameterUdfOptionD3DB() async {
    db.getParameterUdfOption1ByUdfId(udfDDlD3).then((data) {
      setState(() {
        loading = true;
        itemsParameterUdfOptionD3.clear();
        parameterUdfOptionD3List = <ParameterUdfOption>[];
        parameterUdfOptionD3List = data;
        itemsParameterUdfOptionD3.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < parameterUdfOptionD3List.length; i++) {
          itemsParameterUdfOptionD3.add(DropdownItem.getItemParameter(
              parameterUdfOptionD3List[i].id,
              parameterUdfOptionD3List[i].optionDescription));

          if (widget.workplan.udfDdlD3 != null &&
              parameterUdfOptionD3List[i].id == widget.workplan.udfDdlD3) {
            parameterUdfOptionD3Value = widget.workplan.udfDdlD3;
          }
        }
        loading = false;

        if (widget.workplan.udfDdlD3 != null &&
            parameterUdfOptionD3List.contains(widget.workplan.udfDdlD3)) {
          parameterUdfOptionD3Value = widget.workplan.udfDdlD3;
        }
      });
    });
  }

  // void initParameterUdfOptionD3() async {
  //   loading = true;
  //   ParameterUdfOptionModel parameterModel;
  //   var data = {"company_id": widget.user.companyId, "udf_id": udfDDlD3};

  //   var response = await RestService()
  //       .restRequestService(SystemParam.fParameterUdfOption1, data);

  //   setState(() {
  //     parameterModel =
  //         parameterUdfOptionModelFromJson(response.body.toString());
  //     parameterUdfOptionD3List = parameterModel.data;
  //     itemsParameterUdfOptionD3.add(DropdownItem.getItemParameter(
  //         SystemParam.defaultValueOptionId,
  //         SystemParam.defaultValueOptionDesc));
  //     for (var i = 0; i < parameterUdfOptionD3List.length; i++) {
  //       itemsParameterUdfOptionD3.add(DropdownItem.getItemParameter(
  //           parameterUdfOptionD3List[i].id,
  //           parameterUdfOptionD3List[i].optionDescription));
  //     }
  //     loading = false;
  //   });
  // }

  void saveData() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        saveDataOnline();
      } else {
        // print('not connected-else');
        // saveDataOffline();
        Fluttertoast.showToast(
            msg: "No Internet Connection",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on SocketException catch (_) {
      print('not connected-catch');
      saveDataOffline();
    }
  }

  void getWorkplanById() async {
    loading = true;
    var data = {
      "id": widget.workplan.id,
    };

    var response =
        await RestService().restRequestService(SystemParam.fWorkplanById, data);

    setState(() {
      WorkplanInboxModel wi = workplanInboxFromJson(response.body.toString());
      // WorkplanInboxData wid = wi.data[0];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WorkplanData(
                  workplan: wi.data[0],
                  user: widget.user,
                  isMaximumUmur: widget.isMaximumUmur)));
      loading = false;
    });
  }

  void saveDataOnline() async {
    var data = {
      "id": widget.workplan.id,
      "updated_by": widget.user.id,
      "udf_text_d1": _udfTextD1Ctr.text,
      "udf_text_d2": _udfTextD2Ctr.text,
      "udf_text_d3": _udfTextD3Ctr.text,
      "udf_num_d1": _udfNumD1Ctr.text,
      "udf_num_d2": _udfNumD2Ctr.text,
      "udf_num_d3": _udfNumD3Ctr.text,
      "udf_date_d1": _udfDateD1Value,
      "udf_date_d2": _udfDateD2Value,
      "udf_date_d3": _udfDateD3Value,
      "udf_ddl_d1": parameterUdfOptionD1Value,
      "udf_ddl_d2": parameterUdfOptionD2Value,
      "udf_ddl_d3": parameterUdfOptionD3Value,
    };

    // print(data);

    var response = await RestService()
        .restRequestService(SystemParam.fWorkplanUdfUpdate, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];
    print(status);

    if (code == "0") {
      getWorkplanById();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WorkplanData(
                  workplan: widget.workplan,
                  user: widget.user,
                  isMaximumUmur: widget.isMaximumUmur)));
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
    _workplan.udfTextD1 = _udfTextD1Ctr.text;
    _workplan.udfTextD2 = _udfTextD2Ctr.text;
    _workplan.udfTextD3 = _udfTextD3Ctr.text;
    _workplan.udfNumD1 = _udfNumD1Ctr.text;
    _workplan.udfNumD2 = _udfNumD2Ctr.text;
    _workplan.udfNumD3 = _udfNumD3Ctr.text;
    _workplan.udfDdlD1 = parameterUdfOptionD1Value;
    _workplan.udfDdlD2 = parameterUdfOptionD2Value;
    _workplan.udfDdlD3 = parameterUdfOptionD3Value;
    _workplan.udfDateD1 = _udfDateD1Value;
    _workplan.udfDateD2 = _udfDateD2Value;
    _workplan.udfDateD3 = _udfDateD3Value;
    _workplan.flagUpdateUdf = 1;

    db.updateWorkplanActivity(_workplan);

    Fluttertoast.showToast(
        msg: "Data tersimpan secara offline",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkplanData(
                workplan: widget.workplan,
                user: widget.user,
                isMaximumUmur: widget.isMaximumUmur)));
  }
}
