import 'package:dear_diary/Model/AppColor.dart';
import 'package:dear_diary/Model/UserModel.dart';
import 'package:dear_diary/Model/functions.dart';
import 'package:dear_diary/Pages/HomePage.dart';
import 'package:dear_diary/Pages/SignUpPage.dart';
import 'package:dear_diary/main.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: prefer_const_constructors
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  setModel(String id) async {
    var sp = await SharedPreferences.getInstance();
    sp.setString('uid', id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.backgroud,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 100),
            ),
            Text(
              "Note Book",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
            ),
            Container(
              width: 300,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Email", hintStyle: TextStyle(color: Colors.white38)),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Container(
              width: 300,
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "Password", hintStyle: TextStyle(color: Colors.white38)),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            CupertinoButton(
                child: Container(
                  width: 100,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Color.fromARGB(255, 255, 0, 0)),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  User? user = await FirebaseAuth.instance.signIn(emailController.text, passwordController.text).then((value) async {
                    var tempUser = await Firestore.instance.collection('users').document(value.id).get();
                    u = UserModel.fromMap(tempUser.map);
                    setModel(value.id);
                    Navi.allPop(context);
                    Navi.pushReplace(context, HomePage(userModel: u));
                  });
                }),
                CupertinoButton(
              onPressed: () async {
                Navi.pushReplace(context, SignUpPage());
              },
              child: Text("SignUp ?")),
          ],
        ),
      ),
    );
  }
}
