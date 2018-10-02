import 'package:flutter/material.dart';
import 'dart:async';

import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/utilities/config.dart';

class HomeDrawer extends StatelessWidget {
  final String accountName;
  final String accountEmail;

  HomeDrawer({@required String accountName, @required String accountEmail})
      : accountName = accountName, accountEmail = accountEmail;


  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Hung Nguyen"),
              accountEmail: Text("nthungdev@gmail.com"),
              currentAccountPicture: CircleAvatar(),
            ),
            Container(
                alignment: Alignment.center,
                child:  MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWithEmailScreen()));
                  },
                  child: Text("Logout"),
                )
            ),
          ],
        ),
      ),
    );
  }

}

