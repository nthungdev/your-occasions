
import 'package:flutter/material.dart';
import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/screens/setting/setting.dart';
import 'package:youroccasions/screens/user/upload_avatar.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/screens/setting/about.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile (
            title: Text ("Edit Profile Picture"),
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new UploadAvatarPage(Dataset.currentUser.value))),
        
          ),
          ListTile (
            title: Text ("Suggest Improvements"),
            onTap: () {},
          ),
          ListTile (
            title: Text ("Pravacy Policy"),
            onTap:  () {Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));},
          ),
          ListTile (
            title: Text ("Logout"),
            onTap: () async {
              await logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWithEmailScreen()));
            },
          ),
        ],
      ),
    );
  }
}

