import 'package:flutter/material.dart';

import 'package:youroccasions/screens/home/slidebar.dart';
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
  void initState() async {
    super.initState();
    _accountName = await getUserName();
    _accountEmail = await getUserEmail();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  final List<Widget> myTabs = <Widget>[
    Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Text("Nearby events", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit")),
          ],
        ),
      ),
    ),
    Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("Search events page", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"),),
      ),
    ),
    Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("Leaderboard", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"),),
      ),
    ),
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
