import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youroccasions/models/event_comment.dart';
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
    commentController.addListener(_onCommentInputChange);
    commentNode = FocusNode();
    event = widget.event;
    _refresh();

    EventController ec = EventController();
    ec.increaseView(event.id);
  }

  Future<void> _refresh() async {
    await _userController.getUserWithId(event.hostId).then((value){
      if(this.mounted) {
        setState(() { 
          user = value;
        });
      }
    });

    _getComments();

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

  Future<void> _getComments() async {
    Firestore firestore = Firestore.instance;
    // ref = FD.FirebaseDatabase.instance.reference().child("EventThreads");
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

  /// Detect key input event to force rebuild state.
  /// This helps enabling or disabling the clear keyword button
  void _onCommentInputChange(){
    print(commentController.text);
    setState(() { });
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircleAvatar(
                backgroundImage: Dataset.currentUser.value.picture != null 
                ? NetworkImage(Dataset.currentUser.value.picture)
                : AssetImage("assets/images/no-image.jpg")
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              focusNode: commentNode,
              controller: commentController,
              autofocus: false,
              validator: (message) => null,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                hintText: "Add a public comment",
                border: OutlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none, width: 0),
                  // gapPadding: 0,
                )
              )
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              color: Colors.blueAccent,
              disabledColor: Colors.transparent,
              onPressed: commentController.text.isEmpty ? null :
              () {
                print("Send comment");
              },
              icon: Icon(Icons.send),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildComment() {
    return CommentTile(
      onTap: () {
        print("Comment is tapped");
      },
      onTapReply: () {
        print("Reply button press");
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReplyCommentPage(eventComment: eventComment,)));
      },
      image: NetworkImage("https://cdn0.iconfinder.com/data/icons/avatar-15/512/ninja-512.png"),
      userName: "Ninja",
      messsage: "test comment",
      postTime: DateTime.now().subtract(Duration(hours: 3, days: 7)),
    );
  }

  List<Widget> _buildListViewContent() {
    List<Widget> result = List<Widget>();

    result.addAll([
      Column(
        children: <Widget>[
          _buildCoverImage(),
          _buildHost(),
          ListTile(
            title: Text('Name: ${event.name}'),
          ),
          ListTile(
            title: Text('Description: ${event.description}'),
          ),
          ListTile(
            title: Text('Category: ${event.category}'),
          ),
          Divider(
            height: 1,
          ),
          _buildCommentInput(),
          Divider(
            height: 1,
          ),
          _buildComment(),
          Divider(
            height: 1,
          ),
          _buildComment(),
          Divider(
            height: 1,
          ),
          _buildComment(),
          Divider(
            height: 1,
          ),
          _buildComment(),
        ],
      )
    ]);

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