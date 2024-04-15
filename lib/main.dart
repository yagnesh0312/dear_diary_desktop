import 'package:dear_diary/Model/AppColor.dart';
import 'package:dear_diary/Model/NoteModel.dart';
import 'package:dear_diary/Model/UserModel.dart';
import 'package:dear_diary/Pages/GroupPage.dart';
import 'package:dear_diary/Pages/HomePage.dart';
import 'package:dear_diary/Pages/SignUpPage.dart';
import 'package:dear_diary/cradi.dart';
import 'package:dear_diary/widgets/Note.dart';
import 'package:firedart/firedart.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as f;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'Pages/LoginPage.dart';


const uuid = Uuid();
UserModel u = UserModel();
void main() async {
  Firestore.initialize(projectId);
  FirebaseAuth.initialize(apiKey, VolatileStore());
  // runApp(const MyApp());
  var sp = await SharedPreferences.getInstance();
  String? uid = sp.getString('uid');
  if (uid == null) {
    runApp(FluentApp(
      color: Colors.black,
      // darkTheme: ThemeData(
      //     scaffoldBackgroundColor: MyColor.backgroud,
      //     micaBackgroundColor: MyColor.mainColor,
      //     menuColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
    ));
    return;
  }
  var userData =
      await Firestore.instance.collection('users').document(uid).get();
  u = UserModel.fromMap(userData.map);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NoteModel n = NoteModel(
      id: "hello",
      colorId: 4,
      content: "i dont know what we type in this time",
      groupId: "bbb",
      groupName: "hello gyas",
      title: "project",
      time: DateTime.now());
  CollectionReference data = Firestore.instance
      .collection("users")
      .document("yagnesh")
      .collection("notes");

  Future<List<Document>> getData() async {
    List<Document> ListData = await data.get();
    return ListData;
  }

  int idx = 0;
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      color: Colors.black,
      // darkTheme: ThemeData(
      //     animationCurve: Curves.linear,
      //     scaffoldBackgroundColor: MyColor.backgroud,
      //     micaBackgroundColor: MyColor.mainColor,
      //     menuColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: HomePage(
        userModel: u,
      ),
    );
  }
}
