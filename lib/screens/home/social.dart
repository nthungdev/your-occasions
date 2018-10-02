import 'package:flutter/material.dart';

class SocialTabView extends StatefulWidget {
  @override
  _SocialTabView createState() => _SocialTabView();
}

class _SocialTabView extends State<SocialTabView> {

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("Search events page", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"),),
      ),
    );
  }




}
