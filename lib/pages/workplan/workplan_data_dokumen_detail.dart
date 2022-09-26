import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/helper/database.dart';
import 'package:workplan_beta_test/helper/rest_service.dart';
import 'package:workplan_beta_test/helper/utility_image.dart';
import 'package:workplan_beta_test/model/parameter_dokumen_workplan_mapping.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/workplan_dokumen_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data_dokumen_take_picture.dart';
import 'package:workplan_beta_test/pages/workplan/workplan_data_dokumen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:workplan_beta_test/widget/warning.dart';

MaterialColor colorCustom = MaterialColor(0xFF4fa06d, SystemParam.color);

class WorkplanDataDokumenDetail extends StatefulWidget {
  final WorkplanInboxData workplan;
  final User user;
  final String title;
  // final ParameterDokumenWorkplanMappingData dt;
  final int maxPhoto;
  final int dokumenId;
  final bool isMaximumUmur;
  final String description;

  const WorkplanDataDokumenDetail(
      {Key? key,
      required this.workplan,
      required this.user,
      required this.title,
      // required this.dt,
      required this.isMaximumUmur,
      required this.maxPhoto,
      required this.dokumenId,
      required this.description})
      : super(key: key);

  @override
  _WorkplanDataDokumentate createState() => _WorkplanDataDokumentate();
}

class _WorkplanDataDokumentate extends State<WorkplanDataDokumenDetail> {
  bool loading = false;
  bool enabled = false;
  // late List<ParameterDokumen> parameterDokumenList;
  List<ParameterDokumenWorkplanMappingData> parameterDokumenWorkplanList =
      <ParameterDokumenWorkplanMappingData>[];
  late Image imageFromPreferences;
  List<Image> imageFromPreferencesList = <Image>[];
  int imgCount = 0;
  var db = new DatabaseHelper();
  bool isOnline = false;
  String _s3Url = "";
  final _picker = ImagePicker();
  List<WorkplanDokumen> workplanDokumenList = <WorkplanDokumen>[];

  @override
  void initState() {
    super.initState();

    print('lagi build inits3url');
    initS3Url();
    initParameterDokumen();
    if (widget.workplan.isCheckIn == "1" &&
        (widget.workplan.progresStatusIdAlter == 2 ||
            widget.workplan.progresStatusIdAlter == 4)) {
      enabled = true;
    } else {
      enabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final photos = <File>[];
    // final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkplanDataDokumen(
                    workplan: widget.workplan,
                    user: widget.user,
                    title: "Dokumen",
                    isMaximumUmur: widget.isMaximumUmur),
              ));
          return false;
        },
        child: Scaffold(
          //drawer: NavigationDrawerWidget(),
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            backgroundColor: colorCustom,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              //onPressed: () => Navigator.of(context).pop(),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkplanDataDokumen(
                          workplan: widget.workplan,
                          user: widget.user,
                          title: "Dokumen",
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
                  child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: !enabled
                              ? null
                              : () {
                                  // doCapture(widget.dt, 0);
                                  doCapture(0, widget.dokumenId,
                                      widget.maxPhoto, widget.description);
                                },
                          child: Container(
                            child: Icon(Ionicons.camera, size: 130),
                          ),
                        )),
                    Container(
                      child: Text("Silakan ambil photo dokumen"),
                    ),
                    isOnline
                        ? Container(child: createListViewImageS3())
                        : Container(child: createListViewImageOffline())
                  ],
                )),
        ));
  }

  void initParameterDokumen() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
        loading = true;
        ParameterDokumenWorkplanMapping parameterModel;
        var data = {
          "company_id": widget.user.userCompanyId,
          "workplan_activity_id": widget.workplan.id,
          "product_id": widget.workplan.jenisProdukId,
          //"document_id": widget.dt.documentId
          "document_id": widget.dokumenId
        };

        // print(data);
        var response = await RestService().restRequestService(
            SystemParam.fParameterDokumenWorkplanMappingByDocumentId, data);

        setState(() {
          parameterModel =
              parameterDokumenWorkplanMappingFromJson(response.body.toString());
          parameterDokumenWorkplanList = parameterModel.data;
          imgCount = parameterDokumenWorkplanList.length;

          for (var i = 0; i < parameterDokumenWorkplanList.length; i++) {
            loadImageFromPreferences(parameterDokumenWorkplanList[i].dokumen)
                .then((value) {
              setState(() {
                imageFromPreferencesList.add(value);
              });
            });
          }

          loading = false;
        });
      }
    } on SocketException catch (_) {
      isOnline = false;
      db
          .getListWorkplanDokumenByDokumenId(widget.dokumenId.toString())
          .then((value) {
        //
      });
    }
  }

  ListView createListViewImageS3() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: parameterDokumenWorkplanList.length,
      itemBuilder: (BuildContext context, int index) {
        return customListItemImageS3(parameterDokumenWorkplanList[index]);
      },
    );
  }

  ListView createListViewImage2() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: parameterDokumenWorkplanList.length,
      itemBuilder: (BuildContext context, int index) {
        if (imageFromPreferencesList.isNotEmpty) {
          return customListItemImage2(
              imageFromPreferencesList[index],
              parameterDokumenWorkplanList[index].workplanDokumenId,
              widget.dokumenId,
              widget.maxPhoto,
              widget.description);
        } else {
          return customListItemImage2Null();
        }
      },
    );
  }

  customListItemImageS3(ParameterDokumenWorkplanMappingData pdwm) {
    print('ini link foto');
    print(_s3Url);
    print(pdwm.dokumen);
    return GestureDetector(
        onTap: !enabled
            ? null
            : () {
                doCapture(pdwm.workplanDokumenId, widget.dokumenId,
                    widget.maxPhoto, widget.description);
              },
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Container(
              child: CachedNetworkImage(
                imageUrl: _s3Url + "/" + pdwm.dokumen,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Container(),
              ),
              // child: Image.network(
              //     "https://dnrxhhzm9tsok.cloudfront.net/" + pdwm.dokumen),
            ),
          ),
        ));
  }

  customListItemImage2Null() {
    return new Container();
  }

  customListItemImage2(Image imgDock, int workplanDokumenId, int dokumenId,
      int maxPhoto, String description) {
    //print("workplanDokumenId:" + workplanDokumenId.toString());
    return GestureDetector(
        onTap: () {
          // doCapture(widget.dt, workplanDokumenId);
          doCapture(workplanDokumenId, dokumenId, maxPhoto, description);
        },
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Container(
              child: imgDock,
            ),
          ),
        ));
  }

  ListView createListViewImage() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imageFromPreferencesList.length,
      itemBuilder: (BuildContext context, int index) {
        return customListItemImage(imageFromPreferencesList[index]);
      },
    );
  }

  customListItemImage(Image imgDock) {
    // print(imgDock);
    return GestureDetector(
        onTap: () {},
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Container(
              child: imgDock,
            ),
          ),
        ));
  }

  Future<Image> loadImageFromPreferences(String doc) async {
    return Utility.getImageFromPreferences(doc.split('/').last).then((img) {
      Image imgRes = Utility.imageFromBase64String(img!);
      return imgRes;
    });
  }

//  void doCapture(ParameterDokumenWorkplanMappingData dt, int workplanDokumenId)async {
  void doCapture(int workplanDokumenId, int dokumenId, int maxPhoto,
      String description) async {
    // try {
    //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    //   if (image != null) {
    //     await Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (context) => DisplayPictureScreen(
    //           // Pass the automatically generated path to
    //           // the DisplayPictureScreen widget.
    //           // imageReadAsBytes:imageReadAsBytes,
    //           imageSource: image,
    //           imagePath: image.path,
    //           // parameterDokumenWorkplan: widget.parameterDokumenWorkplan,

    //           workplan: widget.workplan,
    //           user: widget.user,
    //           isMaximumUmur: widget.isMaximumUmur,
    //           workplanDokumenId: workplanDokumenId,
    //           description: widget.description,
    //           dokumenId: widget.dokumenId,
    //         ),
    //       ),
    //     );
    //   } else {
    //     return;
    //   }
    // } catch (e) {
    //   print(
    //       'ini error dari fungsi do capture <<<<<<<<<<<<<<<<<============== ');
    //   print(e);
    //   getLostData();
    // }

    // print("dt.maxphoto=" + dt.maxphoto.toString());
    // print("imgCount=" + imgCount.toString());
    if (workplanDokumenId == 0 && imgCount >= maxPhoto) {
      Fluttertoast.showToast(
          msg: "Photo dokumen sudah melebihi batas ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    try {
      final cameras = await availableCameras();
      // Get a specific camera from the list of available cameras.
      final firstCamera = cameras.first;

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkplanDokTakePicture(
              camera: firstCamera,
              // parameterDokumenWorkplan: dt,
              workplan: widget.workplan,
              user: widget.user,
              isMaximumUmur: widget.isMaximumUmur,
              workplanDokumenId: workplanDokumenId,
              dokumenId: dokumenId,
              maxPhoto: maxPhoto, description: description,
            ),
          ));

      initParameterDokumen();
    } catch (e) {
      Warning.showWarning(e.toString());
    }
  }

  Future<void> getLostData() async {
    print('ini proses get lost data <<<<<<<<<==============');
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.files != null) {
      for (final XFile file in response.files!) {
        print('ini file nya <<<<<<<<<<<<<<<<<==============');
        print(file);
      }
    } else {
      print('ini error tidak ada file <<<<<<<<<<<<<<<<<==============');
      print(response.exception);
      // _handleError(response.exception);
    }
  }

  ListView createListViewImageOffline() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workplanDokumenList.length,
      itemBuilder: (BuildContext context, int index) {
        return customListItemImageOffline(workplanDokumenList[index]);
      },
    );
  }

  customListItemImageOffline(WorkplanDokumen workplanDokumenList) {
    //TODO
  }

  initS3Url() async {
    print('masuk ke s3url <<<<<=========');
    db.getEnvByName(SystemParam.EnvAWS).then((value) {
      setState(() {
        loading = true;
        _s3Url = value.value;
        print('ini link dari aws');
        print(_s3Url);
        loading = false;
      });
    });
  }
}
