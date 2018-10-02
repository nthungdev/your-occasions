import 'package:flutter/material.dart';

import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/screens/login/signup.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreen createState() => _CreateEventScreen();
  
}

class _CreateEventScreen extends State<CreateEventScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Create your event"),
      ),
      body: Center(
        child: Column(
          children: <Widget> [
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
