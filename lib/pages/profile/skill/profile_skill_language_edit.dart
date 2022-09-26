import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/personal_info_model.dart';
import 'package:workplan_beta_test/model/personal_language_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/skill/profile_skill.dart';

class ProfileSkillLanguageEdit extends StatefulWidget {
  final User user;
  final PersonalInfoProfilData profileInfo;
  final int languageId;

  
  const ProfileSkillLanguageEdit(
      {Key? key,
      required this.user,
      required this.profileInfo,
      required this.languageId})
      : super(key: key);

  @override
  _ProfileSkillLanguageEditState createState() =>
      _ProfileSkillLanguageEditState();
}

class _ProfileSkillLanguageEditState extends State<ProfileSkillLanguageEdit> {
  bool loading = false;
  final _keyForm = GlobalKey<FormState>();
  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');
  TextEditingController _languageTypeCtrl = new TextEditingController();
  TextEditingController _writtingCtrl = new TextEditingController();
  TextEditingController _readingCtrl = new TextEditingController();
  TextEditingController _speakingCtrl = new TextEditingController();
  late PersonalLanguage  listPersonalLanguage;

  @override
  void initState() {
    super.initState();

    if (widget.languageId != 0) {
      getLanguageList();
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
                builder: (context) => ProfileSkill(
                  user: widget.user,
                  profileInfo: widget.profileInfo,
                ),
              ));
          return false;
        },
        child: Scaffold(
            //drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              title: Text('Bahasa Add/ Edit'),
              centerTitle: true,
              backgroundColor: SystemParam.colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSkill(
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
                          padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Jenis Bahasa',
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
                            controller: _languageTypeCtrl,
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
                                    text: 'Kemampuan Baca (%)',
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
                            //
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            style: new TextStyle(color: Colors.black),
                            controller: _readingCtrl,
                            readOnly: false,
                            validator: requiredValidator,
                            onSaved: (em) {
                              if (em != null) {}
                            },
                            decoration: InputDecoration(
                              suffixText: "%",
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
                                    text: 'Kemampuan Tulis (%)',
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
                            keyboardType: TextInputType.number,
                            
                            textInputAction: TextInputAction.next,
                            style: new TextStyle(color: Colors.black),
                            controller: _writtingCtrl,
                            readOnly: false,
                            validator: requiredValidator,
                            onSaved: (em) {
                              if (em != null) {}
                            },
                            decoration: InputDecoration(
                              suffixText: "%",
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
                                    text: 'Kemampuan Bicara (%)',
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
                            
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            style: new TextStyle(color: Colors.black),
                            controller: _speakingCtrl,
                            readOnly: false,
                            validator: requiredValidator,
                            onSaved: (em) {
                              if (em != null) {}
                            },
                            decoration: InputDecoration(
                              suffixText: "%",
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

  void getLanguageList() async{
    //fPersonalWorkExperienceById
    loading = true;
    var data = {
      "id": widget.languageId,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fPersonalLanguageById, data);

    setState(() {
      // print("response.body.toString():" + response.body.toString());
      PersonalLanguageModel model =
          personalLanguageModelFromJson(response.body.toString());

      if (model.data.length > 0) {
        PersonalLanguage language = model.data[0];
        _languageTypeCtrl.text = language.languageType;
        // ignore: unnecessary_null_comparison
        if(language.readingScore!=null){
          _readingCtrl.text = language.readingScore.toString();
        }

         // ignore: unnecessary_null_comparison
         if(language.writtingScore!=null){
          _writtingCtrl.text = language.writtingScore.toString();
        }

         // ignore: unnecessary_null_comparison
         if(language.speakingScore!=null){
          _speakingCtrl.text = language.speakingScore.toString();
        }
      
      }

      loading = false;
    });
  }

  void saveData()  async {
    
    int readingScore =  int.parse(_readingCtrl.text) ;
    int speakingScore = int.parse(_speakingCtrl.text) ;
    int writtingScore = int.parse(_writtingCtrl.text);

    if(readingScore>100 || speakingScore>100 || writtingScore>100){
      Fluttertoast.showToast(
          msg: "Score harus kurang dari 100 %",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
          return;
    }

    var data = {
      "id": widget.languageId,
      "created_by": widget.user.id,
      "user_id": widget.user.id,
      "company_id": widget.user.userCompanyId,
      "language_type":_languageTypeCtrl.text,
      "reading_score":_readingCtrl.text,
      "speaking_score":_speakingCtrl.text,
      "writting_score":_writtingCtrl.text,
    };

    print(data);

    String function = SystemParam.fPersonalLanguageCreate;
    if(widget.languageId!=0){
      function = SystemParam.fPersonalLanguageUpdate;
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
              builder: (context) => ProfileSkill(
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
