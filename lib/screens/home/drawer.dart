import 'package:flutter/material.dart';

import 'package:youroccasions/screens/home/interested_events.dart';
import 'package:youroccasions/screens/setting/setting.dart';
import 'package:youroccasions/screens/user/upload_avatar.dart';
import 'package:youroccasions/screens/user/user_profile.dart';
import 'package:youroccasions/screens/event/create_event.dart';
import 'package:youroccasions/screens/login/login.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/controllers/user_controller.dart';


final UserController _userController = UserController();

class HomeDrawer extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final String accountPicture;

  HomeDrawer({@required this.accountEmail, @required this.accountName, @required this.accountPicture});

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          Colors.deepPurpleAccent,
          // Colors.indigoAccent,
          Colors.cyanAccent,
          // Colors.lightBlue
        ],
      ),
    );

    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.deepPurpleAccent,
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async{
                      var user = await _userController.getUserWithId(Dataset.currentUser.value.id);
                      Dataset.currentUser.value = user;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(user)));
                    },
                    child: UserAccountsDrawerHeader(
                      margin: EdgeInsets.all(0),
                      // decoration: BoxDecoration(
                      //   // color: Colors.transparent,
                      //   gradient: const LinearGradient(
                      //     begin: FractionalOffset.centerRight,
                      //     end: FractionalOffset.bottomLeft,
                      //     colors: <Color>[
                      //       Colors.cyan,
                      //       Colors.lightBlueAccent,
                      //       // Colors.blueGrey,
                      //     ],
                      //   ),
                      // ),
                      accountName: Text(accountName),
                      accountEmail: Text(accountEmail),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: accountPicture == null
                        ? AssetImage("assets/images/no-avatar2.jpg")
                        : NetworkImage(accountPicture)
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    // decoration: linearGradient,
                    height:screen.height,
                    child: ListView(
                      children: <Widget>[
                        ListTile (
                            title: Text ("Create Event"),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEventScreen())),
                        ),
                        ListTile (
                          title: Text ("My Interested Events"),
                          onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => MyInterestedEventsPage())),
                        ),
                        ListTile (
                          title: Text ("Change Avatar"),
                          onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => UploadAvatarPage(Dataset.currentUser.value))),
                        ),
                        ListTile (
                          title: Text ("Settings"),
                          onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SettingPage())),
                        ), 
                      ],
                    )
                  )
                ]
              ),
            )
          ),
          GestureDetector(
            onTap: () async {
              await logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWithEmailScreen()));
            },
            child: SizedBox(
              width: screen.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                color: Colors.redAccent,
                child: Text ("Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

