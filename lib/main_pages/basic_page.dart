
import 'package:flutter/material.dart';
import 'package:workplan_beta_test/main_pages/session_timer.dart';
import 'package:workplan_beta_test/model/user_model.dart';


mixin BasicPage<Page extends BasePage> on BaseState<Page> {

  // SessionTimer sessionTimer = new SessionTimer();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // behavior:HitTestBehavior.translucent,
      //   onTap: sessionTimer.userActivityDetected(context,widget.user),
      //   onPanDown: sessionTimer.userActivityDetected(context,widget.user),
      //   onScaleStart: sessionTimer.userActivityDetected(context,widget.user),
      //   onHorizontalDragStart: sessionTimer.userActivityDetected(context,widget.user),
      child: rootWidget(context),
    );
  }

  Widget rootWidget(BuildContext context);
}

abstract class BasePage extends StatefulWidget {

  final User user;
  BasePage( this.user, { Key? key}) : super(key: key);
}

abstract class BaseState<Page extends BasePage> extends State<Page> {}