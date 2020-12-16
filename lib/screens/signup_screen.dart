import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quer/constants.dart';
import 'package:quer/quer_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quer/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  static const id = 'signup screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;

  String email;
  String restaurantName;
  String password1;
  String password2;

  bool validatePassword = false;
  bool validate = false;
  bool showSpinner = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  void _signinUser() async {
    setState(() {
      showSpinner = true;
      emailController.text.isEmpty ? validate = true : validate = false;
      password2Controller.text.isEmpty ? validate = true : validate = false;
    });

    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password2,
      );
      final uid = _auth.currentUser.uid;
      FirebaseFirestore.instance.collection('restaurant').doc(uid).set(
        {
          'restaurantName': restaurantName,
          'email': email,
          'password': password2,
          'uid': uid,
        },
      );
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              uid: uid,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      showSpinner = false;
    });
  }

  void onChangedEmail(n) {
    setState(() {
      validate = false;
    });
    email = n;
  }

  void onChangedName(n) {
    setState(() {
      validate = false;
    });
    restaurantName = n;
  }

  void onChangedPassword1(n) {
    setState(() {
      validate = false;
    });
    password1 = n;
  }

  void onChangedPassword2(n) {
    setState(() {
      validate = false;
    });
    password2 = n;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: Theme(
        data: ThemeData(accentColor: kBlackColor),
        child: CircularProgressIndicator(),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          iconTheme: IconThemeData(
            color: kBlackColor,
          ),
          elevation: 0,
          title: HeadingText(
            title: 'Sign up',
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFieldWidget(
                  hintText: 'restaurant name',
                  onChanged: onChangedName,
                  controller: usernameController,
                  errorText: validate ? kInvalidText : null,
                ),
                SizedBox(
                  height: 30,
                ),
                TextFieldWidget(
                  hintText: 'email',
                  onChanged: onChangedEmail,
                  controller: emailController,
                  errorText: validate ? kInvalidText : null,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFieldWidget(
                  hintText: 'password',
                  onChanged: onChangedPassword1,
                  obscureText: true,
                  controller: password1Controller,
                  errorText: validate ? kInvalidText : null,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFieldWidget(
                  hintText: 'confirm password',
                  onChanged: onChangedPassword2,
                  obscureText: true,
                  controller: password2Controller,
                  errorText: validate ? kInvalidText : null,
                ),
                SizedBox(
                  height: 25,
                ),
                ActionsButton(
                  title: 'Sign up',
                  onTap: _signinUser,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
