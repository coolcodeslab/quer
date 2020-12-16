import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quer/constants.dart';
import 'package:quer/quer_widgets.dart';
import 'package:quer/screens/home_screen.dart';
import 'package:quer/screens/login_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  static const id = 'scan screen';
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _fireStore = FirebaseFirestore.instance;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = 'no QR code found';
  QRViewController controller;
  var qrVal = '';

  bool showSpinner = false;
  /*
  checks if the scanned data has UID which matches the UID inside restaurants
  collection and if it does the screen is pushed to the home screen with bool
  passed which disables the FAB and Drawer
  */
  void onQrButtonTapped() async {
    setState(() {
      showSpinner = true;
    });
    try {
      await _fireStore.collection('restaurant').doc(qrVal).get().then(
        (value) async {
          if (value.exists) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  uid: value.id,
                  fromScanScreen: true,
                ),
              ),
            );
          } else {
            print('null');
          }
        },
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      showSpinner = false;
    });
  }

  /*
  check if the scanned document has uid which matches the document id on
  restaurants collection and is there is the it takes the documents id and
  documents restaurantName and saves it into variables qrVal and qrText
   */
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      try {
        _fireStore
            .collection('restaurant')
            .doc(scanData)
            .get()
            .then((value) async {
          setState(() {
            qrVal = value.id;
            qrText = value['restaurantName'];
          });
        });
      } catch (e) {
        setState(() {
          qrText = 'no value found';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: Theme(
          data: ThemeData(accentColor: kBlackColor),
          child: CircularProgressIndicator(),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            //login screen button
            QRView(
              //this creates the borders in scan screen
              overlay: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.black.withOpacity(0.3),
                  width: 160,
                ),
                vertical: BorderSide(
                  color: Colors.black.withOpacity(0.3),
                  width: 40,
                ),
              ),
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
            // top action button which pushes to login screen
            Positioned(
              right: 20,
              top: 30,
              child: ScanScreenTopAction(
                iconData: Icons.menu,
                onTap: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            ),
            //bottom action button which checks for data pushes to home screen
            Positioned(
              bottom: 50,
              child: BottomButton(
                textColor: kBlackColor,
                onTap: onQrButtonTapped,
                title: qrText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
