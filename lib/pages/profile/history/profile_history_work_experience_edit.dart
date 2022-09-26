import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/personal_info_model.dart';
import 'package:workplan_beta_test/model/personal_work_experience_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/history/profile_history.dart';

class ProfileHistoryWorkExperienceEdit extends StatefulWidget {
  final User user;
  final PersonalInfoProfilData profileInfo;
  // final PersonalEducation educationData;
  final int workExperienceId;

  const ProfileHistoryWorkExperienceEdit(
      {Key? key,
      required this.user,
      required this.profileInfo,
      required this.workExperienceId})
      : super(key: key);

  @override
  _ProfileHistoryWorkExperienceEditState createState() =>
      _ProfileHistoryWorkExperienceEditState();
}

class _ProfileHistoryWorkExperienceEditState
    extends State<ProfileHistoryWorkExperienceEdit> {
  
  final _keyForm = GlobalKey<FormState>();
  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');
  TextEditingController _companyNameCtrl = new TextEditingController();
  TextEditingController _positionCtrl = new TextEditingController();

  String _mulaiValueStr = "";
  String _akhirValueStr = "";

  dynamic _mulaiValue;
  dynamic _akhirValue;

  @override
  void initState() {
    super.initState();

    if (widget.workExperienceId != 0) {
      getWorkExperience();
    }
    // initEducationType();
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
              title: Text('Pengalaman Kerja Add/ Edit'),
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
                          padding: const EdgeInsets.only(left: 8.0,top: 10.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Nama Perusahaan',
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
                            controller: _companyNameCtrl,
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
                                    text: 'Jabatan',
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
                            controller: _positionCtrl,
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
                          child: 
                          widget.workExperienceId==0?
                           DateTimeField(
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
                                  firstDate: DateTime(SystemParam.firstDate),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(SystemParam.lastDate),
                                  fieldHintText: SystemParam.strFormatDateHint);
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
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
                                  firstDate: DateTime(SystemParam.firstDate),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(SystemParam.lastDate),
                                  fieldHintText: SystemParam.strFormatDateHint);
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
                          child: 
                          widget.workExperienceId == 0 ?
                          DateTimeField(
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
                                  firstDate: DateTime(SystemParam.firstDate),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(SystemParam.lastDate),
                                  fieldHintText: SystemParam.strFormatDateHint);
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SystemParam.colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          )
                          :DateTimeField(
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
                                  firstDate: DateTime(SystemParam.firstDate),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(SystemParam.lastDate),
                                  fieldHintText: SystemParam.strFormatDateHint);
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

  void getWorkExperience() async {

    loading = true;
    var data = {
      "id": widget.workExperienceId,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fPersonalWorkExperienceById, data);

    setState(() {
      // print("response.body.toString():" + response.body.toString());
      PersonalWorkExperienceModel model =
          personalWorkExperienceModelFromJson(response.body.toString());

      if (model.data.length > 0) {
        PersonalWorkExperience we = model.data[0];
        _companyNameCtrl.text = we.companyName;
        _positionCtrl.text = we.position;
        if (we.startDate != null) {
          _mulaiValue = we.startDate;
          _mulaiValueStr =
              SystemParam.formatDateValue.format(we.startDate);
        }
        if (we.endDate != null) {
          _akhirValue = we.endDate;
          _akhirValueStr =
              SystemParam.formatDateValue.format(we.endDate);
        }
      }

      loading = false;
    });
  }


  void saveData() async {
    var data = {
      "id": widget.workExperienceId,
      "created_by": widget.user.id,
      "user_id": widget.user.id,
      "company_id": widget.user.userCompanyId,
      "company_name":_companyNameCtrl.text,
      "position":_positionCtrl.text,
      "start_date": _mulaiValueStr,
      "end_date": _akhirValueStr
    };
  
    String function = SystemParam.fPersonalWorkExperienceCreate;
    if(widget.workExperienceId!=0){
      function = SystemParam.fPersonalWorkExperienceUpdate;
    }

    var response = await RestService() .restRequestService(function, data);

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
