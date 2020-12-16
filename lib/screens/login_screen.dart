import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quer/quer_widgets.dart';
import 'package:quer/constants.dart';
import 'package:quer/screens/home_screen.dart';
import 'package:quer/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quer/constants.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool validate = false;
  bool showSpinner = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _loginUser() async {
    setState(() {
      showSpinner = true;
      emailController.text.isEmpty ? validate = true : validate = false;
      passwordController.text.isEmpty ? validate = true : validate = false;
    });
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final uid = _auth.currentUser.uid;

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
    emailController.clear();
    passwordController.clear();
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

  void onChangedPassword(n) {
    setState(() {
      validate = false;
    });
    password = n;
  }

  void onTapSignInButton() {
    Navigator.pushNamed(context, SignupScreen.id);
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
            title: 'Log in',
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
                  onChanged: onChangedPassword,
                  obscureText: true,
                  controller: passwordController,
                  errorText: validate ? kInvalidText : null,
                ),
                SizedBox(
                  height: 25,
                ),
                ActionsButton(
                  title: 'log in',
                  onTap: _loginUser,
                ),
                SizedBox(
                  height: 320,
                ),
                Align(
                  alignment: Alignment.center,
                  child: BottomButton(
                    onTap: onTapSignInButton,
                    title: 'Sign up',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
