import 'package:flutter/material.dart';

class BottomMenu extends StatefulWidget {
  @override
  _BottomMenu createState() => _BottomMenu();

  final PageController _pageController;
  final int _currentIndex;

  const BottomMenu({@required PageController pageController, @required int currentIndex})
      : _pageController = pageController,
        _currentIndex = currentIndex;

      
}

class _BottomMenu extends State<BottomMenu> {
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget._currentIndex;
  }

  @override
  void dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new BottomNavigationBar(
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          widget._pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
        });
      },
      currentIndex: widget._currentIndex,
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
    );

    
  }



}
