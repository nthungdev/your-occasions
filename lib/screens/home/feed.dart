import 'package:flutter/material.dart';

import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/screens/home/event_card.dart';
import 'package:youroccasions/controllers/event_controller.dart';
// import 'package:youroccasions/controllers/category_controller.dart';
import 'package:youroccasions/controllers/event_category_controller.dart';

const String MUSIC_CATEGORYNAME = "Music";


class FeedTabView extends StatefulWidget {
  @override
  _FeedTabView createState() => _FeedTabView();
}

class _FeedTabView extends State<FeedTabView> {
  // TODO Fix duplicate card issue. If there is multiple cards of the same event,
  // and 1 of them is interested, the other ones' interest status are not updated.
  List<Event> _eventList;
  List<Event> _trendingEventList;

  @override
  void initState() {
    super.initState();
    getNearbyEventList();
    _eventList = List<Event>();
    _trendingEventList = List<Event>();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _eventList = null;
    _trendingEventList = null;
  }

  getNearbyEventList() async {
    EventController _eventController = EventController();
    var data = await _eventController.getEvent();
    if(!this.mounted){ return; }
    setState(() {
      _eventList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Container(
        // color: Colors.red,
        // padding: EdgeInsets.symmetric(horizontal: 10.0),
        // color: Colors.red,
        child: _eventList == null 
        ? const Center(child: const CircularProgressIndicator()) 
        : ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            addAutomaticKeepAlives: false, // Force to kill the Card
            children: _buildListViewChildren(),
          ),
      ),
    );
  }

  List<Widget> _buildUpcomingEventsCardList(int count) {
    List<Widget> cards = List<Widget>();
    int counter = 0;

    Widget e = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Text("Upcoming events", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit")),
    );

    cards.add(e);

    _eventList.sort((b,a) => a.startTime.compareTo(b.startTime));
    _eventList.forEach((Event currentEvent) {
      counter++;
      if(counter > count) return cards;
      if(currentEvent.startTime.compareTo(DateTime.now()) > 0) {
        cards.insert(1, Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SmallEventCard(
            event: currentEvent,
            imageURL: currentEvent.picture ?? "https://img.cutenesscdn.com/640/cme/cuteness_data/s3fs-public/diy_blog/Information-on-the-Corgi-Dog-Breed.jpg",
            place: currentEvent.locationName ?? "Unname location",
            time: currentEvent.startTime ?? DateTime.now(),
            title: currentEvent.name ?? "Untitled event" ,
          ),
        ));
      }
    });

    return cards;
  }

  void _getTrendingMusicData() async {
    // TODO don't get past event
    EventController _ec = EventController();
    EventCategoryController _ecc = EventCategoryController();
    List<Event> temp = List<Event>();

    // print("DEBUG is getting trending music");

    var eventCategoryList = await _ecc.getEventCategory(categoryName: MUSIC_CATEGORYNAME);
    // print(eventCategoryList);

    for(int i = 0 ; i < eventCategoryList.length ; i++ ) {
      var event = (await _ec.getEvent(id: eventCategoryList[i].id))[0];
      temp.add(event);
    }

    temp.sort((a,b) => a.views.compareTo(b.views));

    if(this.mounted) {
      setState(() {
        _trendingEventList = temp;
      });
    }
  }

  List<Widget> _buildTrendingMusicEventsCardList(int count) {
    List<Widget> cards = List<Widget>();

    int counter = 0;

    Widget e = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Text("Trending in Music", style: TextStyle(fontSize: 30.0, fontFamily: "Niramit")),
    );

    // print("DEBUG trending count : ${_trendingEventList.length}");

    if(_trendingEventList.length == 0) {
      // print("DEBUG inside the if statement");
      _getTrendingMusicData();
    }

    cards.add(e);

    if(_trendingEventList.length == 0) {
      cards.add(Center(child: CircularProgressIndicator()));
      return cards;
    }

    _trendingEventList.forEach((Event currentEvent) {
      counter++;
      if(counter > count) return cards;
      
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

  List<Widget> _buildListViewChildren() {
    // TO DO duplicate cards don't sync favorite status. 
    List<Widget> alist = List<Widget>();

    alist.addAll(_buildUpcomingEventsCardList(5));
    alist.addAll(_buildTrendingMusicEventsCardList(5));

    return alist;
  }




}
