import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:workplan_beta_test/base/system_param.dart';
import 'package:workplan_beta_test/pages/loginscreen.dart';

// Map<int, Color> color = {
//   50: Color.fromRGBO(255, 92, 87, .1),
//   100: Color.fromRGBO(255, 92, 87, .2),
//   200: Color.fromRGBO(255, 92, 87, .3),
//   300: Color.fromRGBO(255, 92, 87, .4),
//   400: Color.fromRGBO(255, 92, 87, .5),
//   500: Color.fromRGBO(255, 92, 87, .6),
//   600: Color.fromRGBO(255, 92, 87, .7),
//   700: Color.fromRGBO(255, 92, 87, .8),
//   800: Color.fromRGBO(255, 92, 87, .9),
//   900: Color.fromRGBO(255, 92, 87, 1),
// };
// MaterialColor colorCustom = MaterialColor(0xFF4fa06d, color);

class OnBoardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OnBoardingPageState();
  }
}

class OnBoardingPageState extends State<OnBoardingPage> {
  List<Slide> listSlides = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        onWillPop: () async {
          // exit;
          await showDialog(
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
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: new Text('Yes'),
                    ),
                  ],
                ),
              );
          
          return false;
        },
        child: IntroSlider(
          slides: listSlides,
          onDonePress: onPressedDone,
          onSkipPress: onPressedDone,
          renderSkipBtn: this.renderSkipBtn(),
          renderNextBtn: this.renderNextBtn(),
          renderDoneBtn: this.renderDoneBtn(),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listSlides.add(Slide(
      widgetTitle: widgetTitle(),
      pathImage: "images/boarding_1.png",
      widgetDescription: this.widgetDescription("WrkPln",
          "Merupakan aplikasi untuk pengelolaan kinerja karyawan dalam melakukan perencanaan dan pelaksanaan pekerjaan"),
      backgroundColor: Colors.white,
    ));
    listSlides.add(Slide(
      widgetTitle: widgetTitle(),
      widgetDescription: this.widgetDescription("GPS & Kamera HP",
          "Aplikasi memerlukan penggunaan lokasi GPS dari Google sebagai bukti kunjungan dilakukan di lokasi yang benar & kamera HP untuk pengambilan photo dokumen pelanggan"),

      pathImage: "images/boarding_2.png",
      backgroundColor: Colors.white,
    ));
    listSlides.add(Slide(
      widgetTitle: widgetTitle(),
      widgetDescription: this.widgetDescription("Keamanan Data",
          "Data tersimpan dalam sistem cloud dengan tingkat keamanan yang ketat dan tinggi yang hanya bisa diakses oleh pihak yang diijinkan, dan telah memperoleh sertifikasi keamanan dunia"),

      pathImage: "images/boarding_3.png",
      backgroundColor: Colors.white,
    ));
  }

  Widget renderNextBtn() {
    return Text(
      "NEXT",
      style: TextStyle(
          fontSize: 18,
          color: SystemParam.colorCustom,
          fontWeight: FontWeight.bold),
    );
  }

  Widget renderDoneBtn() {
    return Text(
      "DONE",
      style: TextStyle(
          fontSize: 18,
          color: SystemParam.colorCustom,
          fontWeight: FontWeight.bold),
    );
  }

  Widget renderSkipBtn() {
    return Text(
      "SKIP",
      style: TextStyle(
          fontSize: 18,
          color: SystemParam.colorCustom,
          fontWeight: FontWeight.bold),
    );
  }

  onPressedDone() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
  }

  widgetDescription(String title, String desc) {
    return Center(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: SystemParam.colorCustom, fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: TextStyle(color: SystemParam.colorCustom, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }

  widgetTitle() {
    return new Center(
      child: new Image.asset(
        "images/App_Splash/WrkPln Logo 2.png",
        height: 100.0,
        width: 100.0,
      ),
    );
  }
}
