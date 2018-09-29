import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// This file interact with local data stored on user's device

/// How preference's names are stored on the phone.
const String USER_ID = "userId";
const String USER_EMAIL = "userEmail";
const String USER_PASSWORD = "userPassword";
const String IS_LOGIN = "isLogin";

Future<bool> getIsLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = (prefs.getBool(IS_LOGIN) ?? false);
  return result;
}

setIsLogin(bool status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(IS_LOGIN, status);
}

Future<int> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = (prefs.getInt(USER_ID) ?? 0);
  return id;
}

setUserId(int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(USER_ID, userId);
}

Future<String> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = (prefs.getString(USER_EMAIL) ?? "");
  return email;
}

setUserEmail(String userEmail) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(USER_EMAIL, userEmail);
}