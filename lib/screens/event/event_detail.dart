import 'package:flutter/material.dart';
import 'dart:async';

import 'package:youroccasions/models/event.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  EventDetailScreen(Event event) :  this.event = event;

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
  
}

class _EventDetailScreenState extends State<EventDetailScreen>{

  Event event;

  @override
  initState() {
    super.initState();
    event = widget.event;
  }
  

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        title: Text("Event Detail"),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('Name: ${event.name}'),
              new Text('Description: ${event.description}'),
              new Text('Category: ${event.category}'),
            ]
          )
        )
      )
    );
  }
}