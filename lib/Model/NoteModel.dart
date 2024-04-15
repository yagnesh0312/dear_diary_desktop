class NoteModel {
  String? id;
  String? title;
  DateTime? time;
  String? content;
  String? groupId;
  String? groupName;
  int? colorId;

  NoteModel({this.id, this.title, this.time, this.content, this.groupId, this.groupName, this.colorId});

  NoteModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    time = map['time'];
    content = map['content'];
    groupId = map['groupId'];
    groupName = map['groupName'];
    colorId = map['colorId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'content': content,
      'groupId': groupId,
      'groupName': groupName,
      'colorId': colorId,
    };
  }
}
