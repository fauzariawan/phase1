import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

// import 'lo'
class BiometrikLogin extends StatefulWidget {
  const BiometrikLogin({Key? key}) : super(key: key);

  @override
  _BiometrikLoginState createState() => _BiometrikLoginState();
}

class _BiometrikLoginState extends State<BiometrikLogin> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String _message = "Not Authorized";

  @override
  void initState() {
    super.initState();
    checkingForBioMetrics();
  }

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    return canCheckBiometrics;
  }

  Future<void> _authenticateMe() async {
// 8. this method opens a dialog for fingerprint authentication.
//    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Authenticate for Testing", // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true, // native process
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(""),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _authenticateMe,
        child: Icon(Icons.add),
      ),
    );
  }
}
