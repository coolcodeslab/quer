import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class BottomButton extends StatelessWidget {
  BottomButton(
      {this.textColor = kBlackColor,
      @required this.onTap,
      @required this.title});
  final Color textColor;
  final Function onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 5),
            )
          ],
        ),
        height: 40,
        width: 195,
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.karla(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class HeadingText extends StatelessWidget {
  HeadingText({@required this.title, this.size});
  final String title;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.karla(
        color: kBlackColor,
        fontWeight: FontWeight.bold,
        fontSize: size,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(1, 3),
            blurRadius: 3.0,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    @required this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.controller,
    this.errorText,
    this.width = 320,
    this.keyboardType,
  });
  final String hintText;
  final Function onChanged;
  final bool obscureText;
  final TextEditingController controller;
  final String errorText;
  final double width;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 40,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: kWhiteColor,
      ),
      child: TextFormField(
        onChanged: onChanged,
        decoration: kTextFieldDecoration.copyWith(
          errorText: errorText,
          hintText: hintText,
          hintStyle: GoogleFonts.karla(
            color: Colors.grey,
          ),
        ),
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
      ),
    );
  }
}

class ActionsButton extends StatelessWidget {
  ActionsButton({@required this.title, @required this.onTap});
  final String title;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 90,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.karla(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  MenuItemCard({this.name, this.price, this.url, this.onLongPress});
  final String name;
  final String price;
  final String url;
  final Function onLongPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 20),
        height: 90,
        width: 320,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(url == null ? null : url),
                  ),
                  color: kBlackColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 7),
                color: kWhiteColor,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: kWhiteColor,
                    ),
                    Container(
                      width: double.infinity,
                      height: 25,
                      color: kWhiteColor,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          price,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      width: 80,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          DrawerItem()
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  DrawerItem({this.onTap, this.name});
  final Function onTap;
  final String name;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.clear,
            ),
            Text(
              name,
              style: GoogleFonts.karla(),
            )
          ],
        ),
        margin: EdgeInsets.all(10),
        height: 60,
        decoration: BoxDecoration(
          color: kWhiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 5),
            )
          ],
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }
}

class ScanScreenTopAction extends StatelessWidget {
  ScanScreenTopAction({this.iconData, this.onTap});
  final IconData iconData;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Icon(
          iconData,
          size: 30,
        ),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 5),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
