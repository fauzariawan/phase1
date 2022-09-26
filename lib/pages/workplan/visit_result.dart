import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/dropdown_item.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/parameter_hasil_kunjungan.dart';
import 'package:workplan_beta_test/model/parameter_tujuan_kunjungan.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/model/workplan_visit_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_visit_list.dart';

class VisitResult extends StatefulWidget {
  final WorkplanInboxData workplan;
  final WorkplanVisit workplanVisit;
  final User user;
  final bool isMaximumUmur;

  const VisitResult(
      {Key? key,
      required this.workplan,
      required this.workplanVisit,
      required this.user,
      required this.isMaximumUmur})
      : super(key: key);

  @override
  _VisitResultState createState() => _VisitResultState();
}

class _VisitResultState extends State<VisitResult> {
  final _keyForm = GlobalKey<FormState>();
  bool loading = false;
  int parameterTujuanKunjunganValue = SystemParam.defaultValueOptionId;
  List<DropdownMenuItem<int>> itemsParameterTujuanKunjungan =
      <DropdownMenuItem<int>>[];

  int parameterHasilKunjunganValue = SystemParam.defaultValueOptionId;
  List<DropdownMenuItem<int>> itemsParameterHasilKunjungan =
      <DropdownMenuItem<int>>[];
  TextEditingController _catatanKunjunganCtrl = new TextEditingController();

  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');

  String checkOutTime = "";
  late WorkplanInboxData wid;
  late WorkplanVisit wV;
  TextEditingController checkOutCtr = new TextEditingController();
  @override
  void initState() {
    super.initState();

    wid = widget.workplan;
    wV = widget.workplanVisit;
    initParameterTujuanKunjungan();
    initParameterHasilKunjungan();
    getWorkplanById();
    getWorkplanVisitById();

    // ignore: unnecessary_null_comparison
    if (widget.workplanVisit.note != null) {
      _catatanKunjunganCtrl.text = widget.workplanVisit.note!;
    }
  }

  void getWorkplanVisitById() async {
    loading = true;
    var data = {
      "visit_id": widget.workplanVisit.id,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fWorkplanVisitById, data);

    setState(() {
      // print("response.body.toString():" + response.body.toString());
      WorkplanVisitModel workplanVisitModel =
          workplanVisitModelFromJson(response.body.toString());
      wV = workplanVisitModel.data[0];
      print("wV.checkOut: "+wV.checkOut.toString());
      if (wV.checkOut != null) {
        // checkOutTime = SystemParam.formatTime.format(wV.checkOut);
        checkOutCtr.text = SystemParam.formatTime.format(wV.checkOut);
      }
      loading = false;
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
      wid = wi.data[0];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkplanVisitList(
                    // workplanVisit: widget.workplanVisit,
                    workplan: widget.workplan,
                    user: widget.user,
                    isMaximumUmur: widget.isMaximumUmur),
              ));
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Visit Activity '),
              centerTitle: true,
              backgroundColor: SystemParam.colorCustom,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkplanVisitList(
                            // workplanVisit: widget.workplanVisit,
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
                    child: Form(
                        key: _keyForm,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                color: Colors.white,
                                elevation: 0.1,
                                child: ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, top: 8.0),
                                    child: Icon(
                                      Icons.card_travel,
                                      color: SystemParam.colorCustom,
                                      size: 50,
                                    ),
                                  ),
                                  title: Text(wid.nomorWorkplan,
                                      style: TextStyle(fontSize: 12)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        wid.fullName,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Badge(
                                          toAnimate: false,
                                          shape: BadgeShape.square,
                                          badgeColor: SystemParam.colorCustom,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          badgeContent: Text(
                                              wid.progresStatusDescription,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      Icon(Icons.more_vert)
                                    ],
                                  ),
                                  //onTap: () {},
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DateTimeField(
                                  enabled: false,
                                  format: SystemParam.formatDateDisplay,
                                  initialValue:
                                      widget.workplanVisit.visitDatePlan!,
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate:
                                            DateTime(SystemParam.firstDate),
                                        initialDate:
                                            widget.workplanVisit.visitDatePlan!,
                                        lastDate:
                                            DateTime(SystemParam.lastDate));

                                    return date;
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: new Icon(Icons.date_range),
                                    fillColor: SystemParam.colorCustom,
                                    labelText: "Tanggal Rencana Kunjungan ",
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
                                child: DateTimeField(
                                  enabled: false,
                                  format: SystemParam.formatDateDisplay,
                                  initialValue:
                                      widget.workplanVisit.visitDateActual!,
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate:
                                            DateTime(SystemParam.firstDate),
                                        initialDate: widget
                                            .workplanVisit.visitDateActual!,
                                        lastDate:
                                            DateTime(SystemParam.lastDate));

                                    return date;
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: new Icon(Icons.date_range),
                                    fillColor: SystemParam.colorCustom,
                                    labelText: "Tanggal Aktual Kunjungan ",
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
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: Colors.black),
                                  enabled: false,
                                  initialValue: SystemParam.formatTime.format(widget.workplanVisit.checkIn),
                                  decoration: InputDecoration(
                                    suffixIcon: new Icon(Icons.access_time),
                                    fillColor: Colors.green,
                                    labelText: "Check In Time",
                                    labelStyle: TextStyle(
                                        color: Colors.green,
                                        fontStyle: FontStyle.normal),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: checkOutCtr,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: Colors.black),
                                  enabled: false,
                                  //initialValue:  SystemParam.formatTime.format(wV.checkOut),
                                  decoration: InputDecoration(
                                    suffixIcon: new Icon(Icons.access_time),
                                    fillColor: Colors.green,
                                    labelText: "Check Out Time",
                                    labelStyle: TextStyle(
                                        color: Colors.green,
                                        fontStyle: FontStyle.normal),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
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
                                          text: 'Tujuan Kunjungan',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
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
                                child: DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
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
                                  // validator: (value) {
                                  //   print(
                                  //       "validaor select:" + value.toString());
                                  //   // ignore: unrelated_type_equality_checks
                                  //   if (value == 0) {
                                  //     return "this field is required";
                                  //   }
                                  //   return null;
                                  // },
                                  value: parameterTujuanKunjunganValue,
                                  items: itemsParameterTujuanKunjungan,
                                  onChanged: (object) {
                                    setState(() {
                                      parameterTujuanKunjunganValue = object!;
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
                                          text: 'Hasil Kunjungan',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
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
                                child: DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
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
                                  // validator: (value) {
                                  //   print(
                                  //       "validaor select:" + value.toString());
                                  //   // ignore: unrelated_type_equality_checks
                                  //   if (value == 0) {
                                  //     return "this field is required";
                                  //   }
                                  //   return null;
                                  // },
                                  value: parameterHasilKunjunganValue,
                                  items: itemsParameterHasilKunjungan,
                                  onChanged: (object) {
                                    setState(() {
                                      parameterHasilKunjunganValue = object!;
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
                                          text: 'Catatan Kunjungan',
                                          style: TextStyle(
                                              //backgroundColor: Theme.of(context)
                                              //                                            .scaffoldBackgroundColor,
                                              color: SystemParam.colorCustom,
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
                                  controller: _catatanKunjunganCtrl,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(color: Colors.blue[900]),
                                  readOnly: false,
                                  maxLines: 3,
                                  //validator: requiredValidator,
                                  onSaved: (em) {
                                    if (em != null) {}
                                  },
                                  decoration: InputDecoration(
                                    // icon: new Icon(Ionicons.phone_portrait),
                                    fillColor: Colors.black,
                                    // labelText: "Nomor HP",
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
                                    onPressed: () {
                                      //prosesSave(empUpd);
                                      if (_keyForm.currentState!.validate()) {
                                        saveData();
                                      }
                                      //saveData();
                                    },
                                  ),
                                ),
                              )
                            ])))));
  }

  void initParameterTujuanKunjungan() async {
    loading = true;
    ParameterTujuanKunjunganModel parameterModel;
    var data = {
      "company_id": widget.user.userCompanyId,
      "id_produk": wid.jenisProdukId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fParameterTujuanKunjungan, data);

    setState(() {
      parameterModel =
          parameterTujuanKunjunganFromJson(response.body.toString());
      List<ParameterTujuanKunjungan> parameterList = parameterModel.data;
      itemsParameterTujuanKunjungan.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < parameterList.length; i++) {
        itemsParameterTujuanKunjungan.add(DropdownItem.getItemParameter(
            parameterList[i].id, parameterList[i].description));
      }
      loading = false;
    });
  }

  void initParameterHasilKunjungan() async {
    loading = true;
    ParameterHasilKunjunganModel parameterModel;
    var data = {
      "company_id": widget.user.userCompanyId,
      //"activity_id": wid.activityId,
      "id_produk": wid.jenisProdukId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fParameterHasilKunjungan, data);

    setState(() {
      parameterModel =
          parameterHasilKunjunganFromJson(response.body.toString());
      List<ParameterHasilKunjungan> parameterList = parameterModel.data;
      itemsParameterHasilKunjungan.add(DropdownItem.getItemParameter(
          SystemParam.defaultValueOptionId,
          SystemParam.defaultValueOptionDesc));
      for (var i = 0; i < parameterList.length; i++) {
        itemsParameterHasilKunjungan.add(DropdownItem.getItemParameter(
            parameterList[i].id, parameterList[i].description));
      }
      loading = false;
    });
  }

  void saveData() async {
    var data = {
      "id": widget.workplanVisit.id,
      "visit_purpose_id": parameterTujuanKunjunganValue == 0? null: parameterTujuanKunjunganValue,
      "visit_result_id": parameterHasilKunjunganValue == 0? null: parameterHasilKunjunganValue,
      "note": _catatanKunjunganCtrl.text,
      "workplan_activity_id": widget.workplan.id,
      "updated_by": widget.user.id
    };

    var response = await RestService()
        .restRequestService(SystemParam.fVisitResultUpdate, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];

    if (code == "0") {
      //sukses
      getWorkplanById();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WorkplanVisitList(
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
}
