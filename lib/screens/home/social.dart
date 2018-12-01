import 'package:flutter/material.dart';
import 'package:youroccasions/controllers/friend_list_controller.dart';
import 'package:youroccasions/models/friend_list.dart';
import 'package:youroccasions/screens/user/user_card.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/screens/user/user_profile.dart';


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
    loadData();
    following = FollowDataset.following.value;
    // loadData();
  }

  void _refresh() async {
      await _getFollowing();
  }

  void loadData() async {
      await _refresh();
  }

  Future _getFollowing() async {
      var data = await _friendController.getFriendList(userId: currentUser.id);
      List<User> users;
      for (var friend in data){
        User temp = await _userController.getUserWithId(friend.friendId);
        users.insert(1,temp);
      };
      FollowDataset.following.value = users;
      if(this.mounted) {
        setState(() {
          following = FollowDataset.following.value;
        });
      }
  }

  Widget _buildUser(User user){
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UserProfileScreen(user))),
      leading: Hero(
        tag: 0,
        child: CircleAvatar(
          backgroundImage: user.picture != null
          ? NetworkImage(user.picture)
          : AssetImage("assets/images/no-image.jpg")
        ),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  }

  List<Widget> _buildFriends(){

    List<Widget> cards = List<Widget>();

    for (var friend in following){
      cards.insert(1,_buildUser(friend));
    }

    return cards;
    
  }

  void onDragDown(DragDownDetails details) {
    print(details.globalPosition);
    _refresh();
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
        // color: Colors.red,
        decoration: linearGradient,
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
