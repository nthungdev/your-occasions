import 'package:flutter/material.dart';

import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/screens/login/signup.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
  
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(child: Column(
        children: <Widget> [
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWithEmailScreen()));
            },
            child: Text("Go back to LoginWithEmail Screen"),
          ),
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpWithEmailScreen()));
            },
            child: Text("Logout"),
          )
        ]
      )));
  }

}
