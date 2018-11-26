import 'package:flutter/material.dart';

import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/screens/home/home.dart';

void main() async {
  var id = await getUserId();

  if(id != null){
    runApp(YourOccasions(true));
  }
  else {
    runApp(YourOccasions(false));
  }
}

class YourOccasions extends StatelessWidget {
  final Widget home;

  YourOccasions(bool isLoggin) : home = (isLoggin ? HomeScreen() : LoginWithEmailScreen());
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

