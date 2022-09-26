import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/main_pages/constans.dart';
import 'package:workplan_beta_test/main_pages/landingpage_view.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/home_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_inbox.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_list.dart';

class TaskMenu extends StatefulWidget {
  final User user;
  const TaskMenu({Key? key, required this.user}) : super(key: key);
  

  @override
  _TaskMenuState createState() => _TaskMenuState();
}

class _TaskMenuState extends State<TaskMenu> {
  List<WorkplanMenu2> _workplanServiceList = [];

  @override
  void initState() {
    super.initState();

    // SessionTimer().startTimer(widget.user.timeoutLogin);
    initMenu();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        // behavior:HitTestBehavior.translucent,
        // onTap: SessionTimer().userActivityDetected(context, widget.user),
        // onTapDown: SessionTimer().userActivityDetected(context, widget.user),
        // onTapUp: SessionTimer().userActivityDetected(context, widget.user),
        child: WillPopScope(
            onWillPop: () async {
              //  Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LandingPage(user: widget.user)));
              return false;
            },
            child: Scaffold(
                //drawer: NavigationDrawerWidget(),
                appBar: AppBar(
                  title: Text('Task Menu'),
                  centerTitle: true,
                  backgroundColor: SystemParam.colorCustom,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    //onPressed: () => Navigator.of(context).pop(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LandingPage(user: widget.user)));
                    },
                  ),
                ),
                body: new Container(
                    child: new ListView(
                        physics: ClampingScrollPhysics(),
                        children: <Widget>[
                      new Container(
                          padding:
                              EdgeInsets.only(left: 2.0, right: 2.0, top: 2.0),
                          // color: Colors.white,
                          child: new Column(
                            children: <Widget>[_buildMenu()],
                          )),
                    ])))));
  }

  Widget _buildMenu() {
    return new SizedBox(
        width: double.infinity,
        height: 200.0,
        child: new Container(
            margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: GridView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: 2,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, position) {
                  return _rowMenuService(_workplanServiceList[position]);
                })));
  }

  Widget _rowMenuService(WorkplanMenu2 menu) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (menu.title == "LIST TASK") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkplanList(
                        user: widget.user,
                      ),
                    ));
              } else if (menu.title == "INBOX") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WorkplanInboxPage(user: widget.user),
                    ));
              } else if (menu.title == "OTHER") {}
            },
            child: new Container(
              decoration: new BoxDecoration(
                  border:
                      Border.all(color: WorkplanPallete.grey200, width: 1.0),
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(10.0))),
              padding: EdgeInsets.all(12.0),
              child: new Icon(
                menu.image,
                color: menu.color,
                size: 74.0,
              ),
              // child: menu.image,
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 6.0),
          ),
          new Text(menu.title, style: new TextStyle(fontSize: 10.0))
        ],
      ),
    );
  }

  initMenu() {
    setState(() {
      _workplanServiceList.add(
        new WorkplanMenu2(
            image: Ionicons.cube_outline,
            color: WorkplanPallete.menuCar,
            title: "INBOX"),
      );

      _workplanServiceList.add(
        new WorkplanMenu2(
            image: Ionicons.checkmark_circle,
            color: WorkplanPallete.menuPulsa,
            title: "LIST TASK"),
      );
    });
  }
}
