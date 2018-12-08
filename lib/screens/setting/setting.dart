
import 'package:flutter/material.dart';
import 'package:youroccasions/screens/setting/setting.dart';
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          Colors.blue,
          Colors.white,
        ],
      ),
    );

    return Scaffold(appBar: 
      new AppBar(title: new Text('Setting'),),
      body: new SafeArea(
        child: new Container(
          height: double.infinity,
          decoration: linearGradient,
        // padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 12.0, right: 12.0),
        // child: new Card(
          child: new Row(
            children: <Widget>[
              new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 22.0, bottom: 8.0),
                    child: new Text("Edit Profile", style: new TextStyle(color: new Color.fromARGB(255, 117, 117, 117), fontSize: 32.0, fontWeight: FontWeight.bold)),
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
                new Text("Youroccasions")

              ],
            ),
          ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
        )
      )
    )
    
    // )
>>>>>>> eda4761b9a5d2cff342cdbd7f8a9daad168d5ac8
    );
  }
}

