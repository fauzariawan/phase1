import 'package:flutter/material.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/utility_image.dart';
import 'package:workplan_beta_test/model/parameter_dokumen_workplan_mapping.dart';

class WorkplanDataDokumenViewImage extends StatefulWidget {
  final ParameterDokumenWorkplanMappingData parameterDokumenWorkplan;
  const WorkplanDataDokumenViewImage(
      {Key? key, required this.parameterDokumenWorkplan})
      : super(key: key);

  @override
  _WorkplanDataDokumenViewImageState createState() =>
      _WorkplanDataDokumenViewImageState();
}

class _WorkplanDataDokumenViewImageState
    extends State<WorkplanDataDokumenViewImage> {
  late Image imageFromPreferences;
  bool loading = false;
  @override
  void initState() {
    super.initState();

    loadImageFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child:Scaffold(

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
              )));
  }

  loadImageFromPreferences() {
    loading = true;
    Utility.getImageFromPreferences(
            widget.parameterDokumenWorkplan.dokumen.split('/').last)
        .then((img) {
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
