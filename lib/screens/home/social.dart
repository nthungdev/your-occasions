import 'package:flutter/material.dart';
import 'package:youroccasions/controllers/friend_list_controller.dart';
import 'package:youroccasions/models/friend_list.dart';
import 'package:youroccasions/screens/user/user_card.dart';

final FriendListController friendController = FriendListController();

class SocialTabView extends StatefulWidget {
  @override
  _SocialTabView createState() => _SocialTabView();
}

class _SocialTabView extends State<SocialTabView> {

  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          // Colors.blue,
          Colors.blue,
          Colors.white,
        ],
      ),
    );

    // return new Material(
    //   child: Container(
    //     decoration: linearGradient,
    //     child: Padding(
    //     padding: const EdgeInsets.all(15.0),
    //     child: Text("Social page", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"),),
    //    ),
    //  )
    // );
    return new Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("Social page", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"),),
      ),
    );
  }




}
