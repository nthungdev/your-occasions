import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text("Search events page", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"),),
        ),
      ),
    );
  }




}
