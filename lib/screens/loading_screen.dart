import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quer/screens/home_screen.dart';
import 'package:quer/screens/scan_screen.dart';

class LoadingScreen extends StatefulWidget {
  static const id = 'loading page';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assignUser();
  }

  String uid;

  void assignUser() async {
    try {
      uid = _auth.currentUser.uid;
      print("success");
    } catch (e) {
      print("its a null");
      uid = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return uid == null
        ? ScanScreen()
        : HomeScreen(
            uid: uid,
          );
  }
}
