import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/models/user_interested_event.dart';
import 'package:youroccasions/controllers/user_interested_event_controller.dart';
import 'package:youroccasions/utilities/config.dart';

class SmallEventCard extends StatefulWidget {
  final Event event;
  final String imageURL;
  final String title;
  final DateTime time;
  final String place;

  SmallEventCard({this.event, this.imageURL, this.title, this.time, this.place});

  @override
  _SmallEventCardState createState() => _SmallEventCardState();

}

class _SmallEventCardState extends State<SmallEventCard> {
  bool _isInterested;
  String _time;
  UserInterestedEventController _controller;
  bool _gotData;
  bool _isInserting;

  @override
  void initState() {
    super.initState();
    _gotData = false;
    _controller = UserInterestedEventController();
    _isInterested = false;
    _time = _formatDate(widget.time.toLocal());
    _isInserting = false;
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getData() async {
    var userId = await getUserId();
    var result = await _controller.getUserInterestedEvent(eventId: widget.event.id, userId: userId);

    _gotData = true;

    if (this.mounted) {
      setState(() {
        _isInterested = !(result.isEmpty) ? true : false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    if (!_gotData) {
      return Material(
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
                    color: Colors.grey,
                  )
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Material(
      child: SizedBox(
        height: screen.height / 7,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(widget.imageURL,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.title, 
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5.0,),
                    Text(_time,
                      overflow: TextOverflow.clip,
                    ),
                    SizedBox(height: 5.0,),
                    Text(widget.place,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                // width: 50.0,
                child: IconButton(
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        _isInterested = !_isInterested;
                        if(_isInterested) _addInterestEvent();
                        else _deleteInterestEvent();
                      });
                    }
                  },
                  icon: Icon(_isInterested ? Icons.favorite : Icons.favorite_border)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _addInterestEvent() async {
    // Prevent inserting twice when pressing quickly by checking _isInserting
    if(!_isInserting) {
      _isInserting = true;
      var userId = await getUserId();
      UserInterestedEvent newModel = UserInterestedEvent(userId: userId, eventId: widget.event.id);
      await _controller.insert(newModel);
      _isInserting = false;
    }
  }

  void _deleteInterestEvent() async {
    var userId = await getUserId();
    var interestedEvent = await _controller.getUserInterestedEvent(userId: userId, eventId: widget.event.id);
    if(interestedEvent.isEmpty) return;
    await _controller.delete(interestedEvent[0].id);
  }

  String _formatDate(DateTime d) {
    List weekday = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    List month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    var minuteFormat = new NumberFormat("00");
    String formattedMinute = minuteFormat.format(d.minute);

    // All day event
    if (d.second == 0) return "${weekday[d.weekday - 1].toString()}, ${month[d.month - 1]} ${d.day}"; 
    else {
      String time = "";
      if (d.hour == 0) {
        time = "${d.hour + 12}:$formattedMinute AM";
      }
      else if (d.hour < 12) {
        time = "${d.hour}:$formattedMinute AM";
      }
      else if (d.hour == 12) {
        time = "${d.hour}:$formattedMinute PM";
      }
      else {
        time = "${d.hour - 12}:$formattedMinute PM";
      }
      return "${weekday[d.weekday]}, ${month[d.month - 1]} ${d.day}, $time";
    } 
  }


}
