import 'package:flutter/material.dart';
import './other_page.dart';

import 'package:youroccasions/screens/user/user_profile.dart';
import 'package:youroccasions/screens/event/create_event.dart';
import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/models/data.dart';

class HomeDrawer extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final String accountPicture;

  HomeDrawer({@required this.accountEmail, @required this.accountName, @required this.accountPicture});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(Dataset.currentUser.value)));},
            child: UserAccountsDrawerHeader(
              accountName: Text(accountName),
              accountEmail: Text(accountEmail),
              currentAccountPicture: CircleAvatar(
                backgroundImage: accountPicture == null
                ? NetworkImage("https://img.huffingtonpost.com/asset/5b7fdeab1900001d035028dc.jpeg?cache=sixpwrbb1s&ops=1910_1000")
                : NetworkImage(accountPicture)
              ),
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
              await logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWithEmailScreen()));
            },
            child: Text("Logout"),
            )
          ),
        ],
      ),
    );
  }
}

