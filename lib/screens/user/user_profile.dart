import 'package:flutter/material.dart';
import 'dart:async';

import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';

final UserController _userController = UserController();

class UserProfileScreen extends StatefulWidget {
  final user user;

  UserProfileScreen(user user) :  this.user = user;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
  
}

class _UserProfileScreenState extends State<UserProfileScreen>{

  user user;
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