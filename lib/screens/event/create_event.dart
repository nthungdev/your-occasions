import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:youroccasions/screens/home/home.dart';
import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/utilities/validator..dart';
import 'package:youroccasions/utilities/cloudinary.dart';
import 'package:youroccasions/screens/event/event_detail.dart';

final EventController _eventController = EventController();

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreen createState() => _CreateEventScreen();
  
}

class _CreateEventScreen extends State<CreateEventScreen> {
  GlobalKey<FormState> formKey;
  TextEditingController nameController;
  TextEditingController descriptionController;
  TextEditingController categoryController;
  DateTime startDate;
  TimeOfDay startTime;
  DateTime endDate;
  TimeOfDay endTime;
  String start;
  String end;
  File _image;
  bool _isSigningUp;

  @override
  initState() {
    super.initState();
    startDate = DateTime.now();
    startTime = TimeOfDay.now();
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    categoryController = TextEditingController();
    _isSigningUp = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
  }
  
  void getImage(ImageSource source) {
    // print(_imageChanged);
    ImagePicker.pickImage(source: source).then((image) {
      setState(() {
        // _imageChanged = true;
        _image = image;
      });
    });
  }

  Widget selectImageButton() {
    var screen = MediaQuery.of(context).size;

    if (_image == null) {
      return ButtonBar(
        children: <Widget>[
          MaterialButton(
            onPressed: () => getImage(ImageSource.camera),
            child: Text("Get image from camera"),
          ),
          MaterialButton(
            onPressed: () => getImage(ImageSource.gallery),
            child: Text("Get image from gallery"),
          ),
        ] 
      );
    }
    else {
      return SizedBox(
        height: screen.height / 3,
        width: screen.width,
        child: Image.file(_image, fit: BoxFit.fitWidth,)
      );
    }
  }
  

  Future<Null> selectStartDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: new DateTime(2020)
    );
    
    if(picked != null){
      setState(() {
        startDate = picked;
        start = picked.month.toString() +'/'+ picked.day.toString() +'/'+ picked.year.toString();
      });
    }
  }

  Future<Null> selectStartTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: startTime
    );
    
    if(picked != null){
      setState(() {
        startTime = picked;
      });
    }
  }
  
  Future<Null> selectEndDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: new DateTime(2020)
    );
    
    if(picked != null && picked != DateTime.now()){
      setState(() {
        endDate = picked;
        end = picked.month.toString() +'/'+ picked.day.toString() +'/'+ picked.year.toString();
      });
    }
  }

  Future<Null> selectEndTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay.now()
    );
    
    if(picked != null){
      setState(() {
        endTime = picked;
      });
    }
  }

  void _submit() async {
    final form = formKey.currentState;

    if (_image == null) {
      print("please select image");
    }
    if (form.validate()) {
      form.save();
      bool result = await create();
      print(result);
      // if(result) {
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EventDetailScreen()));
      // }
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
          // validator: (name) => !isName(name) ? "Invalid name" : null,
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
        // validator: (name) => !isPassword(name) ? "Invalid description" : null,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Event Description',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ));
  }

  Widget categoryForm() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 260.0,
      // color: const Color(0xFF00FF00),
      child: TextFormField(
        controller: categoryController,
        keyboardType: TextInputType.emailAddress,
        // validator: (password) => !isName(password) ? "Invalid!" : null,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Category',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ));
  }

  Future<bool> create() async {
    print("DEBUG: creating event");
    if (!_isSigningUp) {
      _isSigningUp = true;

      final start = new DateTime(startDate.year, startDate.month, startDate.day, startTime.hour, startTime.minute);
      if (endDate != null){
        endDate = new DateTime(endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute);
      }
      String name = nameController.text;
      String description = descriptionController.text;
      String category = categoryController.text;
      int hostId = await getUserId();
      // String location = "Plattsburgh";
      if(_image == null) {
        _isSigningUp = false;
        print("Please select an event image");
      }
      Event newEvent = Event(hostId: hostId, name: name, description: description, category: category, startTime: start, endTime: endDate) ;
      print("DEBUG new event is : $newEvent");
      await _eventController.insert(newEvent);
      print("DEBUG name is : ${newEvent.name}");
      print("Your event is created successfully!");
      // print("Create failed");

      Event createdEvent = (await _eventController.getEvent(hostId: hostId, name: name))[0];
      print("DEBUG: $createdEvent");

      String url;
      Cloudinary cl = Cloudinary(API_KEY, API_SECRET);
      url = await cl.upload(file: toDataURL(file: _image), preset: Presets.eventCover, path: "${createdEvent.id}/cover");
      print("DEBUG url: $url");
      await _eventController.update(createdEvent.id, picture: url);

      _isSigningUp = false;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EventDetailScreen(newEvent)));
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
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              selectImageButton(),
              nameForm(),
              descriptionForm(),
              categoryForm(),
              new Text('Start Date Selected: $start'),
              new RaisedButton(
                child: new Text('Select Date'),
                onPressed: (){selectStartDate(context);}
              ),
              new Text('Start Time Selected: ${startTime.toString().substring(10,15)}'),
              new RaisedButton(
                child: new Text('Select Time'),
                onPressed: (){selectStartTime(context);}
              ),
              new Text('End Date Selected: $end'),
              new RaisedButton(
                child: new Text('Select Date'),
                onPressed: (){selectEndDate(context);}
              ),
              new Text('End Time Selected: ${endTime.toString()}'),
              new RaisedButton(
                child: new Text('Select Time'),
                onPressed: (){selectEndTime(context);}
              ),
              createButton(),
              // MaterialButton(
              // color: Colors.blue,
              // onPressed: () {
              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              // },
              // child: Text("Logout"),
              // )
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