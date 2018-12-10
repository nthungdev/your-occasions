import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youroccasions/models/data.dart';
import 'dart:async';

import 'package:youroccasions/screens/event/event_detail.dart';
import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/models/user_interested_event.dart';
import 'package:youroccasions/controllers/user_interested_event_controller.dart';
import 'package:youroccasions/utilities/config.dart';

const Color _favoriteColor = Colors.red;

class SmallEventCard extends StatefulWidget {
  final Event event;
  final String imageURL;
  final String title;
  final DateTime time;
  final String place;
  final Color color;

  SmallEventCard({this.event, this.imageURL, this.title, this.time, this.place, this.color});

  @override
  _SmallEventCardState createState() => _SmallEventCardState();

}

class _SmallEventCardState extends State<SmallEventCard> {
  UserInterestedEventController _interestedEventController;
  bool _isInterested;
  String _time;
  bool _gotData;
  Timer _queryTimer;

  @override
  void initState() {
    super.initState();
    _gotData = false;
    _interestedEventController = UserInterestedEventController();
    _isInterested = false;
    _time = _formatDate(widget.time.toLocal());
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _interestedEventController = null;
  }

  void _getData() async {
    try {
      var result = await _interestedEventController.getUserInterestedEvent(eventId: widget.event.id, userId: Dataset.currentUser.value.id);
      _gotData = true;

      if (this.mounted) {
        setState(() {
          _isInterested = (result.isNotEmpty) ? true : false;
        });
      }
    } 
    catch (e) {
      print("An exception occurs");
      print(e.toString());
    }
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

    return Material(
      color: Colors.transparent,
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
                  color: Colors.grey[200],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    final screen = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: screen.height / 7,
        child: Card(
          color: Colors.transparent,
          margin: EdgeInsets.all(0.0),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Material(
            // color: Colors.transparent,
            child: InkWell(
              onTap: _onTap,
              splashColor: Colors.red,
              child: Row(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: widget.imageURL != null
                      ? Image.network(widget.imageURL,
                          fit: BoxFit.cover,
                        )
                      : Image.asset("assets/images/no-image.jpg",
                          fit: BoxFit.cover,
                        )
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

                            if(_queryTimer == null) {
                              _queryTimer = Timer(Duration(seconds: 1), _handleTimer);
                            }
                          });
                        }
                      },
                      icon: _isInterested 
                      ? Icon(Icons.favorite,
                          color: _favoriteColor,
                        )
                      : Icon(Icons.favorite_border,
                          color: Colors.black,
                        ),
                    ),
                  ),
                ],
                ),
              ),
            ),
          ),
      ),
    );
  }

  // Push EventDetailScreen to view.
  void _onTap() {
    // _increaseView();
    Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailScreen(widget.event)));
  }

  // Increase the number of view of the this event by 1.
  // void _increaseView() async {
  //   try {
  //     _eventController.increaseView(widget.event.id);
  //   }
  //   catch (e) {
  //     print("An error occurs");
  //     print(e);
  //   }
  // }

  void _handleTimer() {
    if(_isInterested) {
      _addInterestEvent();
    }
    else{
      _deleteInterestEvent();
    }
    _queryTimer = null;
  }
  
  void _addInterestEvent() async {
    var userId = await getUserId();
    UserInterestedEvent newModel = UserInterestedEvent(userId: userId, eventId: widget.event.id);
    var result = await _interestedEventController.getUserInterestedEvent(eventId: widget.event.id, userId: userId);
    if (result.isEmpty) _interestedEventController.insert(newModel);
  }

  void _deleteInterestEvent() async {
    var userId = await getUserId();
    var interestedEvent = await _interestedEventController.getUserInterestedEvent(userId: userId, eventId: widget.event.id);
    if(!(interestedEvent.isEmpty)) _interestedEventController.delete(interestedEvent[0].id);
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
