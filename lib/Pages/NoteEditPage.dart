import 'package:dear_diary/Model/AppColor.dart';
import 'package:dear_diary/Model/NoteModel.dart';
import 'package:dear_diary/Pages/HomePage.dart';
import 'package:dear_diary/main.dart';
import 'package:firedart/firedart.dart';
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/material.dart';

class NoteEditPage extends StatefulWidget {
  final NoteModel n;
  NoteEditPage({Key? key, required this.n}) : super(key: key);

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  FocusNode focusNode = FocusNode();
  var title = TextEditingController();
  CollectionReference data = Firestore.instance.collection("users").document(u.id!).collection("notes");

  var content = f.TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title.text = widget.n.title ?? "";
    content.text = widget.n.content ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: MyColor.backgroud,
          backgroundColor: MyColor.oteColor[widget.n.colorId!],
          title: Text(
            "Note Edit Page",
            style: TextStyle(color: MyColor.mainColor),
          )),
      body: Container(
        color: MyColor.backgroud,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(),
              child: TextField(
                cursorColor: Colors.white,
                controller: title,
                onEditingComplete: () {
                  focusNode.requestFocus();
                },
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 30),
                decoration: InputDecoration(hintText: "Title", border: InputBorder.none, hintStyle: TextStyle(color: Colors.white.withOpacity(0.3))),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  onChanged: (text){
                    
                  },
                  cursorColor: Colors.white,
                  focusNode: focusNode,
                  controller: content,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20),
                  maxLines: null,
                  decoration: InputDecoration(hintText: "Content", border: InputBorder.none, hintStyle: TextStyle(color: Colors.white.withOpacity(0.3))),
                  scribbleEnabled: true,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColor.mainColor,
        onPressed: () async {
          NoteModel n = widget.n;
          if (n.id == null) {
            n.id = uuid.v1();
          }
          n.content = content.text;
          n.title = title.text;
          n.time = DateTime.now();
          await data.document(n.id!).set(n.toMap());
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        userModel: u,
                      )));
        },
        child: Icon(
          f.FluentIcons.save,
          color: Colors.blue,
        ),
      ),
    );
  }
}
