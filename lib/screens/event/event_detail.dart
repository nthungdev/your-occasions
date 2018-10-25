import 'package:flutter/material.dart';
import 'dart:async';

import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/screens/event/update_event.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/controllers/event_controller.dart';

final EventController _eventController = EventController();

class EventDetailScreen extends StatefulWidget {
  final Event event;

  EventDetailScreen(Event event) :  this.event = event;

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
  
}

class _EventDetailScreenState extends State<EventDetailScreen>{

  Event event;
  int id;


  @override
  initState() {
    super.initState();
    event = widget.event;
    getUserId().then((value){
      id = value;
    });
  }

  void delete() async{
    _eventController.delete(event.id);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Detail"),
      ),
      body: new Material(
      child: new Container(
        // color: Colors.red,
        // padding: EdgeInsets.symmetric(horizontal: 10.0),
        // color: Colors.red,
        child: id == event.hostId 
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('Name: ${event.name}'),
              new Text('Description: ${event.description}'),
              new Text('Category: ${event.category}'),
            ]
          ) 
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('Name: ${event.name}'),
              new Text('Description: ${event.description}'),
              new Text('Category: ${event.category}'),
              new IconButton(icon: new Icon(Icons.edit), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdateEventScreen(event)));}),
              new IconButton(icon: new Icon(Icons.delete), onPressed: () {delete();})
            ]
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