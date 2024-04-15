import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:dear_diary/Model/NoteModel.dart';
import 'package:dear_diary/Model/UserModel.dart';
import 'package:dear_diary/Model/functions.dart';
import 'package:dear_diary/Pages/GroupPage.dart';
import 'package:dear_diary/Pages/NoteEditPage.dart';
import 'package:dear_diary/Pages/NoteViewPage.dart';
import 'package:dear_diary/Pages/SignUpPage.dart';
import 'package:dear_diary/main.dart';
import 'package:dear_diary/widgets/Note.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
// import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/AppColor.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  HomePage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NoteModel n = NoteModel(id: "djdk", title: "Title", time: DateTime.now(), content: "9VrUG5amu8Mu6OiMIe9U3KlwOO\nCHSZz1xvf0BpJeaPPPTdK52Sg4itqEl\nwbG5kfDxJ2pcBMyk7lgtY\nsANTeivUaqxEDI5wYJhu0jWgVLCxgAFucuEYTfyWBRSeddx9F5EJAi50qk9JEOO841wweZHodEf0aSeApan4oiZw6kgbEcwlUIrbhUO2DRVTqmGmSpchLmFotcD");
  CollectionReference data = Firestore.instance.collection("users");
  UserModel user = UserModel();
  Future<List<Document>> getData() async {
    List<Document> ListData = await data.get();
    return ListData;
  }

  var grpNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Document>>(
        future: getData(),
        builder: (context, AsyncSnapshot<List<Document>> snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading..");
          }
          var d = snapshot.data!.asMap();
          List? grpList;
          for (var i = 0; i < snapshot.data!.length; i++) {
            log(d[i]!.map.toString());
            var map = d[i]!.map;
            if (map['id'] == widget.userModel.id) {
              grpList = map['groupId'];
              user = UserModel.fromMap(map);
            }
          }
          return Scaffold(
            appBar: AppBar(
                
                centerTitle: true,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Dear Diary",
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: MyColor.oteColor[3], fontSize: 30),
                    ),
                    Text(
                      "Made by Yagnesh",
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white30, fontSize: 10),
                    ),
                  ],
                ),
                backgroundColor: MyColor.mainColor,
                actions: [
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(right: 30),
                    child: Row(
                      children: [
                        for (int i = 0; i < MyColor.oteColor.length; i++) ...[
                          CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(color: MyColor.oteColor[i], borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: () {
                                NoteModel n = NoteModel(
                                  colorId: i,
                                  time: DateTime.now(),
                                );
                                Navi.push(context, NoteEditPage(n: n));
                              })
                        ]
                      ],
                    ),
                  ),CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: 80,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.red),
                    child: Text('LogOut',style: TextStyle(color: Colors.white,fontSize: 15),),
                  ),
                  onPressed: () async{
                    var sp = await SharedPreferences.getInstance();
                    sp.clear();
                    Navi.pushReplace(context, SignUpPage());

                  },
                ),
                ]),
            backgroundColor: MyColor.backgroud,
            body: Container(
              color: MyColor.backgroud,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                        child: Text(
                          "Groups",
                          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
                        )),

                    /// grp List & add button
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: StreamBuilder(
                          stream: Firestore.instance.collection('users').document(widget.userModel.id!).stream,
                          builder: (context, snapshot) {

                            return Row(
                              children: [
                                for (var i = 0; i < (grpList == null ? 0 : grpList.length); i++) ...[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => GroupPage(
                                                    groupid: grpList![i],
                                                    userModel: user,
                                                  )));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(color: MyColor.mainColor, borderRadius: BorderRadius.circular(10)),
                                      child: Text(
                                        grpList![i],
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  )
                                ],
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: MyColor.subColor),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                        )),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: Container(
                                                  child: TextField(
                                                    controller: grpNameController,
                                                  ),
                                                ),
                                                actions: [
                                                  CupertinoButton(
                                                      padding: EdgeInsets.zero,
                                                      child: Container(
                                                          padding: EdgeInsets.all(6),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                                          child: Text(
                                                            "Add",
                                                            style: TextStyle(color: Colors.white),
                                                          )),
                                                      onPressed: () async {
                                                        List l = [];
                                                        l.addAll(grpList ?? []);
                                                        l.add(grpNameController.text);
                                                        await Firestore.instance.collection('users').document(widget.userModel.id!).update({
                                                          'groupId': l
                                                        });
                                                        Navigator.popUntil(context, (route) => route.isFirst);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => HomePage(
                                                                      userModel: widget.userModel,
                                                                    )));
                                                      })
                                                ],
                                              ));
                                    })
                              ],
                            );
                          }),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "All Notes",
                          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
                        )),
                    StreamBuilder(
                        stream: Firestore.instance.collection("users").document(widget.userModel.id!).collection("notes").get().asStream(),
                        builder: (context, AsyncSnapshot<List<Document>> snapshotStream) {
                          if (!snapshotStream.hasData) {
                            return Center(
                                child: Text(
                              "Loading..",
                              style: TextStyle(color: Colors.white),
                            ));
                          }
                          log("this is log : " + snapshotStream.data!.length.toString());
                          return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                height: 1000,
                                width: 1500,
                                constraints: BoxConstraints(minWidth: 1000, maxWidth: 1000),
                                child: GridView(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                  ),
                                  children: snapshotStream.data!.isEmpty
                                      ? [
                                          Text("this is empty")
                                        ]
                                      : snapshotStream.data!.map((e) {
                                          NoteModel n = NoteModel.fromMap(e.map);
                                          return Note(context, n);
                                        }).toList(),
                                ),
                              ));
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
