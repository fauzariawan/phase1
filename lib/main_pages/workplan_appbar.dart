import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:workplan_beta_test/main_pages/messages_view.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/pages/marquee_page.dart';
import 'package:workplan_beta_test/pages/profile/profile_page.dart';

import 'constans.dart';

class WorkPlanAppBar extends AppBar {
  WorkPlanAppBar(BuildContext context, User user, int newMessage)
      : super(
            elevation: 0.25,
            backgroundColor: Colors.white,
            flexibleSpace: _buildGojekAppBar(context, user, newMessage,));

  static Widget _buildGojekAppBar(
      BuildContext context, User user, int newMessage,) {

        
  //  SessionTimer sessionTimer = new SessionTimer();
   
    return new Container(
      padding: EdgeInsets.only(left: 1.0, right: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 1.0, bottom: 8.0),
            child: new Image.asset(
              "images/logo_only.jpg",
              height: 65.0,
              width: 160.0,
            ),
          ),
          new Container(
            child: new Row(
              children: <Widget>[
                Listener(
                  onPointerDown: (PointerDownEvent event) {
                    // sessionTimer.userActivityDetected(context,user);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoticesView(user: user,)));
                  },
                  onPointerUp: (PointerUpEvent event) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoticesView(user: user)));
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: new Container(
                        height: 28.0,
                        width: 28.0,
                        padding: EdgeInsets.all(6.0),
                        alignment: Alignment.centerRight,
                        child: Badge(
                          badgeContent: Text(newMessage.toString()),
                          child: new Icon(
                            Ionicons.notifications,
                            color: WorkplanPallete.green,
                            size: 25.0,
                          ),
                        ),
                      )),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(user: user)));
                  }, 
                  icon: Icon(
                    Ionicons.menu,
                    color: WorkplanPallete.green,
                    size: 25.0,
                  ),
                )
                // Listener(
                //   onPointerDown: (PointerDownEvent event) {
                //     sessionTimer.userActivityDetected(context,user);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => ProfilePage(user: user)));
                //   },
                //   onPointerUp: (PointerUpEvent event) {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => ProfilePage(user: user)));
                //   },
                //   onPointerMove: (PointerMoveEvent event){
                //      Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => ProfilePage(user: user)));
                //   },
                //   child: Padding(
                //       padding: const EdgeInsets.only(left: 5.0),
                //       child: new Container(
                //         height: 28.0,
                //         width: 28.0,
                //         padding: EdgeInsets.all(6.0),
                //         alignment: Alignment.centerRight,
                //         child: new Icon(
                //           Ionicons.menu,
                //           color: WorkplanPallete.green,
                //           size: 25.0,
                //         ),
                //       )),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
