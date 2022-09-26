import 'package:flutter/material.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/utility_image.dart';
import 'package:workplan_beta_test/model/workplan_visit_model.dart';

class VisitCheckinViewImage extends StatefulWidget {
  final WorkplanVisit workplanVisit;
  const VisitCheckinViewImage(
      {Key? key, required this.workplanVisit})
      : super(key: key);

  @override
  _VisitCheckinViewImageState createState() =>
      _VisitCheckinViewImageState();
}

class _VisitCheckinViewImageState
    extends State<VisitCheckinViewImage> {
  late Image imageFromPreferences;
  bool loading = false;
  @override
  void initState() {
    super.initState();

    loadImageFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text(''),
          centerTitle: true,
          backgroundColor: SystemParam.colorCustom,
        ),
        body: loading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Container(
                    child: imageFromPreferences,
                  ),
                ),
              ));
  }

  loadImageFromPreferences() {
    loading = true;
    Utility.getImageFromPreferences(widget.workplanVisit.photoCheckIn.split('/').last).then((img) {
      if (null == img) {
        return;
      }
      setState(() {
        imageFromPreferences = Utility.imageFromBase64String(img);
        loading = false;
      });
    });
  }
}
