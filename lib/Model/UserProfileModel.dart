import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));
String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  int id;
  String name;
  String email;
  String phone;
  String password;

  UserProfileModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  UserProfileModel.fromJson(Map<dynamic, dynamic> res)
      : name = res["name"],
        phone = res["phone"],
        email = res["email"],
        password = res["password"];

  UserProfileModel.fromMap(Map<dynamic, dynamic> res)
      : name = res["name"],
        phone = res["phone"],
        email = res["email"],
        password = res["password"];

  @override
  String toString() {
    return 'UserProfileModel{id: $id, name: $name, email: $email, phone: $phone, password: $password}';
  }
}
