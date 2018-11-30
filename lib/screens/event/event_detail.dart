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
  final GlobalKey<FormFieldState> commentKey = GlobalKey<FormFieldState>();
  Event _event;
  User _host;
  User _currentUser = Dataset.currentUser.value;
  TextEditingController _commentController;
  FocusNode _commentNode;
  DocumentReference _eventReference;
  bool _gotData;
  
  EventComment eventComment;
  List<EventComment> eventComments;
  int descriptionMaxLine;

  @override
  initState() {
    super.initState();
    _event = widget.event;
    _eventReference = Firestore.instance.collection('EventThreads').document(_event.id.toString());
    descriptionMaxLine = 10;
    eventComments = List<EventComment>();
    _gotData = false;
    _commentController = TextEditingController();
    _commentNode = FocusNode();
    _refresh();

    EventController ec = EventController();
    ec.increaseView(_event.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentNode.dispose();
    _commentController.dispose();
  }

  Future<void> _refresh() async {
    await _userController.getUserWithId(_event.hostId).then((value){
      if(this.mounted) {
        setState(() { 
          _host = value;
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

  Future<void> _getComments() async {
    DocumentSnapshot snapshot = await _eventReference.get();
    if (snapshot.exists) {
      List<DocumentSnapshot> documents;
      await snapshot.reference.collection('Comments').getDocuments().then((value) {
        documents = value.documents;
      });
      eventComments.clear();
      for (var document in documents) {
        var comment = EventComment.fromSnapshot(document);
        // print("Id: ${comment.id}");
        await comment.getReplies(document);
        print(comment.replies);
        eventComments.add(comment);
      }
    }
    else {
      // _eventReference.setData({
      //   'comments': [],
      // });
      eventComments = [];
    }
  }

  Future<void> _postComment() async {
    /// Make object for comment
    var comment = EventComment(
      authorId: Dataset.currentUser.value.id,
      date: DateTime.now(),
      eventId: widget.event.id,
      message: _commentController.text.trim(),
    );

    // _eventReference.
    _eventReference.collection("Comments").add(comment.toJson());
    _commentController.clear();
    _commentNode.unfocus();

    _refresh();
  }

  void delete() async {
    await _eventController.delete(_event.id);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  Widget _buildHost() {
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UserProfileScreen(_host))),
      leading: Hero(
        tag: 0,
        child: CircleAvatar(
          backgroundImage: _host.picture != null
          ? NetworkImage(_host.picture)
          : AssetImage("assets/images/no-image.jpg")
        ),
      ),
      title: Text(_host.name),
      subtitle: Text(_host.email),
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
        focusNode: _commentNode,
        controller: _commentController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        validator: (text) => null,
        autofocus: false,
        decoration: InputDecoration(
        ),
      ));
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
          Text(eventComments.length.toString(),
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

    // eventComment.replies.forEach((comment) {
    eventComments.forEach((comment) {
      result.addAll([
        CommentTile(
          onTap: () {
            print("Comment is tapped");
          },
          onTapReply: () {
            print("Reply button press");
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReplyCommentPage(eventComment: comment,)));
            // print("back to event details");
          },
          image: NetworkImage("https://cdn0.iconfinder.com/data/icons/avatar-15/512/ninja-512.png"),
          userName: comment.authorId,
          messsage: comment.message,
          postTime: comment.date,
          repliesCount: comment.replies?.length ?? 0,
        ),
        Divider(
          height: 1,
        )
      ]);
    });

    return result;
  }

  Widget _buildTitle() {
    var screen = MediaQuery.of(context).size;

    return Row(
      children: <Widget>[
        SizedBox(
          width: screen.width * 0.25,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              children: <Widget>[
                Text("DEC",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.redAccent,
                  ),
                ),
                Text("12",
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(widget.event.name,
          maxLines: 2,
          style: TextStyle(
            fontSize: 24
          ),
        )
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      children: <Widget>[

      ],
    );
  }

  List<Widget> _buildListViewContent() {
    List<Widget> result = List<Widget>();

    result.addAll([
      Column(
        children: <Widget>[
          _buildCoverImage(),
          _buildTitle(),
          Divider(height: 1,),
          _buildHost(),
          Divider(height: 1,),
          // ListTile(
          //   contentPadding: EdgeInsets.symmetric(horizontal: 20),
          //   title: Text('Name: ${event.name}'),
          // ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Text('Description: ${_event.description}'),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Text('Category: ${_event.category}'),
          ),
          Divider(
            height: 1,
          ),
          Container(
            height: 10,
            color: Colors.grey[200],
          ),
          _buildCommentHeader(),
          CommentInput(commentNode: _commentNode, commentController: _commentController, onPostComment: _postComment,),
        ],
      )
    ]);

    if (_gotData && eventComments.length != 0) {
      result
        ..add(Divider(height: 1,))
        ..addAll(_buildCommentList());
    }

    return result;
  }

  Widget _buildAppBar() {
    List<Widget> row = List<Widget>();

    row.addAll([
      SizedBox(
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      Expanded(
        child: SizedBox(),
      ),
    ]);

    if (_gotData && Dataset.currentUser.value.id == _event.hostId) {
      row.addAll([
        IconButton(
          icon: Icon(Icons.edit), 
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateEventScreen(_event)));
          }
        ),
        IconButton(
          icon: Icon(Icons.delete), 
          onPressed: delete,
        ),
      ]);
    }

    return SizedBox(
      child: Container(
        color: Color(0x0F000000),
        child: Row(
          children: row,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Event Details"),
      //   actions: _buildActionButtons(),
      // ),
      body: SafeArea(
        child: Container(
          child: !_gotData
          ? Center(child: CircularProgressIndicator(),)
          : Stack(
            children: <Widget>[
              RefreshIndicator(
                displacement: 50,
                onRefresh: _refresh,
                child: ListView(
                  children: _buildListViewContent(),
                ),
              ),
              _buildAppBar(),
            ],
          )
        ),
      )
    );
  }
}

