import 'package:dear_diary/Model/AppColor.dart';
import 'package:dear_diary/Model/UserModel.dart';
import 'package:dear_diary/Model/functions.dart';
import 'package:dear_diary/Pages/HomePage.dart';
import 'package:dear_diary/Pages/LoginPage.dart';
import 'package:dear_diary/main.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cPassController = TextEditingController();

  setModel(String id) async {
    var sp = await SharedPreferences.getInstance();
    sp.setString('uid', id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.backgroud,
      body: Center(
        child: Column(children: [
          Text(
            "SignUp",
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
          Container(
            width: 300,
            child: TextField(
              controller: cPassController,
              decoration: InputDecoration(hintText: "ConfirmPassword", hintStyle: TextStyle(color: Colors.white38)),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          CupertinoButton(
              onPressed: () async {
                var user = await FirebaseAuth.instance.signUp(emailController.text, passwordController.text);
                UserModel userModel = UserModel(id: user.id, email: user.email, password: passwordController.text, name: user.email, group_ids: []);
                var userdata = Firestore.instance.collection('users').document(userModel.id!).set(userModel.toMap());
                u = userModel;
                setModel(userModel.id!);
                Navi.allPop(context);
                Navi.pushReplace(context, HomePage(userModel: userModel));
              },
              child:  Container(
                  width: 100,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Color.fromARGB(255, 255, 0, 0)),
                  child: Text(
                    "SignUp",
                    style: TextStyle(color: Colors.white),
                  ),
                ),),
          CupertinoButton(
              onPressed: () async {
                Navi.pushReplace(context, LoginPage());
              },
              child: Text("LogIn ?")),
        ]),
      ),
    );
  }
}
