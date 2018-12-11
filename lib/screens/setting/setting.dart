
import 'package:flutter/material.dart';
import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/screens/setting/SuggestImprovements.dart';
import 'package:youroccasions/screens/setting/setting.dart';
import 'package:youroccasions/screens/user/upload_avatar.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/screens/setting/about.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Settings",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: new Container(
        color: Colors.blue[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile (
              title: Text ("Edit Profile Picture", style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new UploadAvatarPage(Dataset.currentUser.value))),
          
            ),
            ListTile (
              title: Text ("Suggest Improvements", style: TextStyle(fontWeight: FontWeight.bold),),
              onTap:  () {Navigator.push(context, MaterialPageRoute(builder: (context) => SuggestImprovement ()));},
            ),
            ListTile (
              title: Text ("Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold),),
              onTap:  () {Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));},
            ),
            ListTile (
              title: Text ("Logout", style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () async {
                await logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWithEmailScreen()));
              },
              
            ),
          ],
        ),
      )
    );
  }
}

