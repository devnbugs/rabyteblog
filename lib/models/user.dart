import 'dart:convert';

UserResponseModel userResponseFromJson(String str) => UserResponseModel.fromJson(json.decode(str));

class UserModel {
  String? userName;
  String? emailId;
  String? password;
  String? token;

  UserModel({
    required this.userName,
    required this.emailId,
    required this.password,
    this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['username'];
    emailId = json['email'];
    password = json['password'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = userName;
    data['email'] = emailId;
    data['password'] = password;
    data['token'] = token;
    return data;
  }
}





class UserResponseModel {
  int? code;
  String? message;

  UserResponseModel({this.code, this.message});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}