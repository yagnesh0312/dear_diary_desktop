class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  List? group_ids;

  UserModel({this.id, this.name, this.email, this.password, this.group_ids});

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    email = map['email'];
    password = map['password'];
    group_ids = map['groupId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'groupId': group_ids
    };
  }
}
