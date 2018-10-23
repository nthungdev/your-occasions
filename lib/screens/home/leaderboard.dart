import 'package:flutter/material.dart';

import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/screens/home/leaderboard_item.dart';

class LeaderboardTabView extends StatefulWidget {
  @override
  _LeaderboardTabView createState() => _LeaderboardTabView();
}

class _LeaderboardTabView extends State<LeaderboardTabView> {
  EventController ec;
  List<User> topHost;
  bool _hasData;
  
  @override
  void initState() {
    super.initState();
    _hasData = false;
    ec = EventController();
    getTopHost()
      ..then((onValue) {
        if(this.mounted) {
          setState(() { 
            _hasData = true;
            topHost = LeaderboardDataset.topHost.values;
          });
        }
      });
  }

  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  Widget _row = Row(
    children: <Widget>[
      Icon(Icons.filter_1),
      Text("Hung"),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Container(
        child: ListView(
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            Text("Leaderboard", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"),),
            Text("Top hosts", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"),),
            (!_hasData) 
              ? Center(child: CircularProgressIndicator()) 
              : Leaderboard(
                  children: _buildTopHostsItem(),
                )
          ] 
        ),
      ),
    );
  }

  void getData() async {
    
  }

  List<LeaderboardItem> _buildTopHostsItem() {
    List<LeaderboardItem> result = List.generate(LeaderboardDataset.topHost.values.length, (index) {
      return LeaderboardItem(
        rank: index + 1,
        content: (LeaderboardDataset.topHost.values[index]).name ?? "NoName",
        imageUrl: "https://imgur.com/370VKD8.png",
        // score: (LeaderboardDataset.topHost.values[index]).followers,
      );
    });
    return result;
  }

  // get hosts with the highest views
  Future<void> getTopHost() async {
    /**
     * Data is recently pulled 30 seconds ago. Wait until the 30 seconds span finish to get data again.
     */
    print("DEBUG lastModified topHost : ${LeaderboardDataset.topHost.lastModified}");
    print("DEBUG current time : ${DateTime.now()}");
    if (LeaderboardDataset.topHost.lastModified != null) {
      print("DEBUG Diff in seconds ${(DateTime.now()).difference(LeaderboardDataset.topHost.lastModified).inSeconds}");
    }
    // print("DEBUG Diff in minutes ${LeaderboardDataset.topHost.lastModified.difference(DateTime.now()).inMinutes}");
    if (LeaderboardDataset.topHost.lastModified != null && (DateTime.now()).difference(LeaderboardDataset.topHost.lastModified).inSeconds < 30) return;
    
    var temp = await ec.getEvent();
    Map<int,int> topHostMap = Map();
    var hostIds = List();
    // List<List> result = List();
    temp.forEach(((event) {
      if(topHostMap.containsKey(event.hostId) && event.views != 0) {
        print(topHostMap[event.hostId]);
        topHostMap[event.hostId] = topHostMap[event.hostId] + event.views;
      }
      else {
        topHostMap[event.hostId] = event.views;
      }
    }));

    hostIds = topHostMap.keys.toList();

    List<User> finalResult = List<User>();
    /**
     * Users' data already saved in Dataset.
     */
    if (Dataset.allUsers.values != null) {
      // Dataset.allUsers.values
      Dataset.allUsers.values.forEach((user) {
        if (hostIds.contains(user.id)) {
          finalResult.add(user);
        }
      });
    }
    else {
      UserController uc = UserController();
      finalResult = await uc.getUser()
        ..removeWhere((user) => !topHostMap.containsKey(user.id));
    }
    

    finalResult.sort((a,b) {
      if (topHostMap.containsKey(a.id) && topHostMap.containsKey(b.id)) {
        return topHostMap[b.id].compareTo(topHostMap[a.id]);
      }
      return 0;
    });

    // only get the first 5
    finalResult = finalResult.sublist(0, 5);

    print(finalResult);

    LeaderboardDataset.topHost.values = finalResult;
  }


}
