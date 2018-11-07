import 'package:flutter/material.dart';

import 'package:youroccasions/screens/home/feed.dart';
import 'package:youroccasions/screens/home/leaderboardtab.dart';
import 'package:youroccasions/screens/home/social.dart';
import 'package:youroccasions/screens/home/drawer.dart';
import 'package:youroccasions/screens/home/bottom_menu.dart';
import 'package:youroccasions/screens/search/search.dart';
import 'package:youroccasions/utilities/config.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();

}

class _HomeScreen extends State<HomeScreen> with SingleTickerProviderStateMixin {
  /// _currentPage -> 0: home | 1: social | 2: leaderboard
  int _currentPage = 0;
  String _accountName;
  String _accountEmail;
  PageController _pageController;
  BottomMenu bottomMenu;

  @override
  void initState() {
    super.initState();
    getUserName().then((value) {
      setState(() {
        _accountName = value;
      });
    });
    getUserEmail().then((value) {
      setState(() {
        _accountEmail = value;
      });
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

  List<Widget> _buildActions() {
    List<Widget> actions = List();
    if (_currentPage == 0) {
      actions.add(IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        } ,
      ));
      return actions;
    }
    return null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: _buildActions(),
      ),
      drawer: HomeDrawer(
        accountName: _accountName == null ? "" : _accountName, 
        accountEmail: _accountEmail == null ? "" : _accountEmail,
      ),
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


}
