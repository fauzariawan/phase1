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
import 'package:workplan_beta_test/model/parameter_kategori_produk_model.dart';
import 'package:workplan_beta_test/model/parameter_produk_model.dart';
import 'package:workplan_beta_test/model/parameter_udf_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);

class WorkplanDataProduk extends StatefulWidget {
  final WorkplanInboxData workplan;
  final User user;
  final bool isMaximumUmur;

  const WorkplanDataProduk(
      {Key? key,
      required this.workplan,
      required this.user,
      required this.isMaximumUmur})
      : super(key: key);

  @override
  _ExampleFormState createState() => _ExampleFormState();
}

class _ExampleFormState extends State<WorkplanDataProduk> {
  //GlobalKey myFormKey = new GlobalKey();
  final myFormKey = GlobalKey<FormState>();

  DatabaseHelper db = new DatabaseHelper();
  bool loading = false;
  bool enabled = false;
  late int myNumber;
  String myValue = 'No value saved yet.';
  String labelUdfTextC1 = "UDF Text C1";
  String labelUdfNumC1 = "UDF Num C1";
  String labelUdfDateC1 = "UDF Date C1";
  var _udfDateC1Value = "";

  TextEditingController _udfTextC1Ctr = TextEditingController();
  TextEditingController _udfNumC1Ctr = TextEditingController();

  List<ParameterKategoriProduk> parameterKategoriProdukList =
      <ParameterKategoriProduk>[];
  List<DropdownMenuItem<int>> itemsParameterKategoriProduk =
      <DropdownMenuItem<int>>[];
  int parameterKategoriProdukValue = SystemParam.defaultValueOptionId;

  List<ParameterProduk> parameterProdukList = <ParameterProduk>[];
  List<DropdownMenuItem<int>> itemsParameterProduk = <DropdownMenuItem<int>>[];
  int parameterProdukValue = SystemParam.defaultValueOptionId;

  // CurrencyTextInputFormatter _formatterCurrency = CurrencyTextInputFormatter(locale: 'id',symbol: '');

  TextEditingController _nominalTransaksiCtrl = new TextEditingController();
  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');

  late WorkplanInboxData _workplan;

  // DatabaseHelper db = new DatabaseHelper();

  @override
  void initState() {
    super.initState();

    _workplan = widget.workplan;
    initParameterKategoriProdukDB();

    setState(() {
      if (widget.workplan.nominalTransaksi != null &&
          widget.workplan.nominalTransaksi != "") {
        // _nominalTransaksiCtrl.text =_formatterCurrency.format(widget.workplan.nominalTransaksi.toString()+'00');
        _nominalTransaksiCtrl.text =
            widget.workplan.nominalTransaksi.toString();
      }

      if (widget.workplan.udfTextC1 != null) {
        _udfTextC1Ctr.text = widget.workplan.udfTextC1;
      }

      if (widget.workplan.udfNumC1 != null) {
        _udfNumC1Ctr.text = widget.workplan.udfNumC1.toString();
      }

      if (widget.workplan.udfDateC1 != null) {
        _udfDateC1Value =
            SystemParam.formatDateValue.format(widget.workplan.udfDateC1);
      }

      if (widget.workplan.isCheckIn == "1" &&
          (widget.workplan.progresStatusIdAlter == 2 ||
              widget.workplan.progresStatusIdAlter == 4)) {
        enabled = true;
      } else {
        enabled = false;
      }
    });

    getLableUdf();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
          appBar: AppBar(
            title: Text('Produk'),
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
                  child: Form(
                    key: myFormKey,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Kategori Produk',
                                    style: TextStyle(
                                        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                        color: colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: ' * ',
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
                                  borderSide: BorderSide(color: colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            validator: (value) {
                              //print("validaor select:" + value.toString());
                              if (value == 0) {
                                return "this field is required";
                              }
                              return null;
                            },
                            value: parameterKategoriProdukValue,
                            items: itemsParameterKategoriProduk,
                            onChanged: !enabled
                                ? null
                                : (object) {
                                    setState(() {
                                      parameterKategoriProdukValue = object!;
                                      //
                                      initParameterProdukDB(
                                          parameterKategoriProdukValue);
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
                                    text: 'Jenis Produk',
                                    style: TextStyle(
                                        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                        color: colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: ' * ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        // backgroundColor: Theme.of(context) .scaffoldBackgroundColor,
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
                                  borderSide: BorderSide(color: colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            validator: (value) {
                              //print("validaor select:" + value.toString());
                              if (value == 0) {
                                return "this field is required";
                              }
                              return null;
                            },
                            value: parameterProdukValue,
                            items: itemsParameterProduk,
                            onChanged: !enabled
                                ? null
                                : (object) {
                                    setState(() {
                                      parameterProdukValue = object!;
                                    });
                                  },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Nominal Transaksi',
                                    style: TextStyle(
                                        // backgroundColor: Theme.of(context) .scaffoldBackgroundColor,
                                        color: colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: ' * ',
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
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _nominalTransaksiCtrl,
                            validator: requiredValidator,
                            textInputAction: TextInputAction.next,
                            // inputFormatters: [_formatterCurrency],
                            keyboardType: TextInputType.number,
                            style: new TextStyle(color: Colors.black),
                            readOnly: false,
                            enabled: enabled,
                            decoration: InputDecoration(
                              // icon: new Icon(Ionicons.home_sharp),
                              fillColor: Colors.green,
                              //labelText: "Nominal Transaksi",
                              labelStyle: TextStyle(
                                  color: Colors.green,
                                  fontStyle: FontStyle.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
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
                                    text: '$labelUdfTextC1',
                                    style: TextStyle(
                                        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                        color: colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: ' ',
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
                          child: TextFormField(
                            controller: _udfTextC1Ctr,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: new TextStyle(color: Colors.black),
                            //initialValue: widget.workplanInboxData.kodepos,
                            readOnly: false,
                            //validator: requiredValidator,
                            onSaved: (em) {
                              //if (em != null) {}
                            },
                            enabled: enabled,
                            decoration: InputDecoration(
                              // icon: new Icon(Ionicons.document),
                              fillColor: colorCustom,
                              // labelText: labelUdfTextA1,
                              labelStyle: TextStyle(
                                  color: colorCustom,
                                  fontStyle: FontStyle.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorCustom),
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
                                    text: '$labelUdfNumC1',
                                    style: TextStyle(
                                        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                        color: colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: ' ',
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
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _udfNumC1Ctr,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            // maxLength: 16,
                            style: new TextStyle(color: Colors.black),
                            //initialValue: widget.workplanInboxData.kodepos,
                            readOnly: false,
                            //validator: requiredValidator,
                            onSaved: (em) {
                              //if (em != null) {}
                            },
                            enabled: enabled,
                            maxLength: 15,
                            decoration: InputDecoration(
                              // icon: new Icon(Ionicons.document),
                              fillColor: colorCustom,
                              // labelText: labelUdfNumA1,
                              labelStyle: TextStyle(
                                  color: colorCustom,
                                  fontStyle: FontStyle.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorCustom),
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
                                    text: '$labelUdfDateC1',
                                    style: TextStyle(
                                        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                        color: colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                TextSpan(
                                    text: ' ',
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
                          child: DateTimeField(
                            autovalidateMode: AutovalidateMode.always,
                            onSaved: (valueDate) {
                              _udfDateC1Value = SystemParam.formatDateValue
                                  .format(valueDate!);
                            },
                            onChanged: (valueDate) {
                              _udfDateC1Value = SystemParam.formatDateValue
                                  .format(valueDate!);
                            },
                            enabled: enabled,
                            format: SystemParam.formatDateDisplay,
                            initialValue: widget.workplan.udfDateC1 != null
                                ? widget.workplan.udfDateC1
                                : null,
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  locale: Locale('id'),
                                  firstDate: DateTime(SystemParam.firstDate),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(SystemParam.lastDate),
                                  fieldHintText: SystemParam.strFormatDateHint);
                            },
                            decoration: InputDecoration(
                              suffixIcon: new Icon(Icons.date_range),
                              fillColor: colorCustom,
                              // labelText: labelUdfDateA1,
                              labelStyle: TextStyle(
                                  color: colorCustom,
                                  fontStyle: FontStyle.italic),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorCustom),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorCustom),
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
                                primary: colorCustom,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text("SIMPAN"),
                              onPressed: !enabled
                                  ? null
                                  : () {
                                      if (myFormKey.currentState!.validate()) {
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
        ));
  }

  void initParameterKategoriProdukDB() async {
    // print("parameterKategoriProdukList:");
    db
        .getParameterKategoriProdukByActivityId(
            widget.workplan.activityId.toString())
        .then((data) {
      setState(() {
        itemsParameterKategoriProduk.clear();
        parameterKategoriProdukList = <ParameterKategoriProduk>[];
        loading = true;
        parameterKategoriProdukList = data;
        itemsParameterKategoriProduk.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < parameterKategoriProdukList.length; i++) {
          itemsParameterKategoriProduk.add(DropdownItem.getItemParameter(
              parameterKategoriProdukList[i].id,
              parameterKategoriProdukList[i].description));

          if (widget.workplan.kategoriProdukId != null &&
              parameterKategoriProdukList[i].id ==
                  widget.workplan.kategoriProdukId) {
            parameterKategoriProdukValue = widget.workplan.kategoriProdukId;
            initParameterProdukDB(parameterKategoriProdukValue);
          }
        }

        // if (widget.workplan.kategoriProdukId != null && parameterKategoriProdukList.contains(widget.workplan.kategoriProdukId)) {
        //   parameterKategoriProdukValue = widget.workplan.kategoriProdukId;
        //   initParameterProdukDB(parameterKategoriProdukValue);
        // }

        loading = false;
      });
    });
  }

  // void initParameterKategoriProduk() async {
  //   itemsParameterKategoriProduk.clear();
  //   parameterKategoriProdukList = <ParameterKategoriProduk>[];
  //   loading = true;
  //   ParameterKategoriProdukModel parameterModel;
  //   var data = {
  //     "company_id": widget.user.companyId,
  //     "activity_id": widget.workplan.activityId
  //   };

  //   var response = await RestService()
  //       .restRequestService(SystemParam.fParameterKategoriProduk, data);

  //   setState(() {
  //     parameterModel =
  //         parameterKategoriProdukModelFromJson(response.body.toString());
  //     parameterKategoriProdukList = parameterModel.data;
  //     itemsParameterKategoriProduk.add(DropdownItem.getItemParameter(
  //         SystemParam.defaultValueOptionId,
  //         SystemParam.defaultValueOptionDesc));
  //     for (var i = 0; i < parameterKategoriProdukList.length; i++) {
  //       itemsParameterKategoriProduk.add(DropdownItem.getItemParameter(
  //           parameterKategoriProdukList[i].id,
  //           parameterKategoriProdukList[i].description));

  //       if (widget.workplan.kategoriProdukId != null &&
  //           parameterKategoriProdukList[i].id ==
  //               widget.workplan.kategoriProdukId) {
  //         parameterKategoriProdukValue = widget.workplan.kategoriProdukId;
  //       }
  //     }
  //     loading = false;
  //   });
  // }

  initParameterProdukDB(int kategori) {
    setState(() {
      //loading = true;
      itemsParameterProduk.clear();
      parameterProdukList = <ParameterProduk>[];
      parameterProdukValue = SystemParam.defaultValueOptionId;
    });

    db.getParameterProdukByKategoriId(kategori.toString()).then((data) {
      setState(() {
        //parameterProdukValue = SystemParam.defaultValueOptionId;
        // parameterProdukValue = SystemParam.defaultValueOptionId;
        parameterProdukList = data;

        itemsParameterProduk.add(DropdownItem.getItemParameter(
            SystemParam.defaultValueOptionId,
            SystemParam.defaultValueOptionDesc));
        for (var i = 0; i < parameterProdukList.length; i++) {
          //print("parameterProdukList[i].description:"+parameterProdukList[i].description);
          itemsParameterProduk.add(DropdownItem.getItemParameter(
              parameterProdukList[i].id, parameterProdukList[i].description));
          // itemsParameterProduk.sel
          print("widget.workplan.jenisProdukId :" +
              widget.workplan.jenisProdukId.toString() +
              "-" +
              parameterProdukList[i].id.toString());
          if (widget.workplan.jenisProdukId != null &&
              parameterProdukList[i].id.toString() ==
                  widget.workplan.jenisProdukId.toString()) {
            parameterProdukValue =
                int.parse(widget.workplan.jenisProdukId.toString());
          }
        }

        // if (widget.workplan.jenisProdukId != null && parameterProdukList.contains(widget.workplan.jenisProdukId)) {
        //     parameterProdukValue = widget.workplan.jenisProdukId;
        //   }
      });
    });
  }

  // void initParameterProduk(int val) async {
  //   itemsParameterProduk.clear();
  //   parameterProdukList = <ParameterProduk>[];
  //   parameterProdukValue = SystemParam.defaultValueOptionId;

  //   loading = true;
  //   ParameterProdukModel parameterModel;
  //   var data = {"company_id": widget.user.companyId, "kategori_produk_id": val};

  //   print(data);

  //   var response = await RestService()
  //       .restRequestService(SystemParam.fParameterProduk, data);

  //   print(response.toString());
  //   setState(() {
  //     parameterModel = parameterProdukModelFromJson(response.body.toString());
  //     parameterProdukList = parameterModel.data;

  //     itemsParameterProduk.add(DropdownItem.getItemParameter(
  //         SystemParam.defaultValueOptionId,
  //         SystemParam.defaultValueOptionDesc));
  //     for (var i = 0; i < parameterProdukList.length; i++) {
  //       itemsParameterProduk.add(DropdownItem.getItemParameter(
  //           parameterProdukList[i].id, parameterProdukList[i].description));

  //       if (widget.workplan.jenisProdukId != null &&
  //           parameterProdukList[i].id == widget.workplan.jenisProdukId) {
  //         parameterProdukValue = widget.workplan.jenisProdukId;
  //       }
  //     }

  //     loading = false;
  //   });
  // }

  void saveData() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        saveDataOnline();
      } else {
        print('not connected-else');
        saveDataOffline();
      }
    } on SocketException catch (_) {
      print('not connected-catch');
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

  void getLableUdf() async {
    Future<ParameterUdf> parameterUdfTextC1 =
        db.getParameterUdfByName(labelUdfTextC1);
    parameterUdfTextC1.then((data) {
      setState(() {
        labelUdfTextC1 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfNumC1 =
        db.getParameterUdfByName(labelUdfNumC1);
    parameterUdfNumC1.then((data) {
      setState(() {
        labelUdfNumC1 = data.udfDescription;
      });
    });

    Future<ParameterUdf> parameterUdfDateC1 =
        db.getParameterUdfByName(labelUdfDateC1);
    parameterUdfDateC1.then((data) {
      setState(() {
        labelUdfDateC1 = data.udfDescription;
      });
    });
  }

  void saveDataOnline() async {
    // final nominalTransaksi = _nominalTransaksiCtrl(decimalSeparator: '.', thousandSeparator: ',');
    var data = {
      "id": widget.workplan.id,
      "updated_by": widget.user.id,
      "kategori_produk_id": parameterKategoriProdukValue,
      "jenis_produk_id": parameterProdukValue,
      "nominal_transaksi": _nominalTransaksiCtrl.text,
      "udf_text_c1": _udfTextC1Ctr.text,
      "udf_num_c1": _udfNumC1Ctr.text,
      "udf_date_c1": _udfDateC1Value,
    };

    var response = await RestService()
        .restRequestService(SystemParam.fWorkplanProdukUpdate, data);

    var convertDataToJson = json.decode(response.body);
    var code = convertDataToJson['code'];
    var status = convertDataToJson['status'];
    // print(status);

    if (code == "0") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WorkplanData(
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

  void saveDataOffline() async {
    _workplan.kategoriProdukId = parameterKategoriProdukValue;
    _workplan.jenisProdukId = parameterProdukValue;
    _workplan.nominalTransaksi = _nominalTransaksiCtrl.text;
    _workplan.udfTextC1 = _udfTextC1Ctr.text;
    _workplan.udfNumC1 = _udfNumC1Ctr.text;
    _workplan.udfDateC1 = _udfDateC1Value;
    _workplan.flagUpdateProduk = 1;

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
                workplan: widget.workplan,
                user: widget.user,
                isMaximumUmur: widget.isMaximumUmur)));
  }
}
