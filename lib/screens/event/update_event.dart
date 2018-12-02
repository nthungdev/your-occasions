import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:youroccasions/models/event.dart';
import 'package:youroccasions/controllers/event_controller.dart';
import 'package:youroccasions/utilities/config.dart';
import 'package:youroccasions/utilities/secret.dart';
import 'package:youroccasions/screens/event/event_detail.dart';

import 'package:youroccasions/utilities/cloudinary.dart';

final EventController _eventController = EventController();
bool _isSigningUp = false;

class UpdateEventScreen extends StatefulWidget {
  final Event event;

  UpdateEventScreen(Event event) :  this.event = event;
  
  @override
  _UpdateEventScreen createState() => _UpdateEventScreen();
}

class _UpdateEventScreen extends State<UpdateEventScreen> {
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
  Event event;
  File _image;
  String _imageURL;
  bool _imageChanged;

  @override
  initState() {
    super.initState();
    startDate = DateTime.now();
    startTime = TimeOfDay.now();
    event = widget.event;
    _imageChanged = false;
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController(text: widget.event.name ?? "");
    descriptionController = TextEditingController(text: widget.event.description ?? "");
    categoryController = TextEditingController(text: widget.event.category ?? "");
    
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
  }

  void retrieveImageURL() {
    var url = fetch("event_header/${widget.event.id}");
  }
  
  void getImage(ImageSource source) {
    print(_imageChanged);
    ImagePicker.pickImage(source: source).then((image) {
      setState(() {
        _imageChanged = true;
        _image = image;
      });
    });
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

  Future<Null> selectStartTime(BuildContext context) async {
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
  
  Future<Null> selectEndDate(BuildContext context) async {
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

  Future<Null> selectEndTime(BuildContext context) async {
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

    if (form.validate()) {
      form.save();
      bool result = await update();
      print(result);
      // if(result) {
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EventDetailScreen()));
      // }
    }
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
  
  Widget updateButton() {
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
            child: Text('Update', style: TextStyle(color: Colors.black)),
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
        // validator: (name) => !isPassword(name) ? "Invalid name" : null,
        autofocus: false,
        // initialValue: widget.event.name,
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

  Future<bool> update() async {
    if (!_isSigningUp) {
      _isSigningUp = true;

      String url;
      if(_imageChanged) {
        Cloudinary cl = Cloudinary(CLOUDINARY_API_KEY, API_SECRET);
        url = await cl.upload(file: toDataURL(file: _image), preset: Presets.eventCover, path: "${widget.event.id}/cover");
        print(url);
      }

      final start = new DateTime(startDate.year, startDate.month, startDate.day, startTime.hour, startTime.minute);
      if (endDate != null){
        endDate = new DateTime(endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute);
      }
      String name = nameController.text;
      String description = descriptionController.text;
      String category = categoryController.text;
      String hostId = await getUserId();
      // String location = "Plattsburgh";
      Event newEvent = Event(hostId: hostId, name: name, description: description, category: category, startTime: start, endTime: endDate);
      print("DEBUG new event is : $newEvent");
      
      if(url != null) {
        _eventController.update(event.id, hostId: hostId, name: name, description: description, category: category, startTime: start, endTime: endDate, picture: url);
      }
      else {
        _eventController.update(event.id, hostId: hostId, name: name, description: description, category: category, startTime: start, endTime: endDate);
      }
      _isSigningUp = false;

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EventDetailScreen(newEvent)));
      return true;
    }
    return false;
  }

  Widget _buildCoverImage() {
    if (_imageURL == null) {
      return selectImageButton();
    }
    else {
      return Image.network(_imageURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Update Event"),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildCoverImage(),
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
              updateButton(),
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
  //       title: Text("Update your event"),
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