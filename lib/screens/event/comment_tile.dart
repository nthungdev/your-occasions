import 'package:flutter/material.dart';


class CommentTile extends StatelessWidget {
  final ImageProvider image;
  final String userName;
  final DateTime postTime;
  final String messsage;
  final VoidCallback onTap;
  final VoidCallback onTapReply;
  final bool showCommentIcon;
  final int repliesCount;

  CommentTile({Key key, 
      this.image, 
      this.userName, 
      this.postTime, 
      this.messsage, 
      this.onTap, 
      this.onTapReply,
      this.showCommentIcon,
      @required this.repliesCount}) 
    : super(key: key);

  String _getTimeAway() {
    Duration period = DateTime.now().difference(postTime);
    String result = "";
    if (period.isNegative) {
      return "from the future";
    }
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

  @override
  Widget build(BuildContext context) {
    String timeAway = DateTime.now().difference(postTime).inHours.toString() + " hours ago";

    return GestureDetector(
      onTap: onTap,
      child: Material(
        // color: Colors.green,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          // color: Colors.green,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                        backgroundImage: image,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          child: Text("$userName • ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Text(_getTimeAway(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: Text(messsage),
                    ),  
                  ],
                ),
              ),
              InkWell(
                customBorder: CircleBorder(),
                splashColor: Colors.redAccent,
                onTap: onTapReply,
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.message, color: Colors.black54,),
                      
                    ),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red[300]
                        ),
                        child: Text(repliesCount.toString()),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 10,),
            ],
          ),
        ),
      ),
    );
  }

}
