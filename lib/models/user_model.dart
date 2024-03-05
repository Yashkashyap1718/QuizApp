// ignore_for_file: file_names

class UserModel {
  int? id;
  String? uid;
  String? username;
  String? phoneNumber;
  String? email;

  UserModel({this.id, this.uid, this.username, this.email, this.phoneNumber});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] ?? 1,
        uid: json['uid'] ?? '',
        username: json["name"] ?? '',
        email: json["email"] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": username,
        "email": email,
        "phoneNumber": phoneNumber,
      };
}
