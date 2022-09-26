import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/personal_info_address_model.dart';
import 'package:workplan_beta_test/model/personal_info_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/profile/contact/profile_contact_address_edit.dart';
import 'package:workplan_beta_test/pages/profile/profile_page.dart';

class ProfileContact extends StatefulWidget {
  // final
  final User user;
  final PersonalInfoProfilData profile;

  const ProfileContact({Key? key, required this.user, required this.profile})
      : super(key: key);

  @override
  _ProfileContactState createState() => _ProfileContactState();
}

class _ProfileContactState extends State<ProfileContact> {
  // late String _valGender;
  // List _listGender = ["Male","Female"];  //Array gender
  final _keyForm = GlobalKey<FormState>();
  // final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  // var userId = 1;
  bool enabled = true;
  bool loading = false;

  TextEditingController _facebook = TextEditingController();
  TextEditingController _linkedin = TextEditingController();
  TextEditingController _twitter = TextEditingController();
  TextEditingController _instagram = TextEditingController();

  TextEditingController _contactNoTelponRumah = TextEditingController();
  TextEditingController _contactNoTelponKantor = TextEditingController();
  TextEditingController _contactNoHP = TextEditingController();

  TextEditingController _emergencyNama = TextEditingController();
  TextEditingController _emergencyNoHP = TextEditingController();
  TextEditingController _emergencyHubKeluarga = TextEditingController();
  TextEditingController _emergencyAlamatKeluarga = TextEditingController();

  int addressCount = 0;
  List<PersonalInfoAddress> addressList = <PersonalInfoAddress>[];

  @override
  void initState() {
    super.initState();
    getAdressList();

    loading = true;
    loading = false;

    _facebook.text = widget.profile.facebook;
    _linkedin.text = widget.profile.linkedIn;
    _twitter.text = widget.profile.twitter;
    _instagram.text = widget.profile.instagram;

    _contactNoTelponRumah.text = widget.profile.homePhone;
    _contactNoTelponKantor.text = widget.profile.officePhone;
    _contactNoHP.text = widget.profile.phone;

    _emergencyNama.text = widget.profile.emergencyContactName;
    _emergencyNoHP.text = widget.profile.emergencyContactPhone;
    _emergencyHubKeluarga.text = widget.profile.emergencyContactRelationship;
    _emergencyAlamatKeluarga.text = widget.profile.emergencyContactAddress;
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
              title: Text('Contact'),
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
                                    child: Text("Social Media",
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
                                            text: 'Facebook',
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
                                    controller: _facebook,
                                    // initialValue: widget.personalInfoProfilData.facebook,
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
                                            text: 'Linkedin',
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
                                    controller: _linkedin,
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
                                            text: 'Twitter',
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
                                    controller: _twitter,
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
                                            text: 'Instagram',
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
                                    controller: _instagram,
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
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Contact",
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
                                            text: 'Nomor Telepon Rumah',
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
                                    controller: _contactNoTelponRumah,
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
                                            text: 'Nomor Telepon Kantor',
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
                                    controller: _contactNoTelponKantor,
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
                                            text: 'Nomor HP',
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
                                    controller: _contactNoHP,
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
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Emergency Contact",
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
                                            text: 'Nama',
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
                                    controller: _emergencyNama,
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
                                            text: 'Nomor HP',
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
                                    controller: _emergencyNoHP,
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
                                            text: 'Hubungan Keluarga',
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
                                    controller: _emergencyHubKeluarga,
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
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Card(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Alamat Kerja",
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
                                                            ProfileContactAddressEdit(
                                                                user:
                                                                    widget.user,
                                                                addressId: 0,
                                                                profileInfo: widget
                                                                    .profile)));
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
                                    child: createListViewAddress(),
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
                                        saveDataContact();
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
                  )));
  }

  void saveDataContact() async {
    // print("KE SAVE DATA");
    //urlWorkplanInboxUpdate
    //var userId = 1;

    var data = {
      "id": widget.profile.id,
      "facebook": _facebook.text,
      "linkedIn": _linkedin.text,
      "twitter": _twitter.text,
      "instagram": _instagram.text,
      "home_phone": _contactNoTelponRumah.text,
      "office_phone": _contactNoTelponKantor.text,
      "phone": _contactNoHP.text,
      "emergency_contact_name": _emergencyNama.text,
      "emergency_contact_phone": _emergencyNoHP.text,
      "emergency_contact_relationship": _emergencyHubKeluarga.text,
      "emergency_contact_address": _emergencyAlamatKeluarga.text
    };

    var response = await RestService()
        .restRequestService(SystemParam.fPersonaInfoContactUpdate, data);

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

  void getAdressList() async {
    loading = true;
    var data = {
      "user_id": widget.user.id,
    };
    var response = await RestService().restRequestService(SystemParam.fPersonaAddressByUserId, data);
   
    setState(() {
      PersonalInfoAddressModel model =
          personalInfoAddressModelFromJson(response.body.toString());

      addressCount = model.data.length;
      addressList = model.data;
      loading = false;
    });
  }

  ListView createListViewAddress() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: addressCount,
      itemBuilder: (BuildContext context, int index) {
        return customListItemAddress(
          addressList[index],
        );
      },
    );
  }

  customListItemAddress(PersonalInfoAddress we) {
    // return GestureDetector(
    //     onTap: () {
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => ProfileContactAddressEdit(
    //                   user: widget.user,
    //                   addressId: we.id,
    //                   profileInfo: widget.profile)));
    //     },
    //     child:
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                      child: Text(
                        we.addressName == null ? "" : we.addressName,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
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
                                            ProfileContactAddressEdit(
                                                user: widget.user,
                                                addressId: we.id,
                                                profileInfo: widget.profile)));
                              },
                              child: Icon(Icons.edit_rounded)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                showDeleteDialog(context, we.id,
                                    SystemParam.fPersonaAddresUpdateStatus);
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
                        we.rtrw == null ? "" : we.rtrw,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
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
                        we.kabKotaDesc == null ? "" : we.kabKotaDesc,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
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
                        we.kecamatan == null ? "" : we.kecamatan,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                    // Icon(Icons.edit),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                //       child: Text('',
                //         style: TextStyle(
                //             fontSize: 14, fontWeight: FontWeight.normal),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                //       child: Text('KELURAHAN',
                //         style: TextStyle(
                //             fontSize: 14, fontWeight: FontWeight.normal),
                //       ),
                //     ),
                //   ],
                // )
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
              builder: (context) => ProfileContact(
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
