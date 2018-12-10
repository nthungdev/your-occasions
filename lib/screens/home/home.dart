import 'dart:async';

import 'package:flutter/material.dart';

import 'package:youroccasions/screens/home/feed.dart';
import 'package:youroccasions/screens/home/leaderboardtab.dart';
import 'package:youroccasions/screens/home/social.dart';
import 'package:youroccasions/screens/home/drawer.dart';
import 'package:youroccasions/screens/home/bottom_menu.dart';
import 'package:youroccasions/screens/search/search.dart';
import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();

}

class _HomeScreen extends State<HomeScreen> with SingleTickerProviderStateMixin {
  /// _currentPage -> 0: home | 1: social | 2: leaderboard
  UserController controller = UserController();
  int _currentPage = 0;
  String _accountName;
  String _accountEmail;
  String id;
  PageController _pageController;
  BottomMenu bottomMenu;
  String _title;

  final List<Widget> _myTabViews = <Widget>[
    FeedTabView(),
    FriendsTabView(),
    LeaderboardTabView(),
  ];

  var feedRefreshNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _title = "Feed";

    // getUserName().then((value) {
    //   setState(() {
    //     _accountName = value;
    //   });
    // });
    // getUserEmail().then((value) {
    //   setState(() {
    //     _accountEmail = value;
    //   });
    // });
    // getUserId().then((value) {
    //   id = value;
    //   Dataset.userId.value = id;
    //   getCurrentUser(id);
    // });

    _accountName = Dataset.currentUser.value.name;
    _accountEmail = Dataset.currentUser.value.email;

    print("User's picture: \n");
    print(Dataset.currentUser.value.picture);   

  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }

  Future<void> getCurrentUser(String id) async {
    List<User> currentUser = await controller.getUsers(id: id);
    print(currentUser);
    Dataset.currentUser.value = currentUser[0];
  }

  List<Widget> _buildActions() {
    List<Widget> actions = List();
    if (_currentPage == 0) {
      actions.addAll([
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
          } ,
        ),
      ]);
      return actions;
    }
    return null;
  }

  void navigationTapped(int page) {
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
    
    // getCurrentUser(Dataset.currentUser.value.id);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(_title),
        actions: _buildActions(),
      ),
      drawer: HomeDrawer(
        accountName: Dataset.currentUser.value.name,
        accountEmail: Dataset.currentUser.value.email,
        accountPicture: Dataset.currentUser.value.picture,
      ),
      bottomNavigationBar: BottomMenu(pageController: _pageController, currentIndex: this._currentPage,),
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;   
            switch (index) {
              case 0:
                _title = "Feed";
                break;
              case 1:
                _title = "Friends";
                break;
              case 2:
                _title = "Leaderboard";
                break;
              default:
                _title = "Unknown Page";
            }
          });
        },
        controller: _pageController,
        children: _myTabViews,
      ),
    );
    
  }


}
