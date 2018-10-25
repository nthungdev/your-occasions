import 'package:flutter/material.dart';

import 'package:youroccasions/screens/home/feed.dart';
import 'package:youroccasions/screens/home/leaderboardtab.dart';
import 'package:youroccasions/screens/home/social.dart';
import 'package:youroccasions/screens/home/drawer.dart';
import 'package:youroccasions/screens/home/bottom_menu.dart';
import 'package:youroccasions/screens/event/create_event.dart';
import 'package:youroccasions/screens/search/search.dart';
import 'package:youroccasions/utilities/config.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();

}

class _HomeScreen extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  String _accountName;
  String _accountEmail;
  PageController _pageController;
  BottomMenu bottomMenu;

  @override
  void initState() {
    super.initState();
    getUserName().then((value) {
      _accountName = value;
    });
    getUserEmail().then((value) {
      _accountEmail = value;
    });
    _pageController = PageController();
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }

  final List<Widget> myTabViews = <Widget>[
    FeedTabView(),
    SocialTabView(),
    LeaderboardTabView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
            } ,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEventScreen()));
        },
        child: Icon(Icons.add)
      ),
      drawer: HomeDrawer(accountName: _accountName, accountEmail: _accountEmail),
      bottomNavigationBar: BottomMenu(pageController: _pageController, currentIndex: this._currentPage,),
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            this._currentPage = index;      
          });
        },
        controller: _pageController,
        children: myTabViews,
      ),
    );
    
  }

  void navigationTapped(int page){
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease
    );
  }


}
