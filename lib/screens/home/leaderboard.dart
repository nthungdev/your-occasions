import 'package:flutter/material.dart';

import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/screens/user/user_profile.dart';

const Color _favoriteColor = Colors.red;
const double _itemFontSize = 20.0;

class LeaderboardItem extends StatefulWidget {
  final int rank;
  final String imageUrl;
  final String content;
  final int score;
  final User user;

  LeaderboardItem({this.rank, this.imageUrl, this.content, this.score, this.user});

  @override
  _LeaderboardItemState createState() => _LeaderboardItemState();

}

class _LeaderboardItemState extends State<LeaderboardItem> {
  bool _gotData;

  @override
  void initState() {
    super.initState();
    _gotData = false;
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getData() async {

    _gotData = true;

    if (this.mounted) {
      setState(() {

      });
    }
  }

  void onTap() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => UserProfileScreen(widget.user)));
  }


  Widget _buildLoadingCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: SizedBox(
        height: 40.0,
        child: Container(
          color: Colors.white,
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

    return Material(
      // borderRadius: BorderRadius.circular(10.0),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        highlightColor: Colors.blueAccent,
        splashColor: Colors.blue,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
            child: SizedBox(
              height: 40.0,
              child: Container(
                // color: Colors.tealAccent,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(0.0),
                        // color: Colors.green,
                        child: SizedBox(
                          // width: 20.0,
                          child: Text(widget.rank.toString(),
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: 20.0
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10.0,
                    // ),
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 40.0,
                            height: 40.0,
                            // color: Colors.red,
                            // padding: EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: widget.imageUrl != null 
                                    ? NetworkImage(
                                      widget.imageUrl
                                    )
                                    : AssetImage("assets/images/no-avatar2.jpg")
                                )
                              )
                            ),
                          ),
                          SizedBox(width: screen.width / 30,),
                          Expanded(
                            child: Container(
                              // color: Colors.red,
                              // padding: EdgeInsets.only(right: 40.0 + screen.width / 30),
                              child: Text(widget.content,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ] 
                      ),
                    ),
                    // SizedBox(
                    //   width: 10.0,
                    // ),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        child: Text(
                          widget.score != null ? widget.score.toString() : "", 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0
                          ),
                        ),
                      )
                    )
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_gotData) {
      return _buildLoadingCard();
    }
    return _buildCard();
  }


}


class Leaderboard extends StatefulWidget {
  final String title;
  final List<LeaderboardItem> children;
  final String leadingHeading;
  final String contentHeading;
  final String trailingHeading;

  Leaderboard({@required this.title, this.leadingHeading, this.contentHeading, this.trailingHeading, @required this.children});

  @override
  _LeaderboardState createState() => _LeaderboardState();

}

class _LeaderboardState extends State<Leaderboard> {


  @override
  void initState() {
    super.initState();
    
  }

  List<Widget> _buildChildrenList(){
    return List<Widget>.of(widget.children);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getData() async {


    if (this.mounted) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          // Colors.blue,
          Colors.deepPurpleAccent,
          Colors.transparent,
        ],
      ),
    );

    if(widget.leadingHeading != null && widget.contentHeading != null && widget.trailingHeading != null) {
      return Container(
        padding: EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                widget.title, 
                style: TextStyle(fontSize: 30.0, fontFamily: "Niramit", color: Colors.white), 
                textAlign: TextAlign.center,
              )
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              color: Colors.black26,
              // decoration: BoxDecoration(
              //   color: Colors.blueAccent,
              //   borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))
              // ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      widget.leadingHeading, 
                      style: TextStyle(fontSize: _itemFontSize, fontFamily: "Niramit", color: Colors.white), 
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: EdgeInsets.only(left: 40.0 + (screen.width / 30)),
                      child: Text(
                        widget.contentHeading, 
                        style: TextStyle(fontSize: _itemFontSize, fontFamily: "Niramit", color: Colors.white), 
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      // color: Colors.green,
                      child: Text(
                        widget.trailingHeading, 
                        style: TextStyle(fontSize: _itemFontSize, fontFamily: "Niramit", color: Colors.white), 
                        textAlign: TextAlign.center,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
              ),
              child: Column(
                children: _buildChildrenList(),
              ),
            )
          ] 
        )
      );
    }

    return Container(
      padding: EdgeInsets.all(0.0),
      // decoration: BoxDecoration(
      //   shape: ,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black,
      //       blurRadius: 150.0,
      //       spreadRadius: 150.0,
      //     )
      //   ]
      // ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              widget.title, 
              style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"), 
              textAlign: TextAlign.center,
            )
          ),
          Container(
            padding: EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              color: Colors.amberAccent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 20.0,
                  // offset: Offset.infinite
                  spreadRadius: 20.0
                )
              ],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
            ),
            child: Column(
              children: _buildChildrenList(),
            ),
          )
        ] 
      )
    );
  }



}