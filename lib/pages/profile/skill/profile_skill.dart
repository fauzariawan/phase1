import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/personal_certificate_model.dart';
import 'package:workplan_beta_test/model/personal_info_model.dart';
import 'package:workplan_beta_test/model/personal_language_model.dart';
import 'package:workplan_beta_test/model/personal_training_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/profile_page.dart';
import 'package:workplan_beta_test/pages/profile/skill/profile_skill_certificate_edit.dart';
import 'package:workplan_beta_test/pages/profile/skill/profile_skill_language_edit.dart';
import 'package:workplan_beta_test/pages/profile/skill/profile_skill_training_edit.dart';

class ProfileSkill extends StatefulWidget {
  final User user;
  final PersonalInfoProfilData profileInfo;
  const ProfileSkill({Key? key, required this.user, required this.profileInfo})
      : super(key: key);

  @override
  _ProfileSkillState createState() => _ProfileSkillState();
}

class _ProfileSkillState extends State<ProfileSkill> {
  bool loading = false;
  int languageCount = 0;
  List<PersonalLanguage> languageList = <PersonalLanguage>[];
  int certificateCount = 0;
  List<PersonalCertificate> certificateList = <PersonalCertificate>[];

  int trainingCount = 0;
  List<PersonalTraining> trainingList = <PersonalTraining>[];

  @override
  void initState() {
    super.initState();

    getLanguageList();
    getCertificateList();
    getTrainingList();
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
              title: Text('Skill'),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                  child: Text("Bahasa",
                                      style: TextStyle(
                                          color: SystemParam.colorCustom,
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
                                                    ProfileSkillLanguageEdit(
                                                      user: widget.user,
                                                      languageId: 0,
                                                      profileInfo:
                                                          widget.profileInfo,
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
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: new Container(
                            child: createListViewLanguage(),
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
                                  child: Text("Sertifikat",
                                      style: TextStyle(
                                          color: SystemParam.colorCustom,
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
                                                    ProfileSkillCertificateEdit(
                                                      user: widget.user,
                                                      certificateId: 0,
                                                      profileInfo:
                                                          widget.profileInfo,
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
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: new Container(
                            child: createListViewCertificate(),
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
                                  child: Text("Training",
                                      style: TextStyle(
                                          color: SystemParam.colorCustom,
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
                                                    ProfileSkillTrainingEdit(
                                                      user: widget.user,
                                                      profileInfo:
                                                          widget.profileInfo,
                                                      trainingId: 0,
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
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: new Container(
                            child: createListViewTraining(),
                          ),
                        ),
                      ]))));
  }

  void getLanguageList() async {
    loading = true;
    var data = {
      "user_id": widget.user.id,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fPersonalLanguageByUserId, data);

    setState(() {
      // print("response.body.toString():" + response.body.toString());
      PersonalLanguageModel model =
          personalLanguageModelFromJson(response.body.toString());
      languageCount = model.data.length;
      languageList = model.data;

      loading = false;
    });
  }

  void getCertificateList() async {
    loading = true;
    var data = {
      "user_id": widget.user.id,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fPersonalCertificateByUserId, data);

    setState(() {
      PersonalCertificateModel model =
          personalCertificateModelFromJson(response.body.toString());
      certificateCount = model.data.length;
      certificateList = model.data;

      loading = false;
    });
  }

  ListView createListViewLanguage() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: languageCount,
      itemBuilder: (BuildContext context, int index) {
        return customListItemLanguage(
          languageList[index],
        );
      },
    );
  }

  customListItemLanguage(PersonalLanguage langugae) {
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
                    langugae.languageType,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileSkillLanguageEdit(
                                          user: widget.user,
                                          languageId: langugae.id,
                                          profileInfo: widget.profileInfo,
                                        )));
                          },
                          child: Icon(Icons.edit_rounded)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            showDeleteDialog(context, langugae.id,
                                SystemParam.fPersonalLanguageUpdateStatus);
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
                    langugae.readingScore == null
                        ? "Reading Score : "
                        : "Reading Score : " + langugae.readingScore.toString()+" %",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                // Icon(Icons.edit),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                  child: Text(
                    // ignore: unnecessary_null_comparison
                    langugae.writtingScore == null
                        ? "Writting Score : "
                        : "Writting Score : " +
                            langugae.writtingScore.toString()+" %",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                // Icon(Icons.edit),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                  child: Text(
                    // ignore: unnecessary_null_comparison
                    langugae.speakingScore == null
                        ? "Speaking Score : "
                        : "Speaking Score : " +
                            langugae.speakingScore.toString()+" %",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                // Icon(Icons.edit),
              ],
            ),
          ])),
    );
  }

  ListView createListViewCertificate() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: certificateCount,
      itemBuilder: (BuildContext context, int index) {
        return customListItemCertificate(
          certificateList[index],
        );
      },
    );
  }

  customListItemCertificate(PersonalCertificate we) {
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
                    we.institutionName == null ? "" : we.institutionName,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileSkillCertificateEdit(
                                          user: widget.user,
                                          certificateId: we.id,
                                          profileInfo: widget.profileInfo,
                                        )));
                          },
                          child: Icon(Icons.edit_rounded)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            showDeleteDialog(context, we.id,
                                SystemParam.fPersonalCertificateUpdateStatus);
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
                    we.certificateName == null ? "" : we.certificateName,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                // Icon(Icons.edit),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 8.0),
              child: Text(
                we.certificateDate == null
                    ? ""
                    : SystemParam.formatDateDisplay.format(we.certificateDate),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
          ])),
    );
  }

  void getTrainingList() async {
    loading = true;
    var data = {
      "user_id": widget.user.id,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fPersonalTrainingByUserId, data);

    setState(() {
      // print("response.body.toString():" + response.body.toString());
      PersonalTrainingModel model =
          personalTrainingModelFromJson(response.body.toString());
      trainingCount = model.data.length;
      trainingList = model.data;

      loading = false;
    });
  }

  ListView createListViewTraining() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trainingCount,
      itemBuilder: (BuildContext context, int index) {
        return customListItemTrainingCount(
          trainingList[index],
        );
      },
    );
  }

  customListItemTrainingCount(PersonalTraining tl) {
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
                    tl.institutionName,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileSkillTrainingEdit(
                                          user: widget.user,
                                          profileInfo: widget.profileInfo,
                                          trainingId: tl.id,
                                        )));
                          },
                          child: Icon(Icons.edit_rounded)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            showDeleteDialog(context, tl.id,
                                SystemParam.fPersonalTrainingUpdateStatus);
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
                    tl.trainingName,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                // Icon(Icons.edit),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                  child: Text(
                    tl.trainingDateStart == null
                        ? ""
                        : SystemParam.formatDateDisplay
                            .format(tl.trainingDateStart),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                  child: Text(
                    tl.trainingDateEnd == null
                        ? ""
                        : SystemParam.formatDateDisplay
                            .format(tl.trainingDateEnd),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            )
          ])),
    );
  }

  showDeleteDialog(BuildContext context, int id, function) {
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
        updateStatus(id, function);
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

  void updateStatus(id, function) async {
    var data = {
      "id": id,
      "updated_by": widget.user.id,
      "status": 0,
    };

    // print(data);
    //String function = SystemParam.fPersonalEducationUpdateStatus;
    var response = await RestService().restRequestService(function, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];
    // print(status);

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
