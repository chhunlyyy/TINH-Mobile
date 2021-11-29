import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.phone,
    this.token,
    this.isLogIn,
  });

  int? id;
  String? name;
  String? phone;
  String? token;
  int? isLogIn;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        token: json["token"],
        isLogIn: json["isLogIn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "token": token,
        "isLogIn": isLogIn,
      };
}
