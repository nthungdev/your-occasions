import 'package:flutter/material.dart';

import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/screens/home/leaderboard.dart';

class LeaderboardTabView extends StatefulWidget {
  @override
  _LeaderboardTabView createState() => _LeaderboardTabView();
}

class _LeaderboardTabView extends State<LeaderboardTabView> {
  bool _hasData1;
  bool _hasData2;
  bool _hasData3;
  bool _hasData4;
  
  @override
  void initState() {
    super.initState();
    _hasData1 = false;
    _hasData2 = false;
    _hasData3 = false;
    _hasData4 = false;
    getData();
  }

  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getData() async {
    getTopHost()
      .then((onValue) {
        if(this.mounted) {
          setState(() { 
            _hasData1 = true;
          });
        }
      });
    getMostFollowedUsers()
      .then((onValue) {
        if(this.mounted) {
          setState(() { 
            _hasData2 = true;
          });
        }
      }
    );
  }

  // get hosts with the highest views
  Future<void> getTopHost() async {
    EventController ec = EventController();
    /**
     * Data is recently pulled 30 seconds ago. Wait until the 30 seconds span finish to get data again.
     */
    // print("DEBUG lastModified topHost : ${LeaderboardDataset.topHost.lastModified}");
    // print("DEBUG current time : ${DateTime.now()}");
    // if (LeaderboardDataset.topHost.lastModified != null) {
      // print("DEBUG Diff in seconds ${(DateTime.now()).difference(LeaderboardDataset.topHost.lastModified).inSeconds}");
    // }
    // print("DEBUG Diff in minutes ${LeaderboardDataset.topHost.lastModified.difference(DateTime.now()).inMinutes}");
    if (LeaderboardDataset.topHost.lastModified != null && (DateTime.now()).difference(LeaderboardDataset.topHost.lastModified).inSeconds < 30) return;
    
    var temp = await ec.getEvent();
    Map<int,int> topHostMap = Map();
    var hostIds = List();
    // List<List> result = List();
    temp.forEach(((event) {
      if(topHostMap.containsKey(event.hostId) && event.views != 0) {
        // print(topHostMap[event.hostId]);
        if(event.views != null) {
          topHostMap[event.hostId] = topHostMap[event.hostId] + event.views;
        }
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
    if (Dataset.allUsers.value != null) {
      // Dataset.allUsers.values
      Dataset.allUsers.value.forEach((user) {
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

    // print(finalResult);

    LeaderboardDataset.topHostTotalEventViews.value = topHostMap;

    LeaderboardDataset.topHost.value = finalResult;
  }

  List<LeaderboardItem> _buildTopHostsItem() {
    List<LeaderboardItem> result = List.generate(LeaderboardDataset.topHost.value.length, (index) {
      return LeaderboardItem(
        rank: index + 1,
        content: (LeaderboardDataset.topHost.value[index]).name ?? "NoName",
        imageUrl: (LeaderboardDataset.topHost.value[index]).picture,
        score: LeaderboardDataset.topHostTotalEventViews.value[(LeaderboardDataset.topHost.value[index]).id],
        user: (LeaderboardDataset.topHost.value[index]),
      );
    });
    return result;
  }

  Future<void> getMostFollowedUsers() async {
    /**
     * Data is recently pulled 30 seconds ago. Wait until the 30 seconds span finish to get data again.
     */
    // print("DEBUG lastModified MostFollowedUsers : ${LeaderboardDataset.mostFollowedUsers.lastModified}");
    // print("DEBUG current time : ${DateTime.now()}");
    // if (LeaderboardDataset.mostFollowedUsers.lastModified != null) {
    //   print("DEBUG Diff in seconds ${(DateTime.now()).difference(LeaderboardDataset.mostFollowedUsers.lastModified).inSeconds}");
    // }
    // print("DEBUG Diff in minutes ${LeaderboardDataset.topHost.lastModified.difference(DateTime.now()).inMinutes}");
    if (LeaderboardDataset.mostFollowedUsers.lastModified != null && (DateTime.now()).difference(LeaderboardDataset.mostFollowedUsers.lastModified).inSeconds < 30) return;
    
    
    UserController uc = UserController();
    var mostFollowedusers = await uc.getMostFollowedUsers();
    LeaderboardDataset.mostFollowedUsers.value = mostFollowedusers;
  }

  List<LeaderboardItem> _buildMostFollowedUsersItem() {
    List<LeaderboardItem> result = List.generate(LeaderboardDataset.mostFollowedUsers.value.sublist(0, 5).length, (index) {
      return LeaderboardItem(
        rank: index + 1,
        content: (LeaderboardDataset.mostFollowedUsers.value[index]).name ?? "NoName",
        imageUrl: (LeaderboardDataset.mostFollowedUsers.value[index]).picture,
        score: LeaderboardDataset.mostFollowedUsers.value[index].followers,
        user: (LeaderboardDataset.mostFollowedUsers.value[index]),
      );
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Material(
      child: new Container(
        child: ListView(
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            // Text("Leaderboard", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"),),
            (!_hasData1) 
            ? Center(child: CircularProgressIndicator()) 
            : Leaderboard(
                title: "Highest views hosts",
                children: _buildTopHostsItem(),
                contentHeading: "Host",
                leadingHeading: "Rank",
                trailingHeading: "Views",
              ),
            SizedBox(height: screen.height / 40,),
            (!_hasData2)
            ? Center(child: CircularProgressIndicator()) 
            : Leaderboard(
                title: "Most followed hosts",
                children: _buildMostFollowedUsersItem(),
                contentHeading: "Host",
                leadingHeading: "Rank",
                trailingHeading: "Followers",
              ),
          ] 
        ),
      ),
    );
  }

}
