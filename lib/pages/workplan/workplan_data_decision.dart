import 'package:flutter/material.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/model/workplan_messages.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data.dart';

MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);

class WorkplanDataDecision extends StatefulWidget {
  final WorkplanInboxData workplan;
  final User user;
  final bool isMaximumUmur;

  const WorkplanDataDecision(
      {Key? key,
      required this.workplan,
      required this.user,
      required this.isMaximumUmur})
      : super(key: key);

  @override
  _WorkplanDataDecisionState createState() => _WorkplanDataDecisionState();
}

class _WorkplanDataDecisionState extends State<WorkplanDataDecision> {
  final _keyForm = GlobalKey<FormState>();
  bool loading = false;
  int count = 0;
  // late WorkplanMessagesModel workplanMessages;
  List<WorkplanMessages> wmList = <WorkplanMessages> [];
  TextEditingController _keputusanCtr = new TextEditingController();
  TextEditingController _alasanCtr = new TextEditingController();
  var keputusan = "";
  var db = new DatabaseHelper();
  @override
  void initState() {
    super.initState();
    // getWorkplanMessagesDB();
    getWorkplanMessages();

    if (widget.workplan.keputusan != null) {
      if (widget.workplan.keputusan == "1") {
        keputusan = "Disetujui";
      } else {
        keputusan = "Ditolak";
      }
      _keputusanCtr.text = keputusan;
    }

    // ignore: unnecessary_null_comparison
    if (widget.workplan.alasanTolakDescription != null) {
      _alasanCtr.text = widget.workplan.alasanTolakDescription;
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
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

          //drawer: NavigationDrawerWidget(),
          appBar: AppBar(
            title: Text('Keputusan'),
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _keyForm,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Pesan',
                                    style: TextStyle(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16)),
                                TextSpan(
                                    text: ' : ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: Colors.red)),
                              ],
                            ),
                          ),
                        ),
                        loading == true
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : new Container(child: createListView()),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Keputusan',
                                    style: TextStyle(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16)),
                                TextSpan(
                                    text: '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
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
                            // validator: requiredValidator,
                            controller: _keputusanCtr,
                            maxLines: 1,
                            enabled: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: new TextStyle(color: Colors.black),
                            readOnly: false,
                            onSaved: (em) {
                              if (em != null) {}
                            },
                            decoration: InputDecoration(
                              //icon: new Icon(Ionicons.person),
                              fillColor: colorCustom,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,

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
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Alasan(  ditolak)',
                                    style: TextStyle(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        color: colorCustom,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16)),
                                TextSpan(
                                    text: '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
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
                            // validator: requiredValidator,
                            controller: _alasanCtr,
                            maxLines: 5,
                            enabled: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: new TextStyle(color: Colors.black),
                            readOnly: false,
                            onSaved: (em) {
                              if (em != null) {}
                            },
                            decoration: InputDecoration(
                              //icon: new Icon(Ionicons.person),
                              fillColor: colorCustom,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,

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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )));

  void getWorkplanMessages() async {
    // var userId = widget.user.data.id;
    var data = {
      "workplan_activity_id": widget.workplan.id
      // ,"progres_status_id": progresStatusId
    };

    var response = await RestService()
        .restRequestService(SystemParam.fWorkplanMessagesByWorkplanId, data);

    setState(() {
      WorkplanMessagesModel workplanMessagesModel = workplanMessagesFromJson(response.body.toString());
      count = workplanMessagesModel.data.length;
      wmList = <WorkplanMessages> [];
      wmList = workplanMessagesModel.data;
      loading = false;
    });
  }

  void getWorkplanMessagesDB() async {
    db
        .getWorkplanMessagesByWorkplanActivityId(widget.workplan.id.toString())
        .then((value) {
      setState(() {
        // workplanMessages = workplanMessagesFromJson(response.body.toString());
        wmList = <WorkplanMessages> [];
        wmList = value;
        count = wmList.length;
        loading = false;
      });
    });
  }

  ListView createListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return customListItem(wmList[index]);
      },
    );
  }

  customListItem(WorkplanMessages wmData) {
    return Card(
      color: Colors.white,
      //elevation: 2.0,
      child: ListTile(
        // leading: Image.asset(
        //   "images/man.png",
        // ),
        // title: Text(
        //   SystemParam.formatDateDisplay.format(wmData.createdAt),
        //   style: TextStyle(fontSize: 16),
        // ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(wmData.body,
            style: TextStyle(fontSize: 14),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Dari: "+wmData.fullName+" ("+SystemParam.formatDateDisplay.format(wmData.createdAt)+")",style: TextStyle(fontSize: 12),),
        ),
        //+"tgl: "+SystemParam.formatDateDisplay.format(wmData.createdAt)
        //trailing: Icon(Icons.arrow_forward),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
