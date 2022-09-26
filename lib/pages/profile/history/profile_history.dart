import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/personal_education_model.dart';
import 'package:workplan_beta_test/model/personal_info_model.dart';
import 'package:workplan_beta_test/model/personal_work_experience_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/history/profile_history_education_edit.dart';
import 'package:workplan_beta_test/pages/profile/history/profile_history_work_experience_edit.dart';
import 'package:workplan_beta_test/pages/profile/profile_page.dart';

class ProfileHistory extends StatefulWidget {
  final User user;
  final PersonalInfoProfilData profileInfo;
  const ProfileHistory(
      {Key? key, required this.user, required this.profileInfo})
      : super(key: key);

  @override
  _ProfileHistoryState createState() => _ProfileHistoryState();
}

class _ProfileHistoryState extends State<ProfileHistory> {
  bool loading = false;
  int educationCount = 0;
  List<PersonalEducation> educationList = <PersonalEducation>[];
  int workExperienceCount = 0;
  List<PersonalWorkExperience> workExperienceList = <PersonalWorkExperience>[];

  @override
  void initState() {
    super.initState();

    getEducationList();
    getWorkExperienceList();
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
              title: Text('History'),
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
                                  child: Text("Pendidikan",
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
                                                    ProfileHistoryEducationEdit(
                                                      user: widget.user,
                                                      educationId: 0,
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
                            child: createListViewEducation(),
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
                                  child: Text("Pengalaman Kerja",
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
                                                    ProfileHistoryWorkExperienceEdit(
                                                      user: widget.user,
                                                      profileInfo:
                                                          widget.profileInfo,
                                                      workExperienceId: 0,
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
                            child: createListViewWorkExperience(),
                          ),
                        ),
                      ]))));
  }

  void getEducationList() async {
    loading = true;
    var data = {
      "user_id": widget.user.id,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fPersonalEducationByUserId, data);

    setState(() {
      // print("response.body.toString():" + response.body.toString());
      PersonalEducationModel model =
          personalEducationModelFromJson(response.body.toString());
      educationCount = model.data.length;
      educationList = model.data;

      loading = false;
    });
  }

  void getWorkExperienceList() async {
    loading = true;
    var data = {
      "user_id": widget.user.id,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fPersonalWorkExperienceByUserId, data);

    setState(() {
      // print("response.body.toString():" + response.body.toString());
      PersonalWorkExperienceModel model =
          personalWorkExperienceModelFromJson(response.body.toString());
      workExperienceCount = model.data.length;
      workExperienceList = model.data;

      loading = false;
    });
  }

  ListView createListViewEducation() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: educationCount,
      itemBuilder: (BuildContext context, int index) {
        return customListItemEducation(
          educationList[index],
        );
      },
    );
  }

  customListItemEducation(PersonalEducation education) {
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
                    education.educationTypeDesc,
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
                                        ProfileHistoryEducationEdit(
                                          user: widget.user,
                                          educationId: education.id,
                                          profileInfo: widget.profileInfo,
                                        )));
                          },
                          child: Icon(Icons.edit_rounded)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            showDeleteDialog(context, education.id,
                                SystemParam.fPersonalEducationUpdateStatus);
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
                    education.institution,
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
                    SystemParam.formatDateDisplay.format(education.startDate),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                  child: Text(
                    SystemParam.formatDateDisplay.format(education.endDate),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            )
          ])),
    );
  }

  ListView createListViewWorkExperience() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workExperienceCount,
      itemBuilder: (BuildContext context, int index) {
        return customListItemWorkExperience(
          workExperienceList[index],
        );
      },
    );
  }

  customListItemWorkExperience(PersonalWorkExperience we) {
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
                    we.companyName,
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
                                        ProfileHistoryWorkExperienceEdit(
                                          user: widget.user,
                                          profileInfo: widget.profileInfo,
                                          workExperienceId: we.id,
                                        )));
                          },
                          child: Icon(Icons.edit_rounded)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            showDeleteDialog(
                                context,
                                we.id,
                                SystemParam
                                    .fPersonalWorkExperienceUpdateStatus);
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
                    we.position,
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
                    we.startDate == null
                        ? ""
                        : SystemParam.formatDateDisplay.format(we.startDate),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                  child: Text(
                    we.endDate == null
                        ? ""
                        : SystemParam.formatDateDisplay.format(we.endDate),
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
