import 'package:dear_diary/Model/AppColor.dart';
import 'package:dear_diary/Model/NoteModel.dart';
import 'package:dear_diary/Model/UserModel.dart';
import 'package:dear_diary/Pages/HomePage.dart';
import 'package:dear_diary/Pages/NoteEditPage.dart';
import 'package:dear_diary/main.dart';
import 'package:dear_diary/widgets/Note.dart';
import 'package:firedart/firedart.dart';
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Model/functions.dart';

// import 'package:fluent_ui/fluent_ui.dart';
class GroupPage extends StatefulWidget {
  final String groupid;
  final UserModel userModel;
  GroupPage({Key? key, required this.groupid, required this.userModel}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<NoteModel> noteModels = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.backgroud,
      appBar: AppBar(
        title: Text(widget.groupid),
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
                        NoteModel n = NoteModel(colorId: i, time: DateTime.now(), groupId: widget.groupid);
                        Navi.push(context, NoteEditPage(n: n));
                      })
                ],
                IconButton(
                    onPressed: () async {
                      for (var i = 0; i < noteModels.length; i++) {
                        NoteModel n = noteModels[i];
                        n.groupId = "";
                        Firestore.instance.collection("users").document(widget.userModel.id!).collection('notes').document(n.id!).update(n.toMap());
                      }
                      UserModel newModel = widget.userModel;
                      List l = List.empty(growable: true);
                      l.addAll(newModel.group_ids!);
                      l.remove(widget.groupid);

                      newModel.group_ids = l;
                      await Firestore.instance.collection('users').document(widget.userModel.id!).update(newModel.toMap());
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(userModel: u,)));
                    },
                    icon: Icon(f.FluentIcons.delete))
              ],
            ),
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
            stream: Firestore.instance.collection('users').document(widget.userModel.id!).collection('notes').where('groupId', isEqualTo: widget.groupid).get().asStream(),
            builder: (context, AsyncSnapshot<List<Document>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    'Loading',
                    style: TextStyle(color: Colors.white60),
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 1000,
                  width: 1500,
                  constraints: BoxConstraints(minWidth: 1000,minHeight: 1000, maxWidth: 1000),
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                    children: snapshot.data!.map((e) {
                      NoteModel n = NoteModel.fromMap(e.map);
                      noteModels.add(n);
                      return Note(context, n);
                    }).toList(),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
