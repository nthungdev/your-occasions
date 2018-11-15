import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/screens/home/event_card.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController;
  GlobalKey<FormState> _formKey;
  FocusNode _keywordFocusNode;
  List<Event> _events;
  List<User> _users;
  List<SmallEventCard> _eventCards;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _searchController = TextEditingController();
    _keywordFocusNode = FocusNode();
    _searchController.addListener(onChange);
    _eventCards = null;
  }

  /// Detect key input event to force rebuild state.
  /// This helps enabling or disabling the clear keyword button
  void onChange(){
    print(_searchController.text);
    setState(() { });
  }

  /// This function fires when the clear keyword button is tapped.
  /// Set the search field to empty, dismiss the keyboard on screen.
  void onClearKeywordField() {
    _searchController.text = "";
    _keywordFocusNode.unfocus();
    onSearch(); // Clear the search results
  }

  /// This function fires when search button is tapped or when user tap on return key on keyboard
  void onSearch() async {
    print('OnSearch ran');
    EventController ec = EventController();
    UserController uc = UserController();
    

    if(_searchController.text.isEmpty) {
      _eventCards = null;
      _events = null;
    }
    else {
      /// Hide the on screen keyboard
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      var eventList = await ec.getEvent(name: _searchController.text);
      print("DEBUG: event list: ");
      print(eventList);

      _events = eventList;
    }
    _buildSearchResult();

  }

  Widget _buildSearchBar() {
    List<Widget> result = List<Widget>();

    Widget searchField = TextFormField(
      keyboardType: TextInputType.text,
      controller: _searchController,
      onEditingComplete: onSearch,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search for...'
      ),
    );

    if (_searchController.text.isEmpty) {
      result.add(
        Expanded(
          child: searchField,
        ),
      );
    }
    else {
      result.addAll([
        Expanded(
          child: searchField,
        ),
        IconButton(
          disabledColor: Colors.transparent,
          color: Colors.black,
          icon: Icon(Icons.cancel),
          onPressed: _searchController.text.isEmpty ? null : onClearKeywordField,
        )
      ]);
    }
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: result,
      ),
    );
  }

  void _buildSearchResult() {
    List<SmallEventCard> cards = List<SmallEventCard>();

    if(_events == null) return;

    _events.sort((b,a) => a.startTime.compareTo(b.startTime));
    _events.forEach((Event currentEvent) {
      cards.insert(0, SmallEventCard(
        event: currentEvent,
        imageURL: currentEvent.picture,
        place: currentEvent.locationName ?? "Unname location",
        time: currentEvent.startTime ?? DateTime.now(),
        title: currentEvent.name ?? "Untitled event",
      ));
    });
      
    print(cards);

    setState(() {
      _eventCards = cards;
      print(_eventCards);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_list)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onSearch,
        child: Icon(Icons.search),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: _buildSearchBar()
            ),
            Divider(),
            Expanded(
              // child: ListView(
              //   padding: EdgeInsets.symmetric(horizontal: 10.0),
              //   children: <Widget>[
                  
              //   ],
              // ),
              child: _eventCards == null
              ? Container()
              : _eventCards.length == 0
                ? Center(
                    child: Text("Result not found")
                  )
                : ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _eventCards[index],
                      );
                    },
                  )
            ),
          ],
        ),
      ),
    );
  }




}
