import 'package:flutter/material.dart';


class ReplyTile extends StatelessWidget {
  final ImageProvider image;
  final String userName;
  final DateTime postTime;
  final String messsage;
  final VoidCallback onTap;
  final VoidCallback onTapReply;

  ReplyTile({Key key, this.image, this.userName, this.postTime, this.messsage, this.onTap, this.onTapReply}) 
    : super(key: key);

  String _getTimeAway() {
    Duration period = DateTime.now().difference(postTime);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(width: 10,),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CircleAvatar(
                            backgroundImage: image,
                          ),
                        ),
                      ],
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
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  splashColor: Colors.red,
                  onPressed: onTapReply,
                  icon: Icon(Icons.message, color: Colors.black54,),
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
