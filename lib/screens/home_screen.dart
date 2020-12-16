import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quer/constants.dart';
import 'package:quer/quer_widgets.dart';
import 'package:quer/screens/add_screen.dart';
import 'package:quer/screens/login_screen.dart';
import 'package:quer/screens/scan_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.uid, this.fromScanScreen = false});
  final String uid;
  final bool fromScanScreen;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String userName = '';

  void getUserName() async {
    try {
      await FirebaseFirestore.instance
          .collection('restaurant')
          .doc(widget.uid)
          .get()
          .then(
        (value) async {
          setState(() {
            userName = value['restaurantName'];
          });
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void _signOutUser() async {
    await _auth.signOut();
    Navigator.pushNamed(
      context,
      ScanScreen.id,
    );
  }

  void _onLongPress(String documentId) async {
    print("long pressed");
    try {
      await _firestore
          .collection("restaurant")
          .doc(widget.uid)
          .collection("menu")
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        iconTheme: IconThemeData(
          color: kBlackColor,
        ),
        elevation: 0,
        title: HeadingText(
          title: userName,
        ),
      ),
      drawer: widget.fromScanScreen
          ? null
          : Container(
              decoration: kDrawerDecoration,
              width: 80,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  DrawerItem(
                    onTap: _signOutUser,
                    name: 'log out',
                  )
                ],
              ),
            ),
      floatingActionButton: widget.fromScanScreen
          ? null
          : FloatingActionButton(
              backgroundColor: kBlackColor,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return AddScreen(
                      uid: widget.uid,
                    );
                  },
                );
              },
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          child: ListView(
            children: [
              SizedBox(
                height: 20,
                width: double.infinity,
              ),
              //takes the data from firestore and shows each menu item
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("restaurant")
                    .doc(widget.uid)
                    .collection("menu")
                    .snapshots(),
                builder: (context, snapshot) {
                  List<MenuItemCard> menu = [];
                  if (snapshot.hasData) {
                    final menuItems = snapshot.data.docs;
                    for (var item in menuItems) {
                      final itemName = item.id;
                      final itemPrice = item['price'];
                      final imageUrl = item['downloadUrl'];
                      final menuContainer = MenuItemCard(
                        name: itemName,
                        price: itemPrice,
                        url: imageUrl,
                        onLongPress: widget.fromScanScreen
                            ? null
                            : () {
                                _onLongPress(itemName);
                              },
                      );
                      menu.add(menuContainer);
                    }
                  }
                  return Column(
                    children: menu,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
