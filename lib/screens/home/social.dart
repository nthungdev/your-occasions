import 'package:flutter/material.dart';
import 'package:youroccasions/controllers/friend_list_controller.dart';
import 'package:youroccasions/models/friend_list.dart';
import 'package:youroccasions/screens/user/user_card.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/screens/user/user_profile.dart';

import 'dart:async';

import 'package:youroccasions/models/data.dart';

final FriendListController _friendController = FriendListController();
final UserController _userController = UserController();

class SocialTabView extends StatefulWidget {
  @override
  _SocialTabView createState() => _SocialTabView();
}

class _SocialTabView extends State<SocialTabView> {
  
  User currentUser = Dataset.currentUser.value;
  List<User> following;

  @override
  void initState() {
    super.initState();
    // loadData();
    following = FollowDataset.following.value;
    _refresh();
  }

  Future<void> _refresh() async {
      await _getFollowing();
  }

  Future<void> _getFollowing() async {
      var data = await _friendController.getFriendList(userId: currentUser.id);
      List<User> users = List<User>();

      for (var friend in data){
        User temp = await _userController.getUserWithId(friend.friendId);
        users.add(temp);
      }
      
      FollowDataset.following.value = users;
      // print(data[0].userId);
      // print(users);
      if(this.mounted) {
        setState(() {
          following = FollowDataset.following.value;
        });
      }
  }

  Widget _buildUser(User user){
    var screenWidth = MediaQuery.of(context).size.width;
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UserProfileScreen(user))),
      leading: CircleAvatar(
          backgroundImage: NetworkImage(user.picture ?? "assets/images/no-image.jpg")
        ),
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  }

  List<Widget> _buildFriends(){
    List<Widget> cards = List<Widget>();
    int tag = 0;
    // print(following[0]);
    if (following.length == 0 || following[0] == null){
      return cards;
    }
    // print(1);
    for (var friend in following){
      cards.add(_buildUser(friend));
      tag+=1;
    }

    return cards;
    
  }

  void onDragDown(DragDownDetails details) {
    // print(details.globalPosition);
    _refresh();
  }

  Widget _buildLoadingCard() {
    final screen = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: screen.height / 7,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  color: Colors.grey[200],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          // Colors.blue,
          Colors.blue,
          Colors.white,
        ],
      ),
    );

    // return new Material(
    //   child: Container(
    //     decoration: linearGradient,
    //     child: Padding(
    //     padding: const EdgeInsets.all(15.0),
    //     child: Text("Social page", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit"),),
    //    ),
    //  )
    // );

    return Material(
      child: new Container(
        // color: Colors.orange,
        // color: Colors.red,
        // padding: EdgeInsets.symmetric(horizontal: 10.0),
        color: Colors.white,
        // decoration: linearGradient,
        child: following == null 
        ? const Center(child: const CircularProgressIndicator()) 
        : RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              addAutomaticKeepAlives: false, // Force to kill the Card
              children: _buildFriends(),
            ),
          )
      ),
    );
  }
}
