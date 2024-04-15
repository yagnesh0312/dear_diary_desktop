import 'dart:developer';

import 'package:dear_diary/Model/AppColor.dart';
import 'package:dear_diary/Model/NoteModel.dart';
import 'package:dear_diary/Model/functions.dart';
import 'package:dear_diary/Pages/NoteEditPage.dart';
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteViewPage extends StatefulWidget {
  final NoteModel n;
  NoteViewPage({Key? key, required this.n}) : super(key: key);

  @override
  State<NoteViewPage> createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.backgroud,
      appBar: AppBar(
        title: Text("Note Views Page"),
        backgroundColor: MyColor.oteColor[widget.n.colorId!],
        foregroundColor: Colors.black54,
      ),
      body: Container(
        color: MyColor.backgroud,
        child: Column(
          crossAxisAlignment: f.CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, bottom: 10),
              child: SelectableText(
                widget.n.title!,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 30),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, bottom: 10),
              child: Text(
                widget.n.time.toString(),
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.w400, fontSize: 15),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Linkify(
                    onOpen: (link) async {
                      log(link.url);
                      if (await canLaunchUrl(Uri.parse(link.url))) {
                        launchUrl(Uri.parse(link.url));
                      }
                    },
                    text: widget.n.content!,
                    maxLines: null,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColor.mainColor,
        onPressed: () {
          Navi.push(
              context,
              NoteEditPage(
                n: widget.n,
              ));
        },
        child: Icon(
          f.FluentIcons.edit,
          color: Colors.blue,
        ),
      ),
    );
  }
}
