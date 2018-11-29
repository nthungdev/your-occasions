import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youroccasions/models/event_comment.dart';
import 'package:youroccasions/screens/event/comment_input.dart';
import 'package:youroccasions/screens/event/comment_tile.dart';
import 'package:youroccasions/screens/event/reply_comment_page.dart';

import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/screens/event/update_event.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/screens/user/user_profile.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/models/data.dart';

final EventController _eventController = EventController();
final UserController _userController = UserController();

class EventDetailScreen extends StatefulWidget {
  final Event event;

  EventDetailScreen(this.event);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
  
}

class _EventDetailScreenState extends State<EventDetailScreen>{
  Event event;
  User user;
  // String id;
  User currentUser = Dataset.currentUser.value;
  TextEditingController commentController;
  FocusNode commentNode;
  final GlobalKey<FormFieldState> commentKey = GlobalKey<FormFieldState>();
  bool _gotData;
  
  EventComment eventComment;

  @override
  initState() {
    super.initState();
    _gotData = false;
    commentController = TextEditingController();
    commentNode = FocusNode();
    event = widget.event;
    _refresh();

    EventController ec = EventController();
    ec.increaseView(event.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentNode.dispose();
    commentController.dispose();
  }

  Future<void> _refresh() async {
    await _userController.getUserWithId(event.hostId).then((value){
      if(this.mounted) {
        setState(() { 
          user = value;
        });
      }
    });

    await _getComments();

    if(this.mounted) {
      setState(() { 
        _gotData = true;
      });
    }
  }

  void delete() async {
    await _eventController.delete(event.id);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  Widget _buildHost() {
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

  Widget _buildCoverImage() {
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.width * 3 / 4,
      child: widget.event.picture != null
      ? Image.network(widget.event.picture, fit: BoxFit.cover,)
      : Image.asset("assets/images/no-image.jpg", fit: BoxFit.cover,) 
    );
  }

  Widget _buildPostComment() {
    var screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width / 1.5,
      child: TextFormField(
        key: commentKey,
        focusNode: commentNode,
        controller: commentController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        validator: (text) => null,
        autofocus: false,
        // onFieldSubmitted: (term) {
        //   commentNode.unfocus();
        // },
        decoration: InputDecoration(
          // labelText: "EMAIL",
          // labelStyle: TextStyle(fontWeight: FontWeight.bold),
          // errorMaxLines: 2
        ),
      ));
  }

  Future<void> _getComments() async {;
    DocumentReference ref = Firestore.instance.collection('EventThreads').document('0');
    DocumentSnapshot snapshot = await ref.get();
    EventComment model = EventComment.fromSnapshot(snapshot);
    print(model.replies[0]);
    EventComment modelNested = model.replies[0];
    print(modelNested.replies);
    EventComment modelNested2 = modelNested.replies[0];
    print(modelNested2.message);

    eventComment = model;
  }

  List<Widget> _buildActionButtons() {
    List<Widget> result = List<Widget>();

    if (_gotData && Dataset.currentUser.value.id == event.hostId) {
      result.addAll([
        IconButton(
          icon: Icon(Icons.edit), 
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateEventScreen(event)));
          }
        ),
        IconButton(
          icon: Icon(Icons.delete), 
          onPressed: delete,
        ),
      ]);
    }

    return result;
  }

  Widget _buildCommentHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget>[
          Text("Comments ",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(eventComment.replies.length.toString(),
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCommentList() {
    List<Widget> result = List<Widget>();

    eventComment.replies.forEach((comment) {
      result.add(
        CommentTile(
          onTap: () {
            print("Comment is tapped");
          },
          onTapReply: () {
            print("Reply button press");
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReplyCommentPage(eventComment: eventComment,)));
          },
          image: NetworkImage("https://cdn0.iconfinder.com/data/icons/avatar-15/512/ninja-512.png"),
          userName: comment.authorId,
          messsage: comment.message,
          postTime: comment.date,
        )
      );
    });

    return result;
  }

  List<Widget> _buildListViewContent() {
    List<Widget> result = List<Widget>();

    result.addAll([
      Column(
        children: <Widget>[
          _buildCoverImage(),
          _buildHost(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Text('Name: ${event.name}'),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Text('Description: ${event.description}'),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Text('Category: ${event.category}'),
          ),
          Divider(
            height: 1,
          ),
          Container(
            height: 10,
            color: Colors.grey[100],
          ),
          _buildCommentHeader(),
          CommentInput(commentNode: commentNode, commentController: commentController, onPostComment: () {},),
          Divider(
            height: 1,
          ),
        ],
      )
    ]);

    if (_gotData) {
      result.addAll(_buildCommentList());
    }

    return result;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details"),
        actions: _buildActionButtons(),
      ),
      body: Container(
        child: !_gotData
        ? Center(child: CircularProgressIndicator(),)
        : ListView(
          children: _buildListViewContent(),
        )
      )
    );
  }
}

