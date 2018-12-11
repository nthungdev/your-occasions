import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youroccasions/controllers/user_interested_event_controller.dart';

import 'package:youroccasions/models/category.dart';

import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/models/user_interested_event.dart';
import 'package:youroccasions/screens/home/event_card.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/controllers/event_category_controller.dart';
import 'package:youroccasions/models/data.dart';

class MyInterestedEventsPage extends StatefulWidget {
  @override
  MyInterestedEventsPageState createState() => MyInterestedEventsPageState();
}

class MyInterestedEventsPageState extends State<MyInterestedEventsPage> {
  // TODO Fix duplicate card issue. If there is multiple cards of the same event,
  // and 1 of them is interested, the other ones' interest status are not updated.
  List<Event> _myEvents;
  bool _gotData = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refresh() async {
    // setState(() {
    //   FeedDataset.clearData();      
    // });
    await _getMyEventData();
  }

  Future _getMyEventData() async {
    UserInterestedEventController ueic = UserInterestedEventController();
    var data = await ueic.getUserInterestedEvents(Dataset.currentUser.value.id);
    print(data.length);

    if(this.mounted) {
      setState(() {
        _myEvents = data;
        _gotData = true;
      });
    }

    
  }

  List<Widget> _buildMyEventList() {
    List<Widget> cards = List<Widget>();

    _myEvents.sort((b,a) => a.startTime.compareTo(b.startTime));
    _myEvents.forEach((Event event) {
      cards.insert(0, Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SmallEventCard(
          event: event,
          imageURL: event.picture,
          place: event.locationName ?? "Unname location",
          time: event.startTime ?? DateTime.now(),
          title: event.name ?? "Untitled event" ,
        ),
      ));
    });

    return cards;
  }

  void onDragDown(DragDownDetails details) {
    print(details.globalPosition);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          // Colors.blue,
          Colors.deepPurpleAccent,
          Colors.indigoAccent,
          Colors.blueAccent,
          Colors.lightBlue
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("My Interested Events"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: linearGradient,
          child: !_gotData 
          ? const Center(child: const CircularProgressIndicator()) 
          : _myEvents.length == 0
            ? Center(child: Text("You haven't host any event yet"),)
            : RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  addAutomaticKeepAlives: false, // Force to kill the Card
                  children: _buildMyEventList(),
                ),
            )
        ),
      ),
    );
  }


}
