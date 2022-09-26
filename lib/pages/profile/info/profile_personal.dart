import 'dart:convert';

//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/dropdown_item.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/parameter_model.dart';
import 'package:workplan_beta_test/model/personal_family_model.dart';
import 'package:workplan_beta_test/model/personal_info_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/info/profile_family_edit.dart';
import 'package:workplan_beta_test/pages/profile/profile_page.dart';

class ProfilePersonal extends StatefulWidget {
  // final
  final User user;
  final PersonalInfoProfilData profile;

  //const SkillEditLanguage({ Key? key }) : super(key: key);

  const ProfilePersonal({Key? key, required this.user, required this.profile})
      : super(key: key);

  @override
  _ProfilePersonalState createState() => _ProfilePersonalState();
}

class _ProfilePersonalState extends State<ProfilePersonal> {
  // late String _valGender;
  // List _listGender = ["Male","Female"];  //Array gender
  final _keyForm = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  // var userId = 1;
  bool enabled = true;
  bool loading = false;
  // late PersonalInfoProfilData widget.personalInfoProfilData;
  // ignore: avoid_init_to_null
  // var dateOfBirthday = null;
  // DateTime? dateOfBirthday;

  TextEditingController _nama = TextEditingController();
  TextEditingController _nama2 = TextEditingController();
  TextEditingController _nama3 = TextEditingController();
  String _dateOfBirthValue = "";
  TextEditingController _taxnumber = TextEditingController();
  TextEditingController _taxaddress = TextEditingController();
  TextEditingController _identityCardNumber = TextEditingController();
  TextEditingController _identityCardAddress = TextEditingController();
  TextEditingController _placebirthday = TextEditingController();

  TextEditingController _heightCtrl = TextEditingController();
  TextEditingController _weightCtrl = TextEditingController();
  TextEditingController _sickHistoryCtrl = TextEditingController();
  // TextEditingController _birthDateCtrl  = TextEditingController();
//  late List<Parameter> genderList;
  late List<Parameter> genderList;
  List<DropdownMenuItem<int>> itemsGender = <DropdownMenuItem<int>>[];
  int genderValue = SystemParam.defaultValueOptionId;

  late List<Parameter> maritalStatusList;
  List<DropdownMenuItem<int>> itemsMaritalStatus = <DropdownMenuItem<int>>[];
  int maritalStatusValue = SystemParam.defaultValueOptionId;

  late List<Parameter> religionList;
  List<DropdownMenuItem<int>> itemsReligion = <DropdownMenuItem<int>>[];
  int religionValue = SystemParam.defaultValueOptionId;

  late List<Parameter> nationalityList;
  List<DropdownMenuItem<int>> itemsNationality = <DropdownMenuItem<int>>[];
  int nationalityValue = SystemParam.defaultValueOptionId;

  late List<Parameter> bloodGroupList;
  List<DropdownMenuItem<int>> itemsBloodGroup = <DropdownMenuItem<int>>[
    DropdownMenuItem(
      value: 1,
      child: Text('A',style: TextStyle(fontSize: 14, color: Colors.black)),
    ),
    DropdownMenuItem(
      value: 2,
      child: Text('B',style: TextStyle(fontSize: 14, color: Colors.black)),
    ),
    DropdownMenuItem(
      value: 3,
      child: Text('AB',style: TextStyle(fontSize: 14, color: Colors.black)),
    ),
    DropdownMenuItem(
      value: 4,
      child: Text('O',style: TextStyle(fontSize: 14, color: Colors.black)),
    )
  ];
  int bloodGroupValue = SystemParam.defaultValueOptionId;

  int familyCount = 0;
  List<FamilyData> familyList = <FamilyData>[];

  var _radioIsUseGlasses = "0";
  String _useGlasses = "1";
  String _noUseGlasses = "0";

  @override
  void initState() {
    super.initState();

    loading = true;
    _radioIsUseGlasses = "0";

    getFamilyList();
    initParameterGender();
    initParameterMaritalStatus();
    initParameterReligion();
    initParameterNationality();
    // initParameterBloodGroup();
    // getMyPersonal();
    initPersonalData();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          //  Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  user: widget.user,
                ),
              ));
          return false;
        },
        child: Scaffold(
            //drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              title: Text('Personal'),
              centerTitle: true,
              backgroundColor: SystemParam.colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          user: widget.user,
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
                        Form(
                          key: _keyForm,
                          // autovalidate: false,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Basic Info",
                                        style: TextStyle(
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            color: SystemParam.colorCustom,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Nama Depan',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: new TextStyle(color: Colors.black),
                                    controller: _nama,
                                    //initialValue: "",
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.person),
                                      fillColor: SystemParam.colorCustom,
                                      //labelText: "Nama Depan",
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
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Nama Tengah',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: new TextStyle(color: Colors.black),
                                    controller: _nama2,
                                    //initialValue: "",
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.person),
                                      fillColor: SystemParam.colorCustom,
                                      //labelText: "Nama Tengah",
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
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Nama Belakang',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: new TextStyle(color: Colors.black),
                                    controller: _nama3,
                                    //initialValue: "",
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.person),
                                      fillColor: SystemParam.colorCustom,
                                      //labelText: "Nama Belakang",
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
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Jenis Kelamin',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                  // child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.person),
                                      //errorText: "this field is required",
                                      fillColor: SystemParam.colorCustom,
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
                                    // validator: (value) {
                                    //   print("validaor select:" + value.toString());
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
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Tempat Lahir',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: new TextStyle(color: Colors.black),
                                    controller: _placebirthday,
                                    //initialValue: widget.datum.writtingScore.toString(),
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.create_outline),
                                      fillColor: SystemParam.colorCustom,
                                      //labelText: "Tempat Lahir",
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
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Tanggal Lahir',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                    initialValue: widget.profile.dateOfBirthday,
                                    enabled: enabled,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    onSaved: (valueDate) {
                                      _dateOfBirthValue = SystemParam
                                          .formatDateValue
                                          .format(valueDate!);
                                    },
                                    onChanged: (valueDate) {
                                      _dateOfBirthValue = SystemParam
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
                                              SystemParam.strFormatDateHint
                                          );
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: new Icon(Icons.date_range),
                                      fillColor: SystemParam.colorCustom,
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
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: DateTimeField(
                                //     initialValue: widget.profile.dateOfBirthday,
                                //     enabled: enabled,
                                //     autovalidateMode:
                                //         AutovalidateMode.onUserInteraction,
                                //     onSaved: (valueDate) {
                                //       _dateOfBirthValue = SystemParam
                                //           .formatDateValue
                                //           .format(valueDate!);
                                //     },
                                //     onChanged: (valueDate) {
                                //       _dateOfBirthValue = SystemParam
                                //           .formatDateValue
                                //           .format(valueDate!);
                                //     },

                                //     format: SystemParam.formatDateDisplay,
                                //     onShowPicker: (context, currentValue) {
                                //       return showDatePicker(
                                //           context: context,
                                //           firstDate:
                                //               DateTime(SystemParam.firstDate),
                                //           initialDate:
                                //               currentValue ?? DateTime.now(),
                                //           lastDate:
                                //               DateTime(SystemParam.lastDate),
                                //           fieldHintText:
                                //               SystemParam.strFormatDateHint);
                                //     },
                                //     decoration: InputDecoration(
                                //       suffixIcon: new Icon(Icons.date_range),
                                //       fillColor: SystemParam.colorCustom,
                                //       labelStyle: TextStyle(
                                //           color: SystemParam.colorCustom,
                                //           fontStyle: FontStyle.italic),
                                //       enabledBorder: OutlineInputBorder(
                                //           borderSide: BorderSide(
                                //               color: SystemParam.colorCustom),
                                //           borderRadius: BorderRadius.all(
                                //               Radius.circular(10))),
                                //       focusedBorder: OutlineInputBorder(
                                //           borderSide: BorderSide(
                                //               color: SystemParam.colorCustom),
                                //           borderRadius: BorderRadius.all(
                                //               Radius.circular(10))),
                                //       contentPadding: EdgeInsets.all(10),
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Agama',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                  // child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.person),
                                      //errorText: "this field is required",
                                      fillColor: SystemParam.colorCustom,
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
                                    // validator: (value) {
                                    //   if (value == 0 || value == null) {
                                    //     return "this field is required";
                                    //   }
                                    //   return null;
                                    // },
                                    value: religionValue,
                                    items: itemsReligion,
                                    onChanged: !enabled
                                        ? null
                                        : (object) {
                                            setState(() {
                                              // genderSelected = object!;
                                              religionValue = object!;
                                            });
                                          },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Status Pernikahan',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                  // child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.person),
                                      //errorText: "this field is required",
                                      fillColor: SystemParam.colorCustom,
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
                                    // validator: (value) {
                                    //   // print("validaor select:" + value.toString());
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
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Kewarganegaraan',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                  // child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.person),
                                      //errorText: "this field is required",
                                      fillColor: SystemParam.colorCustom,
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
                                    // validator: (value) {
                                    //   // print("validaor select:" + value.toString());
                                    //   // ignore: unrelated_type_equality_checks
                                    //   if (value == 0 || value == null) {
                                    //     return "this field is required";
                                    //   }
                                    //   return null;
                                    // },
                                    value: nationalityValue,
                                    items: itemsNationality,
                                    onChanged: !enabled
                                        ? null
                                        : (object) {
                                            setState(() {
                                              // genderSelected = object!;
                                              nationalityValue = object!;
                                            });
                                          },
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Identitas",
                                        style: TextStyle(
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            color: SystemParam.colorCustom,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Nomor KTP',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    style: new TextStyle(color: Colors.black),
                                    controller: _identityCardNumber,
                                    //initialValue: widget.datum.writtingScore.toString(),
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.card),
                                      fillColor: SystemParam.colorCustom,
                                      //labelText: "KTP",
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
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Nomor NPWP',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    style: new TextStyle(color: Colors.black),
                                    controller: _taxnumber,
                                    inputFormatters: [
                                      SystemParam.maskFormatterNPWP
                                    ],
                                    //initialValue: widget.datum.writtingScore.toString(),
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.document),
                                      fillColor: SystemParam.colorCustom,
                                      //labelText: "NPWP",
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
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Kesehatan",
                                        style: TextStyle(
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            color: SystemParam.colorCustom,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Golongan Darah',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                  // child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.person),
                                      //errorText: "this field is required",
                                      fillColor: SystemParam.colorCustom,
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
                                    // validator: (value) {
                                    //   // print("validaor select:" + value.toString());
                                    //   // ignore: unrelated_type_equality_checks
                                    //   if (value == 0 || value == null) {
                                    //     return "this field is required";
                                    //   }
                                    //   return null;
                                    // },
                                    value: bloodGroupValue,
                                    items: itemsBloodGroup,
                                    onChanged: !enabled
                                        ? null
                                        : (object) {
                                            setState(() {
                                              // genderSelected = object!;
                                              bloodGroupValue = object!;
                                            });
                                          },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Memakai Kacamata',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Radio(
                                        value: _noUseGlasses,
                                        groupValue: _radioIsUseGlasses,
                                        onChanged: (em) {
                                          // if (em != null) {
                                          setState(() {
                                            _radioIsUseGlasses = _noUseGlasses;
                                          });
                                          // }
                                        },
                                      ),
                                      new Text(
                                        'Tidak',
                                        style: new TextStyle(fontSize: 16.0),
                                      ),
                                      new Radio(
                                        value: _useGlasses,
                                        groupValue: _radioIsUseGlasses,
                                        onChanged: (em) {
                                          // if (em != null) {
                                          setState(() {
                                            _radioIsUseGlasses = _useGlasses;
                                          });
                                          // }
                                        },
                                      ),
                                      new Text(
                                        'Ya',
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Tinggi Badan',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    style: new TextStyle(color: Colors.black),
                                    controller: _heightCtrl,
                                    //initialValue: widget.datum.writtingScore.toString(),
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.document),
                                      fillColor: SystemParam.colorCustom,
                                      //labelText: "Tax Address",
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
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Berat Badan',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    style: new TextStyle(color: Colors.black),
                                    controller: _weightCtrl,
                                    //initialValue: widget.datum.writtingScore.toString(),
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.document),
                                      fillColor: SystemParam.colorCustom,
                                      //labelText: "Tax Address",
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
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Riwayat Penyakit',
                                            style: TextStyle(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                color: SystemParam.colorCustom,
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
                                    keyboardType: TextInputType.text,
                                    maxLines: 2,
                                    textInputAction: TextInputAction.next,
                                    style: new TextStyle(color: Colors.black),
                                    controller: _sickHistoryCtrl,
                                    //initialValue: widget.datum.writtingScore.toString(),
                                    readOnly: false,
                                    // validator: validasiUsername,
                                    onSaved: (em) {
                                      if (em != null) {}
                                    },
                                    decoration: InputDecoration(
                                      //icon: new Icon(Ionicons.document),
                                      fillColor: SystemParam.colorCustom,
                                      //labelText: "Tax Address",
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
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Card(
                                      // color: WorkplanPallete.grey200,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Keluarga",
                                              style: TextStyle(
                                                  color:
                                                      SystemParam.colorCustom,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileFamilyEdit(
                                                              user: widget.user,
                                                              familyId: 0,
                                                              profileInfo:
                                                                  widget
                                                                      .profile,
                                                            )));
                                              },
                                              child: Icon(
                                                Icons.add,
                                                size: 37,
                                              ),
                                            )),
                                      ])),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: new Container(
                                    child: createListViewFamily(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: SystemParam.colorCustom,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      child: Text("UPDATE"),
                                      onPressed: () {
                                        saveData();
                                      },
                                      //color: SystemParam.SystemParam.colorCustom,
                                      // textColor: Colors.white,
                                      //color: Colors.white20,
                                      //color: Colors.white20[500],
                                      // textColor: Colors.white,
                                      // shape: RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.circular(10)),
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

  // void initParameterGender() async {
  //   loading = true;
  //   ParameterModel parameterModel;
  //   var data = {
  //     "parameter_type": SystemParam.paramTypeGender,
  //     "company_id": widget.user.userCompanyId
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

  //     //loading = false;
  //   });
  // }

  void saveData() async {
    //urlWorkplanInboxUpdate
//var userId = 1;

    var data = {
      "id": widget.profile.id,
      "first_name": _nama.text,
      "middle_name": _nama2.text,
      "last_name": _nama3.text,
      "gender": genderValue == 0 ? null : genderValue,
      "religion": religionValue == 0 ? null : religionValue,
      "nationality": nationalityValue == 0 ? null : nationalityValue,
      "tax_number": _taxnumber.text,
      "tax_address": _taxaddress.text,
      "identity_card_number": _identityCardNumber.text,
      "identity_card_address": _identityCardAddress.text,
      "blood_group": bloodGroupValue == 0 ? null : bloodGroupValue,
      "status": maritalStatusValue == 0 ? null : maritalStatusValue,
      "date_of_birthday": _dateOfBirthValue == "" ? null : _dateOfBirthValue,
      "place_of_birthday": _placebirthday.text,
      "is_use_glasses": _radioIsUseGlasses,
      "weight": _weightCtrl.text == "" ? null : _weightCtrl.text,
      "height": _heightCtrl.text == "" ? null : _heightCtrl.text,
      "sick_history": _sickHistoryCtrl.text
    };

    print(data);

    var response = await RestService()
        .restRequestService(SystemParam.fPersonalInfoUpdate, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];

    if (code == "0") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(user: widget.user)));

      Fluttertoast.showToast(
          msg: "Update Data Berhasil",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: SystemParam.colorCustom,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print(status);
      Fluttertoast.showToast(
          msg: "Mohon Maaf, Anda Gagal Update Data :",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void initParameterGender() async {
    itemsGender.clear();
    genderList = <Parameter>[];
    //loading = true;
    ParameterModel parameterModel;
    var data = {
      "parameter_type": SystemParam.parameterTypeGender,
      "company_id": widget.user.userCompanyId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fParameterByTypeCompanyId, data);

    setState(() {
      parameterModel = parameterModelFromJson(response.body.toString());
      genderList = parameterModel.data;
      itemsGender.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < genderList.length; i++) {
        itemsGender.add(DropdownItem.getItemParameter(
            genderList[i].id, genderList[i].parameterValue));
      }

      //loading = false;
    });
  }

  void initParameterMaritalStatus() async {
    maritalStatusList = <Parameter>[];
    itemsMaritalStatus.clear();
    // loading = true;
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

      //loading = false;
    });
  }

  void initParameterReligion() async {
    itemsReligion.clear();
    religionList = <Parameter>[];
    //loading = true;
    ParameterModel parameterModel;
    var data = {
      "parameter_type": SystemParam.parameterTypeReligion,
      "company_id": widget.user.userCompanyId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fParameterByTypeCompanyId, data);

    setState(() {
      parameterModel = parameterModelFromJson(response.body.toString());
      religionList = parameterModel.data;
      itemsReligion.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < religionList.length; i++) {
        itemsReligion.add(DropdownItem.getItemParameter(
            religionList[i].id, religionList[i].parameterValue));
      }

      //loading = false;
    });
  }

  void initParameterNationality() async {
    itemsNationality.clear();
    nationalityList = <Parameter>[];
    //loading = true;
    ParameterModel parameterModel;
    var data = {
      "parameter_type": SystemParam.parameterTypeNationality,
      "company_id": widget.user.userCompanyId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fParameterByTypeCompanyId, data);

    setState(() {
      parameterModel = parameterModelFromJson(response.body.toString());
      nationalityList = parameterModel.data;
      itemsNationality.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < nationalityList.length; i++) {
        itemsNationality.add(DropdownItem.getItemParameter(
            nationalityList[i].id, nationalityList[i].parameterValue));
      }

      //loading = false;
    });
  }

  void initParameterBloodGroup() async {
    itemsBloodGroup.clear();
    bloodGroupList = <Parameter>[];
    //loading = true;
    ParameterModel parameterModel;
    var data = {
      "parameter_type": SystemParam.parameterTypeBlood,
      "company_id": widget.user.userCompanyId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fParameterByTypeCompanyId, data);

    setState(() {
      parameterModel = parameterModelFromJson(response.body.toString());
      bloodGroupList = parameterModel.data;
      itemsBloodGroup.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < bloodGroupList.length; i++) {
        itemsBloodGroup.add(DropdownItem.getItemParameter(
            bloodGroupList[i].id, bloodGroupList[i].parameterValue));
      }

      //loading = false;
    });
  }

  void initPersonalData() {
    genderValue = widget.profile.gender;
    maritalStatusValue = widget.profile.status;
    // ignore: unnecessary_null_comparison
    if (widget.profile.dateOfBirthday != null) {
      _dateOfBirthValue =
          SystemParam.formatDateValue.format(widget.profile.dateOfBirthday);
      // dateOfBirthday = widget.personalInfoProfilData.dateOfBirthday;
      // _birthDateCtrl.text = _dateOfBirthValue;

    }
    //dateOfBirthday = widget.personalInfoProfilData.dateOfBirthday;

    _placebirthday.text = widget.profile.placeOfBirthday;
    // ignore: unnecessary_null_comparison
    if (widget.profile.isUseGlasses != null ||
        widget.profile.isUseGlasses != "") {
      _radioIsUseGlasses = widget.profile.isUseGlasses;
    }

    _nama.text = widget.profile.firstName;
    _nama2.text = widget.profile.middleName;
    _nama3.text = widget.profile.lastName;
    _taxnumber.text = widget.profile.taxNumber;
    _taxaddress.text = widget.profile.taxAddress;
    _identityCardNumber.text = widget.profile.identityCardNumber;
    _identityCardAddress.text = widget.profile.identityCardAddress;
    _sickHistoryCtrl.text = widget.profile.sickHistory;
    // ignore: unnecessary_null_comparison
    if (widget.profile.weight != null) {
      _weightCtrl.text = widget.profile.weight.toString();
    }

    // ignore: unnecessary_null_comparison
    if (widget.profile.height != null) {
      _heightCtrl.text = widget.profile.height.toString();
    }

    bloodGroupValue = widget.profile.bloodGroup;
    nationalityValue = widget.profile.nationality;
    religionValue = widget.profile.religion;
  }

  void getFamilyList() async {
    loading = true;
    var data = {
      "user_id": widget.user.id,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fPersonalFamilyByUserId, data);

    setState(() {
      PersonalFamilyModel model =
          personalFamilyModelFromJson(response.body.toString());
      familyCount = model.data.length;
      familyList = model.data;

      loading = false;
    });
  }

  ListView createListViewFamily() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: familyCount,
      itemBuilder: (BuildContext context, int index) {
        return customListItemFamily(
          familyList[index],
        );
      },
    );
  }

  customListItemFamily(FamilyData we) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                  child: Text(
                    // ignore: unnecessary_null_comparison
                    we.familyName == null ? "" : we.familyName,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                //Icon(Icons.edit),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileFamilyEdit(
                                          user: widget.user,
                                          familyId: we.id,
                                          profileInfo: widget.profile,
                                        )));
                          },
                          child: Icon(Icons.edit_rounded)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            showDeleteDialog(context, we.id);
                          },
                          child: Icon(Icons.delete_forever)),
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                  child: Text(
                    // ignore: unnecessary_null_comparison
                    we.familyRelationship == null ? "" : we.familyRelationship,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 8.0),
              child: Text(
                we.dateOfBirth == null
                    ? ""
                    : SystemParam.formatDateDisplay.format(we.dateOfBirth),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
          ])),
    );
  }

  showDeleteDialog(BuildContext context, int familyId) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        primary: Colors.green,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue"),
      // style: Elevate,
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          primary: Colors.red),
      onPressed: () {
        updateStatusFamily(familyId);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi Hapus"),
      content: Text("Anda yakin menghapus data ini ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void updateStatusFamily(familyId) async {
    var data = {
      "id": familyId,
      "updated_by": widget.user.id,
      "status": 0,
    };

    // print(data);

    String function = SystemParam.fPersonalFamilyUpdateStatus;
    var response = await RestService().restRequestService(function, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];
    // print(status);

    if (code == "0") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePersonal(
                    user: widget.user,
                    profile: widget.profile,
                  )));
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
}
