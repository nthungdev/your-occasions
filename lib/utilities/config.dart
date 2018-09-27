import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// This class interact with local data stored on user's device
class Config {

  // METHODS //
  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = (prefs.getInt('userId') ?? 0);
    return id;
  }

  setUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }
  
  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('userEmail') ?? "");
    return email;
  }

  setUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', userEmail);
  }

}
