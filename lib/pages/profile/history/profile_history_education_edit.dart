import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/dropdown_item.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/parameter_model.dart';
import 'package:workplan_beta_test/model/personal_education_model.dart';
import 'package:workplan_beta_test/model/personal_info_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/history/profile_history.dart';

class ProfileHistoryEducationEdit extends StatefulWidget {
  final User user;
  final PersonalInfoProfilData profileInfo;
  final int educationId;

  const ProfileHistoryEducationEdit(
      {Key? key,
      required this.user,
      required this.profileInfo,
      required this.educationId})
      : super(key: key);

  @override
  _ProfileHistoryEducationEditState createState() =>
      _ProfileHistoryEducationEditState();
}

class _ProfileHistoryEducationEditState
    extends State<ProfileHistoryEducationEdit> {
  late List<Parameter> educationTypeList;
  List<DropdownMenuItem<int>> itemsEducationType = <DropdownMenuItem<int>>[];
  int educationTypeValue = SystemParam.defaultValueOptionId;
  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');
  TextEditingController _institutionCtrl = new TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  String _mulaiValueStr = "";
  String _akhirValueStr = "";

  // DateTime _mulaiValue = DateTime.now();
  // DateTime _akhirValue = DateTime.now();
  dynamic _mulaiValue;
  dynamic _akhirValue;

  @override
  void initState() {
    super.initState();
    // print("init State");
    //_mulaiValue = null;
    //_akhirValue = null;
    if (widget.educationId != 0) {
      getEducation();
    }
    initEducationType();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          //  Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileHistory(
                  user: widget.user,
                  profileInfo: widget.profileInfo,
                ),
              ));
          return false;
        },
        child: Scaffold(
            //drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              title: Text('Pendidikan Add/ Edit'),
              centerTitle: true,
              backgroundColor: SystemParam.colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileHistory(
                          user: widget.user,
                          profileInfo: widget.profileInfo,
                        ),
                      ));
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
                          padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Jenis Pendidikan',
                                    style: TextStyle(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: SystemParam.colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: ' ',
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            validator: (value) {
                              print("validaor select:" + value.toString());
                              // ignore: unrelated_type_equality_checks
                              if (value == 0 || value == null) {
                                return "this field is required";
                              }
                              return null;
                            },
                            value: educationTypeValue,
                            items: itemsEducationType,
                            onChanged: (object) {
                              setState(() {
                                educationTypeValue = object!;
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
                                    text: 'Institution',
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
                            controller: _institutionCtrl,
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
                                    text: 'Mulai',
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
                          child: widget.educationId == 0
                              ? DateTimeField(
                                  //initialValue: _mulaiValue ?? DateTime.now(),
                                  validator: (value) {
                                    if (value == null) {
                                      return "this field is required";
                                    }
                                    return null;
                                  },
                                  onSaved: (valueDate) {
                                    _mulaiValueStr = SystemParam.formatDateValue
                                        .format(valueDate!);
                                  },
                                  onChanged: (valueDate) {
                                    _mulaiValueStr = SystemParam.formatDateValue
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
                                  initialValue: _mulaiValue ?? DateTime.now(),
                                  validator: (value) {
                                    if (value == null) {
                                      return "this field is required";
                                    }
                                    return null;
                                  },
                                  onSaved: (valueDate) {
                                    _mulaiValueStr = SystemParam.formatDateValue
                                        .format(valueDate!);
                                  },
                                  onChanged: (valueDate) {
                                    _mulaiValueStr = SystemParam.formatDateValue
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
                          padding: const EdgeInsets.only(
                            left: 8.0,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Akhir',
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
                          child: widget.educationId == 0
                              ? DateTimeField(
                                  //initialValue: _akhirValue ?? DateTime.now(),
                                  validator: (value) {
                                    if (value == null) {
                                      return "this field is required";
                                    }
                                    return null;
                                  },
                                  onSaved: (valueDate) {
                                    _akhirValueStr = SystemParam.formatDateValue
                                        .format(valueDate!);
                                  },
                                  onChanged: (valueDate) {
                                    _akhirValueStr = SystemParam.formatDateValue
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
                                  initialValue: _akhirValue ?? DateTime.now(),
                                  validator: (value) {
                                    if (value == null) {
                                      return "this field is required";
                                    }
                                    return null;
                                  },
                                  onSaved: (valueDate) {
                                    _akhirValueStr = SystemParam.formatDateValue
                                        .format(valueDate!);
                                  },
                                  onChanged: (valueDate) {
                                    _akhirValueStr = SystemParam.formatDateValue
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

  void getEducation() async {
    //fPersonalWorkExperienceById
    loading = true;
    var data = {
      "id": widget.educationId,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fPersonalEducationById, data);

    setState(() {
      // print("response.body.toString():" + response.body.toString());
      PersonalEducationModel model =
          personalEducationModelFromJson(response.body.toString());

      if (model.data.length > 0) {
        PersonalEducation education = model.data[0];
        _institutionCtrl.text = education.institution;
        educationTypeValue = education.educationTypeId;
        if (education.startDate != null) {
          _mulaiValue = education.startDate;
          _mulaiValueStr =
              SystemParam.formatDateValue.format(education.startDate);
        }
        if (education.endDate != null) {
          _akhirValue = education.endDate;
          _akhirValueStr =
              SystemParam.formatDateValue.format(education.endDate);
        }
      }

      loading = false;
    });
  }

  void initEducationType() async {
    itemsEducationType.clear();
    educationTypeList = <Parameter>[];
    loading = true;
    ParameterModel parameterModel;
    var data = {
      "parameter_type": SystemParam.parameterTypeEducationType,
      "company_id": widget.user.userCompanyId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fParameterByTypeCompanyId, data);

    setState(() {
      parameterModel = parameterModelFromJson(response.body.toString());
      educationTypeList = parameterModel.data;
      itemsEducationType.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < educationTypeList.length; i++) {
        itemsEducationType.add(DropdownItem.getItemParameter(
            educationTypeList[i].id, educationTypeList[i].parameterValue));
      }

      loading = false;
    });
  }

  void saveData() async {
    var data = {
      "id": widget.educationId,
      "created_by": widget.user.id,
      "user_id": widget.user.id,
      "company_id": widget.user.userCompanyId,
      "education_type_id": educationTypeValue,
      "institution": _institutionCtrl.text,
      "start_date": _mulaiValueStr,
      "end_date": _akhirValueStr
    };

    String function = SystemParam.fPersonalEducationCreate;
    if (widget.educationId != 0) {
      function = SystemParam.fPersonalEducationUpdate;
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
              builder: (context) => ProfileHistory(
                    user: widget.user,
                    profileInfo: widget.profileInfo,
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
