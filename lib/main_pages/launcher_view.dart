import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workplan_beta_test/pages/on_boarding_page.dart';

class LauncherPage extends StatefulWidget {
  @override
  _LauncherPageState createState() => new _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    super.initState();

    startLaunching();
  }

  startLaunching() async {
    var duration = const Duration(seconds: 1);
    return new Timer(duration, () {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (_) {
        return new OnBoardingPage();
        //LoginScreen();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
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
        child: new Scaffold(
          body: new Center(
            child: new Image.asset(
              "images/logo_new.png",
              height: 150.0,
              width: 200.0,
            ),
          ),
        ));
  }
}

// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';

// Future<Post> fetchPost() async {
//   /* final response =
//       await http.get('https://jsonplaceholder.typicode.com/posts/1');

//   if (response.statusCode == 200) {
//     // If the call to the server was successful, parse the JSON
//     return Post(userId: 1, id: 1, title: "Halo title", body: "Body");
//   } else {
//     // If that call was not successful, throw an error.
//     throw Exception('Failed to load post');
//   }*/
//   return new Future.delayed(new Duration(seconds: 3), (){
//     return Post(userId: 1, id: 1, title: "Halo title", body: "Body");
//   });
//   // return Post(userId: 1, id: 1, title: "Halo title", body: "Body");
// }

// class Post {
//   final int userId;
//   final int id;
//   final String title;
//   final String body;

//   Post({this.userId, this.id, this.title, this.body});

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//       body: json['body'],
//     );
//   }
// }

// class LauncherPage extends StatefulWidget {
//   @override
//   _LauncherPageState createState() => new _LauncherPageState();
// }

// class _LauncherPageState extends State<LauncherPage> {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       body: Center(
//         child: FutureBuilder<Post>(
//           future: fetchPost(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Text(snapshot.data.title);
//             } else if (snapshot.hasError) {
//               return Text("${snapshot.error}");
//             }

//             // By default, show a loading spinner
//             return CircularProgressIndicator();
//           },
//         ),
//       ),
//     );
//   }
// }
