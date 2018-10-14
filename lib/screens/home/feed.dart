import 'package:flutter/material.dart';

import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/screens/home/event_card.dart';
import 'package:youroccasions/controllers/event_controller.dart';

class FeedTabView extends StatefulWidget {
  @override
  _FeedTabView createState() => _FeedTabView();
}

class _FeedTabView extends State<FeedTabView> {
  List<Event> _nearbyEventList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNearbyEventList();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  getNearbyEventList() async {
    EventController _eventController = EventController();
    var data = await _eventController.getEvent();
    setState(() {
      _nearbyEventList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Container(
        // color: Colors.red,
        child: _nearbyEventList == null 
        ? const Center(child: const CircularProgressIndicator()) 
        : ListView(
          addAutomaticKeepAlives: false, // Force to kill the Card
          children: _buildListView(),
        ),
      ),
    );
  }

  List<Widget> _buildNearbyEventsCardList(int count) {
    List<Widget> cards = List<Widget>();

    _nearbyEventList.forEach((Event currentEvent) {
      // print("DEBUG ${currentEvent.name} picture is ${currentEvent.picture}");
      // print("DEBUG ${currentEvent.name} description is ${currentEvent.description}");
      // print("DEBUG ${currentEvent.name} category is ${currentEvent.category}");
      // print("DEBUG ${currentEvent.name} location is ${currentEvent.locationName}");
      cards.add(Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SmallEventCard(
          event: currentEvent,
          imageURL: currentEvent.picture ?? "https://img.cutenesscdn.com/640/cme/cuteness_data/s3fs-public/diy_blog/Information-on-the-Corgi-Dog-Breed.jpg",
          place: currentEvent.locationName ?? "Unname location",
          time: currentEvent.startTime ?? DateTime.now(),
          title: currentEvent.name ?? "Untitled event" ,
        ),
      ));
    });

    return cards;
  }

  List<Widget> _buildListView() {
    List<Widget> alist = List<Widget>();
    Widget e = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text("Nearby events", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit")),
    );
    alist.add(e);
    alist.addAll(_buildNearbyEventsCardList(5));

    return alist;
  }




}
