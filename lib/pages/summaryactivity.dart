import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(255, 92, 87, .1),
  100: Color.fromRGBO(255, 92, 87, .2),
  200: Color.fromRGBO(255, 92, 87, .3),
  300: Color.fromRGBO(255, 92, 87, .4),
  400: Color.fromRGBO(255, 92, 87, .5),
  500: Color.fromRGBO(255, 92, 87, .6),
  600: Color.fromRGBO(255, 92, 87, .7),
  700: Color.fromRGBO(255, 92, 87, .8),
  800: Color.fromRGBO(255, 92, 87, .9),
  900: Color.fromRGBO(255, 92, 87, 1),
};
MaterialColor colorCustom = MaterialColor(0xFF4fa06d, color);

class Summaryactivity extends StatelessWidget {
  final _keyForm = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('WORKPLAN'),
          centerTitle: true,
          backgroundColor: colorCustom,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                autovalidateMode: AutovalidateMode.disabled, key: _keyForm,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: new TextStyle(color: Colors.black),
                          initialValue: "DSS0121040100001",
                          readOnly: true,
                          // validator: validasiUsername,
                          onSaved: (em) {
                            if (em != null) {}
                          },
                          decoration: InputDecoration(
                            icon: new Icon(Ionicons.document_outline),
                            fillColor: colorCustom,
                            labelText: "No Workplan",
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
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: new TextStyle(color: Colors.black),
                          initialValue: "Follow Up",
                          readOnly: true,
                          // validator: validasiUsername,
                          onSaved: (em) {
                            if (em != null) {}
                          },
                          decoration: InputDecoration(
                            icon: new Icon(Ionicons.create_outline),
                            fillColor: colorCustom,
                            labelText: "Progress",
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
                        padding: const EdgeInsets.all(8.0),
                        child: DateTimeField(
                          readOnly: true,
                          format: format,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.combine(date, time);
                            } else {
                              return currentValue;
                            }
                          },
                          decoration: InputDecoration(
                            icon: new Icon(Icons.date_range),
                            fillColor: colorCustom,
                            labelText: "Tanggal Rencana Kunjungan 1",
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
                        child: DateTimeField(
                          readOnly: true,
                          format: format,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.combine(date, time);
                            } else {
                              return currentValue;
                            }
                          },
                          decoration: InputDecoration(
                            icon: new Icon(Icons.date_range),
                            fillColor: colorCustom,
                            labelText: "Tanggal Aktual Kunjungan 1",
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
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: new TextStyle(color: Colors.black),
                          initialValue: "10:05",
                          readOnly: true,
                          // validator: validasiUsername,
                          onSaved: (em) {
                            if (em != null) {}
                          },
                          decoration: InputDecoration(
                            icon: new Icon(Ionicons.time),
                            fillColor: colorCustom,
                            labelText: "Check in time",
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: new TextStyle(color: Colors.black),
                          initialValue: "12:00",
                          readOnly: true,
                          // validator: validasiUsername,
                          onSaved: (em) {
                            if (em != null) {}
                          },
                          decoration: InputDecoration(
                            icon: new Icon(Ionicons.time),
                            fillColor: colorCustom,
                            labelText: "Check out time",
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: new TextStyle(color: Colors.black),
                          initialValue: "Approaching",
                          readOnly: false,
                          // validator: validasiUsername,
                          onSaved: (em) {
                            if (em != null) {}
                          },
                          decoration: InputDecoration(
                            icon: new Icon(Ionicons.navigate),
                            fillColor: colorCustom,
                            labelText: "Tujuan Kunjungan",
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: new TextStyle(color: Colors.black),
                          initialValue: "Tidak Ada",
                          readOnly: true,
                          // validator: validasiUsername,
                          onSaved: (em) {
                            if (em != null) {}
                          },
                          decoration: InputDecoration(
                            icon: new Icon(Ionicons.navigate),
                            fillColor: colorCustom,
                            labelText: "Hasil Kunjungan",
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: new TextStyle(color: Colors.black),
                          initialValue: "",
                          readOnly: false,
                          // validator: validasiUsername,
                          onSaved: (em) {
                            if (em != null) {}
                          },
                          decoration: InputDecoration(
                            icon: new Icon(Ionicons.book),
                            fillColor: colorCustom,
                            labelText: "Catatan Kunjungan",
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
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text("SIMPAN"),
                            onPressed: () {
                              //prosesSave(empUpd);
                            },
                            color: colorCustom,
                            // textColor: Colors.white,
                            //color: Colors.white20,
                            //color: Colors.white20[500],
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
