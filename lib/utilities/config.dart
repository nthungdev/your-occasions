import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// This file interact with local data stored on user's device

/// How preference's names are stored on the phone.
const String USER_ID = "userId";
const String USER_EMAIL = "userEmail";
const String USER_NAME = "userName";
const String USER_PASSWORD = "userPassword";
const String IS_LOGIN = "isLogin";

Future<bool> getIsLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = (prefs.getBool(IS_LOGIN) ?? false);
  return result;
}

Future<void> setIsLogin(bool status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(IS_LOGIN, status);
}

Future<String> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = (prefs.getString(USER_ID) ?? "");
  return id == "" ? null : id;
}

Future<void> setUserId(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(USER_ID, userId);
}

Future<String> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = (prefs.getString(USER_EMAIL) ?? "");
  return email == "" ? null : email;
}

Future<void> setUserEmail(String userEmail) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(USER_EMAIL, userEmail);
}

Future<String> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String name = (prefs.getString(USER_NAME) ?? "");
  return name;
}


Future<void> setUserName(String userName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(USER_NAME, userName);
}

Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signOut();
}