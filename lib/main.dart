import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/models/user.dart';

import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/screens/home/home.dart';

void main() async {
  // final FirebaseApp app = await FirebaseApp.configure(
  //   name: 'db2',
  //   options: Platform.isIOS
  //   ? const FirebaseOptions(
  //       googleAppID: '1:297855924061:ios:c6de2b69b03a5be8',
  //       gcmSenderID: '297855924061',
  //       databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
  //     )
  //   : const FirebaseOptions(
  //       googleAppID: '1:297855924061:android:669871c998cc21bd',
  //       apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
  //       databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
  //     ),
  // );

  var id = await getUserId();
  print("Id : $id");

  if(id != null){
    UserController uc = UserController();
    User userFromDB = await uc.getUserWithId(id);
    if (userFromDB == null) {
      print("Getting user error");
    }
    else {
      Dataset.currentUser.value = userFromDB;
      runApp(YourOccasions(HomeScreen()));
    }
  }
  else {
    runApp(YourOccasions(LoginWithEmailScreen()));
  }

}

class YourOccasions extends StatelessWidget {
  final Widget home;

  YourOccasions(this.home);
  // YourOccasions(bool isLoggin) : home = SignInDemo();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Your Occasions',
      theme: ThemeData(
        // backgroundColor: Colors.red,
        primarySwatch: Colors.blue,
      ),
      home: home,
    );
  }

}

