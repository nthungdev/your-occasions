import 'package:flutter/material.dart';

class FeedTabView extends StatefulWidget {
  @override
  _FeedTabView createState() => _FeedTabView();
}

class _FeedTabView extends State<FeedTabView> {

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Text("Nearby events", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit")),
          ],
        ),
      ),
    );
  }




}
