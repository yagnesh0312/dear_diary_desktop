import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navi {
  static push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static allPop(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  static pushReplace(BuildContext context,Widget page){
    allPop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));

  }
}
