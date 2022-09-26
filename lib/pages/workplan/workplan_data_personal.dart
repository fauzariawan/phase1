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
import 'package:workplan_beta_test/model/parameter_model.dart';
import 'package:workplan_beta_test/model/parameter_udf_model.dart';
import 'package:workplan_beta_test/model/parameter_udf_option_model.dart';
import 'package:workplan_beta_test/model/parameter_usaha_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data.dart';

// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);

class WorkplanDataPersonal extends StatefulWidget {
  final WorkplanInboxData workplan;
  final User user;
  final bool isMaximumUmur;

  const WorkplanDataPersonal(
      {Key? key,
      required this.workplan,
      required this.user,
      required this.isMaximumUmur})
      : super(key: key);
  @override
  _WorkplanDataPersonalState createState() => _WorkplanDataPersonalState();
}

class _WorkplanDataPersonalState extends State<WorkplanDataPersonal> {
  final _keyForm = GlobalKey<FormState>();
  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');
  bool enabled = false;
  bool loading = false;
  // var maskFormatter = new MaskTextInputFormatter(
  //     mask: '##.###.###.#-###.###', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController _phoneCtr = new TextEditingController();
  TextEditingController _alamatCtr = new TextEditingController();
  TextEditingController _kelurahanCtr = new TextEditingController();
  TextEditingController _kecamatanCtr = new TextEditingController();
  TextEditingController _kabupatenCtr = new TextEditingController();
  TextEditingController _kodePosCtr = new TextEditingController();
  TextEditingController _placeOfBirthCtr = new TextEditingController();
  TextEditingController _identityCardNoCtr = new TextEditingController();
  TextEditingController _npwpCtr = new TextEditingController();
  TextEditingController _lamaUsahaCtr = new TextEditingController();
  TextEditingController _udfTextB1Ctr = TextEditingController();
  TextEditingController _udfTextB2Ctr = TextEditingController();
  TextEditingController _udfNumB1Ctr = TextEditingController();
  TextEditingController _udfNumB2Ctr = TextEditingController();

  // -> "12-34-56-78"
  var _udfDateB1Value = "";
  var _udfDateB2Value = "";
  var _dateOfBirthValue = "";

  List<ParameterUdfOption> parameterUdfOption1List = <ParameterUdfOption>[];
  List<DropdownMenuItem<int>> itemsParameterUdfOption1 =
      <DropdownMenuItem<int>>[];
  int parameterUdfOption1Value = SystemParam.defaultValueOptionId;

  List<ParameterUdfOption> parameterUdfOption2List = <ParameterUdfOption>[];
  List<DropdownMenuItem<int>> itemsParameterUdfOption2 =
      <DropdownMenuItem<int>>[];
  int parameterUdfOption2Value = SystemParam.defaultValueOptionId;

  List<Parameter> genderList = <Parameter>[];
  List<DropdownMenuItem<int>> itemsGender = <DropdownMenuItem<int>>[];
  int genderValue = SystemParam.defaultValueOptionId;

  List<Parameter> maritalStatusList = <Parameter>[];
  List<DropdownMenuItem<int>> itemsMaritalStatus = <DropdownMenuItem<int>>[];
  int maritalStatusValue = SystemParam.defaultValueOptionId;

  List<ParameterUsaha> parameterUsahaList = <ParameterUsaha>[];
  List<DropdownMenuItem<int>> itemsParameterUsaha = <DropdownMenuItem<int>>[];
  int parameterUsahaValue = SystemParam.defaultValueOptionId;

  DatabaseHelper db = new DatabaseHelper();
  String labelUdfTextB1 = "UDF Text B1";
  String labelUdfTextB2 = "UDF Text B2";
  String labelUdfNumB1 = "UDF Num B1";
  String labelUdfNumB2 = "UDF Num B2";
  String labelUdfDateB1 = "UDF Date B1";
  String labelUdfDateB2 = "UDF Date B2";
  String labelUdfDDLB1 = "UDF DDL B1";
  String labelUdfDDLB2 = "UDF DDL B2";
  int udfDDlB1 = 0;
  int udfDDlB2 = 0;
  late WorkplanInboxData _workplan;

  @override
  void initState() {
    super.initState();

    updateWorkplanData();

    _workplan = widget.workplan;
    //print("flag="+_workplan.flagUpdatePersonal.toString());

    initParameterGenderDB();
    initParameterMaritalStatusDB();
    initParameterUsahaDB();

    getLableUdf();

    // _dateOfBirthValue;
    // _udfDateB1Value ;
    // _udfDateB2Value ;

    // ignore: unnecessary_null_comparison
    setState(() {
      // if (widget.workplan.genderId != null) {
      //   genderValue = widget.workplan.genderId;
      // }

      // ignore: unnecessary_null_comparison
      // if (widget.workplan.maritalStatusId != null) {
      //   maritalStatusValue = widget.workplan.maritalStatusId;
      // }

      // ignore: unnecessary_null_comparison
      // if (widget.workplan.jenisUsahaId != null) {
      //   parameterUsahaValue = widget.workplan.jenisUsahaId;
      // }

      // if (widget.workplan.udfDdlB1 != null) {
      //   parameterUdfOption1Value = widget.workplan.udfDdlB1;
      // }

      // if (widget.workplan.udfDdlB2 != null) {
      //   parameterUdfOption2Value = widget.workplan.udfDdlB2;
      // }

      _phoneCtr.text = _workplan.phone;
      _alamatCtr.text = _workplan.personalAlamat;
      _kelurahanCtr.text = _workplan.personalKelurahan;
      _kecamatanCtr.text = _workplan.personalKecamatan;
      _kabupatenCtr.text = _workplan.personalKabupaten;
      _kodePosCtr.text = _workplan.personalKodepos;
      _placeOfBirthCtr.text = _workplan.placeOfBirth;
      _identityCardNoCtr.text = _workplan.identityCardNo;
      _npwpCtr.text = _workplan.npwp;
      //_npwpCtr.value = maskFormatter.updateMask(mask: "##.###.###.#-###.###");

      if (_workplan.lamaUsaha != null) {
        _lamaUsahaCtr.text = _workplan.lamaUsaha.toString();
      }

      _udfTextB1Ctr.text = _workplan.udfTextB1;
      _udfTextB2Ctr.text = _workplan.udfTextB2;
      // ignore: unnecessary_null_comparison
      if (_workplan.udfNumB1 != null) {
        _udfNumB1Ctr.text = _workplan.udfNumB1.toString();
      }

      if (_workplan.udfNumB2 != null) {
        _udfNumB2Ctr.text = _workplan.udfNumB2.toString();
      }

      if (_workplan.dateOfBirth != null && _workplan.dateOfBirth != "") {
        // _dateOfBirthValue = _workplan.dateOfBirth;
        // Datetime.parse();
        try {
          _dateOfBirthValue =
              SystemParam.formatDateValue.format(_workplan.dateOfBirth);
        } on SocketException catch (_) {
          _dateOfBirthValue = _workplan.dateOfBirth;
        }
      }

      if (_workplan.udfDateB1 != null && _workplan.udfDateB1 != "") {
        // _udfDateB1Value = _workplan.udfDateB1;
        _udfDateB1Value =
            SystemParam.formatDateValue.format(_workplan.udfDateB1);
      }

      if (_workplan.udfDateB2 != null && _workplan.udfDateB2 != "") {
        // _udfDateB2Value = _workplan.udfDateB2;
        _udfDateB2Value =
            SystemParam.formatDateValue.format(_workplan.udfDateB2);
      }

      //print("_workplan.isCheckIn:"+_workplan.isCheckIn);

      //print("_workplan.progresStatusIdAlter:"+_workplan.progresStatusIdAlter.toString());

      if (_workplan.isCheckIn == "1" &&
          (_workplan.progresStatusIdAlter == 2 ||
              _workplan.progresStatusIdAlter == 4)) {
        enabled = true;
      } else {
        enabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
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
            title: Text('Personal'),
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
                  child: Column(
                    children: [
                      Form(
                        key: _keyForm,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: colorCustom),
                                  initialValue: widget.workplan.nomorWorkplan,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    //icon: new Icon(Ionicons.document_outline),
                                    fillColor: colorCustom,
                                    labelText: "No Workplan",
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
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: colorCustom),
                                  initialValue:
                                      widget.workplan.progresStatusDescription,
                                  enabled: false,
                                  onSaved: (em) {
                                    if (em != null) {}
                                  },
                                  decoration: InputDecoration(
                                    //icon: new Icon(Ionicons.create_outline),
                                    fillColor: colorCustom,
                                    labelText: "Progress",
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
                                          text: 'Nama',
                                          style: TextStyle(
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: true ? '  ' : ' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  //validator:requiredValidator,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  style: new TextStyle(color: Colors.black),
                                  initialValue: widget.workplan.fullName,
                                  enabled: enabled,
                                  decoration: InputDecoration(
                                    fillColor: colorCustom,
                                    //labelText: "Nama",
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
                                          text: 'No HP',
                                          style: TextStyle(
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  //validator:requiredValidator,
                                  maxLength: 14,
                                  controller: _phoneCtr,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: new TextStyle(color: Colors.black),
                                  //initialValue: widget.workplan.phone,
                                  enabled: enabled,
                                  decoration: InputDecoration(
                                    //icon: new Icon(Ionicons.phone_portrait),
                                    fillColor: Colors.black,
                                    // labelText: "Nomor HP",
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
                                child: Container(
                                  decoration:
                                      new BoxDecoration(color: Colors.white30),
                                  height: 50,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "Alamat Rumah",
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
                                          text: 'Alamat',
                                          style: TextStyle(
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  //validator:requiredValidator,
                                  controller: _alamatCtr,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: Colors.black),
                                  // initialValue: widget.workplan.alamat,
                                  enabled: enabled,
                                  decoration: InputDecoration(
                                    //icon: new Icon(Ionicons.home),
                                    fillColor: colorCustom,
                                    // labelText: "Alamat",
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
                                          text: 'Kelurahan',
                                          style: TextStyle(
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  //validator:requiredValidator,
                                  controller: _kelurahanCtr,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: Colors.black),
                                  // initialValue: "",
                                  enabled: enabled,
                                  decoration: InputDecoration(
                                    //icon: new Icon(Ionicons.home_sharp),
                                    fillColor: colorCustom,
                                    // labelText: "Kelurahan",
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
                                          text: 'Kecamatan',
                                          style: TextStyle(
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  //validator:requiredValidator,
                                  controller: _kecamatanCtr,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: Colors.black),
                                  // initialValue: widget.workplan.kecamatan,
                                  enabled: enabled,

                                  // onSaved: (em) {
                                  //   if (em != null) {}
                                  // },
                                  decoration: InputDecoration(
                                    //icon: new Icon(Ionicons.home_sharp),
                                    fillColor: colorCustom,
                                    // labelText: "Kecamatan",
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
                                          text: 'Kodya/ Kabupaten',
                                          style: TextStyle(
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  //validator:requiredValidator,
                                  controller: _kabupatenCtr,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: Colors.black),
                                  // initialValue: widget.workplan.kabupaten,
                                  enabled: enabled,

                                  // onSaved: (em) {
                                  //   if (em != null) {}
                                  // },
                                  decoration: InputDecoration(
                                    //icon: new Icon(Ionicons.home_sharp),
                                    fillColor: colorCustom,
                                    // labelText: "Kodya/Kabupaten",
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
                                          text: 'Kode Pos',
                                          style: TextStyle(
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  //validator:requiredValidator,
                                  controller: _kodePosCtr,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: new TextStyle(color: Colors.black),
                                  // initialValue: widget.workplan.kodepos,
                                  enabled: enabled,

                                  // onSaved: (em) {
                                  //   if (em != null) {}
                                  // },
                                  decoration: InputDecoration(
                                    //icon: new Icon(Ionicons.document),
                                    fillColor: colorCustom,
                                    // labelText: "Kode Pos",
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
                                          text: 'Tanggal Lahir',
                                          style: TextStyle(
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DateTimeField(
                                  // //validator:(value) {
                                  //   if (value == null) {
                                  //     return "this field is required";
                                  //   }
                                  //   return null;
                                  // },
                                  enabled: enabled,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onSaved: (valueDate) {
                                    _dateOfBirthValue = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                    //  _dateOfBirthValue= valueDate!;
                                  },
                                  onChanged: (valueDate) {
                                    _dateOfBirthValue = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                    // _dateOfBirthValue= valueDate!;
                                  },
                                  format: SystemParam.formatDateDisplay,
                                  initialValue:
                                      widget.workplan.dateOfBirth != null
                                          ? widget.workplan.dateOfBirth
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
                                    fillColor: colorCustom,
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
                                          text: 'Tempat Lahir',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                  //validator:requiredValidator,
                                  controller: _placeOfBirthCtr,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: Colors.black),
                                  // initialValue: widget.workplan.placeOfBirth,
                                  enabled: enabled,
                                  // onSaved: (em) {
                                  //   if (em != null) {}
                                  // },
                                  decoration: InputDecoration(
                                    //icon: new Icon(Ionicons.location),
                                    fillColor: colorCustom,
                                    //labelText: "Tempat Lahir",
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
                                          text: 'Jenis Kelamin',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                  // //validator:(value) {
                                  //   print(
                                  //       "validaor select:" + value.toString());
                                  //   // ignore: unrelated_type_equality_checks
                                  //   if (value == 0 || value == null) {
                                  //     return "this field is required";
                                  //   }
                                  //   return null;
                                  // },
                                  value: genderValue,
                                  items: itemsGender,
                                  onChanged: !enabled
                                      ? null
                                      : (object) {
                                          setState(() {
                                            // genderSelected = object!;
                                            genderValue = object!;
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
                                          text: 'Status Pernikahan',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                  // //validator:(value) {
                                  //   //print("validaor select:"+value.toString());
                                  //   // ignore: unrelated_type_equality_checks
                                  //   if (value == 0 || value == null) {
                                  //     return "this field is required";
                                  //   }
                                  //   return null;
                                  // },
                                  value: maritalStatusValue,
                                  items: itemsMaritalStatus,
                                  onChanged: !enabled
                                      ? null
                                      : (object) {
                                          setState(() {
                                            // genderSelected = object!;
                                            maritalStatusValue = object!;
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
                                          text: 'Nomor KTP',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                  maxLength: 16,
                                  controller: _identityCardNoCtr,
                                  //validator:requiredValidator,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  textInputAction: TextInputAction.next,
                                  style: new TextStyle(color: Colors.black),
                                  //initialValue: widget.workplan.identityCardNo,
                                  enabled: enabled,
                                  decoration: InputDecoration(
                                    fillColor: colorCustom,
                                    // labelText: "Nomor KTP",
                                    labelStyle: TextStyle(
                                      color: colorCustom,
                                      fontStyle: FontStyle.normal,
                                    ),
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
                                          text: 'Nomor NPWP',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                  controller: _npwpCtr,
                                  inputFormatters: [
                                    SystemParam.maskFormatterNPWP
                                  ],
                                  //validator:requiredValidator,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  style: new TextStyle(color: Colors.black),
                                  //initialValue: widget.workplan.npwp,
                                  enabled: enabled,

                                  onSaved: (em) {
                                    if (em != null) {}
                                  },
                                  decoration: InputDecoration(
                                    fillColor: colorCustom,
                                    // labelText: "Nomor NPWP",
                                    labelStyle: TextStyle(
                                      color: colorCustom,
                                      fontStyle: FontStyle.normal,
                                    ),
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
                                          text: 'Jenis Usaha',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                  // //validator:(value) {
                                  //   //print("validaor select:"+value.toString());
                                  //   // ignore: unrelated_type_equality_checks
                                  //   if (value == 0 || value == null) {
                                  //     return "this field is required";
                                  //   }
                                  //   return null;
                                  // },
                                  value: parameterUsahaValue,
                                  items: itemsParameterUsaha,
                                  onChanged: !enabled
                                      ? null
                                      : (object) {
                                          setState(() {
                                            parameterUsahaValue = object!;
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
                                          text: 'Lama Usaha (tahun)',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                  maxLength: 10,
                                  controller: _lamaUsahaCtr,
                                  //validator:requiredValidator,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  textInputAction: TextInputAction.next,
                                  style: new TextStyle(color: Colors.black),
                                  // initialValue:widget.workplan.lamaUsaha.toString(),
                                  enabled: enabled,

                                  // onSaved: (em) {
                                  //   if (em != null) {}
                                  // },
                                  decoration: InputDecoration(
                                    //icon: new Icon(Ionicons.hourglass),
                                    fillColor: colorCustom,
                                    // labelText: "Lama Usaha (Tahun)",
                                    labelStyle: TextStyle(
                                      color: colorCustom,
                                      fontStyle: FontStyle.normal,
                                    ),
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
                                          text: '$labelUdfTextB1',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                  controller: _udfTextB1Ctr,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: Colors.black),
                                  //initialValue: widget.workplanInboxData.kodepos,
                                  enabled: enabled,
                                  // //validator:validasiUsername,
                                  onSaved: (em) {
                                    //if (em != null) {}
                                  },
                                  decoration: InputDecoration(
                                    // icon: new Icon(Ionicons.document),
                                    fillColor: colorCustom,
                                    // labelText: "UDF Text A1",
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
                                          text: '$labelUdfTextB2',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                  controller: _udfTextB2Ctr,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: Colors.black),
                                  //initialValue: widget.workplanInboxData.kodepos,
                                  enabled: enabled,
                                  // //validator:validasiUsername,
                                  onSaved: (em) {
                                    //if (em != null) {}
                                  },
                                  decoration: InputDecoration(
                                    // icon: new Icon(Ionicons.document),
                                    fillColor: colorCustom,
                                    // labelText: "UDF TEXT A2",
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
                                          text: '$labelUdfNumB1',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                  // maxLength: 16,
                                  controller: _udfNumB1Ctr,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: new TextStyle(color: Colors.black),
                                  //initialValue: widget.workplanInboxData.kodepos,
                                  enabled: enabled,
                                  // //validator:validasiUsername,
                                  onSaved: (em) {
                                    //if (em != null) {}
                                  },
                                  maxLength: 15,
                                  decoration: InputDecoration(
                                    // icon: new Icon(Ionicons.document),
                                    fillColor: colorCustom,
                                    // labelText: "UDF Num B1",
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
                                          text: '$labelUdfNumB2',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                  controller: _udfNumB2Ctr,
                                  // maxLength: 16,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: new TextStyle(color: Colors.black),
                                  //initialValue: widget.workplanInboxData.kodepos,
                                  enabled: enabled,
                                  // //validator:validasiUsername,
                                  onSaved: (em) {
                                    //if (em != null) {}
                                  },
                                  maxLength: 15,
                                  decoration: InputDecoration(
                                    // icon: new Icon(Ionicons.document),
                                    fillColor: colorCustom,
                                    // labelText: "UDF Num B2",
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
                                          text: '$labelUdfDateB1',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                    _udfDateB1Value = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                    // _udfDateB1Value = valueDate!;
                                  },
                                  onChanged: (valueDate) {
                                    _udfDateB1Value = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                    // _udfDateB1Value = valueDate!;
                                  },
                                  format: SystemParam.formatDateDisplay,
                                  initialValue:
                                      widget.workplan.udfDateB1 != null
                                          ? widget.workplan.udfDateB1
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
                                    fillColor: colorCustom,
                                    // labelText: "UDF Date 1",
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
                                          text: '$labelUdfDateB2',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
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
                                    _udfDateB2Value = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                    // _udfDateB2Value = valueDate!;
                                  },
                                  onChanged: (valueDate) {
                                    _udfDateB2Value = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                    // _udfDateB2Value = valueDate!;
                                  },
                                  format: SystemParam.formatDateDisplay,
                                  initialValue:
                                      widget.workplan.udfDateB2 != null
                                          ? widget.workplan.udfDateB2
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
                                    fillColor: colorCustom,
                                    // labelText: "UDF Date 1",
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
                                          text: '$labelUdfDDLB1',
                                          style: TextStyle(
                                              // backgroundColor: Theme.of(context) .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonHideUnderline(
                                    child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  //height: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: colorCustom)),
                                  child: DropdownButton<int>(
                                    value: parameterUdfOption1Value,
                                    items: itemsParameterUdfOption1,
                                    onChanged: !enabled
                                        ? null
                                        : (object) {
                                            setState(() {
                                              parameterUdfOption1Value =
                                                  object!;
                                            });
                                          },
                                  ),
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '$labelUdfDDLB2',
                                          style: TextStyle(
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: colorCustom,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                      TextSpan(
                                          text: '  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              // backgroundColor: Theme.of(context)
                                              //     .scaffoldBackgroundColor,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonHideUnderline(
                                    child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  //height: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: colorCustom)),
                                  child: DropdownButton<int>(
                                    // hint: Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(
                                    //     "UDF DDL B2",
                                    //     style: TextStyle(color: Colors.blue[900]),
                                    //   ),
                                    // ),
                                    value: parameterUdfOption2Value,
                                    items: itemsParameterUdfOption2,
                                    onChanged: !enabled
                                        ? null
                                        : (object) {
                                            setState(() {
                                              parameterUdfOption2Value =
                                                  object!;
                                            });
                                          },
                                  ),
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: colorCustom,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: Text("SIMPAN"),
                                    onPressed: !enabled
                                        ? null
                                        : () {
                                            if (_keyForm.currentState!
                                                .validate()) {
                                              saveData();
                                            }
                                          },
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

  // void initParameterGender() async {
  //   itemsGender.clear();
  //   genderList = <Parameter>[];
  //   loading = true;
  //   ParameterModel parameterModel;
  //   var data = {
  //     "parameter_type": SystemParam.parameterTypeGender,
  //     "company_id": widget.user.companyId
  //   };

  //   var response = await RestService()
  //       .restRequestService(SystemParam.fParameterByType, data);

  //   setState(() {
  //     parameterModel = parameterModelFromJson(response.body.toString());
  //     genderList = parameterModel.data;
  //     itemsGender.add(DropdownItem.getItemParameter(
  //         SystemParam.defaultValueOptionId,
  //         SystemParam.defaultValueOptionDesc));
  //     for (var i = 0; i < genderList.length; i++) {
  //       itemsGender.add(DropdownItem.getItemParameter(
  //           genderList[i].id, genderList[i].parameterValue));
  //     }

  //     loading = false;
  //   });
  // }

  initParameterGenderDB() async {
    db.getParameterListByType(SystemParam.parameterTypeGender).then((value) {
      setState(() {
        itemsGender.clear();
        genderList = <Parameter>[];
        genderList = value;
        itemsGender.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < genderList.length; i++) {
          itemsGender.add(DropdownItem.getItemParameter(
              genderList[i].id, genderList[i].parameterValue));

          if (widget.workplan.genderId != null &&
              genderList[i].id == widget.workplan.genderId) {
            genderValue = widget.workplan.genderId;
          }
        }

        if (widget.workplan.genderId != null &&
            genderList.contains(widget.workplan.genderId)) {
          genderValue = widget.workplan.genderId;
        }
      });
    });
  }

  void initParameterMaritalStatus() async {
    maritalStatusList = <Parameter>[];
    itemsMaritalStatus.clear();
    loading = true;
    ParameterModel parameterModel;
    var data = {
      "parameter_type": SystemParam.parameterTypeMaritalStatus,
      "company_id": widget.user.userCompanyId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fParameterByTypeCompanyId, data);

    setState(() {
      parameterModel = parameterModelFromJson(response.body.toString());
      maritalStatusList = parameterModel.data;
      itemsMaritalStatus.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < maritalStatusList.length; i++) {
        itemsMaritalStatus.add(DropdownItem.getItemParameter(
            maritalStatusList[i].id, maritalStatusList[i].parameterValue));
      }

      loading = false;
    });
  }

  initParameterUsahaDB() async {
    db.getParameterUsahaList().then((value) {
      setState(() {
        parameterUsahaList = <ParameterUsaha>[];
        itemsParameterUsaha.clear();
        parameterUsahaList = value;
        itemsParameterUsaha.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < parameterUsahaList.length; i++) {
          itemsParameterUsaha.add(DropdownItem.getItemParameter(
              parameterUsahaList[i].id, parameterUsahaList[i].description));

          if (widget.workplan.jenisUsahaId != null &&
              parameterUsahaList[i].id == widget.workplan.jenisUsahaId) {
            parameterUsahaValue = widget.workplan.jenisUsahaId;
          }
        }

        if (widget.workplan.jenisUsahaId != null &&
            parameterUsahaList.contains(widget.workplan.jenisUsahaId)) {
          parameterUsahaValue = widget.workplan.jenisUsahaId;
        }
      });
    });
  }

  void initParameterUsaha() async {
    parameterUsahaList = <ParameterUsaha>[];
    itemsParameterUsaha.clear();
    loading = true;
    ParameterUsahaModel parameterUsahaModel;
    var data = {"company_id": widget.user.userCompanyId};

    var response = await RestService()
        .restRequestService(SystemParam.fParameterUsaha, data);

    setState(() {
      parameterUsahaModel =
          parameterUsahaModelFromJson(response.body.toString());
      parameterUsahaList = parameterUsahaModel.data;
      itemsParameterUsaha.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < parameterUsahaList.length; i++) {
        itemsParameterUsaha.add(DropdownItem.getItemParameter(
            parameterUsahaList[i].id, parameterUsahaList[i].description));
      }

      loading = false;
    });
  }

  void initParameterUdfOptionDBB1() async {
    db.getParameterUdfOption1ByUdfId(udfDDlB1).then((value) {
      setState(() {
        loading = true;
        itemsParameterUdfOption1.clear();
        parameterUdfOption1List = <ParameterUdfOption>[];
        parameterUdfOption1List = value;
        itemsParameterUdfOption1.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < parameterUdfOption1List.length; i++) {
          itemsParameterUdfOption1.add(DropdownItem.getItemParameter(
              parameterUdfOption1List[i].id,
              parameterUdfOption1List[i].optionDescription));

          if (widget.workplan.udfDdlB1 != null &&
              parameterUdfOption1List[i].id == widget.workplan.udfDdlB1) {
            parameterUdfOption1Value = widget.workplan.udfDdlB1;
          }
        }

        loading = false;

        if (widget.workplan.udfDdlB1 != null &&
            parameterUdfOption1List.contains(widget.workplan.udfDdlB1)) {
          parameterUdfOption1Value = widget.workplan.udfDdlB1;
        }

        // if (widget.workplan.udfDdlB2 != null) {
        //   parameterUdfOption2Value = widget.workplan.udfDdlB2;
        // }
      });
    });
  }

  void initParameterUdfOptionDBB2() async {
    db.getParameterUdfOption1ByUdfId(udfDDlB2).then((value) {
      setState(() {
        loading = true;
        parameterUdfOption2List = <ParameterUdfOption>[];
        itemsParameterUdfOption2.clear();
        parameterUdfOption2List = value;
        itemsParameterUdfOption2.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < parameterUdfOption2List.length; i++) {
          itemsParameterUdfOption2.add(DropdownItem.getItemParameter(
              parameterUdfOption2List[i].id,
              parameterUdfOption2List[i].optionDescription));

          if (widget.workplan.udfDdlB2 != null &&
              parameterUdfOption2List[i].id == widget.workplan.udfDdlB2) {
            parameterUdfOption2Value = widget.workplan.udfDdlB2;
          }
        }

        loading = false;

        if (widget.workplan.udfDdlB2 != null &&
            parameterUdfOption1List.contains(widget.workplan.udfDdlB2)) {
          parameterUdfOption2Value = widget.workplan.udfDdlB2;
        }

        // if (widget.workplan.udfDdlB2 != null) {
        //   parameterUdfOption2Value = widget.workplan.udfDdlB2;
        // }
      });
    });
  }

  // void initParameterUdfB1() async {
  //   parameterUdfOption1List = <ParameterUdfOption>[];
  //   itemsParameterUdfOption1.clear();
  //   loading = true;
  //   ParameterUdfOptionModel parameterModel;
  //   var data = {"company_id": widget.user.companyId, "udf_id": udfDDlB1};

  //   var response = await RestService()
  //       .restRequestService(SystemParam.fParameterUdfOption1, data);

  //   setState(() {
  //     parameterModel =
  //         parameterUdfOptionModelFromJson(response.body.toString());
  //     parameterUdfOption1List = parameterModel.data;
  //     itemsParameterUdfOption1.add(DropdownItem.getItemParameter(
  //         SystemParam.defaultValueOptionId,
  //         SystemParam.defaultValueOptionDesc));
  //     for (var i = 0; i < parameterUdfOption1List.length; i++) {
  //       itemsParameterUdfOption1.add(DropdownItem.getItemParameter(
  //           parameterUdfOption1List[i].id,
  //           parameterUdfOption1List[i].optionDescription));
  //     }
  //     loading = false;
  //   });
  // }

  // void initParameterUdfB2() async {
  //   parameterUdfOption2List = <ParameterUdfOption>[];
  //   itemsParameterUdfOption2.clear();
  //   loading = true;
  //   ParameterUdfOptionModel parameterModel;
  //   var data = {"company_id": widget.user.companyId, "udf_id": udfDDlB2};

  //   var response = await RestService()
  //       .restRequestService(SystemParam.fParameterUdfOption1, data);

  //   setState(() {
  //     parameterModel =
  //         parameterUdfOptionModelFromJson(response.body.toString());
  //     parameterUdfOption2List = parameterModel.data;
  //     itemsParameterUdfOption2.add(DropdownItem.getItemParameter(
  //         SystemParam.defaultValueOptionId,
  //         SystemParam.defaultValueOptionDesc));
  //     for (var i = 0; i < parameterUdfOption2List.length; i++) {
  //       itemsParameterUdfOption2.add(DropdownItem.getItemParameter(
  //           parameterUdfOption2List[i].id,
  //           parameterUdfOption2List[i].optionDescription));
  //     }
  //     loading = false;
  //   });
  // }

  void saveData() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        saveDataOnline();
      }
    } on SocketException catch (_) {
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
  }

  void getLableUdf() {
    Future<ParameterUdf> parameterUdfTextB1 =
        db.getParameterUdfByName(labelUdfTextB1);
    parameterUdfTextB1.then((data) {
      setState(() {
        labelUdfTextB1 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfTextB2 =
        db.getParameterUdfByName(labelUdfTextB2);
    parameterUdfTextB2.then((data) {
      setState(() {
        labelUdfTextB2 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfNumB1 =
        db.getParameterUdfByName(labelUdfNumB1);
    parameterUdfNumB1.then((data) {
      setState(() {
        labelUdfNumB1 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfNumB2 =
        db.getParameterUdfByName(labelUdfNumB2);
    parameterUdfNumB2.then((data) {
      setState(() {
        labelUdfNumB2 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfDateB1 =
        db.getParameterUdfByName(labelUdfDateB1);
    parameterUdfDateB1.then((data) {
      setState(() {
        labelUdfDateB1 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfDateB2 =
        db.getParameterUdfByName(labelUdfDateB2);
    parameterUdfDateB2.then((data) {
      setState(() {
        labelUdfDateB2 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfDdlB1 =
        db.getParameterUdfByName(labelUdfDDLB1);
    parameterUdfDdlB1.then((data) {
      setState(() {
        labelUdfDDLB1 = data.udfDescription;
        udfDDlB1 = data.id;
        initParameterUdfOptionDBB1();
      });
    });

    Future<ParameterUdf> parameterUdfDdlB2 =
        db.getParameterUdfByName(labelUdfDDLB2);
    parameterUdfDdlB2.then((data) {
      setState(() {
        labelUdfDDLB2 = data.udfDescription;
        udfDDlB2 = data.id;
        initParameterUdfOptionDBB2();
      });
    });
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

  initParameterMaritalStatusDB() async {
    db
        .getParameterListByType(SystemParam.parameterTypeMaritalStatus)
        .then((value) {
      setState(() {
        maritalStatusList = <Parameter>[];
        itemsMaritalStatus.clear();
        maritalStatusList = value;
        itemsMaritalStatus.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < maritalStatusList.length; i++) {
          itemsMaritalStatus.add(DropdownItem.getItemParameter(
              maritalStatusList[i].id, maritalStatusList[i].parameterValue));
          if (widget.workplan.maritalStatusId != null &&
              maritalStatusList[i].id == widget.workplan.maritalStatusId) {
            maritalStatusValue = widget.workplan.maritalStatusId;
          }
        }

        if (widget.workplan.maritalStatusId != null &&
            maritalStatusList.contains(widget.workplan.maritalStatusId)) {
          maritalStatusValue = widget.workplan.maritalStatusId;
        }
      });
    });
  }

  void saveDataOnline() async {
    var data = {
      "id": widget.workplan.id,
      "lama_usaha": _lamaUsahaCtr.text,
      "jenis_usaha_id": parameterUsahaValue,
      "npwp": _npwpCtr.text,
      "identity_card_no": _identityCardNoCtr.text,
      "marital_status_id": maritalStatusValue,
      "gender_id": genderValue,
      // ignore: unnecessary_null_comparison
      "date_of_birth": _dateOfBirthValue,
      "place_of_birth": _placeOfBirthCtr.text,
      "alamat": _alamatCtr.text,
      "phone": _phoneCtr.text,
      "kecamatan": _kecamatanCtr.text,
      "kabupaten": _kabupatenCtr.text,
      "kelurahan": _kelurahanCtr.text,
      "kodepos": _kodePosCtr.text,
      "updated_by": widget.user.id,
      "udf_text_b1": _udfTextB1Ctr.text,
      "udf_num_b1": _udfNumB1Ctr.text,
      "udf_ddl_b1": parameterUdfOption1Value,
      // ignore: unnecessary_null_comparison
      "udf_date_b1": _udfDateB1Value,
      "udf_text_b2": _udfTextB2Ctr.text,
      "udf_num_b2": _udfNumB2Ctr.text,
      "udf_ddl_b2": parameterUdfOption2Value,
      // ignore: unnecessary_null_comparison
      "udf_date_b2": _udfDateB2Value,
      // "company_id":widget.user.companyId
    };

    print(data);

    var response = await RestService()
        .restRequestService(SystemParam.fWorkplanPersonalUpdate, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];
    // print(status);

    if (code == "0") {
      getWorkplanById();
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
    _workplan.lamaUsaha = _lamaUsahaCtr.text;
    _workplan.jenisUsahaId = parameterUsahaValue;
    _workplan.npwp = _npwpCtr.text;
    _workplan.identityCardNo = _identityCardNoCtr.text;
    _workplan.maritalStatusId = maritalStatusValue;
    _workplan.genderId = genderValue;
    _workplan.dateOfBirth = _dateOfBirthValue;
    _workplan.placeOfBirth = _placeOfBirthCtr.text;
    _workplan.personalAlamat = _alamatCtr.text;
    _workplan.phone = _phoneCtr.text;
    _workplan.personalKecamatan = _kecamatanCtr.text;
    _workplan.personalKabupaten = _kecamatanCtr.text;
    _workplan.personalKelurahan = _kelurahanCtr.text;
    _workplan.personalKodepos = _kodePosCtr.text;
    _workplan.udfTextB1 = _udfTextB1Ctr.text;
    _workplan.udfNumB1 = _udfNumB1Ctr.text;
    _workplan.udfDdlB1 = parameterUdfOption1Value;
    _workplan.udfDateB1 = _udfDateB1Value;
    _workplan.udfTextB2 = _udfTextB2Ctr.text;
    _workplan.udfNumB2 = _udfNumB2Ctr.text;
    _workplan.udfDdlB2 = parameterUdfOption2Value;
    _workplan.udfDateB2 = _udfDateB2Value;
    _workplan.flagUpdatePersonal = 1;

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
              workplan: _workplan,
              user: widget.user,
              isMaximumUmur: widget.isMaximumUmur),
        ));
  }

  void updateWorkplanData() async {
    await db.getWorkplanActivityUpdatePersonal().then((value) async {
      print(value.length);
      if (null != value && value.length > 0) {
        // var jsonData = value;
        //print(jsonData);

        //var data = {"worklan_personal_list": jsonEncode(value)};
        var data = {
          "worklan_personal_list":
              List<dynamic>.from(value.map((x) => x.toJson()))
        };
        // print(data);
        var respons = await RestService()
            .restRequestService(SystemParam.fWorkplanPersonalUpdateList, data);
        print("fWorkplanPersonalUpdateList :" + respons.body.toString());
      }
    });
  }
}
