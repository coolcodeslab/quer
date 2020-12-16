import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quer/constants.dart';
import 'package:quer/quer_widgets.dart';
import 'package:random_string/random_string.dart';

class AddScreen extends StatefulWidget {
  AddScreen({this.uid});

  final String uid;
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseStorage =
      FirebaseStorage.instance.ref().child('menu pictures');

  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController itemTextEditingController = TextEditingController();

  String itemName;
  String itemPrice;
  String itemDownloadUrl;
  File _image;
  final picker = ImagePicker();
  bool showSpinner = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(
      () {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      },
    );
  }

  void uploadToFireStore() {
    try {
      _firestore
          .collection("restaurant")
          .doc(widget.uid)
          .collection("menu")
          .doc(itemName)
          .set({
        "price": itemPrice,
        "downloadUrl": itemDownloadUrl,
      });
    } catch (e) {
      print(e);
    }
  }

  void uploadPhoto(File file) async {
    setState(() {
      showSpinner = true;
    });
    print('started uploading');
    final String r = randomAlphaNumeric(9);

    await _firebaseStorage.child('$r.jpg').putFile(file).then(
      (data) async {
        await data.ref.getDownloadURL().then(
              (value) => itemDownloadUrl = value,
            );
      },
    );
    print('done');
    uploadToFireStore();
    Navigator.pop(context);
    setState(() {
      showSpinner = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    itemTextEditingController.dispose();
    priceTextEditingController.dispose();
  }

  void onItemChanged(n) {
    itemName = n;
  }

  void onPriceChanged(n) {
    itemPrice = 'Rs.$n';
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: Theme(
        data: ThemeData(
          accentColor: kBlackColor,
        ),
        child: CircularProgressIndicator(),
      ),
      //have wrapped inside another container to get the edge effect
      child: Container(
        color: Color(0xff707070),
        child: Container(
          height: 900,
          decoration: kAddScreenContainerDecoration,
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: HeadingText(
                  title: 'Add item',
                  size: 20,
                ),
              ),
              SizedBox(
                height: 21,
              ),
              TextFieldWidget(
                hintText: 'item name',
                controller: itemTextEditingController,
                onChanged: onItemChanged,
              ),
              SizedBox(
                height: 21,
              ),
              //to display the rs and container in the same column
              Row(
                children: [
                  Text('Rs.'),
                  TextFieldWidget(
                    hintText: 'price',
                    width: 120,
                    controller: priceTextEditingController,
                    onChanged: onPriceChanged,
                  ),
                ],
              ),
              SizedBox(
                height: 21,
              ),
              //getting the omage
              ActionsButton(
                title: 'image',
                onTap: () {
                  getImage();
                },
              ),
              SizedBox(
                height: 80,
              ),
              //adding the image
              Align(
                alignment: Alignment.center,
                child: ActionsButton(
                  title: 'add',
                  onTap: () {
                    uploadPhoto(_image);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
