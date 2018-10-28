import 'package:flutter/material.dart';
import 'dart:async';

import 'package:youroccasions/screens/user/diagonally_cut_colored_image.dart';
import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';

final UserController _userController = UserController();

class UserProfileScreen extends StatefulWidget {
  final User user;

  UserProfileScreen(User user) :  this.user = user;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
  
}

class _UserProfileScreenState extends State<UserProfileScreen>{

  User user;
  int id;


  @override
  initState() {
    super.initState();
    user = widget.user;
    getUserId().then((value){
      setState(() {
        id = value;
      });
    });
  }
  
  Widget _buildAvatar() {
    return new Hero(
      tag: "User Profile",
      child: new CircleAvatar(
        radius: 50.0,
      ),
    );
  }

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        "screens/user/profile_header_background.png",
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB8338f4),
    );
  }

  Widget _createPillButton(
    String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 140.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF413070),
          const Color(0xFF2B264A),
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  _buildDiagonalImageBackground(context),
                  new Align(
                    alignment: FractionalOffset.bottomCenter,
                    heightFactor: 1.4,
                    child: new Column(
                      children: <Widget>[
                        _buildAvatar(),
                        // _buildFollowerInfo(textTheme),
                        // _buildActionButtons(theme),
                      ],
                    ),
                  ),
                  new Positioned(
                    top: 26.0,
                    left: 4.0,
                    child: new BackButton(color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
} 