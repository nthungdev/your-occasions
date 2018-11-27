import 'package:flutter/material.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/models/user.dart';

import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/screens/home/home.dart';

void main() async {
  var id = await getUserId();

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

  runApp(YourOccasions(LoginWithEmailScreen()));
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

