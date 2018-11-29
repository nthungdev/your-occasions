import 'package:flutter/material.dart';

import 'package:youroccasions/models/data.dart';


class CommentInput extends StatefulWidget {
  const CommentInput({
    Key key,
    @required this.commentNode,
    @required this.commentController,
    @required this.onPostComment,
    this.avatarRadius = 40,
    this.hintText = "Add a public comment",
  }) : assert(avatarRadius <= 40), 
       super(key: key);

  final FocusNode commentNode;
  final TextEditingController commentController;
  final VoidCallback onPostComment;
  final double avatarRadius;
  final String hintText;

  @override
  CommentInputState createState() => CommentInputState();
}

class CommentInputState extends State<CommentInput>{
  TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = widget.commentController;
    commentController.addListener(_onCommentInputChange);
  }

  @override
  void dispose() {
    super.dispose();
      // widget.commentNode?.dispose();
      // widget.commentController?.dispose();
      // commentController.dispose(); <-- this cause exception
  }

  /// Detect key input event to force rebuild state.
  /// This helps enabling or disabling the clear keyword button
  void _onCommentInputChange(){
    // print(commentController.text);
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                SizedBox(width: 40 - widget.avatarRadius,),
                SizedBox(
                  height: widget.avatarRadius,
                  width: widget.avatarRadius,
                  child: CircleAvatar(
                    backgroundImage: Dataset.currentUser.value.picture != null 
                    ? NetworkImage(Dataset.currentUser.value.picture)
                    : AssetImage("assets/images/no-image.jpg")
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextFormField(
              focusNode: widget.commentNode,
              controller: commentController,
              autofocus: false,
              validator: (message) => null,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                hintText: widget.hintText,
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
                widget.onPostComment();
              },
              icon: Icon(Icons.send),
            ),
          )
        ],
      ),
    );
  }
}