import 'package:flutter/material.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_list.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_inbox.dart';

MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);

class MenuWorkplan extends StatefulWidget {
  final User user;

  const MenuWorkplan({Key? key, required this.user}) : super(key: key);
  @override
  _MenuWorkplanState createState() => _MenuWorkplanState();
}

class _MenuWorkplanState extends State<MenuWorkplan> {
  late final Color? color;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // SessionTimer sessionTimer = new SessionTimer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SessionTimer().userActivityDetected(context, widget.user);
    // setState(() {
      if (null != _scaffoldKey && null != _scaffoldKey.currentState) {
        // sessionTimer.userActivityDetected( _scaffoldKey.currentState!.context, widget.user);
      }
    // });
  }

  @override
  Widget build(BuildContext context) => new GestureDetector(
      behavior: HitTestBehavior.translucent,
      // onTap: () {
      // _handleUserInteraction(context);
      //},
      // onPanDown: (){
      //   _handleUserInteraction();
      // },
      // onTap: sessionTimer.userActivityDetected(context, widget.user),
      // onPanDown: sessionTimer.userActivityDetected(context, widget.user),
      // onScaleStart: sessionTimer.userActivityDetected(context, widget.user),
      // onHorizontalDragStart: SessionTimer().userActivityDetected(context,widget.user),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Task'),
            centerTitle: true,
            backgroundColor: colorCustom,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  //elevation: 2.0,
                  child: ListTile(
                    leading: Image.asset(
                      "images/inbox.png",
                    ),
                    title: Text(
                      "INBOX",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text("Klik untuk melihat inbox"),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // sessionTimer.userActivityDetected(context, widget.user);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkplanInboxPage(
                              user: widget.user,
                            ),
                          ));
                    },
                  ),
                ),
                Card(
                  color: Colors.white,
                  //elevation: 2.0,
                  child: ListTile(
                    leading: Image.asset(
                      "images/checked.png",
                    ),
                    title: Text(
                      "LIST TASK",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text("Klik untuk melihat workplan"),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkplanList(user: widget.user),
                          ));
                    },
                  ),
                ),
              ],
            ),
          )));
}

class Choice {
  const Choice(
      {required this.title,
      required this.icon,
      required this.title2,
      required MaterialColor color});

  final String title;
  final String title2;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(
      title: 'INBOX', title2: '', icon: Icons.inbox, color: Colors.green),
  const Choice(
      title: 'LIST TASK',
      title2: '',
      icon: Icons.check_circle,
      color: Colors.green),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard(
      {Key? key,
      required this.choice,
      required this.onTap,
      required this.item,
      this.selected: false})
      : super(key: key);

  final Choice choice;
  final VoidCallback onTap;
  final Choice item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    //  TextStyle? textStyle = Theme.of(context).textTheme.display1;

    // if (selected)
    //textStyle = textStyle!.copyWith(color: Colors.lightGreenAccent[400]);
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Card(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.topLeft,
                  child: Icon(
                    choice.icon,
                    size: 80.0,
                    color: Colors.lightGreenAccent[400],
                  )),
              new Expanded(
                child: new Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    choice.title,
                    semanticsLabel: choice.title2,
                    style: null,
                    textAlign: TextAlign.left,
                    maxLines: 5,
                  ),
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )),
    );
  }
}
