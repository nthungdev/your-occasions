
import 'package:flutter/material.dart';
import 'package:youroccasions/screens/setting/setting.dart';
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
            onTap: () {},
          ),
          ListTile (
            title: Text ("about"),
            onTap: () {},
          ),
          ListTile (
            title: Text ("Suggest Inprovements"),
            onTap: () {},
          ),
         


        ],
      ),
    );
  }
}

