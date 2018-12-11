import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youroccasions/controllers/event_category_controller.dart';
import 'package:youroccasions/controllers/user_attended_event_controller.dart';
import 'package:youroccasions/controllers/user_interested_event_controller.dart';
import 'package:youroccasions/models/event_comment.dart';
import 'package:youroccasions/models/user_attended_event.dart';
import 'package:youroccasions/models/user_interested_event.dart';
import 'package:youroccasions/screens/event/comment_input.dart';
import 'package:youroccasions/screens/event/comment_tile.dart';
import 'package:youroccasions/screens/event/reply_comment_page.dart';
import 'package:youroccasions/screens/event/share_event.dart';

import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/screens/event/update_event.dart';
import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/screens/user/user_profile.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/models/data.dart';
import 'package:youroccasions/utilities/places.dart';

final EventController _eventController = EventController();
final UserController _userController = UserController();

List<String> _months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];

class EventDetailScreen extends StatefulWidget {
  final Event event;

  EventDetailScreen(this.event);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
  
}

class _EventDetailScreenState extends State<EventDetailScreen>{
  final GlobalKey<FormFieldState> commentKey = GlobalKey<FormFieldState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Event _event;
  User _host;
  // User _currentUser = Dataset.currentUser.value;
  TextEditingController _commentController;
  FocusNode _commentNode;
  DocumentReference _eventReference;
  bool _gotData;
  List<String> _categories;
  UserInterestedEventController _interestedEventController = UserInterestedEventController();
  UserAttendedController _attendedController = UserAttendedController();
  EventComment eventComment;
  List<EventComment> eventComments;
  int descriptionMaxLine;
  Timer _queryTimer;

  GoogleMapController mapController;
  PlaceData _placeData;

  bool _isInterested;
  bool _isGoing;

  @override
  initState() {
    super.initState();
    _categories = List<String>();
    _event = widget.event;
    _eventReference = Firestore.instance.collection('EventThreads').document(_event.id.toString());
    descriptionMaxLine = 10;
    eventComments = List<EventComment>();
    _gotData = false;
    _commentController = TextEditingController();
    _commentNode = FocusNode();
    _refresh();

    print("Event Id: ${_event.id}");
  }

  @override
  void dispose() {
    super.dispose();
    _commentNode.dispose();
    _commentController.dispose();
  }

  String _formatDate(DateTime d) {
    List weekday = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    List month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    var minuteFormat = new NumberFormat("00");
    String formattedMinute = minuteFormat.format(d.minute);

    // All day event
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
    return "${weekday[d.weekday - 1]}, ${month[d.month - 1]} ${d.day}, $time";
  }

  /// option == true: interested event
  /// option == false: going event
  void _handleTimer(bool option) {
    if (option) {
      if(_isInterested) {
        _addInterestEvent();
      }
      else{
        _deleteInterestEvent();
      }
    }
    else {
      if(_isGoing) {
        _addAttendEvent();
      }
      else{
        _deleteAttendEvent();
      }
    }
    _queryTimer = null;
  }

  void _addInterestEvent() async {
    UserInterestedEvent newModel = UserInterestedEvent(userId: Dataset.currentUser.value.id, eventId: widget.event.id);
    var result = await _interestedEventController.getUserInterestedEvent(eventId: widget.event.id, userId: Dataset.currentUser.value.id);
    if (result.isEmpty) _interestedEventController.insert(newModel);
  }

  void _deleteInterestEvent() async {
    var interestedEvent = await _interestedEventController.getUserInterestedEvent(userId: Dataset.currentUser.value.id, eventId: widget.event.id);
    if(!(interestedEvent.isEmpty)) _interestedEventController.delete(interestedEvent[0].id);
  }
  

  void _addAttendEvent() async {
    UserAttendedEvent newModel = UserAttendedEvent(userId: Dataset.currentUser.value.id, eventId: widget.event.id);
    var result = await _attendedController.getUserAttendedEvent(eventId: widget.event.id, userId: Dataset.currentUser.value.id);
    if (result.isEmpty) _attendedController.insert(newModel);
  }

  void _deleteAttendEvent() async {
    var attendEvent = await _attendedController.getUserAttendedEvent(userId: Dataset.currentUser.value.id, eventId: widget.event.id);
    if(!(attendEvent.isEmpty)) _attendedController.delete(attendEvent[0].id);
  }

  void _onMapCreated(GoogleMapController controller) async {
    setState(() { mapController = controller; });

    mapController.clearMarkers();
    mapController.addMarker(MarkerOptions(
      position: LatLng(_placeData.latitude, _placeData.longitude)
    ));
  }

  _launchURL() async {
    print("place Id: ${_placeData.placeId}");
    String url = "https://www.google.com/maps/search/?api=1&query=${_placeData.latitude},${_placeData.longitude}&query_place_id=${_placeData.placeId}";
    // String url = "https://www.google.com/maps/search/?api=1&query_place_id=${_placeData.placeId}";
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _refresh() async {
    EventController ec = EventController();
    await ec.increaseView(_event.id);

    await _userController.getUserWithId(_event.hostId).then((value){
      if(this.mounted) {
        setState(() { 
          _host = value;
        });
      }
    });

    await _getComments();
    await _getEventCategories();

    
    PlaceSearch ps = PlaceSearch.instance;
    _placeData = await ps.search(_event.address);

    UserInterestedEventController uiec = UserInterestedEventController();
    var temp = await uiec.getUserInterestedEvent(userId: Dataset.currentUser.value.id, eventId: _event.id);
    if (temp.isEmpty) {
      _isInterested = false;
    }
    else {
      _isInterested = true;
    }

    UserAttendedController uaec = UserAttendedController();
    var temp2 = await uaec.getUserAttendedEvent(userId: Dataset.currentUser.value.id, eventId: _event.id);
    if (temp2.isEmpty) {
      _isGoing = false;
    }
    else {
      _isGoing = true;
    }


    if(this.mounted) {
      setState(() { 
        _gotData = true;
      });
    }
    
  }

  Future<void> _getEventCategories() async {
    EventCategoryController ecc = EventCategoryController();
    var temp = await ecc.getEventCategory(eventId: _event.id);
    _categories = List<String>.generate(temp.length, (index) {
      return temp[index].category;
    });
    _event.categories = _categories;
    // print("Categories : $_categories");
  }

  Future<void> _getComments() async {
    DocumentSnapshot snapshot = await _eventReference.get();
    if (snapshot.exists) {
      List<DocumentSnapshot> documents;
      await snapshot.reference.collection('Comments').getDocuments().then((value) {
        documents = value.documents;
      });
      eventComments.clear();
      for (var document in documents) {
        var comment = EventComment.fromSnapshot(document);
        // print("Id: ${comment.id}");
        await comment.getReplies(document);
        print(comment.replies);
        eventComments.add(comment);
      }
    }
    else {
      eventComments = [];
    }
  }

  Future<void> _postComment() async {
    /// Make object for comment
    var comment = EventComment(
      authorId: Dataset.currentUser.value.id,
      date: DateTime.now(),
      authorName: Dataset.currentUser.value.name,
      eventId: widget.event.id,
      authorPicture: Dataset.currentUser.value.picture,
      message: _commentController.text.trim(),
    );

    // _eventReference.
    // print("eventRef: ${_eventReference.documentID}");
    _eventReference.collection("Comments").add(comment.toJson());
    _commentController.clear();
    _commentNode.unfocus();

    _eventReference.setData({}); // Without this. New document on FireStore won't save
    _refresh();
  }

  void delete() async {
    await _eventController.delete(_event.id);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  Widget _buildCoverImage() {
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.width * 3 / 4,
      child: widget.event.picture != null
      ? Image.network(widget.event.picture, fit: BoxFit.cover,)
      : Image.asset("assets/images/no-image.jpg", fit: BoxFit.cover,)
    );
  }
  
  Widget _buildCommentHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget>[
          Text("Comments ",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(eventComments.length.toString(),
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCommentList() {
    List<Widget> result = List<Widget>();

    eventComments.sort((b,a) => a.date.compareTo(b.date));
    eventComments.forEach((comment) {
      result.addAll([
        CommentTile(
          onTap: () {
            print("Comment is tapped");
          },
          onTapReply: () {
            print("Reply button press");
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReplyCommentPage(eventComment: comment,)));
            // print("back to event details");
          },
          image: comment.authorPicture == null ? AssetImage("assets/images/no-avatar2.jpg") : NetworkImage(comment.authorPicture),
          userName: comment.authorName,
          messsage: comment.message,
          postTime: comment.date,
          repliesCount: comment.replies?.length ?? 0,
        ),
        Divider(
          height: 1,
        )
      ]);
    });

    return result;
  }

  Widget _buildTitle() {
    var screen = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: screen.width * 0.17,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Text(_months[_event.startTime.month - 1],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.redAccent,
                    ),
                  ),
                  Text(_event.startTime.day.toString(),
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: screen.width * 0.80,
            child: Text(widget.event.name,
              maxLines: 2,
              style: TextStyle(
                fontSize: 24
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    var screen = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: () {
              if (this.mounted) {
                setState(() {
                  _isInterested = !_isInterested;

                  if(_queryTimer == null) {
                    _queryTimer = Timer(Duration(seconds: 1), () { _handleTimer(true); });
                  }
                });
              }
            },
            child: SizedBox(
              width: (screen.width - 40) / 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Icon(_isInterested ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    Text("Interested"),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (_event.startTime.compareTo(DateTime.now()) < 0) {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(content: Text("The event has past"),)
                );
              }
              else if (this.mounted) {
                setState(() {
                  _isGoing = !_isGoing;

                  if(_queryTimer == null) {
                    _queryTimer = Timer(Duration(seconds: 1), () { _handleTimer(false); });
                  }
                });
              }
            },
            child: SizedBox(
              width: (screen.width - 40) / 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Icon(_isGoing ? Icons.check_circle : Icons.check_circle_outline,
                      color: Colors.blueAccent,
                    ),
                    Text("Going"),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShareEventScreen(_event, _placeData)));
            },
            child: Container(
              width: (screen.width - 40) / 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.share,
                      color: Colors.green,
                    ),
                    Text("Share"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text("Host",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        ListTile(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UserProfileScreen(_host))),
          leading: CircleAvatar(
            backgroundImage: _host.picture != null
            ? NetworkImage(_host.picture)
            : AssetImage("assets/images/no-avatar2.jpg")
          ),
          title: Text(_host.name),
          subtitle: Text(_host.email),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(_formatDate(_event.startTime),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(_event.description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          _buildCategory(),
        ],
      ),
    );
  }

  Widget _buildCategory() {
    List<Widget> chips = List<Widget>();
    _categories.forEach((item) {
      chips.add(
        Chip(
          label: Text(item),
        )
      );
    });

    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: chips,
    );
  }

  Widget _buildLocationInfo() {
    var screen = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 20),
            child: Text("Location",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _launchURL();
            },
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: screen.width - 20,
                  child: Text(_event.locationName,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ),
                SizedBox(
                  width: screen.width - 20,
                  child: Text(_event.address,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600]
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildListViewContent() {
    List<Widget> result = List<Widget>();

    result.addAll([
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCoverImage(),
          _buildTitle(),
          Divider(height: 1,),
          _buildButtons(),
          Divider(height: 1,),
          _buildHost(),
          Divider(height: 1,),
          _buildDescription(),
          Container(
            height: 10,
            color: Colors.grey[200],
          ),
          _buildLocationInfo(),
          Divider(height: 1),
          _buildGoogleMap(),
          Container(
            height: 10,
            color: Colors.grey[200],
          ),
          _buildCommentHeader(),
          CommentInput(commentNode: _commentNode, commentController: _commentController, onPostComment: _postComment,),
        ],
      )
    ]);

    if (_gotData && eventComments.length != 0) {
      result
        ..add(Divider(height: 1,))
        ..addAll(_buildCommentList());
    }

    return result;
  }

  Widget _buildGoogleMap() {
    return SizedBox(
      height: 150,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        options: GoogleMapOptions(
          rotateGesturesEnabled: false,
          // scrollGesturesEnabled: false,
          cameraPosition: CameraPosition(
            target: LatLng(_placeData.latitude, _placeData.longitude),
            zoom: 17
          )
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    List<Widget> row = List<Widget>();

    row.addAll([
      SizedBox(
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back,),
        ),
      ),
      Expanded(
        child: SizedBox(),
      ),
    ]);

    if (_gotData && Dataset.currentUser.value.id == _event.hostId) {
      row.addAll([
        IconButton(
          icon: Icon(Icons.edit), 
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateEventScreen(_event)));
          }
        ),
        IconButton(
          icon: Icon(Icons.delete), 
          onPressed: delete,
        ),
      ]);
    }

    return SizedBox(
      child: Container(
        color: Color.fromARGB(200, 255, 255, 255),
        // color: Color(0x0F000000),
        child: Row(
          children: row,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          child: !_gotData
          ? Center(child: CircularProgressIndicator(),)
          : Stack(
            children: <Widget>[
              RefreshIndicator(
                displacement: 50,
                onRefresh: _refresh,
                child: ListView(
                  children: _buildListViewContent(),
                ),
              ),
              _buildAppBar(),
            ],
          )
        ),
      )
    );
  }
}

