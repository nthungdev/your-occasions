import 'package:flutter/material.dart';

import 'package:youroccasions/screens/home/feed.dart';
import 'package:youroccasions/screens/home/leaderboard.dart';
import 'package:youroccasions/screens/home/social.dart';
import 'package:youroccasions/screens/home/drawer.dart';
import 'package:youroccasions/screens/event/create_event.dart';
import 'package:youroccasions/utilities/config.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();

  
}

class _HomeScreen extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _accountName;
  String _accountEmail;
  TabController _tabController;


  @override
  void initState() {
    super.initState();
    getUserName().then((value) {
      _accountName = value;
    });
    getUserEmail().then((value) {
      _accountEmail = value;
    });
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  final List<Widget> myTabs = <Widget>[
    FeedTabView(),
    SocialTabView(),
    LeaderboardTabView(),
  ];


  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text("Search"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text("Leaderboard"),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEventScreen()));
          },
          child: Icon(Icons.add)
        ),
        drawer: HomeDrawer(accountName: _accountName, accountEmail: _accountEmail),
        body: TabBarView(
          controller: _tabController,
          children: myTabs
        )
      ),
    );
    
  }

}
