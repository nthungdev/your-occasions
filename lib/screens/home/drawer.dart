import 'package:flutter/material.dart';
import 'dart:async';
import './other_page.dart';

import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/screens/user/user_profile.dart';
import 'package:youroccasions/screens/event/create_event.dart';
import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/utilities/config.dart';

class HomeDrawer extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final User user = User(name: 'duong');

  HomeDrawer({@required String accountName, @required String accountEmail})
      : accountName = accountName, accountEmail = accountEmail;


  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(user)));},
              child: UserAccountsDrawerHeader(
                accountName: Text(accountName),
                accountEmail: Text(accountEmail),
                currentAccountPicture: CircleAvatar(),
              ),
            ),
            ListTile (
              title: Text (" Create Events"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEventScreen())),
                ),
            ListTile (
              title: Text (" My Events"),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new OtherPage(" My Events"))),
                ),
            ListTile (
              title: Text (" Shared Events"),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new OtherPage(" Shared Events"))),
            ),   
            ListTile (
                title: Text (" Location"),
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new OtherPage(" Location"))),
              ),   
            ListTile (
              title: Text (" Settings"),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new OtherPage(" Settings"))),
            ),   
            Container(
            alignment: Alignment.center,
            child:  MaterialButton(
              color: Colors.red,
              onPressed: () async {
                await setIsLogin(false);
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
