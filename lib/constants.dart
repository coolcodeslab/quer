import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xfff4f4f4);
const kBlackColor = Colors.black;
const kWhiteColor = Colors.white;
const kGreenColor = Color(0xff73D4B9);

const kInvalidText = 'Invalid value';

const kTextFieldDecoration = InputDecoration(
  hintText: '',
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  ),
  disabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  ),
);

const kDrawerDecoration = BoxDecoration(
  color: kWhiteColor,
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(5),
    bottomRight: Radius.circular(5),
  ),
);

const kAddScreenContainerDecoration = BoxDecoration(
  color: kBackgroundColor,
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(10),
    topLeft: Radius.circular(10),
  ),
);
