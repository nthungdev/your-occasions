import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/models/user.dart';
import 'dart:async';

import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  final Firestore firestore = Firestore();
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  var id = await getUserId();
  // var email = await getUserEmail();
  // var password = await getPassword();

  print("Id : $id");

  if(id != null){
    UserController uc = UserController();
    User userFromDB = await uc.getUserWithId(id);
    // var userFirebase = await FirebaseAuth.instance.signInWithEmailAndPassword(email: userFromDB.email, password: password);

    // var user = await FirebaseAuth.instance.currentUser();
    // Dataset.firebaseUser.value = userFirebase;
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
      debugShowCheckedModeBanner: false,
      title: 'Your Occasions',
      theme: ThemeData(
        // backgroundColor: Colors.red,
        primaryColor: Colors.deepPurpleAccent,
        // primarySwatch: Colors.red,
      ),
      home: home,
    );
  }

}

