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
  bool _gotData = false;
  // bool _hasData3;
  // bool _hasData4;
  
  @override
  void initState() {
    super.initState();
    _hasData1 = false;
    _hasData2 = false;
    // _hasData3 = false;
    // _hasData4 = false;
    // getData();
    _refresh();
  }

  
  @override
  void dispose() {
    super.dispose();
  }

  void getData() async {
    getTopHost()
      .then((onValue) {
        if(this.mounted) {
          setState(() { 
            if (LeaderboardDataset.topHost.value.length != 0) { _hasData1 = true; }
          });
        }
      });
    getMostFollowedUsers()
      .then((onValue) {
        if(this.mounted) {
          setState(() { 
            if (LeaderboardDataset.mostFollowedUsers.value.length != 0) { _hasData2 = true; }
          });
        }
      }
    );
  }

  Future<void> _refresh() async {

    print("refresh leaderboard");


    await getTopHost();
    await getMostFollowedUsers();

    
    if (this.mounted) {
      setState(() {
        _gotData = true;
      });
    }
  }
  
  // get hosts with the highest views
  Future<void> getTopHost() async {
    EventController ec = EventController();

    var temp = await ec.getEvents();
    Map<String,int> topHostMap = Map();
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
      finalResult = await uc.getUsers()
        ..removeWhere((user) => !topHostMap.containsKey(user.id));
    }
    

    finalResult.sort((a,b) {
      if (topHostMap.containsKey(a.id) && topHostMap.containsKey(b.id)) {
        return topHostMap[b.id].compareTo(topHostMap[a.id]);
      }
      return 0;
    });

    // only get the first 5
    if(finalResult.length > 5) finalResult = finalResult.sublist(0, 5);

    // print(finalResult);

    LeaderboardDataset.topHostTotalEventViews.value = topHostMap;

    LeaderboardDataset.topHost.value = finalResult;

    _hasData1 = true;
  }

  List<LeaderboardItem> _buildTopHostsItem() {
    List<LeaderboardItem> result = List.generate(LeaderboardDataset.topHost.value.length, (index) {
      return LeaderboardItem(
        rank: index + 1,
        content: (LeaderboardDataset.topHost.value[index]).name ?? (LeaderboardDataset.topHost.value[index]).email,
        imageUrl: (LeaderboardDataset.topHost.value[index]).picture,
        score: LeaderboardDataset.topHostTotalEventViews.value[(LeaderboardDataset.topHost.value[index]).id],
        user: (LeaderboardDataset.topHost.value[index]),
      );
    });
    return result;
  }

  Future<void> getMostFollowedUsers() async {
    UserController uc = UserController();
    var mostFollowedusers = await uc.getMostFollowedUsers();
    LeaderboardDataset.mostFollowedUsers.value = mostFollowedusers;
    
    _hasData2 = true;
  }

  List<LeaderboardItem> _buildMostFollowedUsersItem() {
    List<LeaderboardItem> result;
    if (LeaderboardDataset.mostFollowedUsers.value.length == 0) { return List<LeaderboardItem>(); }
    if (LeaderboardDataset.mostFollowedUsers.value.length < 5) {
      result = List.generate(LeaderboardDataset.mostFollowedUsers.value.length, (index) {
        return LeaderboardItem(
          rank: index + 1,
          content: (LeaderboardDataset.topHost.value[index]).name ?? (LeaderboardDataset.topHost.value[index]).email,
          imageUrl: (LeaderboardDataset.mostFollowedUsers.value[index]).picture,
          score: LeaderboardDataset.mostFollowedUsers.value[index].followers,
          user: (LeaderboardDataset.mostFollowedUsers.value[index]),
        );
      });
    }
    result = List.generate(LeaderboardDataset.mostFollowedUsers.value.getRange(0, 5).length, (index) {
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
  

  List<Widget> _buildListViewChildren() {
    var screen = MediaQuery.of(context).size;
    List<Widget> alist = List<Widget>();
    
    if (_hasData1) {
      alist.addAll([
        Leaderboard(
          title: "Highest views hosts",
          children: _buildTopHostsItem(),
          contentHeading: "Host",
          leadingHeading: "Rank",
          trailingHeading: "Views",
        ),
        SizedBox(height: screen.height / 40,),
      ]);
    }
    
    if (_hasData2) {
      alist.add(
        Leaderboard(
          title: "Most followed hosts",
          children: _buildMostFollowedUsersItem(),
          contentHeading: "Host",
          leadingHeading: "Rank",
          trailingHeading: "Followers",
        )
      );
    }

    if (alist.length == 0) {
      alist.add(
        Center(child: Text("Wow such empty!"))
      );
    }
    
    return alist;
  }

  @override
  Widget build(BuildContext context) {
    var linearGradient = BoxDecoration(
      gradient: LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          Colors.blue[200],
          Colors.white,
        ],
      ),
    );

    return new Container(
      decoration: linearGradient,
      // color: Colors.white,
      child: !_gotData
      ? Center(child: CircularProgressIndicator(),)
      : RefreshIndicator(
        onRefresh: _refresh,
        child: (!_hasData1 && !_hasData2) 
        ? Center(child: Text("Wow such empty!"))
        : ListView(
            padding: const EdgeInsets.all(15.0),
            children: _buildListViewChildren(),
          )
      ),
    );
  }

}
