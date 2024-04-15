import 'package:dear_diary/Model/AppColor.dart';
import 'package:dear_diary/Model/NoteModel.dart';
import 'package:dear_diary/Model/functions.dart';
import 'package:dear_diary/Pages/HomePage.dart';
import 'package:dear_diary/Pages/NoteViewPage.dart';
import 'package:dear_diary/main.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget Note(BuildContext context, NoteModel n) {
  return GestureDetector(
    onTap: () {
      Navi.push(context, NoteViewPage(n: n));
    },
    child: Container(
      width: 400,
      constraints: BoxConstraints(minHeight: 60, minWidth: 160, maxHeight: 60, maxWidth: 160),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(color: MyColor.oteColor[n.colorId ?? 2], borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)), boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), offset: Offset(0, 10), blurRadius: 10)
            ]),
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: 45),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        child: Text(
                          n.title!,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black54),
                          maxLines: null,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  n.time.toString().substring(0, 10),
                  style: GoogleFonts.inter(fontSize: 10),
                ),
                Expanded(
                  child: Text(
                    n.content.toString(),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.all(15),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                await Firestore.instance.collection('users').document(u.id!).collection('notes').document(n.id!).delete();
                Navi.allPop(context);
                Navi.pushReplace(context, HomePage(userModel: u,));
              },
              child: Container(
                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color.fromARGB(255, 120, 8, 0)),
                height: 25,
                width: 25,
                child: Icon(Icons.highlight_remove_rounded, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
