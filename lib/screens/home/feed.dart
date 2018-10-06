import 'package:flutter/material.dart';

import 'package:youroccasions/screens/home/event_card.dart';

class FeedTabView extends StatefulWidget {
  @override
  _FeedTabView createState() => _FeedTabView();
}

class _FeedTabView extends State<FeedTabView> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text("Nearby events", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit")),
              ),
              SmallEventCard(),
            ],
          ),
        ),
      ),
    );
  }




}
