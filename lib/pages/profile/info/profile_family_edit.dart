import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/personal_family_model.dart';
import 'package:workplan_beta_test/model/personal_info_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/info/profile_personal.dart';

class ProfileFamilyEdit extends StatefulWidget {
  final User user;
  final PersonalInfoProfilData profileInfo;
  final int familyId;

  const ProfileFamilyEdit(
      {Key? key,
      required this.user,
      required this.profileInfo,
      required this.familyId})
      : super(key: key);

  @override
  _ProfileFamilyEditState createState() => _ProfileFamilyEditState();
}

class _ProfileFamilyEditState extends State<ProfileFamilyEdit> {
  bool loading = false;
  final _keyForm = GlobalKey<FormState>();
  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');
  TextEditingController _familyNameCtrl = new TextEditingController();
  TextEditingController _relationCtrl = new TextEditingController();
  String _dateOfBirthValueStr = "";
  dynamic _dateOfBirthValue;

  // late PersonalCertificate  certificate;

  @override
  void initState() {
    super.initState();

    if (widget.familyId != 0) {
      getFamily();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          //  Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePersonal(
                        user: widget.user,
                        profile: widget.profileInfo,
                      )));
          return false;
        },
        child: Scaffold(
            //drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              title: Text('Keluarga Add/ Edit'),
              centerTitle: true,
              backgroundColor: SystemParam.colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePersonal(
                                user: widget.user,
                                profile: widget.profileInfo,
                              )));
                },
              ),
            ),
            body: loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Form(
                    key: _keyForm,
                    // autovalidateMode: ,
                    // autovalidate: false,
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Nama',
                                    style: TextStyle(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: SystemParam.colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: '* ',
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
                            textInputAction: TextInputAction.next,
                            style: new TextStyle(color: Colors.black),
                            controller: _familyNameCtrl,
                            readOnly: false,
                            validator: requiredValidator,
                            onSaved: (em) {
                              if (em != null) {}
                            },
                            decoration: InputDecoration(
                              fillColor: SystemParam.colorCustom,
                              labelStyle: TextStyle(
                                  color: SystemParam.colorCustom,
                                  fontStyle: FontStyle.italic),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
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
                                    text: 'Hubungan keluarga',
                                    style: TextStyle(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: SystemParam.colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: '* ',
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
                            textInputAction: TextInputAction.next,
                            style: new TextStyle(color: Colors.black),
                            controller: _relationCtrl,
                            readOnly: false,
                            validator: requiredValidator,
                            onSaved: (em) {
                              if (em != null) {}
                            },
                            decoration: InputDecoration(
                              fillColor: SystemParam.colorCustom,
                              labelStyle: TextStyle(
                                  color: SystemParam.colorCustom,
                                  fontStyle: FontStyle.italic),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
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
                                    text: 'Tanggal Lahir',
                                    style: TextStyle(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: SystemParam.colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: ' * ',
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
                          child: widget.familyId == 0
                              ? DateTimeField(
                                  //initialValue: _mulaiValue ?? DateTime.now(),
                                  validator: (value) {
                                    if (value == null) {
                                      return "this field is required";
                                    }
                                    return null;
                                  },
                                  onSaved: (valueDate) {
                                    _dateOfBirthValueStr = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                  },
                                  onChanged: (valueDate) {
                                    _dateOfBirthValueStr = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                  },
                                  format: SystemParam.formatDateDisplay,
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                        context: context,
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
                                    // labelText: "Rencana Kunjungan 1",
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
                                )
                              : DateTimeField(
                                  initialValue:
                                      _dateOfBirthValue ?? DateTime.now(),
                                  validator: (value) {
                                    if (value == null) {
                                      return "this field is required";
                                    }
                                    return null;
                                  },
                                  onSaved: (valueDate) {
                                    _dateOfBirthValueStr = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                  },
                                  onChanged: (valueDate) {
                                    _dateOfBirthValueStr = SystemParam
                                        .formatDateValue
                                        .format(valueDate!);
                                  },
                                  format: SystemParam.formatDateDisplay,
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                        context: context,
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
                                    // labelText: "Rencana Kunjungan 1",
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
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: SystemParam.colorCustom),
                              child: Text("SIMPAN"),
                              onPressed: () {
                                if (_keyForm.currentState!.validate()) {
                                  saveData();
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    )))));
  }

  void getFamily() async {
    //fPersonalWorkExperienceById
    loading = true;
    var data = {
      "id": widget.familyId,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fPersonalFamilyById, data);

    setState(() {
      // print("response.body.toString():" + response.body.toString());
      PersonalFamilyModel model =
          personalFamilyModelFromJson(response.body.toString());

      if (model.data.length > 0) {
        FamilyData certificate = model.data[0];
        _familyNameCtrl.text = certificate.familyName;
        // ignore: unnecessary_null_comparison
        if (certificate.familyRelationship != null) {
          _relationCtrl.text = certificate.familyRelationship;
        }

        if (certificate.dateOfBirth != null) {
          _dateOfBirthValue = certificate.dateOfBirth;
          _dateOfBirthValueStr =
              SystemParam.formatDateValue.format(certificate.dateOfBirth);
        }
      }

      loading = false;
    });
  }

  void saveData() async {
    var data = {
      "id": widget.familyId,
      "created_by": widget.user.id,
      "user_id": widget.user.id,
      "company_id": widget.user.userCompanyId,
      "family_name": _familyNameCtrl.text,
      "family_relationship": _relationCtrl.text,
      "date_of_birth": _dateOfBirthValueStr,
    };

    print(data);

    String function = SystemParam.fPersonalFamilyCreate;
    if (widget.familyId != 0) {
      function = SystemParam.fPersonalFamilyUpdate;
    }

    var response = await RestService().restRequestService(function, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];
    print(status);

    if (code == "0") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePersonal(
                    user: widget.user,
                    profile: widget.profileInfo,
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
