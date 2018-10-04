import 'package:flutter/material.dart';
import 'dart:async';

import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/utilities/validator..dart';
import 'package:youroccasions/screens/login/signup.dart';

final EventController _eventController = EventController();
bool _isSigningUp = false;

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreen createState() => _CreateEventScreen();
  
}

class _CreateEventScreen extends State<CreateEventScreen> {
  final formKey = new GlobalKey<FormState>();
  static final nameController = new TextEditingController();
  static final descriptionController = new TextEditingController();
  static final startController = new TextEditingController();
  static final endController = new TextEditingController();

  void _submit() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      bool result = await create();
      print(result);
      if(result) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    }
  }
  
  Widget createButton() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.lightBlueAccent.shade100,
          elevation: 5.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () async {
              _submit();
            },
            // color: Colors.lightBlueAccent,
            child: Text('Create', style: TextStyle(color: Colors.black)),
          ),
        ));
  }

  Widget nameForm() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        width: 260.0,
        child: TextFormField(
          controller: nameController,
          keyboardType: TextInputType.emailAddress,
          validator: (name) => !isPassword(name) ? "Invalid name" : null,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Event Name',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ));
  }

  Widget descriptionForm() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        width: 260.0,
        child: TextFormField(
          controller: descriptionController,
          keyboardType: TextInputType.emailAddress,
          validator: (name) => !isPassword(name) ? "Invalid description" : null,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Event Description',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ));
  }

  Widget startForm() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        width: 260.0,
        // color: const Color(0xFF00FF00),
        child: TextFormField(
          controller: startController,
          keyboardType: TextInputType.emailAddress,
          validator: (password) => !isDate(password) ? "Invalid date" : null,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Start Time',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ));
  }

  Widget endForm() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 260.0,
      child: TextFormField(
          controller: endController,
          autofocus: false,
          keyboardType: TextInputType.text,
          validator: (password) => !isDate(password) ? "Invalid date" : null,
          // obscureText: true,
          decoration: InputDecoration(
            hintText: 'End Time',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          )),
    );
  }

  Future<bool> create() async {
    if (!_isSigningUp) {
      _isSigningUp = true;
      String name = nameController.text;
      String description = descriptionController.text;
      DateTime start = DateTime.parse(startController.text);
      DateTime end = DateTime.parse(endController.text);
      int hostId = await getUserId();
      String location = "Plattsburgh";
      Event newEvent = Event(hostId: hostId, name: name, description: description, startTime: start, endTime: end, locationName: location);
      print("DEBUG new event is : $newEvent");
       _eventController.insert(newEvent)
        ..then((value) {
          print("DEBUG name is : ${newEvent.name}");
          print("Your event is created successfully!");
        }, onError: (e) {
          print("Create failed");
          print(e);
        });
      _isSigningUp = false;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Create Event"),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              nameForm(),
              descriptionForm(),
              startForm(),
              endForm(),
              createButton(),
              MaterialButton(
              color: Colors.blue,
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpWithEmailScreen()));
              },
              child: Text("Logout"),
              )
            ]
          ),
        )
      )
    );
  }
  // Widget build(BuildContext context) {
  //   return new Scaffold(
  //     appBar: AppBar(
  //       title: Text("Create your event"),
  //     ),
  //     body: Center(
  //       child: Column(
  //         children: <Widget> [
  //           MaterialButton(
  //             color: Colors.blue,
  //             onPressed: () {
  //               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpWithEmailScreen()));
  //             },
  //             child: Text("Logout"),
  //           )
  //         ]
  //     )));
  // }
}