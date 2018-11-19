import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/controllers/friend_list_controller.dart';
import 'package:youroccasions/models/friend_list.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/models/data.dart';

const Color _favoriteColor = Colors.red;

class SmallUserCard extends StatefulWidget {
  final User user;
  int userId;

  SmallUserCard({this.user, int userId}) {
    this.userId = userId;
  }

  @override
  _SmallUserCardState createState() => _SmallUserCardState();

}

class _SmallUserCardState extends State<SmallUserCard> {
  FriendListController _friendListController;
  UserController _userController;
  bool _isFollowed;
  bool _gotData;
  Timer _queryTimer;

  @override
  void initState() {
    super.initState();
    _userController = UserController();
    _friendListController = FriendListController();
    _gotData = false;
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userController = null;
    _friendListController = null;
  }

  void getData() async {
    try {
      var userId = Dataset.userId.value;
      var result = await _friendListController.getFriendList(userId: userId, friendId: widget.user.id);

      _gotData = true;

      if (this.mounted) {
        setState(() {
          _isFollowed = !(result.isEmpty) ? true : false;
        });
      }
    } 
    catch (e) {
      print("An exception occurs");
      print(e.toString());
    }
  }
  
  // Push EventDetailScreen to view.
  void _onTap() {
    // _increaseView();
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailScreen(widget.event)));
  }

  void _onFollowPressed() {
    if (this.mounted) {
      setState(() {
        _isFollowed = !_isFollowed;

        if(_queryTimer == null) {
          _queryTimer = Timer(Duration(seconds: 1), _handleTimer);
        }
      });
    }
  }

  void _handleTimer() {
    if(_isFollowed) {
      _followUser();
    }
    else{
      _unfollowUser();
    }
    _queryTimer = null;
  }
  
  void _followUser() async {
    var userId = Dataset.userId.value;
    FriendList newModel = FriendList(userId: userId);
    var result = await _friendListController.getFriendList(userId: userId, friendId: widget.user.id);
    if (result.isEmpty) _friendListController.insert(newModel);
  }

  void _unfollowUser() async {
    var userId = await getUserId();
    var friend = await _friendListController.getFriendList(userId: userId, friendId: widget.user.id);
    if (!(friend.isEmpty)) _friendListController.delete(friend[0].id);
  }

  Widget _buildFollowButton() {
    if (!_isFollowed) {
      return FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        onPressed: _onFollowPressed,
        child: SizedBox(
          child: Text("Follow")
        ),
      );
    }
    return FlatButton(
      color: Colors.white,
      textColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      onPressed: _onFollowPressed,
      child: SizedBox(
        child: Text("Following")
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_gotData) {
      return _buildLoadingCard();
    }
    return _buildCard();
  }

  Widget _buildLoadingCard() {
    final screen = MediaQuery.of(context).size;

    return ListTile(
      onTap: () {},
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
      ),
      trailing: FlatButton(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        onPressed: () {},
        child: Text(""),
      ),
    );
  }

  Widget _buildCard() {
    final screen = MediaQuery.of(context).size;

    return ListTile(
      onTap: _onTap,
      leading: CircleAvatar(
        backgroundImage: widget.user.picture == null 
        ? AssetImage("images/no-image.jpg")
        : NetworkImage(widget.user.picture)
      ),
      title: Text(widget.user.name),
      trailing: _buildFollowButton(),
    );
  }

}
