import 'package:flutter/material.dart';

class LeaderboardTabView extends StatefulWidget {
  @override
  _LeaderboardTabView createState() => _LeaderboardTabView();
}

class _LeaderboardTabView extends State<LeaderboardTabView> {

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("Leaderboard", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"),),
      ),
    );
  }




}
