import 'package:flutter/material.dart';

import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/screens/event/update_event.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/screens/user/user_profile.dart';
import 'package:youroccasions/models/user.dart';
import 'package:youroccasions/controllers/user_controller.dart';
import 'package:youroccasions/models/data.dart';

final EventController _eventController = EventController();
final UserController _userController = UserController();

class EventDetailScreen extends StatefulWidget {
  final Event event;

  EventDetailScreen(this.event);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
  
}

class _EventDetailScreenState extends State<EventDetailScreen>{
  Event event;
  User user;
  // String id;
  User currentUser = Dataset.currentUser.value;

  @override
  initState() {
    super.initState();
    event = widget.event;
    _userController.getUserWithId(event.hostId).then((value){
      user = value;
    });
    // getUserId().then((value){
    //   setState(() {
    //     id = value;
    //   });
    // });

    EventController ec = EventController();
    ec.increaseView(event.id);
  }

  void delete() async {
    _eventController.delete(event.id);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  Widget _buildHost() {

    new ListTile(
      onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => UserProfileScreen(user))),
      leading: new Hero(
        tag: 0,
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(user.picture),
        ),
      ),
      title: new Text(user.name),
      subtitle: new Text(user.email),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Event Detail"),
      ),
      body: Center(
        child: new Material(
          child: new Container(
            // color: Colors.red,
            // padding: EdgeInsets.symmetric(horizontal: 10.0),
            // color: Colors.red,
            child: user.id != event.hostId
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // new ListTile(
                  //   onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => UserProfileScreen(user))),
                  //   leading: new Hero(
                  //     tag: 0,
                  //     child: new CircleAvatar(
                  //       backgroundImage: new NetworkImage(user.picture),
                  //     ),
                  //   ),
                  //   title: new Text(user.name),
                  //   subtitle: new Text(user.email),
                  // ),
                  _buildHost(),
                  SizedBox(
                    width: size.width,
                    height: size.width * 3 / 4,
                    child: widget.event.picture != null
                    ? Image.network(widget.event.picture, fit: BoxFit.cover,)
                    : Image.asset("assets/images/no-image.jpg", fit: BoxFit.cover,) 
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: ListView(
                        children: <Widget>[
                          new Text('Name: ${event.name}'),
                          new Text('Description: ${event.description}'),
                          new Text('Category: ${event.category}'),
                        ],
                      ),
                    ),
                  ),
                ]
              ) 
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // new ListTile(
                  //   onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => UserProfileScreen(user))),
                  //   leading: new Hero(
                  //     tag: 0,
                  //     child: new CircleAvatar(
                  //       backgroundImage: new NetworkImage(user.picture),
                  //     ),
                  //   ),
                  //   title: new Text(user.name),
                  //   subtitle: new Text(user.email),
                  // ),
                  _buildHost(),
                  SizedBox(
                    width: size.width,
                    height: size.width * 3 / 4,
                    child: widget.event.picture != null
                    ? Image.network(widget.event.picture, fit: BoxFit.cover,)
                    : Image.asset("assets/images/no-image.jpg", fit: BoxFit.cover,) 
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Text('Name: ${event.name}'),
                        Text('Description: ${event.description}'),
                        Text('Category: ${event.category}'),
                        IconButton(
                          icon: Icon(Icons.edit), 
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateEventScreen(event)));
                          }),
                        IconButton(
                          icon: Icon(Icons.delete), 
                          onPressed: () { delete(); }
                        )
                      ],
                    ),
                  )
                ]
              )
          )
        ),
      )
    );
  }

  // List<Widget> _
  // Widget build(BuildContext context){
  //   return new Scaffold(
  //     appBar: AppBar(
  //       title: Text("Event Detail"),
  //     ),
  //     body: Center(
  //       child: Form(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             new Text('Name: ${event.name}'),
  //             new Text('Description: ${event.description}'),
  //             new Text('Category: ${event.category}'),
  //             new IconButton(icon: new Icon(Icons.edit), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdateEventScreen(event)));})
  //           ]
  //         )
  //       )
  //     )
  //   );
  // }
}