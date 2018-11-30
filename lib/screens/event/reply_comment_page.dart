import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/models/event_comment.dart';
import 'package:youroccasions/screens/event/comment_input.dart';
import 'package:youroccasions/screens/event/comment_tile.dart';
import 'package:youroccasions/screens/event/reply_tile.dart';


class ReplyCommentPage extends StatefulWidget {
  final EventComment eventComment;

  ReplyCommentPage({Key key, @required this.eventComment}) 
    : super(key: key);

  @override
  ReplyCommentPageState createState() => ReplyCommentPageState();
}

class ReplyCommentPageState extends State<ReplyCommentPage> {
  EventComment _eventComment;
  TextEditingController _commentController;
  FocusNode _commentNode;
  DocumentReference _commentReference;
  bool _gotData;
  List<EventComment> _commentReplies;

  @override
  initState() {
    super.initState();
    _commentReplies = widget.eventComment.replies;
    _gotData = false;
    _eventComment = widget.eventComment;
    _commentController = TextEditingController();
    _commentNode = FocusNode();

    print("Parent ID : ${_eventComment.id}");
    _commentReference = Firestore.instance
      .collection('EventThreads/${_eventComment.eventId}/Comments').document("${_eventComment.id}");
    _refresh();
  }

  Future<void> _refresh() async {
    await _getReplies();

    if(this.mounted) {
      setState(() { 
        _gotData = true;
      });
    }
  }

  Future<void> _getReplies() async {
    List<DocumentSnapshot> documents;
    await _commentReference.collection("Replies").getDocuments().then((value) {
      documents = value.documents;
    });
    if (documents.isNotEmpty) {
      _commentReplies.clear();
      documents.forEach((document) {
        var comment = EventComment.fromSnapshot(document);
        _commentReplies.add(comment);
      });
      _commentReplies.sort((b,a) => a.date.compareTo(b.date));
    }
    else {
      _commentReplies = [];
    }
  }

  Future<void> _postReply() async {
    var comment = EventComment(
      parentId: _eventComment.id,
      authorId: Dataset.currentUser.value.id,
      date: DateTime.now(),
      eventId: _eventComment.eventId,
      message: _commentController.text.trim(),
    );

    await _commentReference.collection("Replies").add(comment.toJson());
    await _commentReference.updateData({
      "replyCount": _eventComment.replies.length + 1
    });
    _commentController.clear();
    _commentNode.unfocus();

    setState(() {
      _commentReplies.add(comment);
    });

    _refresh();
  }

  String _getTimeAway() {
    Duration period = DateTime.now().difference(_eventComment.date);
    String result = "";
    if (period.inDays != 0) {
      if (period.inDays < 7 ) {
        result += "${period.inDays} day" + ((period.inDays > 1) ? "s ago" : " ago");
      }
      else {
        result += "${(period.inDays / 7).round()} week" + ((period.inDays / 7 > 1) ? "s ago" : " ago");
      }
    }
    else if (period.inHours != 0) {
      result += "${period.inHours} hour" + ((period.inHours > 1) ? "s ago" : " ago");
    }
    else {
      result += "${period.inMinutes} minute" + ((period.inMinutes > 1) ? "s ago" :  " ago");
    }

    return result;
  }

  List<Widget> _buildListViewContent() {
    List<Widget> result = List<Widget>();
    
    result.addAll([
      Column(
        children: <Widget>[
          CommentTile(
            image: NetworkImage("https://cdn0.iconfinder.com/data/icons/avatar-15/512/ninja-512.png"),
            messsage: _eventComment.message,
            onTap: () {},
            onTapReply: () {},
            postTime: _eventComment.date,
            userName: _eventComment.authorId,
            repliesCount: _eventComment.replies.length,
          ),
          Divider(
            height: 1,
          ),
          CommentInput(
            hintText: "Add a public reply",
            avatarRadius: 30,
            commentNode: _commentNode, 
            commentController: _commentController, 
            onPostComment: _postReply,
          ),
          Divider(
            height: 1,
          ),
        ],
      )
    ]);
    
    result.addAll(_buildReplyList());
    return result;

  }

  List<Widget> _buildReplyList() {
    List<Widget> result = List<Widget>();

    _commentReplies.forEach((reply) {
      result.addAll([
        ReplyTile(
          onTap: () {
            print("Comment is tapped");
          },
          onTapReply: () {
            print("Reply button press");
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReplyCommentPage(eventComment: reply,)));
          },
          image: NetworkImage("https://cdn0.iconfinder.com/data/icons/avatar-15/512/ninja-512.png"),
          userName: reply.authorId,
          messsage: reply.message,
          postTime: reply.date,
        ),
        Divider(
          height: 1,
        )
      ]);
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.white,
        child: !_gotData
        ? Center(child: CircularProgressIndicator(),)
        : RefreshIndicator(
            displacement: 50,
            onRefresh: _refresh,
            child: ListView(
              children: _buildListViewContent(),
            ),
          )
      ),
    );
  }
}

