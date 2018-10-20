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
  
  @override
  void initState() {
    super.initState();
    ec = EventController();
    getTopHost()
      ..then((onValue) {
        if(this.mounted) {
          setState(() { 
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
            Column(
              children: <Widget>[
                _row,
                _row,
                _row,
                Text(topHost.toString()),
                LeaderboardItem(
                  rank: 1,
                  imageUrl: "https://imgur.com/370VKD8.png",
                  content: "Hung Nguyen",
                  score: 100,
                ),
                LeaderboardItem(
                  rank: 2,
                  imageUrl: "https://imgur.com/370VKD8.png",
                  content: "Hung Nguyen",
                  score: 99,
                ),
                LeaderboardItem(
                  rank: 3,
                  imageUrl: "https://imgur.com/370VKD8.png",
                  content: "Hung Nguyen",
                  score: 98,
                )
              ],
            )
          ] 
          
        ),
      ),
    );
  }

  void getData() async {
    
  }



  Future<void> getTopHost() async {
    /**
     * Data is recently pulled 30 seconds ago. Wait until the 30 seconds span finish to get data again.
     */
    if (LeaderboardDataset.topHost.lastModified != null && LeaderboardDataset.topHost.lastModified.difference(DateTime.now()).inSeconds < 30) return;
    
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
    // result = List.generate(topHostMap.length, (index) {
    //   return [hostIds[index], topHostMap[hostIds[index]]];
    // });

    // result.sort((a,b) => b[1] - a[1]);

    List<User> finalResult = List<User>();
    /**
     * Users' data already saved in Dataset.
     */
    if (Dataset.allUsers.values != null) {
      // Dataset.allUsers.values
      Dataset.allUsers.values.forEach((user) {
        if (hostIds.contains(user.id)) {
          finalResult.add(user.clone());
        }
      });
    }
    else {
      UserController uc = UserController();
      finalResult = await uc.getUser()
        ..removeWhere((user) => !topHostMap.containsKey(user.id));
    }
    
    // print(topHostMap);
    // print(topHostMap.keys);
    // print(finalResult);

    finalResult.sort((a,b) {
      if (topHostMap.containsKey(a.id) && topHostMap.containsKey(b.id)) {
        return topHostMap[b.id].compareTo(topHostMap[a.id]);
      }
      return 0;
    });

    // print(finalResult);

    LeaderboardDataset.topHost.values = finalResult;
  }

}
