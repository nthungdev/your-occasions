
import 'package:flutter/material.dart';
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 12.0, right: 12.0),
      child: new Card(
        child: new Row(
          children: <Widget>[
            new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 22.0, bottom: 8.0),
                  child: new Text("Edit Profile Picture", style: new TextStyle(color: new Color.fromARGB(255, 117, 117, 117), fontSize: 32.0, fontWeight: FontWeight.bold)),
                ),

                new Padding(
                  padding: const EdgeInsets.only(top: 22.0, bottom: 8.0),
                  child: new Text("Suggest Improvements", style: new TextStyle(color: new Color.fromARGB(255, 117, 117, 117), fontSize: 32.0, fontWeight: FontWeight.bold)),
                ),new Padding(
                  
                  padding: const EdgeInsets.only(top: 22.0, bottom: 8.0),
                  child: new Text("About", style: new TextStyle(color: new Color.fromARGB(255, 117, 117, 117), fontSize: 32.0, fontWeight: FontWeight.bold)),
                ),new Padding(
                  padding: const EdgeInsets.only(top: 22.0, bottom: 8.0),
                  child: new Text("Log out", style: new TextStyle(color: new Color.fromARGB(255, 117, 117, 117), fontSize: 32.0, fontWeight: FontWeight.bold)),
                ),



                
                new Divider(),
                new Text("Ibrahim Diallo")

              ],
            ),
          ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
        )
      )
    );
  }
}


