
import 'package:flutter/material.dart';
import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/screens/setting/SuggestImprovements.dart';
import 'package:youroccasions/screens/user/upload_avatar.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/screens/setting/about.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: new AppBar(
        title: Text("SETTINGS",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: new Container(
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListTile (
                title: Text ("Edit Profile Picture", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new UploadAvatarPage(Dataset.currentUser.value))),
              ),
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              child: ListTile (
                title: Text ("Suggest Improvements", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap:  () {Navigator.push(context, MaterialPageRoute(builder: (context) => SuggestImprovement ()));},
              ),
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              child: ListTile (
                title: Text ("Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap:  () {Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));},
              ),
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              child: ListTile (
                title: Text ("Logout", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () async {
                  await logout();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWithEmailScreen()));
                },
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: screen.width,
              color: Colors.grey[200],
              child: Column (
                children: <Widget>[
                  Text (Dataset.currentUser.value.name, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                  Text (Dataset.currentUser.value.email, textAlign: TextAlign.center,),
                ],
              ),
            ),

          ],
        ),
      )
    );
  }
}

