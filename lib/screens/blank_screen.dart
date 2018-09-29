import 'package:flutter/material.dart';

import 'package:youroccasions/screens/login/login.dart';

class BlankScreen extends StatefulWidget {
  String _title;
  Function _f;
  BlankScreen({ Key key , Function f, String title}) : super(key: key) {
    _f = f;
    _title = title;
  }

  @override
  _BlankScreen createState() => _BlankScreen();
  
}

class _BlankScreen extends State<BlankScreen> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(widget._title),),
      body: Center(
        child: MaterialButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWithEmailScreen()));
          },
          child: Text("Go back to LoginWithEmail Screen"),
        )
      )
    );
  }


}


