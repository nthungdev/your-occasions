import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:youroccasions/screens/event/event_detail.dart';
import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/models/user_interested_event.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/controllers/user_interested_event_controller.dart';
import 'package:youroccasions/utilities/config.dart';

const Color _favoriteColor = Colors.red;

class LeaderboardItem extends StatefulWidget {
  final int rank;
  final String imageUrl;
  final String content;
  final int score;

  LeaderboardItem({this.rank, this.imageUrl, this.content, this.score});

  @override
  _LeaderboardItemState createState() => _LeaderboardItemState();

}

class _LeaderboardItemState extends State<LeaderboardItem> {
  String _time;
  bool _gotData;
  Timer _queryTimer;

  @override
  void initState() {
    super.initState();
    _gotData = false;
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getData() async {

    _gotData = true;

    if (this.mounted) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_gotData) {
      return _buildLoadingCard();
    }
    return _buildCard();
  }

  Widget _buildLoadingCard() {
    final screen = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: SizedBox(
        height: 40.0,
        child: Container(
          color: Colors.tealAccent,
          child: Row(
            children: <Widget>[
              Text(widget.rank.toString(),
                style: TextStyle(
                  fontSize: 20.0
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              SizedBox(
                width: 40.0,
                height: 40.0,
                // color: Colors.red,
                // padding: EdgeInsets.all(15.0),
                child: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                        widget.imageUrl)
                    )
                  )
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(widget.content,
                style: TextStyle(
                  fontSize: 20.0
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  Widget _buildCard() {
    final screen = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: SizedBox(
        height: 40.0,
        child: Container(
          color: Colors.tealAccent,
          child: Row(
            children: <Widget>[
              Text(widget.rank.toString() + "st",
                style: TextStyle(
                  fontSize: 20.0
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              SizedBox(
                width: 40.0,
                height: 40.0,
                // color: Colors.red,
                // padding: EdgeInsets.all(15.0),
                child: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                        widget.imageUrl)
                    )
                  )
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(widget.content,
                style: TextStyle(
                  fontSize: 20.0
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(widget.score.toString())
                )
              )
            ],
          ),
        )
      ),
    );
  }


}
