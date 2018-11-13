import 'package:flutter/material.dart';
import 'dart:async';

import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/screens/home/home.dart';

void main() async {
  var result = await checkIsLogin();
  if(result){
    runApp(YourOccasions(true));
  }
  else {
    runApp(YourOccasions(false));
  }
}

Future<bool> checkIsLogin() async {
    return await getIsLogin();
  }

class YourOccasions extends StatelessWidget {
  final Widget home;
  YourOccasions(bool isLoggin) : home = (isLoggin ? HomeScreen() : LoginWithEmailScreen());

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Your Occasions',
      theme: ThemeData(
        // backgroundColor: Colors.red,
        // primarySwatch: Colors.red,
      ),
      home: home,
    );
  }

}

